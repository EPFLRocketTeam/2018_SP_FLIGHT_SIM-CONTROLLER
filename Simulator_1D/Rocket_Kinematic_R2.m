function xdot = Rocket_Kinematic(t,x,Rocket,Environnement,AB_drag, theta)
%   Contain Rocket Behaviour Equation
%   1D simulator
%   State Variable: x
%   - x(1) = height;
%   - x(2) = vertical velocity

% State initialization:
xdot = zeros(2,1);

% Call Function:
[M,dMdt,Cm,dCmdt,I_L,dI_Ldt,I_R,dI_Rdt] = Mass_Properties(t,Rocket,'Linear');
[Temp, a, p, rho, nu] = stdAtmos(x(1), Environnement);
T = Thrust(t,Rocket);
g = 9.81; %[m/s2] Gravity
CD = drag(Rocket,0,x(2),nu,a);
CD_AB = AB_drag(Rocket,theta,0,x(2),nu);

% Behaviour Equation:
xdot(1) = x(2);
xdot(2) = T/M-g-x(2)*dMdt/M-0.5*rho*Rocket.Sm*x(2).^2*(CD+CD_AB)/M;

end

