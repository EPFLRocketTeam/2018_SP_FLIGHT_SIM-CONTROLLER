clear all;
close all;

% Initialize
close all; clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Simulator_1D'),...
        genpath('../Snippets'));

% Rocket Definition
Rocket = rocketReader('Rocket/Rocket_Definition_Eiger_I_Final.txt');
Environnement = environnementReader('Environment/Environnement_Definition_USA.txt');

% Define table generation parameters

H_target = 3048; N_H = 200; N_AB = 5;

% shuriken
AB_span = [-232, -18];
drag_func = @drag_shuriken;
convert_func = @(x) interp1(AB_span, [0, 200] , x, 'linear');

% flaps
% AB_span = [0, 60];
% drag_func = @drag_flaps;
% convert_func = @(x) x;

% thrust and drag error rate [0,1]

thrust_err = 0.085;
ab_err = 0;

% generate table

[tab, path] = Table_1D_Generator_R3(Rocket, Environnement, H_target, drag_func, convert_func, AB_span, N_H, N_AB, thrust_err, ab_err);
