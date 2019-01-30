function xdot = Rocket_Kinematic(t,x,Rocket,Environnement,theta,Amplifier)
%   Contain Rocket Behaviour Equation
%   1D simulator
%   State Variable: x
%   - x(1) = height;
%   - x(2) = vertical velocity

% State initialization:
xdot = zeros(2,1);

% Call Function:
[M,dMdt,Cm,dCmdt,I_L,dI_Ldt,I_R,dI_Rdt] = Mass_Properties(t,Rocket,'Linear');
% <<<<<<< HEAD
% [Temp, a, p, rho] = stdAtmos(x(1));
% =======
[Temp, a, p, rho, Nu] = stdAtmos(x(1),Environnement);
% >>>>>>> origin/master
T = Thrust(t,Rocket);
g = 9.81; %[m/s2] Gravity
CD = drag(Rocket,0,x(2),Nu,a)
CD_AB = drag_shuriken(Rocket,theta,0,x(2),Nu);

% Behaviour Equation:
xdot(1) = x(2);
xdot(2) = Amplifier*T/M-g-x(2)*dMdt/M-0.5*rho*Rocket.Sm*x(2).^2*(CD+CD_AB)/M;

end

