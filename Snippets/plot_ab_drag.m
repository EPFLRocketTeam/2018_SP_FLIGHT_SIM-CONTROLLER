% PLOT_AB_DRAG is a script intended to plot the drag coefficient of the 
% two airbrake models: shuriken and flaps, normalized to the refernce area
% of the rocket. 

% Initialize
close all; clear all;

% create Rocket object
Rocket = rocketReader('Rocket_Definition.txt');

% define environment parameters
m = 3;
Uinf = [50 100 200]; % [m/s] free stream velocity
alpha = 0; % [deg] angle of attack
nu = 1.568e-5; % [m2/s] kinematic viscosity

% define abscissa range
n = 50;
phi = linspace(0,90, n);
theta = linspace(-190, 1, n);

% compute drag coefficient values
CD_flap = zeros(m,n);
CD_shuriken = zeros(m,n);
for j = 1:m
    for i = 1:n
       CD_flap(j,i) = drag_flaps(Rocket, phi(i), 0, Uinf(j), nu);
       CD_shuriken(j,i) = drag_shuriken(Rocket, theta(i), alpha, Uinf(j), nu);
    end
end

% plot graphs
figure; 
Markers = {'+','o','*','x','v','d','^','s','>','<'};

subplot(1,2,1); hold on;
for j = 1:m
    plot(phi/90, CD_flap(j,:), ['k-' Markers{j}], 'DisplayName', ['C_D @ U_\infty = ' num2str(Uinf(j)) 'm/s']);
end
xlabel '% deployed'; ylabel 'C_D';
title 'Normalized flaps drag coefficient';
legend show; grid on;

subplot(1,2,2); hold on;
for j = 1:m
    plot((190+theta)/191, CD_shuriken(j,:), ['k-' Markers{j}], 'DisplayName', ['C_D @ U_\infty = ' num2str(Uinf(j)) 'm/s']);
end
xlabel '% deployed'; ylabel 'C_D';
title 'Normalized shuriken drag coefficient';
legend show;  grid on;