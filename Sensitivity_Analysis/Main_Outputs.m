 %% Main_Outputs.m - Frédéric Berdoz - October 2020 
%
% Main runabale script for visualizing the outpus
% 

% Initialize
clc; clear all; close all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_3D'),...
        genpath('./Helpers'));
    
% ODE integrator warnings
warning('off');

%% Loading the paramters
% Rocket Definition
Rocket = rocketReader('BL2_H3.txt');
Environment = environnementReader('Environment/Environnement_Definition_SA.txt');
SimOutputs = SimOutputReader('Simulation/Simulation_outputs.txt');

SimObj = multilayerwindSimulator3D(Rocket, Environment, SimOutputs);

%% Simulation

[T1, S1] = SimObj.RailSim();

[T2_1, S2_1, T2_1E, S2_1E, I2_1E] = SimObj.FlightSim([T1(end) SimObj.Rocket.Burn_Time(end)], S1(end, 2));

[T2_2, S2_2, T2_2E, S2_2E, I2_2E] = SimObj.FlightSim([T2_1(end) 40], S2_1(end, 1:3)', S2_1(end, 4:6)', S2_1(end, 7:10)', S2_1(end, 11:13)');

T2 = [T2_1; T2_2(2:end)];
S2 = [S2_1; S2_2(2:end, :)];

T_1_2 = [T1;T2];
S_1_2 = [S1;S2(:,3) S2(:,6)];

[T3, S3, T3E, S3E, I3E] = SimObj.DrogueParaSim(T2(end), S2(end,1:3)', S2(end, 4:6)');

[T4, S4, T4E, S4E, I4E] = SimObj.MainParaSim(T3(end), S3(end,1:3)', S3(end, 4:6)');

[T5, S5, T5E, S5E, I5E] = SimObj.CrashSim(T2(end), S2(end,1:3)', S2(end, 4:6)');

%% Margin plot
figure('Name','Static Margin'); hold on;
title 'Static Margin';
yyaxis left;
plot(T2, SimObj.SimAuxResults.CM, 'DisplayName', 'X_{CM}');
plot(T2, SimObj.SimAuxResults.Xcp, 'DisplayName', 'X_{CP}');
ylabel 'X_{CM}, X_{CP} [cm]'
yyaxis right;
plot(T2, SimObj.SimAuxResults.Margin, 'DisplayName', 'Margin');
xlabel 'Time [s]';
ylabel 'Margin [-]';
legend show;

%% Margin * CNa plot and apogee
figure('Name','Simulator Outputs'); 

subplot(1,2,1)
hold on;
title 'Stability Margin'
xline(T2(1), '-', {'End of Rail'}, 'LabelVerticalAlignment', 'middle', 'LabelHorizontalAlignment', 'center', 'Color', 'green', 'LineWidth', 1.2, 'DisplayName', 'End of Rail');
xline(SimObj.Rocket.Burn_Time,  '-', {'End of Propulsion'}, 'LabelVerticalAlignment', 'middle', 'LabelHorizontalAlignment', 'center', 'Color', 'red', 'LineWidth', 1.2, 'DisplayName', 'End of Propulsion');
xline(T2(end),  '-', {'Apogee'}, 'LabelVerticalAlignment', 'middle', 'LabelHorizontalAlignment', 'center', 'Color', 'magenta', 'LineWidth', 1.2, 'DisplayName', 'Apogee');
legend show;

yyaxis left
plot(T2,SimObj.SimAuxResults.Cn_alpha.*SimObj.SimAuxResults.Margin, 'LineWidth', 1.2, 'DisplayName', 'Stability')
xlabel 'Time [s]';
ylabel 'MS{\times}C_{N{\alpha}} [-]';
grid on
ylim([0 50]);

yyaxis right
ylabel 'V [m/s]';
plot(T2,sqrt(S2(:,4).^2 + S2(:,5).^2 + S2(:,6).^2) , 'LineWidth', 1.2, 'DisplayName', 'Velocity')

% Altitude vs. drift
subplot(1,2,2)
title 'Altitude vs Drift'; 
hold on; grid on
plot(sqrt(S2(:,1).^2 + S2(:,2).^2), S2(:,3), 'DisplayName', 'Ascent', 'LineWidth', 1.2);
plot(sqrt(S3(:,1).^2 + S3(:,2).^2), S3(:,3), 'DisplayName', 'Drogue', 'LineWidth', 1.2);
plot(sqrt(S4(:,1).^2 + S4(:,2).^2), S4(:,3), 'DisplayName', 'Main', 'LineWidth', 1.2);
plot(sqrt(S5(:,1).^2 + S5(:,2).^2), S5(:,3), 'd', 'DisplayName', 'CrashSim', 'LineWidth', 1.2);
xlabel 'Drift [m]'; ylabel 'Altitude [m]';

ymax = ceil(S2(end,3)/1000)*1000;
ylim([0 ymax]);
xmax = ceil(sqrt(S5(end,1).^2 + S5(end,2).^2)/100)*100;
xlim([0,xmax]);

legend show;

%% Wind Model
alt = [10 100 200 500 1000 2000];
Vspeed = 3 * ones(1,6);
Vturb = 0.2 * ones(1,6);
Vazy = 150 * ones(1,6);

turb_std = Vturb .* Vspeed;
axis = 0:10:4000;

% Baseline plot
figure('Name', 'Wind Model')
title 'Multi-layered Wind Model';
xlabel 'Velocity [m/s]';
ylabel 'Altitude [m]';
hold on;
grid on;

xl = [-10 15];
xlim(xl);
yl = [0 4000];
ylim(yl);
plt1 = plot(SimObj.Environment.Vspeed, axis, 'DisplayName', 'Wind Model', 'LineWidth', 1.2);
plt2 = plot(Vspeed, alt, 'd', 'DisplayName', 'Data Points', 'LineWidth', 1.5);
yline(S2(end,3), '--', 'LineWidth', 1.2, 'DisplayName', 'Apogee');

for i = 1:10
    
    Vspeed_i_dp = normrnd(Vspeed, turb_std);
    Vspeed_i = interp1(alt, Vspeed_i_dp, axis, 'pchip', 'extrap');
    Vazy_i = interp1(alt, Vazy, axis, 'pchip', 'extrap');
    
    plot(Vspeed_i, axis, 'LineWidth', 0.8, 'Color', [0.8 0.8 0.8]);
    plot(Vspeed_i_dp, alt, 'x', 'DisplayName', 'Data Points', 'LineWidth', 1.2, 'MarkerSize', 4, 'Color', [0.8 0.8 0.8]);
end

xBox = [xl(1), xl(1), 0, 0, xl(1)]
yBox = [yl(1), yl(2), yl(2), yl(1), yl(1)]
patch(xBox, yBox,'black', 'EdgeColor','none', 'FaceColor', 'red', 'FaceAlpha', 0.1);
legend('Deterministic Model', 'Data Points', 'Apogee', 'Random Models');
uistack(plt1,'top')
uistack(plt2,'top')