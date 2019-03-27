function CD = drag_shuriken(Rocket, theta, alpha, Uinf, nu)
% DRAG_SHURIKEN estimates the drag coefficient normalized to the Rocket's
% reference area for the shuriken airbrake design.
% INPUTS : 
% - Rocket  : Rocket object
% - theta   : Airbrakes command input, -232 = closed, 0.9 = open [deg]
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
% - theta : Airbrakes command input, -232 = closed, 0.9 = open [deg]
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
    angle_tab = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 66, 73];
    
    % corresponding surfaces in m^2
    surface_tab = [0, 1.77, 2.85, 4.038, 5.27, 6.534, 7.825, 9.139, 10.47, 11.83, 13.19, 14.57, 15.95, 17.62, 19.56]*1e-4; 
    
    % height in m
    h_tab = [0, 3.91, 7.758, 11.517, 15.16, 18.658, 21.982, 25.104, 27.995, 30.628, 32.979, 35.023, 36.741, 38.564, 39.561]*1e-3; 
    
% ===================== Interpolation and conversions =====================

    % converting the motor angle theta (range [-232, 0.9]) to the 
    % opening angle of the wing(range [0, 73])
    angle = (theta + 232)*73./232.9;
    
    % interpolated surface in function of angle 
    f = interp1(angle_tab, surface_tab, angle, 'pchip');
    
    % interpolated height distance from rocket body
    h = interp1(angle_tab, h_tab, angle, 'pchip');
end