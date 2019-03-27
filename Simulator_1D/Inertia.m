function [I_L,dI_Ldt,I_R] = Inertia(t,Rocket)
%	Return the rocket main inertias
%   INPUT:
%   - t         Time
%   - Rocket    Structure Containing all datas
%   OUTPUT:
%   - I_L       Longitudinal Inertia
%   - I_R       Rotational Inertia

% Appel de fonctions necessaires
[M,dMdt] = Mass_Lin(t,Rocket);
[cm dcmdt] = CM(t,Rocket);

% I_L:
R_i = 0.005; % Diametre interieur grains (Tjr identique)
R_e = Rocket.motor_dia/2; % Diametre exterieur grains

I_L_Casing = Rocket.casing_mass*(Rocket.motor_length^2/12 + R_e^2/2); 

Grain_Mass = M-Rocket.rocket_m-Rocket.casing_mass; % Masse des grains
I_L_Grain = Grain_Mass*(Rocket.motor_length^2/12 + (R_e^2+R_i^2)/4);

I_L = Rocket.rocket_I + I_L_Casing + I_L_Grain + ...
    (Grain_Mass+Rocket.casing_mass)*...
    (Rocket.L-cm-Rocket.motor_length/2)^2; % I + ... + Steiner

% dI_L/dt:
dI_L_Grain = dMdt*(Rocket.motor_length^2/12 + (R_e^2+R_i^2)/4);

dI_Ldt = dI_L_Grain+dMdt*(Rocket.L-cm-Rocket.motor_length/2)^2+...
    2*(Grain_Mass+Rocket.casing_mass)*(Rocket.L-cm-Rocket.motor_length/2)*...
    dcmdt;

% I_R:
I_R = 0;
end

