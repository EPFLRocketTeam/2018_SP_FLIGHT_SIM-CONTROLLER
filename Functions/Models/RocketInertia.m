function [M, dMdt, CM, I, dIdt] = RocketInertia(t, Rocket, massmodel)
% ROCKETINERTIA Compute mass, mass derivative, center of mass position from
% cone tip, Inertia moment tensor and derivative of the inertia moment
% tensor. 
% INPUTS : 
% - t           :   time [s]
% - Rocket      :   Rocket structure
% - massmodel   :   mass model selection [0 (linear), 1 (non-linear)]
% OUTPUTS
% - M           :   Mass [kg]
% - dMdt        :   Time derivative of mass [kg/s]
% - CM          :   Center of mass from cone tip [m]
% - I           :   Moment of inertia tensor in rocket coordinate system (3x3)[kgm^2]
% - dIdt        :   Time derivative of moment of inertia tensor in rocket coordinate system (3x3)[kgm^2/s]

% Compute mass values
if(massmodel)
    [M, dMdt] = Mass_Lin(t, Rocket);
else
    [M, dMdt] = Mass_Non_Lin(t, Rocket);
end

% Compute center of mass
CM = (Rocket.rocket_cm*Rocket.rocket_m + ... 
    (M-Rocket.rocket_m)*(Rocket.L-Rocket.motor_length/2))/M;

% Compute Inertia tensor
% longitudinal inertia
R_i = 0.005; % Diametre interieur grains (Tjr identique)
R_e = Rocket.motor_dia/2; % Diametre exterieur grains

I_L_Casing = Rocket.casing_mass*(Rocket.motor_length^2/12 + R_e^2/2); 

Grain_Mass = M-Rocket.rocket_m-Rocket.casing_mass; % Masse des grains
I_L_Grain = Grain_Mass*(Rocket.motor_length^2/12 + (R_e^2+R_i^2)/4);

I_L = Rocket.rocket_I + I_L_Casing + I_L_Grain + ...
    (Grain_Mass+Rocket.casing_mass)*...
    (Rocket.L-CM-Rocket.motor_length/2); % I + ... + Steiner
% rotational inertia

I = [I_L, 1];
% TODO : rotational inertia and inertia moment derivative.
dIdt = 0;
end