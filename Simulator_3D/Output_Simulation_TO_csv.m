% Initialize
close all; 
%clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'));

% Rocket Definition

cHeader = {'time(ms)' 'X(x)' 'X(y)' 'X(z)'  'A(x)' 'A(y)' 'A(z)', 'P(Pa)', 'T(K)'}; %dummy header
commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas
%write header to file
fid = fopen('test.csv','w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);

cHeader = {'time(ms)' 'X(x)' 'X(y)' 'X(z)'  'A(x)' 'A(y)' 'A(z)', 'P(Pa)', 'T(K)'}; %dummy header
commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas
%write header to file
fid = fopen('log.csv','w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);



Rocket_0 = rocketReader('WASSERFALLEN_FRANKENSTEIN.txt');
SimOutputs = SimOutputReader('Simulation/Simulation_outputs.txt');
name_of_environnment = 'Environment/Environnement_Definition_Wasserfallen.txt';

Environment = environnementReader(name_of_environnment);
SimObj = Simulator3D_CAN_COM(Rocket_0, Environment, SimOutputs);
[T1, S1] = SimObj.RailSim();
[T2_1, S2_1, T2_1E, S2_1E, I2_1E] = SimObj.FlightSim([T1(end) SimObj.Rocket.Burn_Time(end)], S1(end, 2));
[T2_2, S2_2, T2_2E, S2_2E, I2_2E] = SimObj.FlightSim([T2_1(end) 40], S2_1(end, 1:3)', S2_1(end, 4:6)', S2_1(end, 7:10)', S2_1(end, 11:13)');
T2 = [T2_1; T2_2(2:end)];
S2 = [S2_1; S2_2(2:end, :)];
T_1_2 = [T1;T2];
S_1_2 = [S1;S2(:,3) S2(:,6)];
[T3, S3, T3E, S3E, I3E] = SimObj.DrogueParaSim(T2(end), S2(end,1:3)', S2(end, 4:6)');
[T4, S4, T4E, S4E, I4E] = SimObj.MainParaSim(T3(end), S3(end,1:3)', S3(end, 4:6)');

T = readtable('test.csv', 'HeaderLines',1);
max = T{end,1};
bound = round(100*max)/100;
[~, index] = unique(T{:,1}); 
X = interp1(T{:,1}(index), T{:,2}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  
Y = interp1(T{:,1}(index), T{:,3}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  
Z = interp1(T{:,1}(index), T{:,4}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  
AX = interp1(T{:,1}(index), T{:,5}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  
AY = interp1(T{:,1}(index), T{:,6}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  
AZ = interp1(T{:,1}(index), T{:,7}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  
P = interp1(T{:,1}(index), T{:,8}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  
T = interp1(T{:,1}(index), T{:,9}(index) , 0.0: 0.01 : bound, 'pchip', 'extrap');  

%cHeader = {'time(ms)' 'A(mg selon x)' 'A(mg y)' 'A(mg z)' 'P(Pa)'}; %dummy header
cHeader = {'time(ms)' 'X(m)' 'Y(m)' 'Z(m)'  'Ax(mg)' 'Ay(mg)' 'Az(mg)', 'P(Pa)', 'T(K)'}; %dummy header
commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas
%write header to file
fid = fopen('result.csv','w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);

[t,~,p,~, ~] = stdAtmos(Environment.Start_Altitude, Environment);


to_output = transpose([ 0.0: 0.01 : 19.99 ; 0*ones(1,2000) ; 0*ones(1,2000); 000*ones(1,2000);
     0*ones(1,2000) ; 0*ones(1,2000); -1000*ones(1,2000); p*ones(1,2000); t*ones(1,2000) ]);

dlmwrite('result.csv',to_output,'-append');


to_output = transpose([ 20.0: 0.01 : bound+20 ; X;Y;Z;AX ; AY ; AZ ; P ;T]);
            
dlmwrite('result.csv',to_output,'-append');




