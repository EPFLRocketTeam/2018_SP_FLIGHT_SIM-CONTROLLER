function [M,dMdt,Cm,dCmdt,I_L,dI_Ldt,I_R,dI_Rdt] = Mass_Properties(t,Rocket,Opt)
%Return the global mass properties of the rocket
%   [M,dMdt,Cm,dCmdt,I_L,dI_Ldt,I_R,dI_Rdt] = Mass_Properties_Lin(t,Rocket)
%   INPUT:
%   - t         Time [s]
%   - Rocket    Matlab structure containing all data [.]
%   OUTPUT:
%   - M         Mass [kg]
%   - dMdt      Derivative of Mass [kg/s]
%   - Cm        Center of Mass [m]
%   - dCmdt     Derivative of Center of Mass [m/s]
%   - I_L       Longitudinal Moment of Inertia [kgm^2]
%   - dI_Ldt    Derivative of L. Moment of Inertia [kgm^2/s]
%   - I_R       Rotational Moment of Inertia [kgm^2]
%   - dI_Rdt    Derivative of R. Moment of Inertia [kgm^2/s]

%--------------------------------------------------------------------------
% Mass
%--------------------------------------------------------------------------
if strcmp(Opt, 'Linear')
    if t > Rocket.Burn_Time
        M = Rocket.rocket_m + Rocket.casing_mass;
        dMdt = 0;
    else
        dMdt = Rocket.propel_mass/Rocket.Burn_Time;
        M = Rocket.rocket_m+Rocket.motor_mass-t*dMdt;
    end
elseif strcmp(Opt, 'NonLinear')
    if t>Rocket.Burn_Time
    M = Rocket.rocket_m+Rocket.motor_mass-Rocket.propel_mass;
    dMdt = 0;
    else
    tt = linspace(0,t,500);
    Current_Impulse = trapz(tt,Thrust(tt,Rocket));
    M = Rocket.rocket_m + Rocket.motor_mass - ... 
        Rocket.Thrust2dMass_Ratio*Current_Impulse;
    dMdt = Rocket.Thrust2dMass_Ratio*Thrust(t,Rocket);
    end
else
    error('Opt parameter should be Linear or Nonlinear')
end
%--------------------------------------------------------------------------
% Center of Mass
%--------------------------------------------------------------------------
% Centre de masse
Cm = (Rocket.rocket_cm*Rocket.rocket_m + ... 
    (M-Rocket.rocket_m)*(Rocket.L-Rocket.motor_length/2))/M;
 
% Derivee centre de masse
dCmdt = (dMdt*(Rocket.L-Rocket.motor_length/2)-dMdt*Cm)/M;

%--------------------------------------------------------------------------
% Moment of Inertia
%--------------------------------------------------------------------------
% I_L:
R_i = 0.005; % Diametre interieur grains (Tjr identique)
R_e = Rocket.motor_dia/2; % Diametre exterieur grains

I_L_Casing = Rocket.casing_mass*(Rocket.motor_length^2/12 + R_e^2/2); 

Grain_Mass = M-Rocket.rocket_m-Rocket.casing_mass; % Masse des grains
I_L_Grain = Grain_Mass*(Rocket.motor_length^2/12 + (R_e^2+R_i^2)/4);

I_L = Rocket.rocket_I + I_L_Casing + I_L_Grain + ...
    (Grain_Mass+Rocket.casing_mass)*...
    (Rocket.L-Cm-Rocket.motor_length/2)^2; % I + ... + Steiner

% dI_L/dt:
dI_L_Grain = dMdt*(Rocket.motor_length^2/12 + (R_e^2+R_i^2)/4);

dI_Ldt = dI_L_Grain+dMdt*(Rocket.L-Cm-Rocket.motor_length/2)^2+...
    2*(Grain_Mass+Rocket.casing_mass)*(Rocket.L-Cm-Rocket.motor_length/2)*...
    dCmdt;

% I_R:
I_R = 1e6;

% dI_R/dt:
dI_Rdt = 0;
end

