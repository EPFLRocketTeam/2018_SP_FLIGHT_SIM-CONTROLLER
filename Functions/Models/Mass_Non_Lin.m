function [mass,dmassdt] = Mass_Non_Lin(t,Rocket)
%	Return the tocket mass during burn time
%   INPUT:
%   - t         Time
%   - Rocket    Structure Containing all datas
%   OUTPUT:
%   - Mass      Rocket mass
%   - dMassdt   Rocket mass derivative over time

% OUTPUT:
if t>Rocket.Burn_Time
    mass = Rocket.rocket_m+Rocket.motor_mass-Rocket.propel_mass;
    dmassdt = 0;
else
    tt = linspace(0,t,500);
    Current_Impulse = trapz(tt,Thrust(tt,Rocket));
    mass = Rocket.rocket_m + Rocket.motor_mass - Rocket.Thrust2dMass_Ratio*Current_Impulse;
    dmassdt = Rocket.Thrust2dMass_Ratio*Thrust(t,Rocket);
end
end

