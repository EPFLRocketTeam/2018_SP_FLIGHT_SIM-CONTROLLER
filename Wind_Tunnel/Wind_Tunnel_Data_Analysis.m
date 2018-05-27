% DRAG COEFFICIENT ESTIMATION
% -------------------------------------------------------------------------
% Projet de Semestre Rocket Team
% Wind Tunnel Test: 22.05.2018
% Operation Responsible:        Maxime Eckstein
% Data acquisition Responsible: Eric Brunner
% Data analysis Responsible:    Emilien Mingard
% => Enregistrer en xlsx, pour eviter les macros non souhaitees
close all;clc;clear all;

% -------------------------------------------------------------------------
% Informations: Wind Tunnel
% -------------------------------------------------------------------------
% Experiments:
fm = 50; % Frequency of acquisition
Nb_Exp = 1; % Number of experiments performed (Nb of Excel Sheets)
ID_Angles_Attaque = [49 50 51 52 53 54 55 56];
ID_Aerofreins = [57 58 59 60 61 62 63 64 65 66];
FileName = 'Data_Rocket_Shuriken.xlsx';

% Data Order:
Pos_Wind_Speed = 4;
Pos_Road_Speed = 5;
Pos_Attack_Angle = 6;
Pos_Temperature = 7;
Pos_Humidity = 11;
Pos_Density = 12;
Pos_Fx = 13;
Pos_Fy = 14;
Pos_Fz = 15;
Pos_Mx = 16;
Pos_My = 17;
Pos_Mz = 18;
Pos_AirBreak = 23;

% Balance Data Filtering:
fc_balance = 0.5;
[b_balance,a_balance] = butter(6,fc_balance/(fm/2));

% Density Data Filtering:
fc_rho = 20;
[b_rho,a_rho] = butter(6,fc_rho/(fm/2));

% -------------------------------------------------------------------------
% Informations: Rocket
% -------------------------------------------------------------------------
Rocket = rocketReader('Rocket_Definition.txt');
Environnement = environnementReader('Environnement_Definition.txt');

% -------------------------------------------------------------------------
% Angle of Attack
% -------------------------------------------------------------------------
for i = ID_Angles_Attaque
    Sheet = ['Run_' num2str(i)];
    Current_Exp = xlsread(FileName,Sheet);
    
    % Wind Speed:
    V_Wind_Onset = 22;
    Data_pos = find(Current_Exp(:,Pos_Wind_Speed)>V_Wind_Onset);
    V = Current_Exp(Data_pos,Pos_Wind_Speed);
    
    % Balance Data, offset correction
    Fx = filter(b_balance,a_balance,Current_Exp(:,Pos_Fx));
    mFx = mean(Fx(1:100));
    Fx = Fx(Data_pos)-mFx;
    Fy = filter(b_balance,a_balance,Current_Exp(:,Pos_Fy));
    mFy = mean(Fy(1:100));
    Fy = Fy(Data_pos)-mFy;
    Fz = filter(b_balance,a_balance,Current_Exp(:,Pos_Fz));
    mFz = mean(Fx(1:100));
    Fz = Fz(Data_pos)-mFz;
    %Mx = filter(b_balance,a_balance,Current_Exp(:,Pos_Mx));
    %My = filter(b_balance,a_balance,Current_Exp(:,Pos_My));
    %Mz = filter(b_balance,a_balance,Current_Exp(:,Pos_Mz));
    rho = filter(b_rho,a_rho,Current_Exp(Data_pos,Pos_Density));
    rho = mean(rho); % Keep only average value
    
    % Angle of attack:
    AA = Current_Exp(1,Pos_Attack_Angle)/180*pi; % DEG 2 RAD
    
    % Check if Airbreak are at 0;
    if(Current_Exp(3,Pos_AirBreak)~=0)
    error('Airbreak are not closed');
    end
    
    %% DRAG FORCE:
    % Data:
    Fd = -Fz/cos(AA); 
    Cd = 2*Fd./(rho.*Rocket.Sm.*V.^2);
    figure(1);
    plot(V,Fd,'DisplayName',['Angle of Attack: ' num2str(AA/pi*180) 'deg']);hold on;
    title('Drag force comparison');grid on;legend show;
    xlabel('Wind Speed [m/s]');ylabel('Drag coefficient [-]');
    
    V_model = linspace(20,80,100);
    Cd_model = [];
    for i = 1:length(V_model)
        Cd_model = [Cd_model,drag(Rocket, AA, V_model(i), 1.38e-5, 343)]; %% CHANGE VISCOSITY
    end
    plot(V_model,Cd_model.*(rho.*Rocket.Sm.*V_model.^2)/2,'DisplayName',['Angle of Attack: ' num2str(AA/pi*180) 'deg']);
     
    %% NORMAL FORCE:
    Fn = -Fy+Fd*sin(AA);
    Cn = 2*Fn./(rho.*Rocket.Sm.*V.^2);
    figure(11);
    plot(V,Fn,'DisplayName',['Angle of Attack: ' num2str(AA/pi*180) 'deg']);hold on;
    title('Normal force comparison');grid on;legend show;
    xlabel('Wind Speed [m/s]');ylabel('Normal coefficient [-]');
