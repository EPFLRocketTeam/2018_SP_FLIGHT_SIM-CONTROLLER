function CD = drag_shuriken(Rocket, theta, alpha, Uinf, nu)
% DRAG_SHURIKEN estimates the drag coefficient normalized to the Rocket's
% reference area for the shuriken airbrake design.
% INPUTS : 
% - Rocket  : Rocket object
% - theta   : Airbrakes command input, -190.5 = closed, 1.162 =
%             open [deg]
% - alpha   : wind angle of attack [rad]
% - Uinf    : Air free stream velocity [m/s]
% - nu      : dynamic viscosity coefficient [m2/s]

% ============================== Parameters ===============================

    CD0 = 1.17;
    U = abs(Uinf*cos(alpha));
    Rex = Rocket.ab_x*U/nu;
    delta = 0.37*Rocket.ab_x/Rex^0.2;

% =========================== Compute values ==============================
    % surface and height
    [S,h] = surface(theta);

    % drag coefficient
    if h<delta
        qr = 49/72*(h/delta)^(2/7);
    else
        qr = 1 - 4/9*delta/h+1/8*(delta/h)^2;
    end
    CD = Rocket.ab_n*CD0*qr*S/Rocket.Sm;
end

function [f, h] = surface(theta)
% SURFACE computes the surface and height of a shuriken's wing in function of the
% angle of opening
% INPUTS : 
% - theta : Airbrakes command input, -216 = closed, 1.7 = open [deg]
%           
% OUTPUTS :  
% - f     : surface of the wing with an opening of theta
% - h     : height/distance from the rocket's body

    % We have found values of surface for different angle of opening 
    % WARNING : angle [deg] is a value contained in the interval [0, 66.1],
    %           0 = airbrakes closed, 66.1 = airbrakes fully opened
    %           It is different from theta which is the angle of rotation 
    %           of the servomotor ([-190.5, -1,5])
    
% ==================== Parameters measured with CATIA =====================

    % angles in degrees
    angle_tab = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70];
    
    % corresponding surfaces in m^2
    surface_tab = [0, 1.1, 2.23, 3.38, 4.56, 5.76, 6.98, 8.22, 9.48, 10.75, 12.03, 13.32, 14.61, 15.9, 17.19]*1e-4; 
    
    % height in m
    h_tab = [0, 3.76, 7.45, 11.04, 14.5, 17.81, 20.95, 23.88, 26.58, 29.03, 31.2, 33.09, 34.64, 35.87, 36.76]*1e-3; 
    
% ===================== Interpolation and conversions =====================

    % converting the motor angle theta (range [-216, 1.7]) to the 
    % opening angle of the wing(range [0, 70])
    angle = (theta + 216)*70./217.7;
    
    % interpolated surface in function of angle 
    f = interp1(angle_tab, surface_tab, angle, 'pchip');
    
    % interpolated height distance from rocket body
    h = interp1(angle_tab, h_tab, angle, 'pchip');
end