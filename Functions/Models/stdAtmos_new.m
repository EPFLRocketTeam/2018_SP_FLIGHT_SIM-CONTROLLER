% function [T, a, p, rho, Nu] = stdAtmos(alt,Env)
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
% - linear temperature variation with altitude with a slope of -9.5°C/km-->
% comes from result of radiosonde data
% - homogenous composition
%
% LIMITATIONS:
% - troposphere: 10km
%
% AUTHOR: ERIC BRUNNER ET PAUL GERMANN
% LAST UPDATE: 01/04/2021

% CHECK ALTITUDE RANGE
% if alt > 1e4
%     error('stdAtmos:outOfRange', 'The altitude is out of range: max 10km.')
% end
    
% CONSTANTS
R = 287.04; %[M^2/?K/sec^2] real gas constant of air
gamma = 1.4; %[-] specific heat coefficient of air
Rad=6.371e6;

% MEAN SEA LEVEL CONDITIONS
p0 = 101325; %[Pa]
T0 = 288.15; %[K]
a0 = 340.294; %[m/sec] sound speed at sea level
g0 = 9.80665; %[m/sec^2] gravity at sea level

%GRAVITY EXPRESSION: ACCELERATION DUE TO GRAVITY (IEC 60193)
% g=9.7803*(1+0.0053*(sin(Environnement.Start_Latitude))^2)-3*10^(-6)*alt;
Env.date=20210419;
Env.time=17;
Env.Start_Latitude=47;
Env.Start_Longitude=8;
alt=3000;


% import data from website
url=append('https://nomads.ncep.noaa.gov/dods/gfs_0p25/gfs',num2str(Env.date),'/gfs_0p25_',num2str(mod(floor(Env.time/6)*6,24)),'z'); %national weather serice website server


% first find lattude, longitude and level indexes
lat_index= Env.Start_Latitude/0.25 + 90/0.25 + 1;    %lattitude starts as -90° and matlab indexes start at 1 and increments of 0.25
lon_index= round(Env.Start_Longitude/0.25)+1 ; %lattitude starts as 0° and matlab indexes start at 1
time_index= mod(round((mod(floor(Env.time/6)*6 ,24) - round(Env.time))/6),3);   %time index in the data array

levels= ncread(url,'lev',1,Inf);    %array of altitudes given in mbar
% altitudes= 0.3048*145366.45*(1-(levels/(p0/100)).^0.190284); %formula to convert mbar to meters 
% z= p0/100 * (1-alt/(0.3048*145366.45))^(1/0.190284);  % convert alt into mbar to find it in array

altitudes=zeros(length(levels),1);

 for i=1:length(levels)
     gph=ncread(url,'hgtprs',[lon_index lat_index i time_index],[1 1 1 1]);
     altitudes(i)=gph*Rad/(Rad-gph);
 end
pression=interp1(altitudes,levels,alt)

% % figure to compare std model and acquired data
% figure
% plot(altitudes,levels(1:size(altitudes)));
% hold on
% plot(0.3048*145366.45*(1-(levels/(p0/100)).^0.190284),levels);
% hold off
% grid on
% 

 [level_diff, level_index]= min(abs(levels-z));      %smallest difference between alt and levels & the index in the data array 
% 
% %find temperature for chosen latitude, longitude, time and altitude
T=ncread(url,'tmpprs',[lon_index lat_index level_index time_index],[1 1 1 1]);%[longitude latitude level time]
%u=ncread(url,'ugrd_1829m');
%v=ncread(url,'vgrd_1829m');

%if graph of temperature if wanted, add this:
% temp=zeros(length(temperature),1);
% for i=1:length(temperature)
%     temp(i)=temperature(:,:,i);     %changing format of the temperature variable
% end




% latitude=ncread(url,'lat',lat_index,1);
% longitude=ncread(url,'lon',lon_index,1);        %find latitude and longitude and explicit time 
% time=ncread(url,'time',time_index,1);

% figure
% plot(altitudes, temp,'- b','linewidth',1.2)
% xlabel('altitude [m]')
% ylabel('temperature [K]')
% grid on

% TEMPERATURE MODEL
% T = Env.Temperature_Ground + Env.dTdh*(alt-Env.Start_Altitude)/1000; %en [K]

% PRESSURE MODEL
% if Env.Start_Latitude==32.942380 && Env.Start_Longitude== -106.91428
%     p = p0*(1+Env.dTdh/1000*(alt-Env.Start_Altitude)/T0).^(-g0/R/Env.dTdh*1000);
% else
%     p = p0*(1+Env.dTdh/1000*(alt)/T0).^(-g0/R/Env.dTdh*1000);
% 
% end

% DENSITY MODEL
% x = Env.Saturation_Vapor_Ratio*Env.Humidity_Ground;
% rho = p./R./T*(1+x)/(1+1.609*x);

% % SPEED OF SOUND
a = sqrt(gamma*R*T);
% 
% % VISCOSITY
% Nu = interp1(Env.T_Nu,Env.Viscosity,[T]);
% end