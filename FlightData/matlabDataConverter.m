close all; 

%% ------------------------------------------------------------------------
% File creation
% ------------------------------------------------------------------------

name = 'SimDataPayerne.h'

delete(name);

% open file
headerId = fopen(name, 'w');

%% ------------------------------------------------------------------------
% Table definiton
% ------------------------------------------------------------------------
T = [T1;T2]
Altitude = [X1(:,1); X(:,3)];
Pressure = [];
for i = 1:length(T)
    [~,~,]
Pressure = []
end
data_table = [];

%% ------------------------------------------------------------------------
% Header writing
% ------------------------------------------------------------------------

% write header data
fprintf(headerId, '#ifndef INCLUDE_SIM_DATA_ \n');
fprintf(headerId, '#define INCLUDE_SIM_DATA_ \n\n');
fprintf(headerId, ['#define SIM_TAB_HEIGHT ' num2str(height(dataArray)) '\n']);
fprintf(headerId, ['#define SIM_TAB_WIDTH ' num2str(4) '\n']);
fprintf(headerId, '#define SIM_TIMESTAMP 0\n');
fprintf(headerId, '#define SIM_ALTITUDE 1\n');
fprintf(headerId, '#define SIM_PRESSURE 2\n');
fprintf(headerId, '#define SIM_ACCELX 3\n');
fprintf(headerId, ['static const float32_t SimData[' num2str(height(dataArray)) '][' num2str(4) '] = {\n']);

% 