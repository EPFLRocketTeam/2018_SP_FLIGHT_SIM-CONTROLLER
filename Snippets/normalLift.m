function [CNa, Xp] = normalLift(Rocket, alpha, K, M, theta, Galejs)

[CNa_barrowman, Xp_barrowman] = barrowmanLift(Rocket, alpha, M, theta);

if Galejs
    [CNa_galejs, Xp_galejs] = robertGalejsLift(Rocket, alpha, K);
    CNa = sum([CNa_barrowman, CNa_galejs]);
    Xp = sum([CNa_barrowman.*Xp_barrowman, CNa_galejs.*Xp_galejs])/CNa;
else
    CNa = sum(CNa_barrowman);
    Xp = sum(CNa_barrowman.*Xp_barrowman)/CNa;
end

end