% DRAG COEFFICIENT ESTIMATION
% -------------------------------------------------------------------------
% Projet de Semestre Rocket Team
% Wind Tunnel Test: 22.05.2018
% Operation Responsible:        Maxime Eckstein
% Data acquisition Responsible: Eric Brunner
% Data analysis Responsible:    Emilien Mingard
% => Enregistrer en xlsx, pour eviter les macros non souhaitees
% V.2
close all;clc;
% -------------------------------------------------------------------------
% Informations: Wind Tunnel et Fusee
% -------------------------------------------------------------------------
% Experiments:
fm = 50; % Frequency of acquisition
Nb_Exp = 1; % Number of experiments performed (Nb of Excel Sheets)
ID_Angles_Attaque = [49 50 51 52 53 54 55 56]; %[49 50 51 52 53 54 55 56]
ID_Aerofreins = [];%[57 58 59 60 61 62 63 64 65 66];
FileName = 'Data_Rocket_Shuriken.xlsx';

% User parameter:
V_Wind_Onset = 20; % Keep value only when V_wind > V_Wind_Onset
Local_Mean = 40; % Number of data for local averaging 
Offset_Estimation = 100; % Number of point to compute initial offset
Dir = 0; % 1 = increasing speed, 0 = decreasing speed

% Data Order:
Pos_Wind_Speed = 4;
Pos_Road_Speed = 5;
Pos_Attack_Angle = 6;
Pos_Temperature = 10;
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

% Rocket 
Rocket = rocketReader('Rocket_Definition_Final.txt');

% Environnement 
Environnement = environnementReader('Environnement_Definition.txt');

% -------------------------------------------------------------------------
% Analysis: Angle of Attack
% -------------------------------------------------------------------------
for i = ID_Angles_Attaque
    % Open the xls sheet:
    Sheet = ['Run_' num2str(i)];
    Current_Exp = xlsread(FileName,Sheet);
    
    % Airbreak Close check:
    if(Current_Exp(3,Pos_AirBreak)~=0)
        error('Airbreak are not closed');
    end
    
    % Path (Increasing or Decreasing)
    V_Wind_Max = 76;
    Centering_Pos = find(Current_Exp(:,Pos_Wind_Speed)>V_Wind_Max);
    Center = floor(mean(Centering_Pos));
    
    % Wind Speed:
    Data_pos_tmp = find(Current_Exp(:,Pos_Wind_Speed)>V_Wind_Onset);
    if(Dir == 1)
        tmp1 = find(Data_pos_tmp<Center);
        Data_pos = Data_pos_tmp(tmp1);
    else
        tmp1 = find(Data_pos_tmp>Center);
        Data_pos = Data_pos_tmp(tmp1);
    end
    V = Current_Exp(Data_pos,Pos_Wind_Speed);
    
    % Balance Data
    Fx = Current_Exp(:,Pos_Fx);
    Fy = Current_Exp(:,Pos_Fy);
    Fz = Current_Exp(:,Pos_Fz);
    
    % Offset estimation:
    V_Wind_Offset_Max = 0.5;
    V_Wind_Offset_Min = 0.2;
    Data_pos_tmp = find(Current_Exp(:,Pos_Wind_Speed)<V_Wind_Offset_Max & Current_Exp(:,Pos_Wind_Speed)>V_Wind_Offset_Min);
    if(Dir == 1)
        tmp1 = find(Data_pos_tmp<Center);
        Offset_Pos = Data_pos_tmp(tmp1);
        mFx = mean(Fx(Offset_Pos));
        mFy = mean(Fy(Offset_Pos));
        mFz = mean(Fz(Offset_Pos));
    else
        tmp1 = find(Data_pos_tmp>Center);
        Offset_Pos = Data_pos_tmp(tmp1);
        mFx = mean(Fx(Offset_Pos));
        mFy = mean(Fy(Offset_Pos));
        mFz = mean(Fz(Offset_Pos));
    end
    
    % Offset correction:
    Fx = Fx(Data_pos)-mFx;
    Fy = Fy(Data_pos)-mFy;
    Fz = Fz(Data_pos)-mFz;
    
    % Balance filtering:
    Nb_elem = floor(length(V)/Local_Mean);
    fFx = [];fFy = [];fFz = [];fV = [];
    for j = 1:Nb_elem
        fFx = [fFx mean(Fx((j-1)*(Local_Mean)+1:j*Local_Mean))];
        fFy = [fFy mean(Fy((j-1)*(Local_Mean)+1:j*Local_Mean))];
        fFz = [fFz mean(Fz((j-1)*(Local_Mean)+1:j*Local_Mean))];
        fV = [fV mean(V((j-1)*(Local_Mean)+1:j*Local_Mean))];
    end
    
    % Averaged density:
    rho = mean(Current_Exp(Data_pos,Pos_Density)); 
    
    % Averaged Temperature: 
    T = mean(Current_Exp(Data_pos,Pos_Temperature))+273.15;
    
    % Equivalent Viscosity: 
    Nu = interp1(Environnement.T_Nu',Environnement.Viscosity',[T]);
    
    % Angle of Attack:
    AA = Current_Exp(1,Pos_Attack_Angle)/180*pi;
    AB = 0;
