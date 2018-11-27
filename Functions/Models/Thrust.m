function T = Thrust(t,Rocket)
%	Return the motor thrust along its axis
%   INPUT:
%   - t         Time
%   - Rocket    Structure Containing all datas
%   OUTPUT:
%   - T         Motor Thrust

%   Linear Interpolation
if t > Rocket.Burn_Time 
    T = 0;
elseif t < 0
    T = 0;
else
    T = interp1(Rocket.Thrust_Time,Rocket.Thrust_Force,t);
end
end

