function CDT = drag_AB(Rocket, theta, alpha, Uinf, nu)
% DRAG_AB outputs drag coefficient of a flap type airbrake normalized
% to the airbrake's braking surface. 
% INPUTS:
% - Rocket  : Rocket data structure
% - theta   : Airbrake opening angle [rad]
% - alpha   : Angle of attack [rad]
% - Uinf    : Free stream velocity [m/s]
% - nu      : Dynamic viscosity [m2/s]
% - a       : Speed of sound [m/s]
% OUTPUTS:
% - CDT     : Drag coefficient normalized to Rocket reference diameter
% REFERENCES:
% - Hassan Arif, Identification and Control of a High Power Rocket, EPFL
% Semester Project Report, Professor Collin Jones, June 2017.
% - Fluid Dynamics Drag, S.F.Hoearner, 1965
% 


% -------------------------------------------------------------------------
% 1. Parameter definition
% -------------------------------------------------------------------------

% 1.1 Flat plate with approx. 1:1 aspect ratio ()
CD0 = 1.17;
h_eff = Rocket.ab_h*sin(theta);
U = Uinf*cos(alpha);
Rex = Rocket.ab_x*U/nu;
delta = 0.37*Rocket.ab_x/Rex^0.2;

% -------------------------------------------------------------------------
% 2. Coefficient computation
% -------------------------------------------------------------------------

% 2.1 Dynamic pressure correction factor 
if h_eff>delta
    Qr = (1-0.125*delta/h_eff);
elseif h_eff<=delta && h_eff>=0
    Qr = (7/8*(h_eff/8)^(1/7));
else
    error('ERROR: effective deployment height of airbrakes is either NaN or negative.')
end
% 2.1 airbrake drag coefficient
CDT = CD0*Qr*sin(theta)^3*Rocket.ab_S/Rocket.Sm;

end
