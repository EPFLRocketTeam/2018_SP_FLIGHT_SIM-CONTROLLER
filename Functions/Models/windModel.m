function U = windModel(t, I, V_inf, Model, h_alt)
% WINDMODEL computes wind based on specified Model. Wind can be constant or
% turbulent. Available models are:
% - None        : No wind change, wind is constant
% - Gaussian    : Stochastic wind intensity based on gaussian distribution
% - VonKarman   : Stochastic wind intensity based on VonKarman turbulence
%                 spectra
% INPUTS :
% - t           : simulation time [s]
% - I           : turbulent intensity = U_std/U_mean []
global t_wind_
global wind_

if(strcmp(Model,'None'))
    
    U = V_inf; 
    
else
    
    if isempty(t_wind_)
        t_wind_ = 0;   
        wind_ = V_inf;
    end
    
    if(strcmp(Model,'Gaussian'))
    
        if(t>t_wind_(end))
            t_wind_ = [t_wind_, t];
            turb_std = I*V_inf;
            U = normrnd(V_inf, turb_std);
            wind_ = [wind_, U]; 
        else
            U = interp1(t_wind_, wind_', t, 'linear')';
        end
        
    elseif(strcmp(Model, 'VonKarman'))
        if(t>t_wind_(end))
            t_wind_ = [t_wind_, t];
            turb_std = I*V_inf;
            z0 = 0.001; % terrain roughness length [m] (desert)
            zi = 1000*Z0^(0.18);
            
            
            %TODO: complete model!!!!
            
            wind_ = [wind_, U];
        else
            U = interp1(t_wind_, wind_', t, 'linear')';
        end
    elseif(strcmp(Model, 'Logarithmic'))

            z0 = 0.0024; % [m]; % terrain roughness length [m] (desert)
            h_ground = 1.5; %[m] measure windspeed 
            U = V_inf*(log(h_alt/z0)/log(h_ground/z0));
            
            wind_ = [wind_, U]; 
    else
        error(['Error: windmodel ' Model 'is unknown.'...
            'Type help windModel to view available models.']);
    end
    
end

    function VKns = VK_long_norm_spectr(n, L2u, U_mean)
        % returns normalized longitudinal spetrum of tubulence at frequency
        % n, caracteristic length L2u and mean velocity U_mean.
        VKns = 4*n*L2u/U_mean/(1+70.8*(n*L2u/U_mean)^2)^5/6;
    end

    function VKns = VK_perp_norm_spectr(n, L2v, U_mean)
        % returns normalized perpendicular spetrum of tubulence at frequency
        % n, caracteristic length L2v and mean velocity U_mean.
        VKns = 4*(n*L2v/U_mean)*(1+755.2*(n*L2v/U_mean)^2)/(1+283.2*(n*L2v/U_mean)^2)^11/6;
    end

    function L2u = L2u_func(z, zi)
       if  z>zi
           L2u = 280;
       else
           L2u = 280*(z/zi)^(0.35);
       end
    end

    function L2v = L2v_func(z, zi)
       if  z>zi
           L2v = 140;
       else
           L2v = 140*(z/zi)^(0.48);
       end
    end

end