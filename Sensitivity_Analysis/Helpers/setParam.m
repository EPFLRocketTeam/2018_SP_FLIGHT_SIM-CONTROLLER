function SimObj = setParam(SimObj, Xid, X)
%SETPARAM sets the given parameters to the given values in the simulator object.
%   INPUTS
%       SimObj  Simulator object (only multilayerwindSimulator3D implemented)
%       Xid     Names of the parameters
%       X       Values of the parameters
%   OUTPUT
%       SimObj  Simulator object with the new values


% multilayerwindSimulator3D list of parameters

[rocketparamIDs, envparamIDs] = paramNames(SimObj);

% Base wind layer values
layerspeed = [SimObj.Environment.Vspeed(2) ...
           SimObj.Environment.Vspeed(11) ...
           SimObj.Environment.Vspeed(16) ...
           SimObj.Environment.Vspeed(51) ...
           SimObj.Environment.Vspeed(101) ...
           SimObj.Environment.Vspeed(201)];

layerAzi = [SimObj.Environment.Vazy(2) ...
           SimObj.Environment.Vazy(11) ...
           SimObj.Environment.Vazy(16) ...
           SimObj.Environment.Vazy(51) ...
           SimObj.Environment.Vazy(101) ...
           SimObj.Environment.Vazy(201)];

% Boolean for case by case treatment (efficiency)       
isChanged_Vi = false;
isChanged_ai = false;

% Nominal values
layerheight_NV = [10, 100, 200, 500, 1000, 2000];
interpheight = 0:10:4000;
Thrust_Time_NV = [0, 0.02/6.35, 6/6.35, 1];

% Checking that the geometrical information is complete
nz_param = sum(ismember(["z1", "z12", "z23"], Xid));
if  (nz_param ~= 0) && (nz_param ~= 3)
    error("Error: the information about the stages heights is incomplete");
end

nd_param = sum(ismember(["dmin", "dd"], Xid));
if (nd_param ~= 0) && (nd_param ~= 2)
    error("Error: the information about the stages diameters is incomplete");
end


% Changing the parameters in SimObj
k = length(Xid);
for i=1:k
    id = Xid(i);
    
    switch id
        case "dmin"
            dmin = X(i);
        case "dd"
            dd = X(i);
        case "z1"
            z1 = X(i);
        case "z12"
            z12 = X(i);
        case "z23"
            z13 = X(i);
        case "T1"
            SimObj.Rocket.Thrust_Force(2) = X(i); 
        case "T2"
            SimObj.Rocket.Thrust_Force(3) = X(i); 
        case "Vi1"
            layerspeed(1) = X(i);
            isChanged_Vi = true;
        case "Vi2"
            layerspeed(2) = X(i);
            isChanged_Vi = true;
        case "Vi3"
            layerspeed(3) = X(i);
            isChanged_Vi = true;
        case "Vi4"
            layerspeed(4) = X(i);
            isChanged_Vi = true;
        case "Vi5"
            layerspeed(5) = X(i);
            isChanged_Vi = true;
        case "Vi6"
            layerspeed(6) = X(i);
            isChanged_Vi = true;
        case "ai1"
            layerAzi(1) = X(i);
            isChanged_ai = true;
        case "ai2"
            layerAzi(2) = X(i);
            isChanged_ai = true;
        case "ai3"
            layerAzi(3) = X(i);
            isChanged_ai = true;
        case "ai4"
            layerAzi(4) = X(i);
            isChanged_ai = true;
        case "ai5"
            layerAzi(5) = X(i);
            isChanged_ai = true;
        case "ai6"
            layerAzi(6) = X(i);
            isChanged_ai = true;
        case "Burn_Time"
            SimObj.Rocket.Burn_Time = X(i);
            SimObj.Rocket.Thrust_Time =  X(i) * Thrust_Time_NV;
        otherwise
            if ismember(id, rocketparamIDs)
                SimObj.Rocket.(id) = X(i);
            elseif ismember(id, envparamIDs)
                SimObj.Environment.(id) = X(i);
            else
                print("Error: unknown parameter (", id, ")");
            end
    end
