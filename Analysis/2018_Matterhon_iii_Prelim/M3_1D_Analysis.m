%% Rocket Simulator 1D

%--------------------------------------------------------------------------
% Initialize
%--------------------------------------------------------------------------
close all; clear all;

root = split(pwd, filesep);
root = char(join(root(1:end-2), filesep));

addpath(genpath([root '/Simulator_1D']),...
        genpath([root '/Declarations']),...
        genpath([root '/Functions']),...
        genpath([root '/Snippets']));
    
%--------------------------------------------------------------------------
% Parameters
%--------------------------------------------------------------------------    

test_masses = 12:1:14;
test_motors = {'AT_L850.txt', 'AT_L900.txt', 'AT_L1040.txt', 'AT_L1150.txt', 'AT_L1170.txt', 'AT_L1250.txt', 'AT_L1365.txt', 'AT_L1390.txt', 'AT_L1420.txt', 'AT_L1520.txt', 'AT_L2200.txt'};

n_masses = length(test_masses);
n_motors = length(test_motors);

%--------------------------------------------------------------------------
% Rocket Simulations
%--------------------------------------------------------------------------

% Rocket Definition
Rocket = rocketReader('BL_H4.txt');
Environnement = environnementReader('Environnement_Definition_Cernier.txt');

% Initial Conditions
x_0 = [0;0]; % No speed, no height
tspan = [0 30];

% Simulation options
Option = odeset('Events', @myEvent);

% Apogee store variable
app = zeros(n_motors, n_masses);
% max speed store variable
v_max = zeros(n_motors, n_masses);
M_max = zeros(n_motors, n_masses);
% launchrail departure speed
v_rail = zeros(n_motors, n_masses);

% Batch simulations
for i = 1:n_motors
    
    fprintf('Analysing file : %s', test_motors{i});
    
    Rocket = motor2RocketReader(test_motors{i}, Rocket);
    
    for j = 1:n_masses
        
        fprintf(', m = %f', test_masses(j));
        
        Rocket.rocket_m = test_masses(j);
        
        [T,X] = ode45(@(t,x) Rocket_Kinematic_R2(t,x,Rocket,Environnement,@drag_shuriken, -190.5),tspan,x_0,Option);
        app(i,j) = X(end, 1);
        [v_max(i,j), ind_v_max] = max(X(:,2));
        [~, a, ~, ~, ~] = stdAtmos(Environnement.Start_Altitude+X(ind_v_max, 1), Environnement);
        M_max(i,j) = v_max(i,j)/a;
        
        v_rail(i,j) = interp1(X(find(X(:,1)>0),1), X(find(X(:,1)>0),2), Environnement.Rail_Length);
         
    end
    
    display(' ');
    
end

%--------------------------------------------------------------------------
% Analyse results
%--------------------------------------------------------------------------

% order curves
integral_val = trapz(test_masses, app');
[~,ind_sort] = sort(integral_val);

app = app(ind_sort, :);
M_max = M_max(ind_sort, :);
v_max = v_max(ind_sort, :);
v_rail = v_rail(ind_sort, :);
test_motors = test_motors(ind_sort);

%--------------------------------------------------------------------------
% Plot results
%--------------------------------------------------------------------------

figure;
plot(test_masses, app', 'LineWidth', 2);
l = legend(char(test_motors));
set(l, 'Interpreter', 'none');
title('Appogee vs. dry mass');
xlabel 'Mass [kg]'; ylabel 'Appogee [m]';
set(gca, 'FontSize', 14);

figure;
plot(test_masses, M_max', 'LineWidth', 2);
l = legend(char(test_motors));
set(l, 'Interpreter', 'none');
title('Max Mach vs. dry mass');
xlabel 'Mass [kg]'; ylabel 'max(Mach) [-]';
set(gca, 'FontSize', 14);

figure;
plot(test_masses, v_rail', 'LineWidth', 2);
l = legend(char(test_motors));
set(l, 'Interpreter', 'none');
title(['Departure velocity vs. dry mass ( Rail Length = ' num2str(Environnement.Rail_Length) 'm )']);
xlabel 'Mass [kg]'; ylabel 'v_{rail} [m/s]';
set(gca, 'FontSize', 14);

