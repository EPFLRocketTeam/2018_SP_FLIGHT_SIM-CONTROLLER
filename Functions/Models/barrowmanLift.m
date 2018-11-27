function [Calpha, CP] = barrowmanLift(Rocket, alpha, M, theta)

    % reference area

    Aref = pi*Rocket.diameters(2)^2/4;
    
    % cone
    if strcmp(Rocket.cone_mode, 'on')
        if alpha == 0
            CNa_cone = 2;
        else
            CNa_cone = 2*sin(alpha)/alpha;
        end    
    CP_cone = 2/3*Rocket.stage_z(2);   
    end
    
    % stages
    CNa_stage = zeros(1, Rocket.stages-2);
    CP_stage = zeros(1, Rocket.stages-2);
    for i = 1:(Rocket.stages-2)
        if alpha == 0
            CNa_stage(i) = (Rocket.diameters(i+2)^2-Rocket.diameters(i+1)^2)*pi/Aref/2;
        else
            CNa_stage(i) = (Rocket.diameters(i+2)^2-Rocket.diameters(i+1)^2)*pi/Aref/2*sin(alpha)/alpha;
        end
        CP_stage(i) = Rocket.stage_z(i+1)+1/3*(Rocket.stage_z(i+2)-Rocket.stage_z(i+1))*(1+(1-Rocket.diameters(i+1)/Rocket.diameters(i+2))/(1-(Rocket.diameters(i+1)/Rocket.diameters(i+2))^2));
    end
    
    % fins 
    if(M<1)
        beta  = sqrt(1-M^2);
    else
        warning('Warining: In barrowman calculations Mach number is > 1.');
        beta = sqrt(M^2-1);
    end
    gamma_c = atan(((Rocket.fin_xs+Rocket.fin_ct)/2-Rocket.fin_cr/2)/Rocket.fin_s);
    A = 0.5*(Rocket.fin_ct+Rocket.fin_cr)*Rocket.fin_s;
    R = Rocket.diameters(find(Rocket.stage_z<Rocket.fin_xt, 1, 'last'))/2;
    KTB = 1 + R/(R+Rocket.fin_s);
    CNa1 = KTB*2*pi*Rocket.fin_s^2/Aref/(1+sqrt(1+(beta*Rocket.fin_s^2/A/cos(gamma_c))^2));
    CNa_fins = CNa1*sum(sin(theta+2*pi/Rocket.fin_n*(0:(Rocket.fin_n-1))).^2);
    CP_fins = Rocket.fin_xt + Rocket.fin_xs/3*(Rocket.fin_cr+2*Rocket.fin_ct)/(Rocket.fin_cr+Rocket.fin_ct) + 1/6*((Rocket.fin_cr+Rocket.fin_ct)-(Rocket.fin_cr*Rocket.fin_ct)/(Rocket.fin_cr+Rocket.fin_ct));
    
    % Output
    Calpha = [CNa_stage, CNa_fins]; 
    CP = [CP_stage, CP_fins]; 
    if strcmp(Rocket.cone_mode, 'on')
        Calpha = [CNa_cone, Calpha]; 
        CP = [CP_cone, CP]; 
    end    
    
    CP(find(isnan(CP))) = 0;
end