%     %-------------------------- DRAG FORCE ----------------------------
%     fFd = -fFz/cos(AA);
%     figure(1);
%     title('Drag Force Comparison');
%     plot(fV,fFd,'DisplayName',['WT - yaw: ' num2str(AA/pi*180) 'deg']);hold on;
%     legend show;
%     
%     V_model = linspace(20,80,30);Fd_model = [];
%     for i = 1:length(V_model)
%         Fd_model = [Fd_model drag(Rocket,AA,V_model(i),Nu,343)*0.5*rho*Rocket.Sm*V_model(i)^2];
%     end
%     plot(V_model,Fd_model,'LineStyle','none','Marker','*','DisplayName',['Matlab - yaw: ' num2str(AA/pi*180) 'deg']);
%     legend show;xlabel('Wind Speed [m/s]');ylabel('F_D [N]');
    %-------------------------- NORMAL FORCE --------------------------
%     fFn = -fFy-fFd*sin(AA);
%     figure(2);
%     title('Normal Force Comparison');
%     plot(fV,fFn,'DisplayName',['WT - \alpha: ' num2str(AA/pi*180) 'deg']);hold on;
%     legend show;
%     
%     V_model = linspace(20,80,30);Fn_model = [];
%     for i = 1:length(V_model)
%         [CNa, Xp, CNa_barrowman, Xp_barrowman] = normalLift(Rocket, AA, 1.1, V_model(i)/343, 0, 1);
%         Fn_model = [Fn_model CNa*AA*0.5*rho*Rocket.Sm*V_model(i)^2];
%     end
%     plot(V_model,Fn_model,'LineStyle','none','Marker','*','DisplayName',['Pred. - \alpha: ' num2str(AA/pi*180) 'deg']);
%     legend show;xlabel('Wind Speed [m/s]');ylabel('F_N [N]');

     %-------------------------- Fy --------------------------
    figure(100);
    title('Fy Comparison');
    plot(fV,-fFy,'DisplayName',['WT - Fy: ' num2str(AA/pi*180) 'deg']);hold on;
    legend show;
    V_model = linspace(20,80,30);Fy_model = [];
    for i = 1:length(V_model)
        [CNa, Xp] = normalLift(Rocket,AA,1.1,V_model(i)/346,0,1);
        Fy_model = [Fy_model (CNa*AA+sin(AA)*drag(Rocket,AA,V_model(i),Nu,343))*0.5*rho*Rocket.Sm*V_model(i)^2];
    end
    plot(V_model,Fy_model,'LineStyle','none','Marker','*','DisplayName',['Matlab - Fy: ' num2str(AA/pi*180) 'deg']);
    legend show;xlabel('Wind Speed [m/s]');ylabel('Fy [N]');
end

