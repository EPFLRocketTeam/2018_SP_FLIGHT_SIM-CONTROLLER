function Environnement = environnementReader(environnementFilePath,varargin)

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
            
        case 'dTdh'
            line_data_num = textscan(line_data, '%f');
            Environnement.dTdh = line_data_num{1}(1);  
          
            %multilayerwind, number of layer , windlayer1, ..., windlayer n
            % windlayer: mesured_height, V_inf, V_Azimuth, Turb_I 
        case 'multilayerwind'
            line_data_string = textscan(line_data,'%s');
            Environnement.numberLayer = str2double(line_data_string{1}{1});
            i = 1: Environnement.numberLayer;
            layerheight = i;
            layerspeed = i;
            layerAzi = i;
            layerTurb = i;
            for i = 1: Environnement.numberLayer
                layerheight(i)= str2double(line_data_string{1}{2+4*(i-1)});
                layerspeed(i)= str2double(line_data_string{1}{3+4*(i-1)});
                layerAzi(i)= str2double(line_data_string{1}{4*i});
                layerTurb(i)= str2double(line_data_string{1}{1+4*i});
            end
            if nargin < 2
                for i = 1: Environnement.numberLayer
                    turb_std = layerspeed(i) * layerTurb(i);
                    layerAzi(i) = normrnd(layerAzi(i),2);
                    layerspeed(i) = normrnd(layerspeed(i), turb_std);
                end
            end
            axis = 0:10: 4000;
            Environnement.Vspeed = interp1(layerheight,layerspeed,axis, 'pchip', 'extrap');
            Environnement.Vazy = interp1(layerheight,layerAzi,axis, 'pchip', 'extrap');
            Environnement.Vturb= interp1(layerheight,layerTurb,axis, 'pchip', 'extrap');
            Environnement.Vdirx= cosd(Environnement.Vazy);
            Environnement.Vdiry= sind(Environnement.Vazy);
            Environnement.Vdirz= 0*cosd(Environnement.Vazy);
            
            
            
         %   hold on
          %  plot(axis,Environnement.Vspeed,'r')
           % plot(axis,Environnement.Vazy,'b')
            %plot(axis,Environnement.Vturb,'k')
            %xlim([0 4000])
            %ylim([-1 100])
            %hold off;
            Environnement.isWindLayered = 1;
            
        case 'map'
            line_data_string = textscan(line_data,'%s');
            map_name = line_data_string{1}{1};
            [Environnement.map_x, Environnement.map_y, Environnement.map_z]=xyz2grid(map_name);
            Environnement.map_x=Environnement.map_x-2648540;
            Environnement.map_y= Environnement.map_y-1195050;
            Environnement.map_z= Environnement.map_z-Environnement.Start_Latitude;
            
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

