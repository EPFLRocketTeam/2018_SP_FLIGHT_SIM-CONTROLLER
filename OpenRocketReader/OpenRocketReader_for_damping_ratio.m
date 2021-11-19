clc
close all
clear

addpath('Data');
lw=1.2;

addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'),...
        genpath('../Simulator_3D'));
% Rocket Definition
 Rocket = rocketReader('Wildhorn_test.txt');
Environment = environnementReader('Environment/Environnement_Definition_EUROC.txt');
% SimOutputs = SimOutputReader('Simulation/Simulation_outputs.txt');

warning('off','all')
%% For csv : time[s],altitude[ft],acc[m/s^2],stability margin [calib],mach

OpenRocketData = readmatrix('Wildhorn_data.csv');
time = OpenRocketData(:,1);
altitude = OpenRocketData(:,2); %altitude above launch point
veloc = OpenRocketData(:,3);
acc = OpenRocketData(:,4);
attack_angle=OpenRocketData(:,5);
Mass=OpenRocketData(:,6)/1000;
Il=OpenRocketData(:,7);
x_cp = OpenRocketData(:,8)/100;
x_cg = OpenRocketData(:,9)/100;
margin1 = OpenRocketData(:,10);
mach1 = OpenRocketData(:,11);
[apogee1,i_apo1] = max(altitude);
t_apo1 = time(i_apo1);

% Y=gradient(Mass)./gradient(time);
% 
% figure
% plot(time, Mass)
% hold on
% plot(time(1:end), Y)
% legend('mass','mdot')
%% For damping ratio : 
% Speed off rail
% V = velo1(end, 2);

for j=1:length(time)
% Local speed of sound and density of air
[~,a(j),~,rho] = stdAtmos(Environment.Start_Altitude + altitude(j), Environment);

M(j) = veloc(j)/a(j); %mach number
alpha = attack_angle(j)*pi/180; %angle of attack
theta = 0; %roll angle
[Calpha(j,:), CP(j,:)] = barrowmanLift(Rocket, alpha, M(j), theta);

CNa2A(j) = 0;
W = x_cg(j);
for i = 1:length(Calpha(j,:))
    CNa2A(j) = CNa2A(j) + Calpha(j,i) * (CP(j,i) - W)^2;
end
d = max(Rocket.diameters);
Ar = pi/4*d^2;

C2A(j) = rho * veloc(j) * Ar / 2 * CNa2A(j);

dMdt = -gradient(Mass)./gradient(time); %change in rocket mass
Lne = 2.75; %distance tip of rocket to nozzle

C2R(j) = dMdt(j) * (Lne - W)^2;

% C2A: Aerodynamic Damping Moment Coefficient
% C2R: Propulsive Damping Moment Coefficient
% C2: Damping Moment Coefficient
C2(j) = C2A(j) + C2R(j);

CNa(j) = sum(Calpha(j,:));
P = x_cp(j);

C1(j) = rho / 2 * veloc(j)^2 * Ar * CNa(j) * (P - W);

% Damping ratio
epsilon(j) = C2(j) / (2 * sqrt(C1(j) * Il(j)));

end
%% Plot data
% 
% figure;
% hold on;grid on;
% title('Acceleration and altitude')
% yyaxis right;
% plot(time,altitude,'DisplayName','altitude','Linewidth',lw);
% ylabel('altitude [m]');
% xlabel('time [s]');
% yyaxis left;
% plot(time,acc./9.81,'DisplayName','acceleration','Linewidth',lw);
% ylabel('acceleration [g]');
% legend show;
% 
% figure;
% hold on;grid on;
% title('Stability margin')
% plot(time,margin1,'DisplayName','Stability Margin','Linewidth',lw);
% xlabel('time [s]');
% ylabel('stability margin [cal]');
% % 
% figure;
% hold on;grid on;
% title('velocity and altitude')
% yyaxis right;
% plot(time,altitude,'DisplayName','altitude','Linewidth',lw);
% ylabel('altitude [m]');
% xlabel('time [s]');
% yyaxis left;
% plot(time,veloc,'DisplayName','mach','Linewidth',lw);
% ylabel('velocity [m/s]');
% legend show;
% % 
% figure
% hold on;grid on;
% title('CG and CP locations')
% plot(time1,x_cg,'DisplayName','Centre of gravity','Linewidth',lw);
% plot(time1,x_cp,'DisplayName','Centre of pressure','Linewidth',lw);
% ylabel('distance from tip of rocket[cm]');
% xlabel('time [s]');
% legend show;

figure;
hold on;grid on;
title('damping ratio')
plot(time,epsilon,'Linewidth',lw);
hold on
yline(0.05,'-- r','linewidth',lw)
yline(0.3,'-- r','linewidth',lw)
xline(0.34,'-- b','linewidth',lw)
text(0.34,0.4,'rail departure')
xline(44.2,'-- b','linewidth',lw)
text(44.2,0.4,'apogee')
xline(6.36,'-- b','linewidth',lw)
text(6.36,0.5,'motor burnout')
ylabel('damping ratio');
xlabel('time [s]');

if min(epsilon)<0.05 
    verif1=' minimum damping ratio is too small ';
elseif min(epsilon)>0.3
     verif1=' minimum damping ratio is too big ';
else
    verif1=' min value is good ';
end
if max(epsilon(1:850))>0.3
    verif2=' max value is too big';
elseif max(epsilon(1:850))<0.05 
    verif2=' max value is too small'; 
else 
    verif2=' max value is good ';
end
disp(append('damping ratio min: ',num2str(min(epsilon(1:end))),verif1))
disp(append('damping ratio max: ',num2str(max(epsilon(1:850))),verif2))
%stopping at 41s because after that the damping ratio diverges near the
%apogee