function xdot = Rocket_Kinematic_2D(t,x,Rocket,Environnement,theta)
%   Contain Rocket Behaviour Equation
%   2D simulator
%   State Variable: x
%   - x(1) = vertical position
%   - x(2) = vertical velocity
%   - x(3) = horizontal position
%   - x(4) = horizontal velocity
%   - x(5) = angle
%   - x(6) = angular speed

%--------------------------------------------------------------------------
% Pre Simulation
%--------------------------------------------------------------------------

% State Initialization
xdot = zeros(6,1);

% Environnemental Parameters
nu = Environnement.Nu;

% Necessary function calls
[M,dMdt] = Mass_Non_Lin(t,Rocket);  % Rocket Mass information
[Temp, a, p, rho] = stdAtmos(x(1)); % Atmosphere information
T = Thrust(t,Rocket);   % Motor thrust
g = 9.81;               % Gravity []



% Multiple Time Used Parameters
V_Shift = 1e-15; % Avoid instabilities dut to atan(0/0) velocity shift
V = sqrt((x(4)+(Environnement.V_inf)).^2+(x(2)).^2); % Total Air flow Speed
beta = atan( (x(4)+Environnement.V_inf+V_Shift) / (x(2)) ); % Angle between vertical axe and Total Air flow Speed
q = 1/2*rho*Rocket.Sm*V^2; % Dynamic pressure
CD = drag(Rocket,0,V,nu,a);  % Drag coefficient
CD_AB = drag_shuriken(Rocket,theta,0,V,nu); % Airbreak drag coefficient
[CNa, Xp] = normalLift(Rocket,0,1.1,V/346,0,0); % Normal lift Coefficient
[Calpha, CP] = barrowmanLift(Rocket,0,V/346,0); % No roll
C1 = CorrectionMoment(Rocket,CNa,Xp,V);
C2 = DampingMoment(Rocket,Calpha,CP,V);

%--------------------------------------------------------------------------
% Behaviour Equations
%--------------------------------------------------------------------------
% Vertical Axis:
xdot(1) = x(2);
xdot(2) = (T-(CD+CD_AB)*q)*cos(x(5))/M - CNa*q*sin(x(5))/M*(x(5)-beta) - g - dMdt*x(2)/M;

% Horizontal Axis:
xdot(3) = x(4);
xdot(4) = (T-(CD+CD_AB)*q)*sin(x(5))/M + CNa*q*cos(x(5))/M*(x(5)-beta) - dMdt*x(4)/M;

% Rotational:
xdot(5) = x(6);
xdot(6) = (-C1*(x(5)-beta)-C2*(x(6))) / Rocket.rocket_I;
end

