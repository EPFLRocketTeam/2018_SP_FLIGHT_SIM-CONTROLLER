function [t,T,prop_Mass,total_Mass] = motorReader(motorFilePath)
%   motorReader extract the motor data

% -------------------------------------------------------------------------
% 1. Read Motor
% -------------------------------------------------------------------------

rfid = fopen(motorFilePath);

% 1.1 Read Informations
line_content = fgetl(rfid); % Read one line
Info = textscan(line_content,'%s %f32 %f32 %f32 %f32 %f32 %s');

% 1.2 Read Thrust Informations
t = []; T = []; % Initialization

while ~feof(rfid)   % Test end of file
    
    line_content = fgetl(rfid); % Read one line
    Tmp = textscan(line_content,'%f32 %f32');
    t = [t Tmp{1}];
    T = [T Tmp{2}];
end
end

