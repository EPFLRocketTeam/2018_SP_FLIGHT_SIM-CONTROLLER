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
            
        case 'Rail_Length'
            line_data_num = textscan(line_data, '%f');
            Environnement.Rail_Length = line_data_num{1}(1);
            
        case 'Rail_Angle'
            line_data_num = textscan(line_data, '%f');
            Environnement.Rail_Angle = line_data_num{1}(1)/180*pi;
            
        case 'Rail_Azimuth'
            line_data_num = textscan(line_data, '%f');
            Environnement.Rail_Azimuth = line_data_num{1}(1)/180*pi;
        otherwise
            display(['ERROR: In environnement definition, unknown line identifier: ' line_id]);
         
    end
    
% -------------------------------------------------------------------------
% 2. Intrinsic parameters
% -------------------------------------------------------------------------
% 2.1 Environnement Viscosity
Tmp = xlsread('Viscosity.xlsx');
T_Nu = Tmp(:,1);
Viscosity = Tmp(:,2);
Environnement.Nu = interp1(T_Nu,Viscosity,[Environnement.Temperature_Ground]);
end   
end

