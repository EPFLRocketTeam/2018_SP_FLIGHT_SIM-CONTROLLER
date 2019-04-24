%% Stability analysis
% https://apogeerockets.com/education/downloads/Newsletter197.pdf
% https://www.apogeerockets.com/education/downloads/Newsletter195.pdf
% https://www.apogeerockets.com/education/downloads/Newsletter193.pdf
% https://www.apogeerockets.com/downloads/barrowman_report.pdf (pas utilisé
% directement)
% Formules tirées des documents ci-dessus et des fichiers Main_3D et
% Simulator3D.

clear all; close all; clc;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'),...
        genpath('../Simulator_3D'));

% Rocket Definition
Rocket = rocketReader('Rocket/Rocket_Definition_Eiger_I_R07.txt');
Environment = environnementReader('Environment/Environnement_Definition_USA.txt');
SimOutputs = SimOutputReader('Simulation/Simulation_outputs.txt');

warning('off','all')

%% ========================================================================
% Nominal case
% =========================================================================

SimObj = Simulator3D(Rocket, Environment, SimOutputs);

% -------------------------------------------------------------------------
% 6DOF Rail Simulation
%--------------------------------------------------------------------------

[T1, S1] = SimObj.RailSim();

% -------------------------------------------------------------------------
% 6DOF Flight Simulation
%--------------------------------------------------------------------------

[T2_1, S2_1, T2_1E, S2_1E, I2_1E] = SimObj.FlightSim([T1(end) SimObj.Rocket.Burn_Time(end)], S1(end, 2));

[T2_2, S2_2, T2_2E, S2_2E, I2_2E] = SimObj.FlightSim([T2_1(end) 40], S2_1(end, 1:3)', S2_1(end, 4:6)', S2_1(end, 7:10)', S2_1(end, 11:13)');

T2 = [T2_1; T2_2(2:end)];
S2 = [S2_1; S2_2(2:end, :)];

% -------------------------------------------------------------------------
% Results
% -------------------------------------------------------------------------

% Speed off rail
V = S1(end, 2);
% Local speed of sound and density of air
[~,a,~,rho] = stdAtmos(Environment.Start_Altitude + S2(1, 3), Environment);
% Mach number
M = V / a;
alpha = 0;
theta = 0;
[Calpha, CP] = barrowmanLift(Rocket, alpha, M, theta);

CNa2A = 0;
W = SimObj.SimAuxResults.CM(1);
for i = 1:length(Calpha)
    CNa2A = CNa2A + Calpha(i) * (CP(i) - W)^2;
end
d = max(Rocket.diameters);
Ar = pi/4*d^2;

C2A = rho * V * Ar / 2 * CNa2A;

[~,dMdt] = Mass_Non_Lin(T1(end), Rocket);
Lne = Rocket.stage_z(end);

C2R = dMdt * (Lne - W)^2;

% C2A Aerodynamic Damping Moment Coefficient
% C2R Propulsive Damping Moment Coefficient
% C2 Damping Moment Coefficient
C2 = C2A + C2R;

CNa = sum(Calpha);
P = SimObj.SimAuxResults.Xcp(1);

C1 = rho / 2 * V^2 * Ar * CNa * (P - W);

Il = SimObj.SimAuxResults.Il(1);

% Damping ratio
epsilon = C2 / (2 * sqrt(C1 * Il));

% display(['CG - Nominal case : ' num2str(Rocket.rocket_cm)]);
% display(['Il initial - Nominal case : ' num2str(Rocket.rocket_I)]);
% display(['Rho - Nominal case : ' num2str(rho)]);
display(['Speed - Nominal case : ' num2str(norm(V))]);
display(['CN_alpha - Nominal case : ' num2str(Calpha(end))]);
display(['Stability - Nominal case : ' num2str((P-W)/d)]);
display(['Damping ratio - Nominal case : ' num2str(epsilon)]);


%% ========================================================================
% Max speed
% =========================================================================

[maxi,index] = max(S2(:,6));

% Max speed
X = S2(index, 1:3);
V = S2(index, 4:6);
% Local speed of sound and density of air
[~,a,~,rho] = stdAtmos(Environment.Start_Altitude + S2(index, 3), Environment);
% Mach number
M = norm(V) / a;

