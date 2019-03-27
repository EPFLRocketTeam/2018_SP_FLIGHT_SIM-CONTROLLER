% -------------------------------------------------------------------------
% Initialize
% -------------------------------------------------------------------------
close all; clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'),...
        genpath('../Simulator_2D'));
    
% -------------------------------------------------------------------------
% Parameter definitions
% -------------------------------------------------------------------------

% Rocket & Environment
Rocket = rocketReader('../Declarations/Rocket/Rocket_Definition_Mass.txt');
Environment = environnementReader('../Declarations/Environment/Environnement_Definition.txt');

% Control table parameters
H_target = 1030;
drag_func = @drag_shuriken;
phi_span = [-190, -18];
convert_func = @(phi) interp1(phi_span, [0, 172], phi, 'linear');
N_H = 50;
N_AB = 5;

% Airbrake simulation parameters
ab_target = 100;
Update_time = 0.1;

%% ------------------------------------------------------------------------
% Table generation
% -------------------------------------------------------------------------
ab_tab = Table_1D_Generator_R2(Rocket, Environment, H_target, drag_func, convert_func, phi_span, N_H, N_AB);

%% ------------------------------------------------------------------------
% 2D Airbrake simulation
% -------------------------------------------------------------------------
[T, X, theta_control] = Sim_Airbrakes(Rocket, Environment, drag_func, ab_tab, ab_target, 0.5, Update_time, 1);
plot(X(:,3), X(:,4), 'DisplayName', 'Control Path');
legend show;
