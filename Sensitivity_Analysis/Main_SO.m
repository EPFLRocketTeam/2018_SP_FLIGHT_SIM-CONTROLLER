%% Main_SO.m - Frédéric Berdoz - October 2020 
%
% Main runabale script for the Sobol analysis applied to the ERT
% simulator.
% 

% Initialize
clc;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_3D'),...
        genpath('./Helpers'));
    
% ODE integrator warnings
warning('off');

%% User input for the EE analysis
N = 2^12; % Number of samples for the Sobol analysis (different than k for broadcasting)
sigma = 0.05; % Relative size of the input domains (intervals)
scheme = "LHC"; %LHC, Sobol, MC
SAVED = true;
ONLYDLR = true;

% missing fin_n, ab_n and lug_n.
Xid = [ "dmin" "dd" "z1" "z12" "z23" "fin_xt" "fin_s" "fin_cr" "fin_ct" "fin_xs" ...
         "fin_t" "lug_S" "rocket_m" "rocket_I" "rocket_cm" "ab_x" "ab_phi" ... 
         "pl_mass" "para_main_SCD" "para_drogue_SCD" "para_main_event" "intermotor_d" "motor_diaP" ...
         "motor_lengthP" "propel_massP" "motor_massP" "motor_diaF" "motor_lengthF" "propel_massF" ...
         "motor_massF" "Burn_Time" "T1" "T2" "Temperature_Ground" "Pressure_Ground" "Humidity_Ground"  ... 
         "Start_Altitude" "dTdh" "Rail_Length" "Rail_Angle" "Rail_Azimuth"...
         "Vi1" "Vi2" "Vi3" "Vi4" "Vi5" "Vi6" "ai1" "ai2" "ai3" "ai4" "ai5" "ai6"]';
    


%Less inputs for debugging
%Xid = ["fin_xt" "fin_s" "fin_cr" "fin_ct" "fin_xs" "fin_t" "Burn_Time" "T1"]; 

Yid = ["Veor" "apogee" "t@apogee" "Vmax" "Vmax@t" "Cdmax" "a_max" "margin_min" "CNa_min" "MarCNa_min" "MarCNa_av" "landing_azi" "landing_drift"];


% Base input values
Rocket = rocketReader('BL2_H3.txt'); 
Environment = environnementReader('Environment/Environnement_Definition_SA.txt'); %with exactly 6 windlayers
SimOutputs = SimOutputReader('Simulation/Simulation_outputs.txt');
 
% Base simulator object
SimObj = multilayerwindSimulator3D(Rocket, Environment, SimOutputs);

%% Sobol analysis

XX = baseValues(SimObj, Xid, sigma);
k = length(Xid);
o = length(Yid);

% Sampling
X = SOsampling(Xid, XX, N, scheme);
disp("Computing f(X):");
Y_X = SimAPI(SimObj, Xid, Yid, X); 

if ~ONLYDLR
    Z = SOsampling(Xid, XX, N, scheme);

    % Evaluating the simulator at each sample
    disp("---------------------------------------");
    disp("Computing f(Z):");
    Y_Z = SimAPI(SimObj, Xid, Yid, Z); 
    % Looping over each input
    E = eye(k); %Easy way of getting basis vectors
    Y_is = NaN(o, N, k); %Array storing the outputs when keeping only x_i the same
    Y_nis = NaN(o, N, k); %Array storing the outputs when changing everything but x_i


    for i = 1:k
        e_i = E(:, i);
        disp("---------------------------------------");
        disp("Computing f(Z + (X-Z)e_i) for i = " + num2str(i) + "/" + num2str(k) + ":");
        Y_is(:,:,i) =  SimAPI(SimObj, Xid, Yid, Z + (X-Z).*e_i);
        disp("---------------------------------------");
        disp("Computing f(X + (Z-X)e_i) for i = " + num2str(i) + "/" + num2str(k) + ":");
        Y_nis(:,:,i) = SimAPI(SimObj, Xid, Yid, X + (Z-X).*e_i);

    end
end


%% Save outputs
if SAVED
    folder_out = "Outputs/";
    
    file_out = "SO_k" + num2str(k) + "_o" + num2str(o) + "_N" + num2str(N) + "_" + scheme + ".mat";

    if isfile(folder_out + file_out)
        disp("File already exists. Saved under 'tmp_" + file_out + ".");
        save(folder_out + "tmp_" + file_out);
    else
        save(folder_out + file_out);
    end
end

