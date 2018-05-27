function dxdt = Free_Fall_Kinematic(t,x,Rocket,Environnement,theta)
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
V_inf = Environnement.V_inf;        % Vitesse du vent [m/s]

% Appels des fonctions necessaires
[M,dMdt,Cm,dCmdt,I_L,dI_Ldt,I_R,dI_Rdt] = Mass_Properties(t,Rocket,'Linear')
[Temp, a, p, rho, Nu] = stdAtmos(-x(3),Environnement); % Atmosphere [K,m/s,Pa,kg/m3]
g = -9.81;                           % Gravite [m2/s]

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
CD_AB = drag_shuriken(Rocket,theta,abs(alpha),V,Nu); % Coef. Trainee des A?rofreins
CD = drag(Rocket,abs(alpha),V,Nu,a);             % Coef. Trainee de la fus?e
q = 1/2*rho*Rocket.Sm*V^2;                  % Pression dynamique
Ft = [0;-q*(CD+CD_AB)];                     % Force de train?e

% Force Normale (E,F)
[CNa, Xp] = normalLift(Rocket,abs(alpha),1.1,V/a,0,0); % Normal lift Coefficient
Fn = [q*CNa*alpha;0];        % Force Normale

% Moment autour de X=D=U
[Calpha, CP] = barrowmanLift(Rocket,abs(alpha),V/a,0); % Coef. Normaux des sections
C1 = CorrectionMoment(t,Rocket,CNa,Xp,V,Environnement,x(3)); % Coef. Moment de correction
C2 = DampingMoment(t,Rocket,Calpha,CP,V,Environnement,x(3)); % Coef. Moment amortis

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

