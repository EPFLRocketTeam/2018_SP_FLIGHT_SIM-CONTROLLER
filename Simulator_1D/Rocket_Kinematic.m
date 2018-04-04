function xdot = Rocket_Kinematic(t,x,Rocket,Environnement,theta,Amplifier)
%   Contain Rocket Behaviour Equation
%   1D simulator
%   State Variable: x
%   - x(1) = height;
%   - x(2) = vertical velocity

% State initialization:
xdot = zeros(2,1);

% Environnemental parameter:
nu = Environnement.Nu; %[m2/s] Viscosity, &&&&&&&&&&&& ADD FUNCTION??

% Call Function:
[M,dMdt] = Mass_Lin(t,Rocket);
[Temp, a, p, rho] = stdAtmos(x(1));
T = Thrust(t,Rocket);
g = 9.81; %[m/s2] Gravity &&&&&&&&&&&&&&&&&&&& ADD FUNCTION??
CD = drag(Rocket,0,x(2),nu,a);
CD_AB = drag_shuriken(Rocket,theta,0,x(2),nu);

% Behaviour Equation:
xdot(1) = x(2);
xdot(2) = Amplifier*T/M-g-x(2)*dMdt/M-0.5*rho*Rocket.Sm*x(2).^2*(CD+CD_AB)/M;
end

