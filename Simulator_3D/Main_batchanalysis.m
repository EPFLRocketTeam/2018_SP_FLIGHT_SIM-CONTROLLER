%% Rocket Simulator 3D-Effect of wind and Rail angle on apogee

% Initialize
close all; clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'));

% Rocket Definition
Rocket = rocketReader('Eiger_Kaltbrunn.txt');
Environment = environnementReader('Environment/Environnement_Definition_Kaltbrunn.txt');
SimOutputs = SimOutputReader('Simulation/Simulation_outputs.txt');

SimObj = Simulator3D(Rocket, Environment, SimOutputs);
%%
windSpace = [-5;-4;-3;-2;-1;0;1;2;3;4;5];
rail_AngleSpace = [0; 0.03;0.06;0.09];
%%
batchResults =[];
fh = figure; hold on;
for i=1:length(windSpace)
    for j=1:length(rail_AngleSpace)
        Environment = setfield(Environment, 'V_inf',windSpace(i) );
        Environment = setfield(Environment, 'Rail_Angle', rail_AngleSpace(j));
        
        
         SimObj = Simulator3D(Rocket, Environment, SimOutputs);
    
        %% ------------------------------------------------------------------------
        % 6DOF Rail Simulation
        %--------------------------------------------------------------------------

        [T1, S1] = SimObj.RailSim();

        %% ------------------------------------------------------------------------
        % 6DOF Flight Simulation
        %--------------------------------------------------------------------------

         [T2, S2, T21, S21, I2_1E] = SimObj.FlightSim([T1(end) SimObj.Rocket.Burn_Time(end)], S1(end, 2));

        apogee_rec(i,j) = S2(end, 3);

        plot(T2, S2(:,3));

        drawnow;
        
        batchResults = [batchResults; T2(end), S2(end, 3), windSpace(i), rail_AngleSpace(j)];
        
        
    end
end
%% Save Results

save('WindRailStudy','batchResults' )
%%
figure
surf(rail_AngleSpace,windSpace,apogee_rec)