%% Initialize
close all
clear all

% load directories
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'),...
        genpath('../Simulator_2D'));
    
% load defintions
Rocket_USA = rocketReader('BL_H4.txt');
Environment_USA = environnementReader('Environnement_Definition.txt');
Environment_Payerne = environnementReader('Environnement_Definition_Payerne.txt');
SimOutputs = SimOutputReader('Simulation_outputs.txt');

% OpenRocket data
OR_t_U = [25.3, 25.25, 25.25, 25.2];
OR_A_U = [3094, 3091, 3081, 3066];
OR_t_P = [16.36, 16.355, 16.35, 16.31];
OR_A_P = [1158.7, 1156.8, 1151.5, 1143];

% Experimental data
Exp_t_P = 16.3;
Exp_A_P = 1109;

% counter
i = 1;

%% Simulate
h1 = figure(1); ax1 = gca; hold(ax1, 'on');
h2 = figure(2); ax2 = gca;  hold(ax2, 'on');
h3 = figure(3); ax3 = gca; hold(ax3, 'on');
h4 = figure(4); ax4 = gca; hold(ax4, 'on');

% shift plot colors
h = plot(ax3, nan(2,size(get(gca,'colororder'),1)-5)); %Loop back
delete(h);
h = plot(ax4, nan(2,size(get(gca,'colororder'),1)-5)); %Loop back
delete(h);

for v = 0:2:6
    
    Environment_Payerne.V_inf = v+0.001;
    Environment_USA.V_inf = v+0.001;

    % 3D_USA 
    SimObj_U = Simulator3D(Rocket_USA, Environment_USA, SimOutputs);
    [T3D1_U, S3D1_U] = SimObj_U.RailSim();
    [T3D2_U, S3D2_U] = SimObj_U.FlightSim(T3D1_U(end), S3D1_U(end,2));

    % 3D_Payerne
    SimObj_P = Simulator3D(Rocket_Payerne, Environment_Payerne, SimOutputs);
    [T3D1_P, S3D1_P] = SimObj_P.RailSim();
    [T3D2_P, S3D2_P] = SimObj_P.FlightSim(T3D1_P(end), S3D1_P(end,2));

    % 2D_USA
    % Initial Conditions
    x_0 = [0;0]; % At rest position
    tspan = [0 Rocket_USA.Burn_Time];

    % Simulation
    Option = odeset('Events', @myEventRail);
    [T2D1_U,S2D1_U] = ode45(@(t,x) Rail_Initial_State(t,x,Rocket_USA,Environment_USA),tspan,x_0,Option);

    Rail_Angle = Environment_USA.Rail_Angle;
    Rail_L = Environment_USA.Rail_Length;

    % Initial Conditions
    x_0 = [Rail_L*sin(Rail_Angle);S2D1_U(end,2)*sin(Rail_Angle);Rail_L*cos(Rail_Angle);S2D1_U(end,2)*cos(Rail_Angle);Rail_Angle;0]; % No speed, no height, no angle
    tspan = [T2D1_U(end) 28];

    % Simulation
    Option = odeset('Events', @myEventApogee);
    [T2D2_U,S2D2_U] = ode45(@(t,x) Rocket_Kinematic_2D(t,x,Rocket_USA,Environment_USA,-190.5),tspan,x_0,Option);

    % 2D_Payerne
    % Initial Conditions
    x_0 = [0;0]; % At rest position
    tspan = [0 Rocket_Payerne.Burn_Time];

    % Simulation
    Option = odeset('Events', @myEventRail);
    [T2D1_P,S2D1_P] = ode45(@(t,x) Rail_Initial_State(t,x,Rocket_Payerne,Environment_Payerne),tspan,x_0,Option);

    Rail_Angle = Environment_Payerne.Rail_Angle;
    Rail_L = Environment_Payerne.Rail_Length;

    % Initial Conditions
    x_0 = [Rail_L*sin(Rail_Angle);S2D1_P(end,2)*sin(Rail_Angle);Rail_L*cos(Rail_Angle);S2D1_P(end,2)*cos(Rail_Angle);Rail_Angle;0]; % No speed, no height, no angle
    tspan = [T2D1_P(end) 28];

    % Simulation
    Option = odeset('Events', @myEventApogee);
    [T2D2_P,S2D2_P] = ode45(@(t,x) Rocket_Kinematic_2D(t,x,Rocket_Payerne,Environment_Payerne,-190.5),tspan,x_0,Option);

    %% Plot Data
    % altitude vs time
    p3d_h = plot(ax1, T3D2_U, S3D2_U(:,3), '--','DisplayName', ['3D, v = ' num2str(v)]);
    plot(ax1, T2D2_U, S2D2_U(:,3), '-', 'DisplayName', ['2D, v = ' num2str(v)], 'Color', get(p3d_h, 'Color'));
    p3d_h = plot(ax2, T3D2_P, S3D2_P(:,3), '--', 'DisplayName', ['3D, v = ' num2str(v)]);
    plot(ax2, T2D2_P, S2D2_P(:,3), '-', 'DisplayName', ['2D, v = ' num2str(v)], 'Color', get(p3d_h, 'Color'));

    % apogees 
    p3d_h = plot(ax3, T3D2_U(end), S3D2_U(end,3), '*', 'DisplayName', ['3D, v = ' num2str(v)]);
    plot(ax3, T2D2_U(end), S2D2_U(end,3), 'o', 'DisplayName', ['2D, v = ' num2str(v)], 'Color', get(p3d_h, 'Color'));
    plot(ax3, OR_t_U(i), OR_A_U(i), '+', 'DisplayName', ['OR, v = ' num2str(v)], 'Color', get(p3d_h, 'Color'))
    
    p3d_h = plot(ax4, T3D2_P(end), S3D2_P(end,3), '*', 'DisplayName', ['3D, v = ' num2str(v)]);
    plot(ax4, T2D2_P(end), S2D2_P(end,3), 'o', 'DisplayName', ['2D, v = ' num2str(v)], 'Color', get(p3d_h, 'Color'));
    plot(ax4, OR_t_P(i), OR_A_P(i), '+', 'DisplayName', ['OR, v = ' num2str(v)], 'Color', get(p3d_h, 'Color'))
    
    i = i+1;
