%% Rocket Simulator 3D

% Initialize
close all; clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'));

% Rocket Definition
Rocket = rocketReader('Rocket_Definition_Final.txt');
Environment = environnementReader('Environnement_Definition.txt');
SimOutputs = SimOutputReader('Simulation_outputs.txt');

SimObj = Simulator3D(Rocket, Environment, SimOutputs);

%% ------------------------------------------------------------------------
% 6DOF Rail Simulation
%--------------------------------------------------------------------------

[T1, S1] = SimObj.RailSim();

display(['Launch rail departure velocity : ' num2str(S1(end,2))]);

%% ------------------------------------------------------------------------
% 6DOF Boost Simulation
%--------------------------------------------------------------------------
[T2_1, S2_1, T2_1E, S2_1E, I2_1E] = SimObj.FlightSim([T1(end) SimObj.Rocket.Thrust_Time(end)], S1(end,2));

%% ------------------------------------------------------------------------
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
%% ------------------------------------------------------------------------
% 3DOF Recovery Drogue
%--------------------------------------------------------------------------

[T3, S3, T3E, S3E, I3E] = SimObj.DrogueParaSim(T2(end), S2(end,1:3)', S2(end, 4:6)');

%% ------------------------------------------------------------------------
% 3DOF Recovery Main
%--------------------------------------------------------------------------

[T4, S4, T4E, S4E, I4E] = SimObj.MainParaSim(T3(end), S3(end,1:3)', S3(end, 4:6)');

%% ------------------------------------------------------------------------
% 3DOF Crash Simulation
%--------------------------------------------------------------------------

[T5, S5, T5E, S5E, I5E] = SimObj.CrashSim(T2(end), S2(end,1:3)', S2(end, 4:6)');

%% ------------------------------------------------------------------------
% Analyse results
%--------------------------------------------------------------------------

% PLOT 1 : 3D rocket trajectory

C = quat2rotmat(S2(:, 7:10));
angle = rot2anglemat(C);

% plot rocket orientation
figure; hold on;
direcv = zeros(length(C),3);
for i  = 1:length(C)
    direcv(i,:) = C(:,:,i)*[0;0;1];
end
%quiver3(S2(:,1), S2(:,2), S2(:,3), direcv(:,1), direcv(:,2), direcv(:,3));

% plot trajectory of CM
plot3(S2(:,1), S2(:,2), S2(:,3), 'DisplayName', 'Ascent');
plot3(S3(:,1), S3(:,2), S3(:,3), 'DisplayName', 'Drogue Descent');
plot3(S4(:,1), S4(:,2), S4(:,3), 'DisplayName', 'Main Descent');
plot3(S5(:,1), S5(:,2), S5(:,3), 'DisplayName', 'Ballistic Descent')
daspect([1 1 1]); pbaspect([1, 1, 1]); view(45, 45);
% [XX, YY, M, Mcolor] = get_google_map(Environment.Start_Latitude, Environment.Start_Longitude, 'Height', ceil(diff(xlim)/3.4), 'Width', ceil(diff(ylim)/3.4));
% xImage = [xlim',xlim'];
% yImage = [ylim;ylim];
% zImage = zeros(2);
% colormap(Mcolor);
% surf(xImage, yImage, zImage, 'CData', M,'FaceColor', 'texturemap', 'EdgeColor', 'none', 'DisplayName', 'Base Map');
title '3D trajectory representation'
xlabel 'S [m]'; ylabel 'E [m]'; zlabel 'Altitude [m]';
legend show;

% PLOT 2 : time dependent altitude
figure; hold on;
plot(T2, S2(:,3));
plot(T3, S3(:,3));
plot(T4, S4(:,3));
plot(T5, S5(:,3));
title 'Altitude vs. time'
xlabel 't [s]'; ylabel 'Altitude [m]';

