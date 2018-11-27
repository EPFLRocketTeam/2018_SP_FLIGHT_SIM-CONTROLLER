%% Analysis of USA flight

% Initialize
close all; clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_3D'),...
        genpath('../FlightData'));
    
%% Load Raven 1 data

raven1_acc = csvread('USA/MATTERHORN_FLIGHT_1_acc.csv', 1, 0);
raven1_alt = csvread('USA/MATTERHORN_FLIGHT_1_alt.csv', 1, 0);
raven1_alt(:,2) = raven1_alt(:,2)*0.3048;
raven1_lim_i = find(raven1_acc(:, 1)>46, 1, 'first');
raven1_acc = raven1_acc(1:raven1_lim_i, :);
raven1_lim_i = find(raven1_alt(:, 1)>46, 1, 'first');
raven1_alt = raven1_alt(1:raven1_lim_i, :);

%% Load Raven 2 data

raven2_acc = csvread('USA/MATTERHORN_FLIGHT_2_acc.csv', 1, 0);
raven2_alt = csvread('USA/MATTERHORN_FLIGHT_2_alt.csv', 1, 0);
raven2_alt(:,2) = raven2_alt(:,2)*0.3048;
raven2_lim_i = find(raven2_acc(:, 1)>46, 1, 'first');
raven2_acc = raven2_acc(1:raven2_lim_i, :);
raven2_lim_i = find(raven2_alt(:, 1)>46, 1, 'first');
raven2_alt = raven2_alt(1:raven2_lim_i, :);

%% Load Nosecone data

nose_data = csvread('USA/ERT18-MATTERHORN II - flight_data telemetry.csv', 0, 0);
nose_time = 3;
nose_alt = 4;
nose_vspd = 5;
nose_pres = 6;
nose_temp = 7;
nose_accX = 8;
nose_accY = 9;
nose_accZ = 10;
nose_fs = 11;
nose_ab = 12;
nose_dp = 13;
nose_t_lo_i = find(abs(nose_data(:,nose_accX))>5, 1, 'first');
nose_t_lo = nose_data(nose_t_lo_i,nose_time); 
nose_alt_init = nose_data(nose_t_lo_i,nose_alt); 
nose_data(:, nose_time) = (nose_data(:, nose_time)- nose_t_lo)/1000;
nose_data(:, nose_alt) = nose_data(:, nose_alt) - nose_alt_init;
nose_t_ab_i = find(nose_data(:, nose_ab)>0, 1, 'first');
nose_t_ab = nose_data(nose_t_ab_i, nose_time);
nose_t_force_i = find(nose_data(:, nose_accX) > 0, 1, 'first');
nose_t_force = nose_data(nose_t_force_i, nose_time);
%% Run simulation

% Rocket Definition
Rocket = rocketReader('Rocket/Rocket_Definition_Final.txt');
Environment = environnementReader('Environment/Environnement_Definition.txt');
SimOutputs = SimOutputReader('Simulation_outputs.txt');

SimObj = Simulator3D(Rocket, Environment, SimOutputs);

% ------------------------------------------------------------------------
% 6DOF Rail Simulation
%--------------------------------------------------------------------------

[T1, S1] = SimObj.RailSim();

display(['Launch rail departure velocity : ' num2str(S1(end,2))]);

% ------------------------------------------------------------------------
% 6DOF Boost Simulation
%--------------------------------------------------------------------------
[T2_1, S2_1, T2_1E, S2_1E, I2_1E] = SimObj.FlightSim([T1(end) SimObj.Rocket.Thrust_Time(end)], S1(end,2));

% ------------------------------------------------------------------------
% 6DOF Boost Simulation
%--------------------------------------------------------------------------

SimObj.Rocket.cone_mode = 'off';
SimObj.Rocket.rocket_m = SimObj.Rocket.rocket_m-2.1;
SimObj.Rocket.rocket_cm = 1.44;
SimObj.Rocket.rocket_I = 5.68;

[T2_2, S2_2, T2_2E, S2_2E, I2_2E] = SimObj.FlightSim([T2_1(end) 40], S2_1(end,1:3)', S2_1(end,4:6)', S2_1(end,7:10)', S2_1(end,11:13)');