end

if nz_param == 3
    SimObj.Rocket.stage_z = [0, z1, z1 + z12, z1 + z12 + z13];
end

if nd_param == 2
    SimObj.Rocket.diameters = [0, dmin + dd, dmin + dd, dmin];
end

if isChanged_Vi
    SimObj.Environment.Vspeed = interp1(layerheight_NV, layerspeed, interpheight, 'pchip', 'extrap');
end

if isChanged_ai
    SimObj.Environment.Vazy = interp1(layerheight_NV, layerAzi, interpheight, 'pchip', 'extrap');
    SimObj.Environment.Vdirx= cosd(SimObj.Environment.Vazy);
    SimObj.Environment.Vdiry= sind(SimObj.Environment.Vazy);
end

% Changing the dependent parameters (see rocketReader.m part 4)

% 4.1 Maximum body diameter
SimObj.Rocket.dm = SimObj.Rocket.diameters(find(SimObj.Rocket.diameters == max(SimObj.Rocket.diameters), 1, 'first'));
% 4.2 Fin cord
SimObj.Rocket.fin_c = (SimObj.Rocket.fin_cr + SimObj.Rocket.fin_ct)/2; 
% 4.3 Maximum cross-sectional body area
SimObj.Rocket.Sm = pi*SimObj.Rocket.dm^2/4; 
% 4.4 Exposed planform fin area
SimObj.Rocket.fin_SE = (SimObj.Rocket.fin_cr + SimObj.Rocket.fin_ct )/2*SimObj.Rocket.fin_s; 
% 4.5 Body diameter at middle of fin station (CAREFUL, assumption for the SA)
SimObj.Rocket.fin_df = SimObj.Rocket.dm; 
% 4.6 Virtual fin planform area
SimObj.Rocket.fin_SF = SimObj.Rocket.fin_SE + 1/2*SimObj.Rocket.fin_df*SimObj.Rocket.fin_cr; 
% 4.8 Rocket Length
SimObj.Rocket.L = SimObj.Rocket.stage_z(end);
% Saturation Vapor Ration
p_ws = exp(77.345+0.0057*SimObj.Environment.Temperature_Ground-7235/SimObj.Environment.Temperature_Ground)/SimObj.Environment.Temperature_Ground^8.2;
p_a = SimObj.Environment.Pressure_Ground;
SimObj.Environment.Saturation_Vapor_Ratio = 0.62198*p_ws/(p_a-p_ws);
% Casing masses
SimObj.Rocket.casing_massP = SimObj.Rocket.motor_massP-SimObj.Rocket.propel_massP;
SimObj.Rocket.casing_massF = SimObj.Rocket.motor_massF-SimObj.Rocket.propel_massF;
%Global motor info
SimObj.Rocket.motor_dia = max(SimObj.Rocket.motor_diaP, SimObj.Rocket.motor_diaF);
SimObj.Rocket.motor_length = SimObj.Rocket.motor_lengthP + SimObj.Rocket.motor_lengthF + SimObj.Rocket.intermotor_d ;
SimObj.Rocket.propel_mass = SimObj.Rocket.propel_massP + SimObj.Rocket.propel_massF ;
SimObj.Rocket.motor_mass = SimObj.Rocket.motor_massP + SimObj.Rocket.motor_massF; 
SimObj.Rocket.casing_mass = SimObj.Rocket.casing_massP + SimObj.Rocket.casing_massF ;
% Mass variation coefficient
A_T = trapz(SimObj.Rocket.Thrust_Time, SimObj.Rocket.Thrust_Force);
SimObj.Rocket.Thrust2dMass_Ratio = SimObj.Rocket.propel_mass/(A_T);


end
