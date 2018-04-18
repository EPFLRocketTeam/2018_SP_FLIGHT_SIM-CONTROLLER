% -------------------------------------------------------------------------
% Initialize
% -------------------------------------------------------------------------

close all; clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'));
    
% -------------------------------------------------------------------------
% Definitions
% -------------------------------------------------------------------------
% rocket structure
Rocket = rocketReader('Rocket_Definition.txt');
% environment structure
Environnement = environnementReader('Environnement_Definition.txt');
% target altitude and discretization grid
H_target = 1000; % [m]
% airbrake boundaries and test values
theta_AB = linspace(-190.5, 1.165, 5); % [deg]

% -------------------------------------------------------------------------
% Forward simulaiton
% -------------------------------------------------------------------------
tspan = [0, 30];
x0 = [0,0];
Option = odeset('Events', @myEvent);
[t,x] = ode45(@(t,x) Rocket_Kinematic(t,x,Rocket,Environnement,theta_AB(1),1),tspan,x0, Option);
% get altitude and time value for beginning of burn phase
H_initial = interp1(t, x(:,1), Rocket.Burn_Time, 'linear');

figure; hold on;
title 'Velocity and height plot for boost and braking trajectories';
set(gca, 'Fontsize', 16); xlabel 'h'; ylabel 'v';
plot(x(:,1), x(:,2), 'k--', 'DisplayName', 'Nominal trajectory');

display('Sim: Boost OK ');
% -------------------------------------------------------------------------
% Backward simulation
% -------------------------------------------------------------------------
tspan = [30 double(Rocket.Burn_Time)];
x0 = [H_target, 0];
for theta = theta_AB
    [t,x] = Sim_1D(Rocket, Environnement, tspan, x0, 'Altitude', H_initial, -1)
    plot(x(:,1), x(:,2), 'DisplayName', ['\theta = ' num2str(theta)]);
    display(['Sim: Angle ' num2str(theta) ' OK']);
end