% -------------------------------------------------------------------------
% Analysis: Angle of Airbreaks
% -------------------------------------------------------------------------
for i = ID_Aerofreins
    % Open the xlsx sheet:
    Sheet = ['Run_' num2str(i)];
    Current_Exp = xlsread(FileName,Sheet);
    
    % Airbreak Close check:
    if(Current_Exp(3,Pos_Attack_Angle)~=0)
        error('Angle of attack is not null');
    end
    
    % Path (Increasing or Decreasing)
    V_Wind_Max = 76;
    Centering_Pos = find(Current_Exp(:,Pos_Wind_Speed)>V_Wind_Max);
    Center = floor(mean(Centering_Pos));
    
    % Wind Speed:
    Data_pos_tmp = find(Current_Exp(:,Pos_Wind_Speed)>V_Wind_Onset);
    if(Dir == 1)
        tmp1 = find(Data_pos_tmp<Center);
        Data_pos = Data_pos_tmp(tmp1);
    else
        tmp1 = find(Data_pos_tmp>Center);
        Data_pos = Data_pos_tmp(tmp1);
    end
    V = Current_Exp(Data_pos,Pos_Wind_Speed);
    
    % Balance Data
    %Fx = Current_Exp(:,Pos_Fx);
    %Fy = Current_Exp(:,Pos_Fy);
    Fz = Current_Exp(:,Pos_Fz);
    
    % Offset estimation:
    V_Wind_Offset_Max = 1;
    V_Wind_Offset_Min = 0.2;
    Data_pos_tmp = find(Current_Exp(:,Pos_Wind_Speed)<V_Wind_Offset_Max & Current_Exp(:,Pos_Wind_Speed)>V_Wind_Offset_Min);
    if(Dir == 1)
        tmp1 = find(Data_pos_tmp<Center);
        Offset_Pos = Data_pos_tmp(tmp1);
        %mFx = mean(Fx(Offset_Pos));
        %mFy = mean(Fy(Offset_Pos));
        mFz = mean(Fz(Offset_Pos));
    else
        tmp1 = find(Data_pos_tmp>Center);
        Offset_Pos = Data_pos_tmp(tmp1);
        %mFx = mean(Fx(Offset_Pos));
        %mFy = mean(Fy(Offset_Pos));
        mFz = mean(Fz(Offset_Pos));
    end
    
    % Offset correction:
    %Fx = Fx(Data_pos)-mFx;
    %Fy = Fy(Data_pos)-mFy;
    Fz = Fz(Data_pos)-mFz;
    
    % Balance filtering:
    Nb_elem = floor(length(V)/Local_Mean);
    fFx = [];fFy = [];fFz = [];fV = [];
    for j = 1:Nb_elem
        %fFx = [fFx mean(Fx((j-1)*(Local_Mean)+1:j*Local_Mean))];
        %fFy = [fFy mean(Fy((j-1)*(Local_Mean)+1:j*Local_Mean))];
        fFz = [fFz mean(Fz((j-1)*(Local_Mean)+1:j*Local_Mean))];
        fV = [fV mean(V((j-1)*(Local_Mean)+1:j*Local_Mean))];
    end
    
    % Averaged density:
    rho = mean(Current_Exp(Data_pos,Pos_Density));
    
    % Airbreak aperture:
    AB = Current_Exp(1,Pos_AirBreak);
    
    %-------------------------- DRAG FORCE ----------------------------
    fFd = -fFz;
    figure(i);
    plot(fV,fFd,'DisplayName',['WT - Airbreak: ' num2str(AB) '%']);hold on;
    
    V_model = linspace(20,80,30);Fd_model = [];
    for i = 1:length(V_model)
        Fd_model = [Fd_model drag(Rocket,0,V_model(i),Nu,343)*0.5*rho*Rocket.Sm*V_model(i)^2];
    end
    plot(V_model,Fd_model,'LineStyle','none','Marker','*','DisplayName',['Pred. - Airbreak: ' num2str(AB) '%']);
    legend show;
    %-------------------------- NORMAL FORCE --------------------------
end