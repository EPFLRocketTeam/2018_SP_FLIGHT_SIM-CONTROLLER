function dCNa = dnormalLift_ddelta(Rocket, alpha, K, M, theta, Galejs)
% NORMALLIFT computes the normal force intensity applied to the center of
% pressure according to Barrowman's theory and corrections for extreme
% aspect ratio bodies proposed by robert Galejs.
% INPUTS:
% - Rocket      : Rocket object
% - alpha       : angle of attack [rad]
% - K           : Robert Galejs' correction factor
% - M           : Mach number
% - theta       : Roll angle
% - Galejs      : Flag indicating use of Galejs' correction or not [1 or 0]
% OUTPUTS:
% - dCNa        : Normal lift derivative versus delta coefficient derivative [1/rad]



dCNa_barrowman = dbarrowmanLift_ddelta(Rocket, alpha, M, theta);

if Galejs
    dCalpha2 = drobertGalejsLift_ddelta(Rocket, alpha, K);
    dCNa = sum([dCNa_barrowman,dCalpha2]);
else
    dCNa = sum(dCNa_barrowman);
end
end

