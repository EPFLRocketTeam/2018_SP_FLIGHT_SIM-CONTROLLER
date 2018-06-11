function xdot = Rail_Initial_State(t,x,Rocket,Environnement)
%   Rail behaviour simulation
%   As the Rocket is constrainted against the rail, it is a 1D simulation

%   Initialization
xdot = zeros(2,1);

% Environnemental Parameters
alpha = Environnement.Rail_Angle;
V_inf = Environnement.V_inf;

% Necessary function calls
[M,dMdt,Cm,dCmdt,I_L,dI_Ldt,I_R,dI_Rdt] = Mass_Properties(t,Rocket,'NonLinear');
[Temp, a, p, rho, Nu] = stdAtmos(x(1),Environnement); % Atmosphere information
T = Thrust(t,Rocket);   % Motor thrust
g = 9.81;               % Gravity []

% Multiple Time Used Parameters
V = sqrt(x(2)^2+2*x(2)*V_inf*sin(alpha)+V_inf^2); % Total Air flow Speed
q = 1/2*rho*Rocket.Sm*V^2; % Dynamic pressure
CD = drag(Rocket,0,V,Nu,a);  % Drag coefficient

% Equation
if T < M*g
    xdot(1) = 0;
    xdot(2) = 0;
else
    xdot(1) = x(2);
    xdot(2) = T/M-g*cos(alpha)-CD*q/M-dMdt/M;
end
end

