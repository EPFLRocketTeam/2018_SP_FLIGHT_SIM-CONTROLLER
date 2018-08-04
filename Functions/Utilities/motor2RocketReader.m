function Rocket = motor2RocketReader(motorFilePath, Rocket)
% MOTOR2ROCKETREADER reads the information contained in the RASP formatted
% motor text file named 'motorFilePath' into the 'Rocket' structure.

[time, Thrust, Info] = motorReader(motorFilePath);

Rocket.motor_dia = Info{2}/1000;
Rocket.motor_length = Info{3}/1000;
Rocket.motor_delay = Info{4};
Rocket.propel_mass = Info{5};
Rocket.motor_mass = Info{6};
Rocket.casing_mass = Rocket.motor_mass-Rocket.propel_mass;
Rocket.Thrust_Time = time;
Rocket.Thrust_Force = Thrust;

end