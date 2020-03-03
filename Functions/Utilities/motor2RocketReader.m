function Rocket = motor2RocketReader(motorFilePath, Rocket)
% MOTOR2ROCKETREADER reads the information contained in the RASP formatted
% motor text file named 'motorFilePath' into the 'Rocket' structure.
if( Rocket.isHybrid == 0)
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
else
    
[time, ThrustP, InfoP] = motorReader(motorFilePath);
[timeF,ThrustF,InfoF] = motorReader(Rocket.fuel_ID);


% prop bloc info
Rocket.motor_diaP = InfoP{2}/1000;
Rocket.motor_lengthP = InfoP{3}/1000;
Rocket.motor_delayP = InfoP{4}{1};
Rocket.propel_massP = InfoP{5};
Rocket.motor_massP = InfoP{6};
Rocket.casing_massP = Rocket.motor_massP-Rocket.propel_massP;

% fuel info
Rocket.motor_diaF = InfoF{2}/1000;
Rocket.motor_lengthF = InfoF{3}/1000;
Rocket.motor_delayF = InfoF{4}{1};
Rocket.propel_massF = InfoF{5};
Rocket.motor_massF = InfoF{6};
Rocket.casing_massF = Rocket.motor_massF-Rocket.propel_massF;

%Global info
Rocket.motor_dia = max(Rocket.motor_diaP, Rocket.motor_diaF);
Rocket.motor_length = Rocket.motor_lengthP + Rocket.motor_lengthF + Rocket.intermotor_d ;
Rocket.motor_delay = InfoP{4}{1};
Rocket.propel_mass = Rocket.propel_massP + Rocket.propel_massF ;
Rocket.motor_mass = Rocket.motor_massP + Rocket.motor_massF; 
Rocket.casing_mass = Rocket.casing_massP + Rocket.casing_massF ;

        
    
    
% thrust lookup table
if time(1)>0
   time = [0, time];
   ThrustP = [0, ThrustP];
elseif time(1)<0
   error('ERROR: in motor2RocketReader, thrust curve only allows positive time values'); 
end
Rocket.Thrust_Time = time;
Rocket.Thrust_Force = ThrustP;

% Burn time
Rocket.Burn_Time = time(end);

% Mass variation coefficient
A_T = trapz(time,ThrustP);
Rocket.Thrust2dMass_Ratio = Rocket.propel_mass/(A_T);    
end
end