function CD = drag_flaps(Rocket, phi, alpha, Uinf, nu)
% DRAG_FLAPS estimates the drag coefficient normalized to the Rocket's
% reference area for the flaps airbrake design.
% LIMITATIONS
% - Constant Reynold's number for flat plate is valid for Reh = Uinf*b/nu >
% 10^4 
% INPUTS : 
% - Rocket  : Rocket object
% - phi   : Airbrakes command input, 0 = closed, 60 = open [deg]
% - alpha   : wind angle of attack [rad]
% - Uinf    : Air free stream velocity [m/s]
% - nu      : dynamic viscosity coefficient [m2/s]

% parameters
CD0 = 1.17; % empirical drag coefficient for a flat plate in perpendicular air flow
            % c.f. FLUID DYNAMIC DRAG, S. F. HOERNER, 1965
w = 0.106; % width [m]
b = 0.089; % flap length [m]
S = w*b; % flap surface [m2]
U = abs(Uinf*cos(alpha));
Rex = Rocket.ab_x*U/nu;
delta = 0.37*Rocket.ab_x/Rex^0.2;

% drag coefficient
if phi<asind(delta/w)
    qr = 7/9*(w*sind(phi)/delta)^(2/7);
else
    qr = 1 - 2/9*(delta/w/sind(phi));
end
CD = Rocket.ab_n*CD0*qr*S/Rocket.Sm*sind(phi)^3;

end