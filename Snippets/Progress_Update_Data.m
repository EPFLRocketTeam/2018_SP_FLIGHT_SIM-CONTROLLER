clear all;
close all;

% Initialize
close all; clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Simulator_3D'),...
        genpath('../Snippets'));

% Rocket Definition
Rocket = rocketReader('Rocket/Rocket_Definition_Eiger_I_Final.txt');

Payload_mass = 4;

% Conversion 
m_to_in = 39.3700787;
kg_to_lbs = 2.20462262185;

%% Rocket Information

Airframe_Length_in = Rocket.L * m_to_in;
Airframe_Diameter_in = Rocket.dm * m_to_in;
Fin_span_in = Rocket.fin_s * m_to_in;
% LV weight with casing and without payload
Vehicle_wieght_lbs = (Rocket.rocket_m + Rocket.casing_mass - Payload_mass) * kg_to_lbs;
Propellant_weight_lbs = Rocket.propel_mass * kg_to_lbs;
Payload_weight_lbs = Payload_mass * kg_to_lbs;
% Sum below is identical to un-commented calculation
% Liftoff_weight_lbs = Vehicle_wieght_lbs + Propellant_weight_lbs + Payload_weight_lbs;
Liftoff_weight_lbs = (Rocket.rocket_m + Rocket.motor_mass) * kg_to_lbs;

Rocket_Information = [Airframe_Length_in;
    Airframe_Diameter_in;
    Fin_span_in;
    Vehicle_wieght_lbs;
    Propellant_weight_lbs;
    Payload_weight_lbs;
    Liftoff_weight_lbs];

display(['Airframe_Length_in = ' num2str(Airframe_Length_in)]);
display(['Airframe_Diameter_in = ' num2str(Airframe_Diameter_in)]);
display(['Fin_span_in = ' num2str(Fin_span_in)]);
display(['Vehicle_wieght_lbs = ' num2str(Vehicle_wieght_lbs)]);
display(['Propellant_weight_lbs = ' num2str(Propellant_weight_lbs)]);
display(['Payload_weight_lbs = ' num2str(Payload_weight_lbs)]);
display(['Liftoff_weight_lbs = ' num2str(Liftoff_weight_lbs)]);

%% Predicted Flight Analysis and Data

% Rocket Definition
Environment = environnementReader('Environment/Environnement_Definition_USA.txt');
SimOutputs = SimOutputReader('Simulation/Simulation_outputs.txt');

SimObj = Simulator3D(Rocket, Environment, SimOutputs);

warning('off','all')

%--------------------------------------------------------------------------
% 6DOF Rail Simulation
%--------------------------------------------------------------------------

[T1, S1] = SimObj.RailSim();

%--------------------------------------------------------------------------
% 6DOF Flight Simulation
%--------------------------------------------------------------------------

[T2_1, S2_1, T2_1E, S2_1E, I2_1E] = SimObj.FlightSim([T1(end) SimObj.Rocket.Burn_Time(end)], S1(end, 2));

%SimObj.Rocket.cone_mode = 'off';

[T2_2, S2_2, T2_2E, S2_2E, I2_2E] = SimObj.FlightSim([T2_1(end) 40], S2_1(end, 1:3)', S2_1(end, 4:6)', S2_1(end, 7:10)', S2_1(end, 11:13)');

T2 = [T2_1; T2_2(2:end)];
S2 = [S2_1; S2_2(2:end, :)];

% Constants
g0 = 9.80665; %[m/sec^2] gravity at sea level
m_to_feet = 3.2808399;

% Results

% Considering peak thrust at liftoff
Liftoff_thrust_to_weight_ratio = max(Rocket.Thrust_Force) / ((Rocket.rocket_m + Rocket.motor_mass) * g0);
Launch_rail_departure_velocity_ft = S1(end,2) * m_to_feet;

Stability = (SimObj.SimAuxResults.Xcp - SimObj.SimAuxResults.CM)./Rocket.dm;
% Cut values near apogee, when the rocket's speed is below 50 m/s
% (arbitrary, value chosen from analysis)
Stability = Stability(1:length(S2_1));

Min_static_margin_during_boost = min(Stability);

Max_acceleration_g = max(diff(S2(:,6))./diff(T2)) / g0;

Max_speed_ft = max(S2(:,6)) * m_to_feet;

Predicted_apogee_ft = S2(end,3) * m_to_feet;

Predicted_Flight_Data_and_Analysis = [Liftoff_thrust_to_weight_ratio;
    Launch_rail_departure_velocity_ft;
    Min_static_margin_during_boost;
    Max_acceleration_g;
    Max_speed_ft;
    Predicted_apogee_ft];

display(['Liftoff_thrust_to_weight_ratio = ' num2str(Liftoff_thrust_to_weight_ratio)]);
display(['Launch_rail_departure_velocity_ft = ' num2str(Launch_rail_departure_velocity_ft)]);
display(['Min_static_margin_during_boost = ' num2str(Min_static_margin_during_boost)]);
display(['Max_acceleration_g = ' num2str(Max_acceleration_g)]);
display(['Max_speed_ft = ' num2str(Max_speed_ft)]);
display(['Predicted_apogee = ' num2str(Predicted_apogee_ft)]);

%% End

warning('on','all')