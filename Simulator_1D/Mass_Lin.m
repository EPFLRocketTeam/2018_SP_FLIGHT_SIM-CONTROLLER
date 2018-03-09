function [mass,dmassdt] = Mass_Lin(t,Rocket)
%	Return the tocket mass during burn time
%   INPUT:
%   - t         Time
%   - Rocket    Structure Containing all datas
%   OUTPUT:
%   - Mass      Rocket mass
%   - dMassdt   Rocket mass derivative over time

% OUTPUT:
if t > Rocket.Burn_Time
    dmassdt = 0;
    mass = Rocket.rocket_m-Rocket.motor_mass;
else
    dmassdt = Rocket.motor_mass/Rocket.Burn_Time;
    mass = Rocket.rocket_m-t*dmassdt;
end
end

