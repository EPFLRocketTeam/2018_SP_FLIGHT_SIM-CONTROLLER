%% Main_NS.m - Frédéric Berdoz - October 2020 
%
% Main runabale script for the analysis of the different ODDE solver applied to the ERT
% simulator.
% 

% Initialize
close all; clear all; clc;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_3D'),...
        genpath('./Simulators'),...
        genpath('./Helpers'));
    
% ODE integrator warnings
warning('off');

%% User input for the NS analysis
N = 50;
sigma = 0.05; % Relative size of the input domains (intervals)

% missing fin_n, ab_n and lug_n.
Xid = [ "dmin" "dd" "z1" "z12" "z23" "fin_xt" "fin_s" "fin_cr" "fin_ct" "fin_xs" ...
        "fin_t" "lug_S" "rocket_m" "rocket_I" "rocket_cm" "ab_x" "ab_phi" ... 
        "pl_mass" "para_main_SCD" "para_drogue_SCD" "para_main_event" "intermotor_d" "motor_diaP" ...
        "motor_lengthP" "propel_massP" "motor_massP" "motor_diaF" "motor_lengthF" "propel_massF" ...
        "motor_massF" "Burn_Time" "T1" "T2" "Temperature_Ground" "Pressure_Ground" "Humidity_Ground"  ... 
        "Start_Altitude" "dTdh" "Rail_Length" "Rail_Angle" "Rail_Azimuth"...
        "Vi1" "Vi2" "Vi3" "Vi4" "Vi5" "Vi6" "ai1" "ai2" "ai3" "ai4" "ai5" "ai6"]';
    

%Less inputs for debugging
%Xid = [ "dmin" "dd" "z1" "z12" "z23" "fin_xt"]'; 


% Base input values
Rocket = rocketReader('BL2_H3.txt'); 
Environment = environnementReader('Environment/Environnement_Definition_SA.txt'); %with exactly 6 windlayers
SimOutputs = SimOutputReader('Simulation/Simulation_outputs.txt');
 
% Base simulator object
SimObj = multilayerwindSimulator3D(Rocket, Environment, SimOutputs);

%% Creating the samples
XX = baseValues(SimObj, Xid, sigma);
k = length(Xid);

rng = rand(k, N);
X = rng.*(XX(:,3) - XX(:,2)) + XX(:,2);

%% ode45

SimObj = multilayerwindSimulator3D_ode45(Rocket, Environment, SimOutputs);
[Y_45, t_45] = SimAPI_NS(SimObj, Xid, X);

%% ode23

SimObj = multilayerwindSimulator3D_ode23(Rocket, Environment, SimOutputs);
[Y_23, t_23] = SimAPI_NS(SimObj, Xid, X);

%% ode113

SimObj = multilayerwindSimulator3D_ode113(Rocket, Environment, SimOutputs);
[Y_113, t_113] = SimAPI_NS(SimObj, Xid, X);

%% ode15s

SimObj = multilayerwindSimulator3D_ode15s(Rocket, Environment, SimOutputs);
[Y_15s, t_15s] = SimAPI_NS(SimObj, Xid, X);

%% ode23s

SimObj = multilayerwindSimulator3D_ode23s(Rocket, Environment, SimOutputs);
[Y_23s, t_23s] = SimAPI_NS(SimObj, Xid, X);

%% ode23t

SimObj = multilayerwindSimulator3D_ode23t(Rocket, Environment, SimOutputs);
[Y_23t, t_23t] = SimAPI_NS(SimObj, Xid, X);

%% ode23tb

SimObj = multilayerwindSimulator3D_ode23tb(Rocket, Environment, SimOutputs);
[Y_23tb, t_23tb] = SimAPI_NS(SimObj, Xid, X);


%% Save outputs

folder_out = "Outputs/";
file_out = "NS_N" + num2str(N) + ".mat";

if isfile(folder_out + file_out)
    disp("File already exists. Saved under 'tmp_" + file_out + ".");
    save(folder_out + "tmp_" + file_out);
else
    save(folder_out + file_out);
end


