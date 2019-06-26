function SimOutput = SimOutputReader(simOutputFilePath)

% -------------------------------------------------------------------------
% 1. Read Environnement
% -------------------------------------------------------------------------

rfid = fopen(simOutputFilePath);

if rfid < 0
   error('ERROR: SimOutput file name unfound.') 
end

while ~feof(rfid)

    line_content = fgetl(rfid);
    [line_id, line_data] = strtok(line_content);
    switch line_id
        
        case 'Margin'
            line_data_num = textscan(line_data, '%f');
            SimOutput.Margin = line_data_num{1}(1);
            
        case 'Alpha'
            line_data_num = textscan(line_data, '%f');
            SimOutput.Alpha = line_data_num{1}(1);
            
        case 'Cn_alpha'
            line_data_num = textscan(line_data, '%f');
            SimOutput.Cn_alpha = line_data_num{1}(1);
            
        case 'Xcp'
            line_data_num = textscan(line_data, '%f');
            SimOutput.Xcp = line_data_num{1}(1);    
        
        case 'Cd'
            line_data_num = textscan(line_data, '%f');
            SimOutput.Cd = line_data_num{1}(1);
           
        case 'Mass'
            line_data_num = textscan(line_data, '%f');
            SimOutput.Mass = line_data_num{1};  
            
        case 'CM'
            line_data_num = textscan(line_data, '%f');
            SimOutput.CM = line_data_num{1}(1);
            
        case 'Il'
            line_data_num = textscan(line_data,'%f');
            SimOutput.Il = line_data_num{1}(1);
            
        case 'Ir'
            line_data_num = textscan(line_data, '%f');
            SimOutput.Ir = line_data_num{1}(1);
            
        case 'Delta'
            line_data_num = textscan(line_data, '%f');
            SimOutput.Delta = line_data_num{1}(1);
            
        case 'Nose_Alpha'
            line_data_num = textscan(line_data, '%f');
            SimOutput.Nose_Alpha = line_data_num{1}(1);
            
        case 'Nose_Delta'
            line_data_num = textscan(line_data, '%f');
            SimOutput.Nose_Delta = line_data_num{1}(1);
            
        otherwise
            display(['ERROR: In simOutput definition, unknown line identifier: ' line_id]);
         
    end
end  