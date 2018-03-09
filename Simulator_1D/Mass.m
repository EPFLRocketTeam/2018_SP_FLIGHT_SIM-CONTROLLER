function [Mass,dMassdt] = Mass(t,Rocket)
%	Return the tocket mass during burn time
%   INPUT:
%   - t         Time
%   - Rocket    Structure Containing all datas
%   OUTPUT:
%   - Mass      Rocket mass
%   - dMassdt   Rocket mass derivative over time

% OUTPUT:
if t > Rocket.Burn_Time
    dMassdt = 0;
    Mass = Rocket.rocket_m-Rocket.motor_mass;
else
    dMassdt = Rocket.motor_mass/Rocket.Burn_Time
    Mass = Rocket.rocket_m-t*dMassdt;
end
end

