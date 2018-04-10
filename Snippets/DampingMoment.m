function C2 = DampingMoment(t,Rocket,Calpha,CP,Velocity)
% Give damping moment based on rocket geometry & motor caracteristics
%

%--------------------------------------------------------------------------
% 1 Intrasic parameter
%--------------------------------------------------------------------------
rho = 1.22; % Air density at launch pad [kg/m3]
mdot = Rocket.propel_mass/Rocket.Burn_Time;
cm = CM(t,Rocket);

%--------------------------------------------------------------------------
% 2 Subparameter
%--------------------------------------------------------------------------
%2.1 Thrust damping coefficient 
CR2 = mdot*(Rocket.L-cm).^2;

%2.2 Aerodynamic damping coefficient
CNa_Total = sum(Calpha.*(CP-cm).^2);
CA2 = rho*Velocity*Rocket.Sm/2*CNa_Total;

%--------------------------------------------------------------------------
% 3 Total Damping Coefficient
%--------------------------------------------------------------------------
C2 = CR2+CA2;
end

