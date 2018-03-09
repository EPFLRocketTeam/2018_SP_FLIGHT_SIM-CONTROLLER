function xdot = Rocket_Kinematic(t,x,Rocket)
%   Contain Rockete Behaviour Equation
%   1D simulator
%   State Variable: x
%   - x(1) = height;
%   - x(2) = vertical velocity

% State initialization:
xdot = zeros(2,1);

% Environnemental parameter
nu = 1.578e-5; %[m2/s] Viscosity, &&&&&&&&&&&& ADD FUNCTION??
a = 346;       %[m/s] Speed of sound &&&&&&&&& ADD FUNCTION??

% Call Function
[Mass,dMassdt] = Mass(t,Rocket);
T = Thrust(t,Rocket);
g = 9.81; %[m/s2] Gravity &&&&&&&&&&&&&&&&&&&& ADD FUNCTION??
rho = 1.22; %[kg/m3] Density &&&&&&&&&&&&&&&&& ADD FUNCTION??
CD = drag(Rocket,0,x(2),nu,a);

% Behaviour Equation:
xdot(1) = x(2);
xdot(2) = T/Mass-g-x(2)*dMassdt/Mass-0.5*rho*Rocket.Sm*x(2).^2*CD;
end