C = quat2rotmat(normalizeVect(S2(index, 7:10)'));

RA = C*[0,0,1]'; % Roll Axis
Vcm = V -...
          ... % Wind as computed by windmodel
windModel(T2(index), Environment.Turb_I,Environment.V_inf*Environment.V_dir,...
Environment.Turb_model,X(3))';
alpha = atan2(norm(cross(RA, Vcm)), dot(RA, Vcm));
angle = rot2anglemat(C);
theta = angle(3);

[Calpha, CP] = barrowmanLift(Rocket, alpha, M, theta);

CNa2A = 0;
W = SimObj.SimAuxResults.CM(index);
for i = 1:length(Calpha)
    CNa2A = CNa2A + Calpha(i) * (CP(i) - W)^2;
end
d = max(Rocket.diameters);
Ar = pi/4*d^2;

C2A = rho * norm(V) * Ar / 2 * CNa2A;

[~,dMdt] = Mass_Non_Lin(T2(index), Rocket);
Lne = Rocket.stage_z(end);

C2R = dMdt * (Lne - W)^2;

% C2A Aerodynamic Damping Moment Coefficient
% C2R Propulsive Damping Moment Coefficient
% C2 Damping Moment Coefficient
C2 = C2A + C2R;

CNa = sum(Calpha);
P = SimObj.SimAuxResults.Xcp(index);

C1 = rho / 2 * norm(V)^2 * Ar * CNa * (P - W);

Il = SimObj.SimAuxResults.Il(index);

% Damping ratio
epsilon = C2 / (2 * sqrt(C1 * Il));

% display(['CG - Max speed : ' num2str(Rocket.rocket_cm)]);
% display(['Il initial - Max speed : ' num2str(Rocket.rocket_I)]);
% display(['Rho - Max speed : ' num2str(rho)]);
display(['Speed - Max speed : ' num2str(norm(V))]);
display(['CN_alpha - Max speed : ' num2str(Calpha(end))]);
display(['Stability - Max speed case : ' num2str((P-W)/d)]);
display(['Damping ratio - Max speed case : ' num2str(epsilon)]);

%% ========================================================================
% Extra values
% =========================================================================

display(['Apogee : ' num2str(S2(end, 3))]);

%% ========================================================================
% Worst case
% =========================================================================

% ROCKET CHANGES
Rocket.rocket_cm = Rocket.rocket_cm * 1.05;
Rocket.rocket_I = Rocket.rocket_I * 1.05;
% Speed off rail
V = 20;

SimObj = Simulator3D(Rocket, Environment, SimOutputs);

% -------------------------------------------------------------------------
% 6DOF Rail Simulation
%--------------------------------------------------------------------------

[T1, S1] = SimObj.RailSim();

% -------------------------------------------------------------------------
% 6DOF Flight Simulation
%--------------------------------------------------------------------------

[T2_1, S2_1, T2_1E, S2_1E, I2_1E] = SimObj.FlightSim([T1(end) SimObj.Rocket.Burn_Time(end)], V);

[T2_2, S2_2, T2_2E, S2_2E, I2_2E] = SimObj.FlightSim([T2_1(end) 40], S2_1(end, 1:3)', S2_1(end, 4:6)', S2_1(end, 7:10)', S2_1(end, 11:13)');

T2 = [T2_1; T2_2(2:end)];
S2 = [S2_1; S2_2(2:end, :)];

% -------------------------------------------------------------------------
% Results
% -------------------------------------------------------------------------

% Local speed of sound and density of air
[~,a,~,rho] = stdAtmos(Environment.Start_Altitude + S2(1, 3), Environment);
% CHANGE DENSITY
rho = rho * 0.95;
% Mach number
M = V / a;
alpha = 0;
theta = 0;
[Calpha, CP] = barrowmanLift(Rocket, alpha, M, theta);
% CHANGE CN_alpha FOR THE FINS
Calpha(end) = Calpha(end)*0.9;

CNa2A = 0;
W = SimObj.SimAuxResults.CM(1);
for i = 1:length(Calpha)
    CNa2A = CNa2A + Calpha(i) * (CP(i) - W)^2;
end
d = max(Rocket.diameters);
Ar = pi/4*d^2;

C2A = rho * V * Ar / 2 * CNa2A;

[~,dMdt] = Mass_Non_Lin(T1(end), Rocket);
Lne = Rocket.stage_z(end);

C2R = dMdt * (Lne - W)^2;

% C2A Aerodynamic Damping Moment Coefficient
% C2R Propulsive Damping Moment Coefficient
% C2 Damping Moment Coefficient
C2 = C2A + C2R;

CNa = sum(Calpha);
P = SimObj.SimAuxResults.Xcp(1);

C1 = rho / 2 * V^2 * Ar * CNa * (P - W);

Il = SimObj.SimAuxResults.Il(1);

% Damping ratio
epsilon = C2 / (2 * sqrt(C1 * Il));

% display(['CG - Worst case : ' num2str(Rocket.rocket_cm)]);
% display(['Il initial - Worst case : ' num2str(Rocket.rocket_I)]);
% display(['Rho - Worst case : ' num2str(rho)]);
display(['Speed - Worst case : ' num2str(norm(V))]);
display(['CN_alpha - Worst case : ' num2str(Calpha(end))]);
display(['Stability - Worst case : ' num2str((P-W)/d)]);
display(['Damping ratio - Worst case : ' num2str(epsilon)]);


%% ========================================================================
% Worst case Max speed
% =========================================================================

[maxi,index] = max(S2(:,6));

% Max speed
X = S2(index, 1:3);
V = S2(index, 4:6);
% Local speed of sound and density of air
[~,a,~,rho] = stdAtmos(Environment.Start_Altitude + S2(index, 3), Environment);
% CHANGE DENSITY
rho = rho * 0.95;
% Mach number
M = norm(V) / a;

C = quat2rotmat(normalizeVect(S2(index, 7:10)'));

RA = C*[0,0,1]'; % Roll Axis
Vcm = V -...
          ... % Wind as computed by windmodel
windModel(T2(index), Environment.Turb_I,Environment.V_inf*Environment.V_dir,...
Environment.Turb_model,X(3))';
alpha = atan2(norm(cross(RA, Vcm)), dot(RA, Vcm));
angle = rot2anglemat(C);
theta = angle(3);

[Calpha, CP] = barrowmanLift(Rocket, alpha, M, theta);
% CHANGE CN_alpha FOR THE FINS
Calpha(end) = Calpha(end)*0.9;

CNa2A = 0;
W = SimObj.SimAuxResults.CM(index);
for i = 1:length(Calpha)
    CNa2A = CNa2A + Calpha(i) * (CP(i) - W)^2;
end
d = max(Rocket.diameters);
Ar = pi/4*d^2;

C2A = rho * norm(V) * Ar / 2 * CNa2A;

[~,dMdt] = Mass_Non_Lin(T2(index), Rocket);
Lne = Rocket.stage_z(end);

C2R = dMdt * (Lne - W)^2;

% C2A Aerodynamic Damping Moment Coefficient
% C2R Propulsive Damping Moment Coefficient
% C2 Damping Moment Coefficient
C2 = C2A + C2R;

CNa = sum(Calpha);
P = SimObj.SimAuxResults.Xcp(index);

C1 = rho / 2 * norm(V)^2 * Ar * CNa * (P - W);

Il = SimObj.SimAuxResults.Il(index);

% Damping ratio
epsilon = C2 / (2 * sqrt(C1 * Il));

% display(['CG - Worst case Max speed : ' num2str(Rocket.rocket_cm)]);
% display(['Il initial - Worst case Max speed : ' num2str(Rocket.rocket_I)]);
% display(['Rho - Worst case Max speed : ' num2str(rho)]);
display(['Speed - Worst case Max speed : ' num2str(norm(V))]);
display(['CN_alpha - Worst case Max speed : ' num2str(Calpha(end))]);
display(['Stability - Worst case Max speed case : ' num2str((P-W)/d)]);
display(['Damping ratio - Worst case Max speed case : ' num2str(epsilon)]);

%% ========================================================================
% Extra values
% =========================================================================

display(['Apogee : ' num2str(S2(end, 3))]);


warning('on','all')