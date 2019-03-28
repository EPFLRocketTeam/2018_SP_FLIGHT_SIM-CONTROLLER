%% 
addpath(genpath('../Simulator_3D'));
Main_3D;
close all


% %% Rocket data
% % Rocket mass
% m = 31.092;
% % Longitudinal inertia
% I_i = 38.93;
% I_f = 35.95;
% % CG position
% W_i = 1.9136;
% W_f = 1.7836;
% % CP locations
% P = 2.3;
X_F = 2.74;
% % Rocket length
L_r = SimObj.Rocket.stage_z(end)ithub
% % Reference diameter
d = d
% % Normal coefficients
C_N_alpha = 12.3;
C_N_alpha_F = 10.7;
% 
% %% Motor data
% % Propellant mass
m_p = 4.959; % CS_M1800
% % Burn time
t_b = 5.6;
% % Initial thrust
% F = 2200;
% % Speed at end of rail
V0 = S1(end)
% 
% Density
rho = 0.943
% %% Margins


%% Calculations
W = SimObj.SimAuxResults.CM(1)
P = SimObj.SimAuxResults.Xcp(1)
d = max(Rocket.diameters)

C_m_alpha = C_N_alpha*d/L_r*(P-W)

C_mq_fin = 2*C_N_alpha_F*(X_F-P)^2/L_r^2
C_mq_thrust = 4*m_p/t_b*(L_r-P)^2/(rho*V0*L_r)
C_mq = C_mq_fin + C_mq_thrust
Margin = SimObj.SimAuxResults.Margin(1)
Damping = 0.25*L_r/V0*sqrt(85600*d*L_r/SimObj.SimAuxResults.Ir(1))*C_mq/sqrt(C_m_alpha)