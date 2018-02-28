function [CNa, Xp] = normalLift(Rocket, alpha, K, M, theta)

[CNa_barrowman, Xp_barrowman] = barrowmanLift(Rocket, alpha, M, theta);
[CNa_galejs, Xp_galejs] = robertGalejsLift(Rocket, alpha, K);

CNa = sum([CNa_barrowman, CNa_galejs]);
Xp = sum([CNa_barrowman.*Xp_barrowman, CNa_galejs.*Xp_galejs])/CNa;
end