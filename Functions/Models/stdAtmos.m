function [T, a, p, rho, Nu] = stdAtmos(alt,Environnement)
% stdAtmos
%
% INPUT:    - alt   : altitude [m]
%
% OUPTUT:   - T     : local standard temperature [?K]
%           - a     : local speed of sound [m/s]
%           - p     : local standard pressure [Pa]
%           - rho   : local standard density [kg/m^3]
%
% ASSUMPTIONS:
% - hydrostatic approximation of atmosphere
% - linear temperature variation with altitude
% - homogenous composition
%
% LIMITATIONS:
% - troposphere: 10km
%
% AUTOR:    ERIC BRUNNER
% LAST UPDATE: 05/03/2017

% CHECK ALTITUDE RANGE
if alt > 1e4
    error('stdAtmos:outOfRange', 'The altitude is out of range: max 10km.')
end
    
% CONSTANTS
R = 287.04; %[M^2/?K/sec^2] real gas constant of air
gamma = 1.4; %[-] specific heat coefficient of air
% MEAN SEA LEVEL CONDITIONS
p0 = 101325; %[Pa]
rho0 = 1.225; %[kg/m^3]
T0 = 288.15; %[?K]
a0 = 340.294; %[m/sec]
g0 = 9.80665; %[m/sec^2]

% DATA
% stations
dTdh = -6.5; %[?K/km] temperature variation in troposphere

% TEMPERATURE MODEL
T = T0 + dTdh*alt/1000;

% PRESSURE MODEL
p = p0*(1+dTdh/1000*alt/T0).^(-g0/R/dTdh*1000);

% DENSITY MODEL
x = Environnement.Saturation_Vapor_Ratio*Environnement.Humidity_Ground;
rho = p./R./T*(1+x)/(1+1.609*x);

% SPEED OF SOUND
a = sqrt(gamma*R*T);

% VISCOSITY
Nu = interp1(Environnement.T_Nu,Environnement.Viscosity,[T]);
end