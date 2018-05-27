function U = windModel(t, I, V_inf, Model)

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
        
    end
    
end

end