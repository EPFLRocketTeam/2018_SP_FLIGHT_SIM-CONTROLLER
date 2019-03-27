function Environnement = environnementReader(environnementFilePath)

% -------------------------------------------------------------------------
% 1. Read Environnement
% -------------------------------------------------------------------------

rfid = fopen(environnementFilePath);

if rfid < 0
   error('ERROR: Environnement file name unfound.') 
end

while ~feof(rfid)

    line_content = fgetl(rfid);
    [line_id, line_data] = strtok(line_content);
    switch line_id
        
        case 'Temperature_Ground'
            line_data_num = textscan(line_data, '%f');
            Environnement.Temperature_Ground = line_data_num{1}(1);
            
        case 'Pressure_Ground'
            line_data_num = textscan(line_data, '%f');
            Environnement.Pressure_Ground = line_data_num{1}(1);
            
        case 'Humidity_Ground'
            line_data_num = textscan(line_data, '%f');
            Environnement.Humidity_Ground = line_data_num{1}(1);
        
        case 'V_inf'
            line_data_num = textscan(line_data, '%f');
            Environnement.V_inf = line_data_num{1}(1);
           
        case 'V_Azimuth'
            line_data_num = textscan(line_data, '%f');
            Environnement.V_Azimuth = line_data_num{1};  
            
        case 'Turb_I'
            line_data_num = textscan(line_data, '%f');
            Environnement.Turb_I = line_data_num{1}(1);
            
        case 'Turb_model'
            line_data_string = textscan(line_data,'%s');
            Environnement.Turb_model = line_data_string{1}{1};
            
        case 'Rail_Length'
            line_data_num = textscan(line_data, '%f');
            Environnement.Rail_Length = line_data_num{1}(1);
            
        case 'Rail_Angle'
            line_data_num = textscan(line_data, '%f');
            Environnement.Rail_Angle = line_data_num{1}(1)/180*pi;
            
        case 'Rail_Azimuth'
            line_data_num = textscan(line_data, '%f');
            Environnement.Rail_Azimuth = line_data_num{1}(1)/180*pi;
            
        case 'Start_Altitude'
            line_data_num = textscan(line_data, '%f');
            Environnement.Start_Altitude = line_data_num{1}(1);
        
        case 'Start_Latitude'
            line_data_num = textscan(line_data, '%f');
            Environnement.Start_Latitude = line_data_num{1}(1);
            
        case 'Start_Longitude'
            line_data_num = textscan(line_data, '%f');
            Environnement.Start_Longitude = line_data_num{1}(1);    
        otherwise
            display(['ERROR: In environnement definition, unknown line identifier: ' line_id]);
         
    end
end  
    
% -------------------------------------------------------------------------
% 2. Intrinsic parameters
% -------------------------------------------------------------------------
% 2.1 Environnement Viscosity
Tmp = xlsread('Snippets/Viscosity.xlsx');
Environnement.T_Nu = Tmp(:,1);
Environnement.Viscosity = Tmp(:,2);

% 2.2 Humidity Changes
p_ws = exp(77.345+0.0057*Environnement.Temperature_Ground-7235/Environnement.Temperature_Ground)/Environnement.Temperature_Ground^8.2;
p_a = Environnement.Pressure_Ground;
Environnement.Saturation_Vapor_Ratio = 0.62198*p_ws/(p_a-p_ws);

% 2.3 Wind direction
Environnement.V_dir = [cosd(Environnement.V_Azimuth);sind(Environnement.V_Azimuth); 0];
end

