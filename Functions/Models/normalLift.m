function [CNa, Xp, CNa_barrowman, Xp_barrowman] = normalLift(Rocket, alpha, K, M, theta, Galejs)
% NORMALLIFT computes the normal force intensity applied to the center of
% pressure according to Barrowman's theory and corrections for extreme
% aspect ratio bodies proposed by robert Galejs.
% INPUTS:
% - Rocket      : Rocket object
% - alpha       : angle of attack [rad]
% - K           : Robert Galejs' correction factor
% - M           : Mach number
% - theta       : Roll angle [rad]
% - Galejs      : Flag indicating use of Galejs' correction or not [1 or 0]
% OUTPUTS:
% - CNa        : Normal lift derivative versus delta coefficient derivative [1/rad]
% - Xp          : Center of pressure
% - CNa_barrowman: Normal lift coefficient derivatives of rocket components
% according to barrowman theory [1/rad]
% - Xp_barrowman: Center of pressure of rocket components
% according to barrowman theory [1/rad]

[CNa_barrowman, Xp_barrowman] = barrowmanLift(Rocket, alpha, M, theta);
% Fac for montecarlo simulation 
Xp_barrowman = Xp_barrowman*Rocket.cp_fac;
CNa_barrowman = CNa_barrowman*Rocket.CNa_fac;
if Galejs
    [CNa_galejs, Xp_galejs] = robertGalejsLift(Rocket, alpha, K);
    CNa = sum([CNa_barrowman, CNa_galejs]);
    Xp = sum([CNa_barrowman.*Xp_barrowman, CNa_galejs.*Xp_galejs])/CNa;
else
    CNa = sum(CNa_barrowman);
    Xp = sum(CNa_barrowman.*Xp_barrowman)/CNa;
end

end