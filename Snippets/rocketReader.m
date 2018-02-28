function Rocket = rocketReader(rocketFilePath)

rfid = fopen(rocketFilePath);

while ~feof(rfid)

    line_content = fgetl(rfid);
    [line_id, line_data] = strtok(line_content);
    line_data_num = textscan(line_data, '%f');
    switch line_id
        
        case "stages"
            Rocket.stages = line_data_num{1}(1);
            
        case "diameters"
            Rocket.diameters = line_data_num{1}';
            
        case "stage_z"
            Rocket.stage_z = line_data_num{1}';
            
        case "fin_n"
            Rocket.fin_n = line_data_num{1}(1);
            
        case "fin_xt"
            Rocket.fin_xt = line_data_num{1}(1);
            
        case "fin_s"
            Rocket.fin_s = line_data_num{1}(1);
            
        case "fin_cr"
            Rocket.fin_cr = line_data_num{1}(1);    
            
        case "fin_ct"
            Rocket.fin_ct = line_data_num{1}(1);
            
        case "fin_t"
            Rocket.fin_t = line_data_num{1}(1);
            
        case "fin_xs"
            Rocket.fin_xs = line_data_num{1}(1);
            
        case "lug_n"
            Rocket.lug_n = line_data_num{1}(1);    
            
        case "lug_S"
            Rocket.lug_S = line_data_num{1}(1);
            
        case "rocket_m"
            Rocket.rocket_m = line_data_num{1}(1);
            
        case "rocket_I"
            Rocket.rocket_I = line_data_num{1}(1);
            
        otherwise
            display(["ERROR: In rocket definition, unknown line identifier: " line_id]);
         
    end

end    
    
if checkStages(Rocket)
    error("ERROR: Reading rocket definition file.")
end

function flag = checkStages(Rocket)
    flag = 0;
    if ~(length(Rocket.diameters) == Rocket.stages && length(Rocket.stage_z) == Rocket.stages)
        flag = 1;
        display("ERROR: In rocket defintion, rocket diameters and/or stage_z are not equal in length to the announced stages.")
    elseif ~(Rocket.diameters(1) == 0 && Rocket.stage_z(1) == 0)
        flag = 1;
        display("ERROR: In rocket defintion, rocket must start with a point (diameters(1) = 0, stage_z(1) = 0)");
    end
    
end

end

