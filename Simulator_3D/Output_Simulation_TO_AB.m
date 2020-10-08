% Initialize
close all; 
%clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'));


Rocket_0 = rocketReader('BL_H4.txt');
SimOutputs = SimOutputReader('Simulation/Simulation_outputs.txt');
name_of_environnment = 'Environment/Environnement_Definition_Wasserfallen.txt';

Environment = environnementReader(name_of_environnment);
SimObj = Simulator3D_AB_COM(Rocket_0, Environment, SimOutputs);
    
    
cHeader = {'time(ms)' 'A(mg)' 'A(mg)' 'A(mg)' 'P(Pa)'}; %dummy header
commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas
%write header to file
fid = fopen('log.csv','w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);

[~,~,p,~, ~] = stdAtmos(Environment.Start_Altitude, Environment);


to_output = transpose([ 0.0: 0.01 : 19.99 ; 0*ones(1,2000) ; 0*ones(1,2000); -1000*ones(1,2000); p*ones(1,2000)]);

dlmwrite('log.csv',to_output,'-append');


[T1, S1] = SimObj.RailSim();
[T2_1, S2_1, T2_1E, S2_1E, I2_1E] = SimObj.FlightSim([T1(end) SimObj.Rocket.Burn_Time(end)], S1(end, 2));
[T2_2, S2_2, T2_2E, S2_2E, I2_2E] = SimObj.FlightSim([T2_1(end) 40], S2_1(end, 1:3)', S2_1(end, 4:6)', S2_1(end, 7:10)', S2_1(end, 11:13)');
T2 = [T2_1; T2_2(2:end)];
S2 = [S2_1; S2_2(2:end, :)];
T_1_2 = [T1;T2];
S_1_2 = [S1;S2(:,3) S2(:,6)];
[T3, S3, T3E, S3E, I3E] = SimObj.DrogueParaSim(T2(end), S2(end,1:3)', S2(end, 4:6)');
[T4, S4, T4E, S4E, I4E] = SimObj.MainParaSim(T3(end), S3(end,1:3)', S3(end, 4:6)');






