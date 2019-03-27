clc
close all
clear

addpath('Data');

%% For csv : time[s],altitude[ft],acc[m/s^2],stability margin [calib],mach

OpenRocketData = csvread('Eiger_I_data.csv',17,0);
time1 = OpenRocketData(:,1);
altitude1 = OpenRocketData(:,2);
acc1 = OpenRocketData(:,3);
margin1 = OpenRocketData(:,4);
mach1 = OpenRocketData(:,5);
[apogee1,i_apo1] = max(altitude1);
t_apo1 = time1(i_apo1);

%% For csv : 

%% Plot data

figure;
hold on;grid on;
title('Acceleration and altitude')
yyaxis right;
plot(time1,altitude1,'DisplayName','altitude');
ylabel('altitude [m]');
xlabel('time [s]');
yyaxis left;
plot(time1,acc1./9.81,'DisplayName','acceleration');
ylabel('acceleration [g]');
legend show;

figure;
hold on;grid on;
title('Stability margin')
plot(time1(1:i_apo1),margin1(1:i_apo1),'DisplayName','Stability Margin');
xlabel('time [s]');
ylabel('stability margin [cal]');

figure;
hold on;grid on;
title('Mach and altitude')
yyaxis right;
plot(time1(1:i_apo1),altitude1(1:i_apo1),'DisplayName','altitude');
ylabel('altitude [m]');
xlabel('time [s]');
yyaxis left;
plot(time1(1:i_apo1),mach1(1:i_apo1),'DisplayName','mach');
ylabel('mach');
legend show;