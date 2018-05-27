function [T, S] = Sim_3D(Rocket, Environment)
% SIM_3D simulates rocket flight of vehicle defined in Rocket structure and
% in environment defined by the Environment structure.

% zero out global variable
clear global

%% ------------------------------------------------------------------------
% 6DOF Rail Simulation
%--------------------------------------------------------------------------

% Initial Conditions
X0 = [0,0]'; % positioned at 0 height and 0 velocity

% time span 
tspan = [0, 5];

% options
Option = odeset('Events', @(t,x) RailEvent(t,x, Environment));

% integration
[T1,S1] = ode45(@(t,x) Dynamics_Rail_1DOF(t,x,Rocket,Environment),tspan,X0, Option);

%% ------------------------------------------------------------------------
% 6DOF Flight Simulation
%--------------------------------------------------------------------------

% Rail vector
C_rail = rotmat(Environment.Rail_Angle, 2)*rotmat(-Environment.Rail_Azimuth, 3);
RV = C_rail*[0;0;1];

% Initial Conditions
X0 = RV*Environment.Rail_Length; % spatial position of cm
V0 = RV*S1(end,2); % Initial velocity of cm
Q0 = rot2quat(C_rail); % Initial attitude
W0 = [0;0;0]; % Initial angular rotation in rocket principle coordinates
S0 = [X0; V0; Q0'; W0];

% time span
tspan = [T1(end), 100];

% options
Option = odeset('Events', @ApogeeEvent);

% integration
[T,S] = ode45(@(t,s) Dynamics_6DOF(t,s,Rocket,Environment),tspan,S0, Option);

end