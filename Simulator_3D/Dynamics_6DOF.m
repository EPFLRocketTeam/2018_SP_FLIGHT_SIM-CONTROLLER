function S_dot = Dynamics_6DOF(t, s, Rocket, Environment)

X = s(1:3);
V = s(4:6);
Q = s(7:10);
W = s(11:13);

%% Check quaternion norm
Q = normalizeVect(Q);

%% Coordinate systems

% Rotation matrix from rocket coordinates to Earth coordinates
C = quat2rotmat(Q');
angle = rot2anglemat(C);

% Rocket principle frame vectors expressed in earth coordinates
YA = C*[1,0,0]'; % Yaw axis
PA = C*[0,1,0]'; % Pitch Axis
RA = C*[0,0,1]'; % Roll Axis

% Earth coordinate vectors expressed in earth's frame
XE = [1, 0, 0]';
YE = [0, 1, 0]';
ZE = [0, 0, 1]';

%% Rocket Inertia
[M,dMdt,Cm,dCmdt,I_L,dI_Ldt,I_R,dI_Rdt] = Mass_Properties(t,Rocket,"NonLinear");
I = C'*diag([I_L, I_L, I_R])*C; % Inertia TODO: I_R in Mass_Properties

%% Environment
g = 9.81;               % Gravity [m/s2] 
[Temp, a, p, rho] = stdAtmos(X(3)+Environment.Start_Altitude); % Atmosphere information (TODO: Include effect of humidity and departure altitude)

%% Force estimations 

% Thrust
% Oriented along roll axis of rocket frame, expressed in earth coordinates. 
T = Thrust(t,Rocket)*RA; % (TODO: Allow for thrust vectoring -> error)

% Gravity
G = -g*M*ZE;

% Aerodynamic corrective forces
% Compute center of mass angle of attack
Vcm = V -...
         ... % Wind as computed by windmodel
    windModel(t, Environment.Turb_I,Environment.V_inf*Environment.V_dir,...
    Environment.Turb_model); 

Vcm_mag = norm(Vcm);
alpha_cm = atan2(norm(cross(RA, Vcm)), dot(RA, Vcm));

% Mach number
Mach = Vcm_mag/a;
% Normal lift coefficient and center of pressure
[CNa, Xcp,CNa_bar,CP_bar] = normalLift(Rocket, alpha_cm, 1.1, Mach, angle(3), 1);
% Stability margin
margin = (Xcp-Cm);

% Compute Rocket angle of attack
Wnorm = W/norm(W);
if(isnan(Wnorm))
    Wnorm  = zeros(3,1);
end
Vrel = Vcm + margin*sin(acos(dot(RA,Wnorm)))*(cross(RA, W));
Vmag = norm(Vrel);
Vnorm = normalizeVect(Vrel);

% Angle of attack 
Vcross = cross(RA, Vnorm);
Vcross_norm = normalizeVect(Vcross);
alpha = atan2(norm(cross(RA, Vnorm)), dot(RA, Vnorm));
delta = atan2(norm(cross(RA, ZE)), dot(RA, ZE));

% wind coordinate transformation
if(abs(alpha)<1e-3)
    RW = RA;
elseif(abs(alpha-pi)<1e-3)
    RW = -RA;
else
    Cw = quat2rotmat([Vcross_norm'*sin(alpha/2), cos(alpha/2)]);
    RW = C*Cw*[0;0;1];
end

% normal force
NA = cross(RA, Vcross); % normal axis
if norm(NA) == 0
    N = [0, 0, 0]'; 
else
    N = 0.5*rho*Rocket.Sm*CNa*alpha*Vmag^2*NA/norm(NA);
end

% Drag
% Drag coefficient
CD = drag(Rocket, alpha, Vmag, Environment.Nu, a); % (TODO: make air-viscosity adaptable to temperature)
% if t>Rocket.Burn_Time
%    CD = CD + drag_shuriken(Rocket, 1.16, alpha, Vmag, Environment.Nu); 
% end
% Drag force
D = -0.5*rho*Rocket.Sm*CD*Vmag^2*RW; 

% Total forces
F_tot = ...
    T +...  ;% Thrust
    G +...  ;% gravity
    N +... ;% normal force
    D      ; % drag force

%% Moment estimation

%Aerodynamic corrective moment
MN = norm(N)*margin*Vcross_norm; 

% Aerodynamic damping moment
W_pitch = W - dot(W,RA)*RA; % extract pitch and yaw angular velocity
CDM = pitchDampingMoment(Rocket, rho, CNa_bar, CP_bar, dMdt, Cm, norm(W_pitch) , Vmag); 
MD = -0.5*rho*CDM*Rocket.Sm*Vmag^2*normalizeVect(W_pitch);

M_tot = ...
    MN...  ; % aerodynamic corrective moment
   + MD ; % aerodynamic damping moment
           
           
%% State derivatives

% Translational dynamics
X_dot = V;
V_dot = 1/M*(F_tot - V*dMdt);

% Rotational dynamics
Q_dot = quat_evolve(Q, W);
W_dot = I\(M_tot-cross(W,I*W)); % (TODO: Add inertia variation with time)

% Return derivative vector
S_dot = [X_dot;V_dot;Q_dot;W_dot];
end