end
% 1D_USA
[T1D_U, S1D_U] = Sim_1D(Rocket_USA, Environment_USA, [0, 30], [0,0], @drag_shuriken, -190.5, 'Velocity', 0, -1);
% 1D_Payerne

[T1D_P, S1D_P] = Sim_1D(Rocket_Payerne, Environment_Payerne, [0, 30], [0,0], @drag_shuriken, -190.5, 'Velocity', 0, -1);

plot(ax1, T1D_U, S1D_U(:,1), 'DisplayName', '1D');
plot(ax2, T1D_P, S1D_P(:,1), 'DisplayName', '1D');
plot(ax3, T1D_U(end), S1D_U(end,1), 'x', 'DisplayName', '1D');
plot(ax4, T1D_P(end), S1D_P(end,1), 'x', 'DisplayName', '1D');
plot(ax4, Exp_t_P, Exp_A_P, 'd', 'DisplayName', 'Mesuré');

title(ax3, 'Sensibilité au vent : Apogée vs. temps, USA'); xlabel(ax3, 't_{apogee} [s]'); ylabel(ax3, 'Apogee [m]');
set(ax3, 'FontSize', 14);
title(ax4, 'Sensibilité au vent : Apogée vs. temps, Payerne'); xlabel(ax4, 't_{apogee} [s]'); ylabel(ax4, 'Apogee [m]');
set(ax4, 'FontSize', 14);

l1 = legend(ax1, 'show'); set(l1, 'Location', 'NorthWest');
l2 = legend(ax2, 'show'); set(l2, 'Location', 'NorthWest');
l3 = legend(ax3, 'show'); set(l3, 'Location', 'NorthEastOutside');
l4 = legend(ax4, 'show'); set(l4, 'Location', 'NorthEastOutside');