% PLOT 3 : Altitude vs. drift
figure; hold on;
plot(sqrt(S2(:,1).^2 + S2(:,2).^2), S2(:,3));
%quiver(sqrt(S2(:,1).^2 + S2(:,2).^2), S2(:,3), sqrt(direcv(:,1).^2 + direcv(:,2).^2), direcv(:,3));
plot(sqrt(S3(:,1).^2 + S3(:,2).^2), S3(:,3));
plot(sqrt(S4(:,1).^2 + S4(:,2).^2), S4(:,3));
plot(sqrt(S5(:,1).^2 + S5(:,2).^2), S5(:,3));
title 'Altitude vs. drift'
xlabel 'Drift [m]'; ylabel 'Altitude [m]';
daspect([1 1 1]);

% PLOT 4 : Aerodynamic properties
figure; hold on;
% Plot Margin
subplot(3,2,1);
plot(T2, SimObj.SimAuxResults.Margin)
hold on;
plot(ones(1,2)*Rocket.Burn_Time, ylim, 'g');
title 'Margin';
% Plot Xcp
subplot(3,2,2);
plot(T2, SimObj.SimAuxResults.Xcp)
hold on;
plot(ones(1,2)*Rocket.Burn_Time, ylim, 'g');
title 'X_{cp}';
% Plot AoA vs. time
subplot(3,2,3);
plot(T2, SimObj.SimAuxResults.Alpha)
hold on;
plot(ones(1,2)*Rocket.Burn_Time, ylim, 'g');
title '\alpha';
% Plot CNa vs. time
subplot(3,2,4);
plot(T2, SimObj.SimAuxResults.Cn_alpha)
hold on;
plot(ones(1,2)*Rocket.Burn_Time, ylim, 'g');
title 'Cn_{\alpha}';
% Plot Cd vs. time
subplot(3,2,5);
plot(T2, SimObj.SimAuxResults.Cd)
ylim([0, 1.5]);
tmpYlim = ylim;
set(gca, 'YTick', tmpYlim(1):0.1:tmpYlim(2));
hold on;
plot(ones(1,2)*Rocket.Burn_Time, ylim, 'g');
title 'Cd'
screensize = get( groot, 'Screensize' );
set(gcf,'Position',[screensize(1:2), screensize(3)*0.5,screensize(4)]);

% PLOT 5 : Mass properties
figure; hold on;
% Plot mass vs. time
subplot(2,2,1);
plot(T2, SimObj.SimAuxResults.Mass)
hold on;
plot(ones(1,2)*Rocket.Burn_Time, ylim, 'g');
tmpYlim = ylim;
title 'Mass';
set(gca, 'YTick', tmpYlim(1):0.5:tmpYlim(2));
hold on;
plot(ones(1,2)*Rocket.Burn_Time, ylim, 'g');
% Plot CM vs. time
subplot(2,2,2);
plot(T2, SimObj.SimAuxResults.CM)
tmpYlim = ylim;
title 'CM';
set(gca, 'YTick', tmpYlim(1):0.01:tmpYlim(2));
hold on;
plot(ones(1,2)*Rocket.Burn_Time, ylim, 'g');
% Plot Il vs. time
subplot(2,2,3);
plot(T2, SimObj.SimAuxResults.Il)
tmpYlim = ylim;
title 'Il';
set(gca, 'YTick', tmpYlim(1):0.1:tmpYlim(2));
hold on;
plot(ones(1,2)*Rocket.Burn_Time, ylim, 'g');
%Plot Ir vs. time
subplot(2,2,4);
plot(T2, SimObj.SimAuxResults.Ir)
title 'Ir';
hold on;
plot(ones(1,2)*Rocket.Burn_Time, ylim, 'g');
screensize = get( groot, 'Screensize' );
set(gcf,'Position',[screensize(3)*0.5, screensize(2),...
    screensize(3)*0.5,screensize(3)*0.5]);            

% PLOT 6 : Margin plot
figure; hold on;
title 'Stability margin'
yyaxis left;
plot(T2, SimObj.SimAuxResults.CM, 'DisplayName', 'X_{CM}');
plot(T2, SimObj.SimAuxResults.Xcp, 'DisplayName', 'X_{CP}');
ylabel 'X_{CM}, X_{CP} [cm]'
yyaxis right;
plot(T2, SimObj.SimAuxResults.Margin, 'DisplayName', 'Margin');
ylabel 'Margin [calibers]';
title 'Dynamic Stability Margin'
legend show;