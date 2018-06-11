%% Initialize
close all
clear all

% load directories
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'),...
        genpath('../Simulator_2D'));
    
% load defintions
Rocket_USA = rocketReader('Rocket_Definition_Final.txt');
Rocket_Payerne = rocketReader('Rocket_Definition_Payerne.txt');
Environment_USA = environnementReader('Environment_Definition.txt');
Environment_Payerne = environnementReader('Environment_Definition.txt');

%% Simulate