T2 = [T2_1; T2_2(2:end)];
S2 = [S2_1;S2_2(2:end, :)];

display(['Apogee AGL : ' num2str(S2(end,3))]);
display(['Max speed : ' num2str(max(S2(:,6)))]);
display(['Max acceleration : ' num2str(max(diff(S2(:,6))./diff(T2)))]);

%% plot data

% Figure 1 : time plot of altitude
figure; hold on;
% raven 1
plot(raven1_alt(:,1), raven1_alt(:,2), '-' ,'DisplayName', 'Raven 1');
% raven 2
plot(raven2_alt(:,1), raven2_alt(:,2), '-' ,'DisplayName', 'Raven 2');
% nose cone
plot(nose_data(:, nose_time), nose_data(:, nose_alt), '-', 'DisplayName', 'Cone');
plot(nose_t_ab*ones(1,2), ylim, '--' ,'DisplayName', 'First Airbrake Command');
plot(nose_t_force*ones(1,2), ylim, '--', 'DisplayName', 'Acceleration Inversion');
% simulation data
plot(T2, S2(:,3), '-', 'DisplayName', 'Simulation');
legend show; xlabel 'time [s]'; ylabel 'altitude [m]';
title('Altitude vs time');
set(gca, 'FontSize', 16);
grid on;
  

% Figure 2 : acceleration plot
figure; hold on;
% nose cone
plot(nose_data(:, nose_time), nose_data(:, nose_accX), 'DisplayName', 'Cone');
legend show; xlabel 'time [s]'; ylabel 'acceleration [g]';
title('Acceleration vs. time');
grid on;

% Figure 3 : interp and averaged raven
T = 0:0.1:ceil(T2(end));
filter_average = 1/5*ones(1,5);

raven1_alt_filt = filter(filter_average,1,raven1_alt(:,2));
raven1_alt_filt_interp = interp1(raven1_alt(:,1), raven1_alt_filt, T,'spline');
raven2_alt_filt = filter(filter_average,1,raven2_alt(:,2));
raven2_alt_filt_interp = interp1(raven2_alt(:,1), raven2_alt_filt, T,'spline');

t_stop = 5.6;   % Out of "nominal" curve due to cone lost
i_stop = 50;
t_go = 12;      % Back on "nominal" curve
i_go = 130;

raven1_alt_filt_interp2 = interp1(T([1:i_stop,i_go:end]),... 
    raven1_alt_filt_interp([1:i_stop,i_go:end]), T,'pchip');
raven2_alt_filt_interp2 = interp1(T([1:i_stop,i_go:end]),... 
    raven2_alt_filt_interp([1:i_stop,i_go:end]), T,'pchip');

figure; hold on;
plot(T,raven1_alt_filt_interp,'DisplayName', 'Raven1 avg')
plot(T,raven1_alt_filt_interp2, 'DisplayName', 'Raven1 interp')
plot(T,raven2_alt_filt_interp, 'DisplayName', 'Raven2 avg')
plot(T,raven2_alt_filt_interp2, 'DisplayName', 'Raven2 interp')
plot(T2,S2(:,3), 'DisplayName', 'Simulation altitude')
legend show; xlabel 'time [s]'; ylabel 'altitude [m]';
title('Interpolated Raven altitude vs. time');
grid on;

% Figure 4 : velocity plot
filter_average = 1/3*ones(1,3);
T_vel = 0:0.5:23;

sim_vel = interp1(T2,S2(:,6),T,'spline');
tmp_rav = circshift(raven1_alt_filt_interp2,-1);
tmp_T = circshift(T,-1);
raven1_vel = (tmp_rav(1:end-1)-raven1_alt_filt_interp2(1:end-1)) ./ ...
    (tmp_T(1:end-1)-T(1:end-1));
raven1_vel = [raven1_vel raven1_vel(end)];
raven1_vel_avg = interp1(T(1:51),raven1_vel(1:51),T_vel(1:11),'pchip');
figure; hold on;
plot(T,sim_vel,T_vel(1:11),raven1_vel_avg,T,raven1_vel)