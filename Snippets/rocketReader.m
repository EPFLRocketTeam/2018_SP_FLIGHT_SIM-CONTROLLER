function Rocket = rocketReader(rocketFilePath)

% -------------------------------------------------------------------------
% 1. Read Rocket
% -------------------------------------------------------------------------

rfid = fopen(rocketFilePath);

if rfid < 0
   error('ERROR: Rocket file name unfound.') 
end

while ~feof(rfid)

    line_content = fgetl(rfid);
    [line_id, line_data] = strtok(line_content);
    line_data_num = textscan(line_data, '%f');
    switch line_id
        
        case 'stages'
            Rocket.stages = line_data_num{1}(1);
            
        case 'diameters'
            Rocket.diameters = line_data_num{1}';
            
        case 'stage_z'
            Rocket.stage_z = line_data_num{1}';
            
        case 'fin_n'
            Rocket.fin_n = line_data_num{1}(1);
            
        case 'fin_xt'
            Rocket.fin_xt = line_data_num{1}(1);
            
        case 'fin_s'
            Rocket.fin_s = line_data_num{1}(1);
            
        case 'fin_cr'
            Rocket.fin_cr = line_data_num{1}(1);    
            
        case 'fin_ct'
            Rocket.fin_ct = line_data_num{1}(1);
            
        case 'fin_t'
            Rocket.fin_t = line_data_num{1}(1);
            
        case 'fin_xs'
            Rocket.fin_xs = line_data_num{1}(1);
            
        case 'lug_n'
            Rocket.lug_n = line_data_num{1}(1);    
            
        case 'lug_S'
            Rocket.lug_S = line_data_num{1}(1);
            
        case 'rocket_m'
            Rocket.rocket_m = line_data_num{1}(1);
            
        case 'rocket_cm'
            Rocket.rocket_cm = line_data_num{1}(1);
            
        case 'rocket_I'
            Rocket.rocket_I = line_data_num{1}(1);
        
        case "ab_x"
            Rocket.ab_x = line_data_num{1}(1);
            
        case "ab_w"
            Rocket.ab_w = line_data_num{1}(1);    
        
        case "ab_h"
            Rocket.ab_h = line_data_num{1}(1);      
            
        case "ab_n"
            Rocket.ab_n = line_data_num{1}(1); 
            
        otherwise
            display(['ERROR: In rocket definition, unknown line identifier: ' line_id]);
         
    end

end    
   
% -------------------------------------------------------------------------
% 2. Checks
% -------------------------------------------------------------------------

if checkStages(Rocket)
    error('ERROR: Reading rocket definition file.')
end

% -------------------------------------------------------------------------
% 3. Intrinsic parameters
% -------------------------------------------------------------------------

% 3.1 Maximum body diameter
Rocket.dm = Rocket.diameters(find(Rocket.diameters == max(Rocket.diameters), 1, 'first')); 
% 3.2 Fin cord
Rocket.fin_c = (Rocket.fin_cr + Rocket.fin_ct)/2; 
% 3.3 Maximum cross-sectional body area
Rocket.Sm = pi*Rocket.dm^2/4; 
% 3.4 Exposed planform fin area
Rocket.fin_SE = (Rocket.fin_cr + Rocket.fin_ct )/2*Rocket.fin_s; 
% 3.5 Body diameter at middle of fin station
Rocket.fin_df = interp1(Rocket.stage_z, Rocket.diameters, Rocket.fin_xt+Rocket.fin_cr/2, 'linear'); 
% 3.6 Virtual fin planform area
Rocket.fin_SF = Rocket.fin_SE + 1/2*Rocket.fin_df*Rocket.fin_cr; 
% 3.7 Airbrake braking surface
Rocket.ab_S = Rocket.ab_w*Rocket.ab_h;

% -------------------------------------------------------------------------
% 4. Sub-routines
% -------------------------------------------------------------------------

function flag = checkStages(Rocket)
    flag = 0;
    if ~(length(Rocket.diameters) == Rocket.stages && length(Rocket.stage_z) == Rocket.stages)
        flag = 1;
        display('ERROR: In rocket defintion, rocket diameters and/or stage_z are not equal in length to the announced stages.')
    elseif ~(Rocket.diameters(1) == 0 && Rocket.stage_z(1) == 0)
        flag = 1;
        display('ERROR: In rocket defintion, rocket must start with a point (diameters(1) = 0, stage_z(1) = 0)');
    end
end

end

