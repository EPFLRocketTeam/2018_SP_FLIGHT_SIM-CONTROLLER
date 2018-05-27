function [T2,X2, ab_control] = Sim_Airbrakes(Rocket, Environment, AB_drag, AB_tab, AB_target, KP, UpTime, control_flag)

    % define global simulation parameters
    theta = min(AB_tab(:,3));
    h_tab = unique(AB_tab(:,1));
    ab_control = [];
    %--------------------------------------------------------------------------
    % Rail Simulation
    %--------------------------------------------------------------------------
    % Initial Conditions
    x_0 = [0;0]; % At rest position
    tspan = [0 double(Rocket.Burn_Time)];

    % Simulation
    Option = odeset('Events', @myEventRail);
    [T1,X1] = ode45(@(t,x) Rail_Initial_State(t,x,Rocket,Environment),tspan,x_0,Option);
    
    %--------------------------------------------------------------------------
    % Fly Simulation
    %--------------------------------------------------------------------------
    Rail_Angle = Environment.Rail_Angle;
    Rail_L = Environment.Rail_Length;

    % Initial Conditions
    x_0 = [Rail_L*sin(Rail_Angle);X1(end,2)*sin(Rail_Angle);Rail_L*cos(Rail_Angle);X1(end,2)*cos(Rail_Angle);Rail_Angle;0]; % No speed, no height, no angle
    tspan = T1(end):UpTime:28;

    % Simulation
    Option = odeset('Events', @myEventApogee, 'OutputFcn', @(t,x,flag) output(t,x,flag,Rocket));
    [T2,X2] = ode45(@(t,x) Rocket_Kinematic_2D(t,x,Rocket,Environment),tspan,x_0,Option);
    
    %--------------------------------------------------------------------------
    % Rocket dynamics
    %--------------------------------------------------------------------------
    
    function xdot = Rail_Initial_State(t,x,Rocket,Environment)
    %   Rail behaviour simulation
    %   As the Rocket is constrainted against the rail, it is a 1D simulation

    %   Initialization
    xdot = zeros(2,1);

    % Environnemental Parameters
    nu = Environment.Nu;
    alpha = Environment.Rail_Angle;
    V_inf = Environment.V_inf;

    % Necessary function calls
    [M,dMdt] = Mass_Non_Lin(t,Rocket);  % Rocket Mass information
    [Temp, a, p, rho] = stdAtmos(x(1)); % Atmosphere information
    T = Thrust(t,Rocket);   % Motor thrust
    g = 9.81;               % Gravity []

    % Multiple Time Used Parameters
    V = sqrt(x(2)^2+2*x(2)*V_inf*sin(alpha)+V_inf^2); % Total Air flow Speed
    q = 1/2*rho*Rocket.Sm*V^2; % Dynamic pressure
    CD = drag(Rocket,0,V,nu,a);  % Drag coefficient

    % Equation
        if T < M*g
            xdot(1) = 0;
            xdot(2) = 0;
        else
            xdot(1) = x(2);
            xdot(2) = T/M-g*cos(alpha)-CD*q/M-dMdt/M;
        end
    end

    function dxdt = Rocket_Kinematic_2D(t,x,Rocket,Environment)
    %   Contain Rocket Behaviour Equation
    %   2D simulator
    %   State Variable: x
    %   - x(1) = horizontal position
    %   - x(2) = horizontal velocity
    %   - x(3) = vertical position
    %   - x(4) = vertical velocity
    %   - x(5) = angle
    %   - x(6) = angular speed

    %--------------------------------------------------------------------------
    % Initialisation
    %--------------------------------------------------------------------------
    dxdt = zeros(6,1);

    % Parametres environnementaux
    nu = Environment.Nu;              % Viscosite [Pas]
    V_inf = Environment.V_inf;        % Vitesse du vent [m/s]

    % Appels des fonctions necessaires
    [M,dMdt,Cm,dCmdt,I_L,dI_Ldt,I_R,dI_Rdt] = Mass_Properties(t,Rocket,'Linear');
    [Temp, a, p, rho] = stdAtmos(x(3)); % Atmosphere [K,m/s,Pa,kg/m3]
    g = 9.81;                           % Gravite [m2/s]

    % Decalage de protection
    V_Shift = 1e-15; % Evite les instabilites telles que atan(0/0)

    %--------------------------------------------------------------------------
    % Angle des reperes p.r au referentiel (X,Y,Z)
    %--------------------------------------------------------------------------
    delta = x(5);   % Repere (D,E,F), D = X
    beta = atan( (x(2)+V_inf+V_Shift)/(x(4))); % Repere (U,V,W), U = X

    % Angle d'attaque
    alpha = delta-beta;     % Angle d'attaque de la fusee

    %--------------------------------------------------------------------------
    % Forces exprimees dans leur repere respectif
    %--------------------------------------------------------------------------
    % Force de Gravite (Y,Z)
    G = [0;-g];

    % Force de Poussee (E,F)
    T = [0;Thrust(t,Rocket)];

    % Force de Trainee (V,W)
    V = sqrt((x(2)+V_inf).^2+x(4).^2);          % Flux d'air vu par la fusee
    CD_AB = AB_drag(Rocket,theta,abs(alpha),V,nu); % Coef. Trainee des A?rofreins
    CD = drag(Rocket,abs(alpha),V,nu,a);             % Coef. Trainee de la fus?e
    q = 1/2*rho*Rocket.Sm*V^2;                  % Pression dynamique
    Ft = [0;-q*(CD+CD_AB)];                     % Force de train?e

    % Force Normale (E,F)
    [CNa, Xp] = normalLift(Rocket,abs(alpha),1.1,V/a,0,0); % Normal lift Coefficient
    Fn = [q*CNa*alpha;0];        % Force Normale

    % Moment autour de X=D=U
    [Calpha, CP] = barrowmanLift(Rocket,abs(alpha),V/a,0); % Coef. Normaux des sections
    C1 = CorrectionMoment(t,Rocket,CNa,Xp,V); % Coef. Moment de correction
    C2 = DampingMoment(t,Rocket,Calpha,CP,V); % Coef. Moment amortis

    %--------------------------------------------------------------------------
    % Matrice de Rotation
    %--------------------------------------------------------------------------
    % (D,E,F) -> (X,Y,Z)
    Q_delta = [cos(delta),sin(delta);-sin(delta),cos(delta)]; 

    % (U,V,W) -> (X,Y,Z)
    Q_beta = [cos(beta),sin(beta);-sin(beta),cos(beta)];

    %--------------------------------------------------------------------------
    % Equations
    %--------------------------------------------------------------------------
    Xdot = [x(2);x(4)]; % Vecteur vitesse

    % Mouvement en translation
    Xdotdot = (Q_delta*(T+Fn)+Q_beta*Ft-dMdt*Xdot)/M+G;

    % Mouvement de rotation
    dxdt(5) = x(6);
    dxdt(6) = (-C1*alpha-C2*x(6)-dI_Ldt*x(5))/I_L;

    % Envoi des valeurs
    dxdt(1) = x(2);
    dxdt(3) = x(4);
    dxdt(2) = Xdotdot(1);
    dxdt(4) = Xdotdot(2);
    end

    %--------------------------------------------------------------------------
    % Output function
    %--------------------------------------------------------------------------
    
    function status = output(t,x,flag, Rocket)
        
        status = 0;
        
        if isempty(flag)
            
           if(t(end)>Rocket.Burn_Time && control_flag)
               
              h_current = x(3, end); v_current = x(4, end); 
              h_tab_up = h_tab(find(h_tab>h_current, 1, 'first'), 1);
              h_tab_lo = h_tab(find(h_tab<h_current, 1, 'last'), 1);
              phi = (h_current-h_tab_lo)/(h_tab_up - h_tab_lo);
              
              if(h_current>max(h_tab))
                  theta = max(AB_tab(:,3));
              else
              
                  index_up = find(AB_tab(:,1)==h_tab_up); index_lo = find(AB_tab(:,1)==h_tab_lo);
                  v_tab = AB_tab(index_up,2)*phi+AB_tab(index_lo,2)*(1-phi);
                  theta_tab = AB_tab(index_up,3)*phi+AB_tab(index_lo,3)*(1-phi);

                  if(v_current > max(v_tab))
                      theta = max(theta_tab);
                  elseif(v_current <min(v_tab))
                      theta = min(theta_tab);
                  else

                    theta_current = interp1(v_tab, theta_tab, v_current, 'linear');
                    theta = theta_current+KP*(theta_current-AB_target);
                    if(theta > max(theta_tab))
                      theta = max(theta_tab);
                    elseif(theta <min(theta_tab))
                      theta = min(theta_tab);
                    end

                  end
              
              end
              
           end
           
           ab_control = [ab_control theta];
           
        end
        
    end
    
end