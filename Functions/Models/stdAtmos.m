function [T, a, p, rho, Nu] = stdAtmos(alt,Env)
% stdAtmos
%
% INPUT:    - alt   : altitude [m]
%           - Env   : Environment Structure
%
% OUPTUT:   - T     : local standard temperature [K]
%           - a     : local speed of sound [m/s]
%           - p     : local standard pressure [Pa]
%           - rho   : local standard density [kg/m^3]
%           - Nu    : local kinematic viscosity of air [m^2/s]
%
% ASSUMPTIONS:
% - hydrostatic approximation of atmosphere
% - linear temperature variation with altitude with a slope of -9.5�C/km-->
% comes from result of radiosonde data
% - homogenous composition
%
% LIMITATIONS:
% - troposphere: 10km
%
% AUTHOR: ERIC BRUNNER ET PAUL GERMANN
% LAST UPDATE: 01/04/2019

% CHECK ALTITUDE RANGE
if alt > 1e5
    error('stdAtmos:outOfRange', 'The altitude is out of range: max 10km.')
end
    
% CONSTANTS
R = 287.04; %[M^2/?K/sec^2] real gas constant of air
gamma = 1.4; %[-] specific heat coefficient of air
% MEAN SEA LEVEL CONDITIONS
p0 = 101325; %[Pa]
T0 = 288.15; %[K]
a0 = 340.294; %[m/sec] sound speed at sea level
g0 = 9.80665; %[m/sec^2] gravity at sea level

%GRAVITY EXPRESSION: ACCELERATION DUE TO GRAVITY (IEC 60193)
%g=9.7803*(1+0.0053*(sin(Environnement.Start_Latitude))^2)-3*10^(-6)*alt;

% TEMPERATURE MODEL
T = Env.Temperature_Ground + Env.dTdh*(alt-Env.Start_Altitude)/1000; %en [K]

% PRESSURE MODEL
p = p0*(1+Env.dTdh/1000*alt/T0).^(-g0/R/Env.dTdh*1000);

% DENSITY MODEL
x = Env.Saturation_Vapor_Ratio*Env.Humidity_Ground;
rho = p./R./T*(1+x)/(1+1.609*x);

% SPEED OF SOUND
a = sqrt(gamma*R*T);

% VISCOSITY
Nu = interp1(Env.T_Nu,Env.Viscosity,[T]);
end