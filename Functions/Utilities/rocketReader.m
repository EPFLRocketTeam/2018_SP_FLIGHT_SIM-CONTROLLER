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
    switch line_id
        
        case 'stages'
            line_data_num = textscan(line_data, '%f');
            Rocket.stages = line_data_num{1}(1);
            
        case 'diameters'
            line_data_num = textscan(line_data, '%f');
            Rocket.diameters = line_data_num{1}';
            
        case 'stage_z'
            line_data_num = textscan(line_data, '%f');
            Rocket.stage_z = line_data_num{1}';
            
        case 'cone_mode'
            line_data_string = textscan(line_data,'%s');
            Rocket.cone_mode = line_data_string{1}{1};    
            
        case 'fin_n'
            line_data_num = textscan(line_data, '%f');
            Rocket.fin_n = line_data_num{1}(1);
            
        case 'fin_xt'
            line_data_num = textscan(line_data, '%f');
            Rocket.fin_xt = line_data_num{1}(1);
            
        case 'fin_s'
            line_data_num = textscan(line_data, '%f');
            Rocket.fin_s = line_data_num{1}(1);
            
        case 'fin_cr'
            line_data_num = textscan(line_data, '%f');
            Rocket.fin_cr = line_data_num{1}(1);    
            
        case 'fin_ct'
            line_data_num = textscan(line_data, '%f');
            Rocket.fin_ct = line_data_num{1}(1);
            
        case 'fin_t'
            line_data_num = textscan(line_data, '%f');
            Rocket.fin_t = line_data_num{1}(1);
            
        case 'fin_xs'
            line_data_num = textscan(line_data, '%f');
            Rocket.fin_xs = line_data_num{1}(1);
            
        case 'lug_n'
            line_data_num = textscan(line_data, '%f');
            Rocket.lug_n = line_data_num{1}(1);    
            
        case 'lug_S'
            line_data_num = textscan(line_data, '%f');
            Rocket.lug_S = line_data_num{1}(1);
            
        case 'rocket_m'
            line_data_num = textscan(line_data, '%f');
            Rocket.rocket_m = line_data_num{1}(1);
            
        case 'rocket_I'
            line_data_num = textscan(line_data, '%f');
            Rocket.rocket_I = line_data_num{1}(1);
            
        case 'rocket_cm'
            line_data_num = textscan(line_data, '%f');
            Rocket.rocket_cm = line_data_num{1}(1);
            
        case 'ab_x'
            line_data_num = textscan(line_data, '%f');
            Rocket.ab_x = line_data_num{1}(1);
            
        case 'ab_n'
            line_data_num = textscan(line_data, '%f');
            Rocket.ab_n = line_data_num{1}(1);
            
        case 'ab_phi'
            line_data_num = textscan(line_data, '%f');
            Rocket.ab_phi = line_data_num{1}(1);    
            
        case 'motor'
            line_data_string = textscan(line_data,'%s');
            Rocket.motor_ID = line_data_string{1}{1};
            
        case 'motor_fac'
            line_data_num = textscan(line_data,'%f');
            Rocket.motor_fac = line_data_num{1}(1);    
            
        case 'pl_mass'
            line_data_num = textscan(line_data,'%f');
            Rocket.pl_mass = line_data_num{1}(1);
            
        case 'para_main_SCD'
            line_data_num = textscan(line_data,'%f');
            Rocket.para_main_SCD = line_data_num{1}(1);
            
        case 'para_drogue_SCD'
            line_data_num = textscan(line_data,'%f');
            Rocket.para_drogue_SCD = line_data_num{1}(1);
            
        case 'para_main_event'
            line_data_num = textscan(line_data,'%f');
            Rocket.para_main_event = line_data_num{1}(1); 
            
        case 'cp_fac'
            line_data_num = textscan(line_data,'%f');
            Rocket.cp_fac = line_data_num{1}(1);
        
        case 'CNa_fac'
            line_data_num = textscan(line_data,'%f');
            Rocket.CNa_fac = line_data_num{1}(1);
            
        case 'CD_fac'
            line_data_num = textscan(line_data,'%f');
            Rocket.CD_fac = line_data_num{1}(1);
                        
        otherwise
            display(['ERROR: In rocket definition, unknown line identifier: ' line_id]);
         
    end

end    
   
% -------------------------------------------------------------------------
% 2. Read Motor
% -------------------------------------------------------------------------

rfid = fopen(Rocket.motor_ID);

% 2.1 Read Informations
line_content = fgetl(rfid); % Read one line
Info = textscan(line_content,'%s %f32 %f32 %s %f32 %f32 %s');

Rocket.motor_dia = Info{2}/1000;
Rocket.motor_length = Info{3}/1000;
Rocket.motor_delay = Info{4};
Rocket.propel_mass = Info{5};
Rocket.motor_mass = Info{6};
Rocket.casing_mass = Rocket.motor_mass-Rocket.propel_mass;

% 2.2 Read Thrust Informations
t = [0]; T = [0]; % Initialization

while ~feof(rfid)   % Test end of file
    
    line_content = fgetl(rfid); % Read one line
    Tmp = textscan(line_content,'%f32 %f32');
    t = [t Tmp{1}];
    T = [T Tmp{2}];
end

Rocket.Thrust_Time = t;
Rocket.Thrust_Force = T;
% -------------------------------------------------------------------------
% 3. Checks
% -------------------------------------------------------------------------

if checkStages(Rocket)
    error('ERROR: Reading rocket definition file.')
end

if ~(strcmp(Rocket.cone_mode, 'on') || strcmp(Rocket.cone_mode, 'off'))
    error(['ERROR: Cone mode parameter ' Rocket.cone_mode ' unknown.']);
end

% -------------------------------------------------------------------------
% 4. Intrinsic parameters
% -------------------------------------------------------------------------

% 4.1 Maximum body diameter
Rocket.dm = Rocket.diameters(find(Rocket.diameters == max(Rocket.diameters), 1, 'first')); 
% 4.2 Fin cord
Rocket.fin_c = (Rocket.fin_cr + Rocket.fin_ct)/2; 
% 4.3 Maximum cross-sectional body area
Rocket.Sm = pi*Rocket.dm^2/4; 
% 4.4 Exposed planform fin area
Rocket.fin_SE = (Rocket.fin_cr + Rocket.fin_ct )/2*Rocket.fin_s; 
% 4.5 Body diameter at middle of fin station
Rocket.fin_df = interp1(Rocket.stage_z, Rocket.diameters, Rocket.fin_xt+Rocket.fin_cr/2, 'linear'); 
% 4.6 Virtual fin planform area
Rocket.fin_SF = Rocket.fin_SE + 1/2*Rocket.fin_df*Rocket.fin_cr; 
% 4.8 Rocket Length
Rocket.L = Rocket.stage_z(end);
% 4.9 Burn Time
Rocket.Burn_Time = t(end);

% -------------------------------------------------------------------------
% 5. Mass variation
% -------------------------------------------------------------------------
% 5.1 Total Impulse
tt = linspace(0,Rocket.Burn_Time,2000);
TT = Thrust(tt,Rocket);
A_T = trapz(tt,TT); % Area under Thrust Curve

% 5.2 Total Mass
Rocket.Thrust2dMass_Ratio = Rocket.propel_mass/A_T;

% -------------------------------------------------------------------------
% 6. Sub-routines
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

