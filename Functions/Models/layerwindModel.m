function U = layerwindModel(Environnement, h_alt)
% WINDMODEL computes wind based on specified Model. Wind can be constant or
% turbulent. Available models are:
% - None        : No wind change, wind is constant
% - Gaussian    : Stochastic wind intensity based on gaussian distribution
% - VonKarman   : Stochastic wind intensity based on VonKarman turbulence
%                 spectra
% INPUTS :
% - t           : simulation time [s]
% - I           : turbulent intensity = U_std/U_mean []


    alt = min(4000, max(0,round(X(3))));
    V_inf = Environnement.Vspeed(alt)*Environnement.Vdir(alt);
    U = V_inf;
            
end