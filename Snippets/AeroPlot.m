% ------------------------------------------------------------------------
% AEROPLOT
% Plot Aerodynamic values of lift and drag for various angles of attack, 
% airbrake deployment angles and flow regimes.
% Date : 1.03.2018
% Author : Eric Brunner
% -------------------------------------------------------------------------

clear all; close all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'));
    
% -------------------------------------------------------------------------
% 1.0 Parameters and definitions
% -------------------------------------------------------------------------

readRocketFile = 1;
rocketFile = 'BL_H3.txt';

if readRocketFile
   Rocket = rocketReader(rocketFile); 
end

V = linspace(0, 346, 20);
alpha = linspace(0, pi/4, 5);
r = linspace(0, 1, 10);
nu = 1.5e-5;
a = 346;

% -------------------------------------------------------------------------
% 2.0 Coefficient calculation
% -------------------------------------------------------------------------

CD = zeros(length(V), length(alpha));
CNa = zeros(1, length(alpha));
XCP = zeros(1, length(alpha));

for i = 1:length(V)
    for j = 1:length(alpha) 
            CD(i,j) = drag(Rocket, alpha(j), V(i), nu, a);          
    end
end

for j = 1:length(alpha)
        [CNa(j),XCP(j)]  = normalLift(Rocket, alpha(j), 1.1, 0, 0, 1);
end
% -------------------------------------------------------------------------
% 3.0 Plot values
% -------------------------------------------------------------------------

set(0,'defaultaxescolororder',[0 0 0]);
set(0,'DefaultAxesLineStyleOrder',{'-', '--', ':', '-.', '-*'});

% 3.1 Drag coefficient
figure; hold on;
for i = 1:length(alpha)
    plot(V/a, CD(:,i,1), 'DisplayName', ['\alpha = ' num2str(rad2deg(alpha(i))) '^\circ'],...
        'LineWidth', 2);
end
legend show; grid on;
title 'Body-Fin Drag coefficient'; 
xlabel 'M [-]'; ylabel 'Cd [-]';
set(gca, 'Fontsize', 16);

% 3.1 Normal force coefficient
figure; hold on;
plot(rad2deg(alpha), CNa.*alpha, 'LineWidth', 2);
grid on;
title 'Normal force coefficient'; 
xlabel '\alpha [°]'; ylabel 'Cn [-]';
set(gca, 'Fontsize', 16);

% 3.1 Stability Margin
figure; hold on;
plot(rad2deg(alpha), (XCP-Rocket.rocket_cm)/Rocket.dm, 'LineWidth', 2);
grid on;
title 'Stability margin'; 
xlabel '\alpha [°]'; ylabel '(X_{cp} - X_{cm})/d_m [-]';
set(gca, 'Fontsize', 16);