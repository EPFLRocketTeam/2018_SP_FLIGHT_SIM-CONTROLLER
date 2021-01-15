%% Main_EE.m - Frédéric Berdoz - October 2020 
%
% Main runabale script for the elementary Effect method (Morris, 1993) applied to the ERT
% simulator.
% 

% Initialize
close all; clear all; clc;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_3D'),...
        genpath('./Helpers'));
    
% ODE integrator warnings
warning('off');

%% User input for the EE analysis
p = 100; % mesh simuze of the input space p-level grid
r = 50; % Number of rep etition for the EE analysis
sigma = 0.10; % Relative size of the input domains (intervals)

% missing fin_n, ab_n and lug_n.
Xid = [ "dmin" "dd" "z1" "z12" "z23" "fin_xt" "fin_s" "fin_cr" "fin_ct" "fin_xs" ...
        "fin_t" "lug_S" "rocket_m" "rocket_I" "rocket_cm" "ab_x" "ab_phi" ... 
        "pl_mass" "para_main_SCD" "para_drogue_SCD" "para_main_event" "intermotor_d" "motor_diaP" ...
        "motor_lengthP" "propel_massP" "motor_massP" "motor_diaF" "motor_lengthF" "propel_massF" ...
        "motor_massF" "Burn_Time" "T1" "T2" "Temperature_Ground" "Pressure_Ground" "Humidity_Ground"  ... 
        "Start_Altitude" "dTdh" "Rail_Length" "Rail_Angle" "Rail_Azimuth"...
        "Vi1" "Vi2" "Vi3" "Vi4" "Vi5" "Vi6" "ai1" "ai2" "ai3" "ai4" "ai5" "ai6"]';
    
Yid = ["Veor" "apogee" "t@apogee" "Vmax" "Vmax@t" "Cdmax" "a_max" "margin_min" "CNa_min" "MarCNa_min" "MarCNa_av" "landing_azi" "landing_drift"];

%Less inputs for debugging
%Xid = [ "dmin" "dd" "z1" "z12" "z23" "fin_xt"]'; 
%Yid = ["Veor" "apogee"];

% Base input values
Rocket = rocketReader('BL2_H3.txt'); 
Environment = environnementReader('Environment/Environnement_Definition_SA.txt'); %with exactly 6 windlayers
SimOutputs = SimOutputReader('Simulation/Simulation_outputs.txt');
 
% Base simulator object
SimObj = multilayerwindSimulator3D(Rocket, Environment, SimOutputs);

%% EE analysis
XX = baseValues(SimObj, Xid, sigma);
Delta = p/(2*(p-1));
k = length(Xid);
o = length(Yid);
d = NaN(r, k, o);

% Looping over the r repetitions
for l = 1:r
    t_r0 = tic;
    disp("Starting round " +  num2str(l) + "/" + num2str(r) + ".");
    
    % Sampling
    [B_l, EEid] = EEsampling(Xid, p);
    
    % Rescaling and shifting
    X = B_l'.*(XX(:,3) - XX(:,2)) + XX(:,2);
    
    % Evaluating the simulator at each sample
    Y_l = SimAPI(SimObj, Xid, Yid, X); 
    
    % Computing the elemetary effects
    d(l, :, :) = (Y_l(:,EEid(2,:)) - Y_l(:,EEid(1,:)))';
    
    disp("Round " +  num2str(l) + "/" + num2str(r) + " done. [" + num2str(toc(t_r0)) + " s]");
end

%% Results

mu = squeeze(mean(abs(d), 1));
[mu_sorted, idx_sorted] = sort(mu, 1);


%% Save outputs

folder_out = "Outputs/";
file_out = "EE_k" + num2str(k) + "_o" + num2str(o) + "_r" + num2str(r) + ".mat";

if isfile(folder_out + file_out)
    disp("File already exists. Saved under 'tmp_" + file_out + ".");
    save(folder_out + "tmp_" + file_out);
else
    save(folder_out + file_out);
end


