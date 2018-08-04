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

test_masses = [12 13 14];
test_motors = {'AT_L850', 'AT_L900', 'AT_L1040'};

n_masses = length(test_masses);
n_motors = length(test_motors);

%--------------------------------------------------------------------------
% Rocket Simulations
%--------------------------------------------------------------------------

% Rocket Definition
Rocket = rocketReader('Rocket_Definition_Final.txt');
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

% Batch simulations
for i = 1:n_motors
    for j = 1:n_masses
        
        [Rocket.Thrust_Time,Rocket.Thrust_Force,Rocket.propel_mass,Rocket.motor_mass] = motorReader('AT_L850.txt');
        
        
        [T,X] = ode45(@(t,x) Rocket_Kinematic_R2(t,x,Rocket,Environnement,@drag_shuriken, -190.5),tspan,x_0,Option);
        app(i,j) = X(end, 1);
        [v_max(i,j), ind_v_max] = max(X(2,:));
        [~, a, ~, ~, ~] = stdAtmos(Environnement.Start_Altitude+X(1, ind_v_max), Environnement);
        M_max(i,j) = v_max(i,j)/a;
    end
end

%--------------------------------------------------------------------------
% Plot results
%--------------------------------------------------------------------------

plot(test_masses, app);
legend(char(test_motors));