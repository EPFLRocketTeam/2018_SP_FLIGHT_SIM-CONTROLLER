% Rocket Simulator 3D

% Initialize
close all; clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'));

% Rocket Definition
Rocket = rocketReader('BL2_H2_AB.txt');
Environment = environnementReader('Environment/Environnement_Definition_2021.txt');
SimOutputs = SimOutputReader('Simulation/Simulation_outputs.txt');

SimObj = SimuMike3D(Rocket, Environment, SimOutputs);

%% ------------------------------------------------------------------------
% 6DOF Rail Simulation
%--------------------------------------------------------------------------

[T1, S1] = SimObj.RailSim();


display(['Launch rail departure velocity : ' num2str(S1(end,2))]);
display(['Launch rail departure time : ' num2str(T1(end))]);
display(['Burn Time : ' num2str(Rocket.Burn_Time(end))]);

%% ------------------------------------------------------------------------
% 6DOF Flight Simulation
%--------------------------------------------------------------------------

marge = SimObj.FlightSim([T1(end) SimObj.Rocket.Burn_Time(end)], S1(end, 2));
marge1 = SimObj.FlightSim([Rocket.Burn_Time(end),0], S1(end, 2));
min= ones(1,91);
minsafe = 2* ones(1,91) ;
max = 6 * ones(1,91);
plot(0:1:90,marge,'g')
hold on
plot(0:1:90, marge1,'b')
plot(0:1:90,min,'--r')
plot(0:1:90,minsafe,'--k')
plot(0:1:90,max,'--m')
xlabel('angle of attack (°)')
ylabel('caliber stability')
h = legend('rocket at end of rail', 'rocket after burn time','critical min', 'safe min' , 'max');
hold off;