end

% %% -------------------------------------------------------------------------
% % Angle of Airbreak
% % -------------------------------------------------------------------------
% for i = ID_Aerofreins
%     Sheet = ['Run_' num2str(i)];
%     Current_Exp = xlsread(FileName,Sheet);
%     
%     % Wind Speed:
%     V_Wind_Onset = 18;
%     Data_pos = find(Current_Exp(:,Pos_Wind_Speed)>V_Wind_Onset);
%     V = Current_Exp(Data_pos,Pos_Wind_Speed);
%     
%     
%     % Getting the right informations:
%     Fx = filter(b_balance, a_balance,Current_Exp(Data_pos,Pos_Fx));
%     Fy = filter(b_balance, a_balance,Current_Exp(Data_pos,Pos_Fy));
%     Fz = filter(b_balance, a_balance,Current_Exp(Data_pos,Pos_Fz));
%     Mx = filter(b_balance, a_balance,Current_Exp(Data_pos,Pos_Mx));
%     My = filter(b_balance, a_balance,Current_Exp(Data_pos,Pos_My));
%     Mz = filter(b_balance, a_balance,Current_Exp(Data_pos,Pos_Mz));
%     rho = filter(b_rho,a_rho,Current_Exp(Data_pos,Pos_Density));
%     
%     % Angle of Airbreak:
%     AB = Current_Exp(1,Pos_AirBreak); % PERCENT OR DEG
%     AA = 0;
%     % Check if Angle of attack is 0;
%     if(Current_Exp(3,Pos_Attack_Angle)~=0)
%     error('Angle of attack is not zero');
%     end
%     
%    
%     %% DRAG FORCE:
%     Fd = Fz/cos(AA);
%     Cd = 2*Fd./(rho.*Rocket.Sm.*V.^2);
%     figure(2);
%     plot(V,Cd,'DisplayName',['Angle of Airbreaks ' num2str(AB) '%']);hold on;
%     title('Drag Coefficient Comparison');grid on;legend show;
%     xlabel('Wind Speed [m/s]');ylabel('Drag Coefficient [-]');
%     
%     %% NORMAL FORCE:
%     Fn = Fy-Fd*sin(AA);
%     Cn = 2*Fn./(rho.*Rocket.Sm.*V.^2);
%     figure(12);
%     plot(V,Fn,'DisplayName',['Angle of Airbreak: ' num2str(AB) '%']);hold on;
%     title('Normal Coefficient Comparison');grid on;legend show;
%     xlabel('Wind Speed [m/s]');ylabel('Normal Coefficient [-]');
% 
%     %% Fz FORCE:
%     figure(22);
%     plot(V,Fz,'DisplayName',['Angle of Airbreaks ' num2str(AB) '%']);hold on;
%     title('Fz Force Comparison');grid on;legend show;
%     xlabel('Wind Speed [m/s]');ylabel('Fz Force [N]');
% end