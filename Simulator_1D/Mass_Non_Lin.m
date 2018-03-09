function [mass,dmassdt] = Mass_Non_Lin(t,Rocket)
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
    tt = linspace(0,Rocket.Burn_Time,2000);
    pos = find(tt<t);
    mass = Rocket.Thrust2dMass_Ratio*trapz(tt(pos),Thrust(tt(pos),Rocket));
    dmassdt = Rocket.Thrust2dMass_Ratio*Thrust(t,Rocket);
end
end

