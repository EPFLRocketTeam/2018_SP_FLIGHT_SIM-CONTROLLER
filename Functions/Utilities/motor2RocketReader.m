function Rocket = motor2RocketReader(motorFilePath, Rocket)
% MOTOR2ROCKETREADER reads the information contained in the RASP formatted
% motor text file named 'motorFilePath' into the 'Rocket' structure.

[time, Thrust, Info] = motorReader(motorFilePath);

% motor info
Rocket.motor_dia = Info{2}/1000;
Rocket.motor_length = Info{3}/1000;
Rocket.motor_delay = Info{4}{1};
Rocket.propel_mass = Info{5};
Rocket.motor_mass = Info{6};
Rocket.casing_mass = Rocket.motor_mass-Rocket.propel_mass;

% thrust lookup table
if time(1)>0
   time = [0, time];
   Thrust = [0, Thrust];
elseif time(1)<0
   error('ERROR: in motor2RocketReader, thrust curve only allows positive time values'); 
end
Rocket.Thrust_Time = time;
Rocket.Thrust_Force = Thrust;

% Burn time
Rocket.Burn_Time = time(end);

% Mass variation coefficient
A_T = trapz(time,Thrust);
Rocket.Thrust2dMass_Ratio = Rocket.propel_mass/A_T;

end