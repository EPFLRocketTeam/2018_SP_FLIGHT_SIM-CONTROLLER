function [mass,dmassdt] = Mass_Lin(t,Rocket)
%	Return the rocket mass during burn time
%   INPUT:
%   - t         Time
%   - Rocket    Structure Containing all datas
%   OUTPUT:
%   - Mass      Rocket mass
%   - dMassdt   Rocket mass derivative over time

% OUTPUT:
if t > Rocket.Burn_Time
    mass = Rocket.rocket_m + Rocket.casing_mass;
    dmassdt = 0;
else
    dmassdt = Rocket.propel_mass/Rocket.Burn_Time;
    mass = Rocket.rocket_m+Rocket.motor_mass-t*dmassdt;
end
end

