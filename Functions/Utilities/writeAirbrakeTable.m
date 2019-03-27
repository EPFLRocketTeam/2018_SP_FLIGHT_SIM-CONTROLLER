function writeAirbrakeTable(path, length, N_AB, table)
% WRITEAIRBRAKETABLE writes .h file from control table
% INPUTS :
% - path    : path to control .csv table file
% - length  : table length
% - N_AB    : number of discrete airbrake angles in table
% - table   : table data

% get file path and create .h file
[filepath, name, ~] = fileparts(path);
fileId = fopen([filepath, name, '.h'], 'w');

% write header
fprintf(fileId, '#ifndef SHURIKEN_LOOKUP_TABLE \n');
fprintf(fileId, '#define SHURIKEN_LOOKUP_TABLE \n\n');
fprintf(fileId, ['#define TABLE_LENGTH ', num2str(length), '\n']);
fprintf(fileId, '#define TABLE_WIDTH 3 \n');
fprintf(fileId, ['#define TABLE_DIFF_SPEEDS_SAME_ALTITUDE ', num2str(N_AB), '\n']);
fprintf(fileId, 'static const float32_t SimData[TABLE_LENGTH][TABLE_WIDTH] = {\n');

% populate Array
for i = 1:length
   fprintf(fileId, [writeCArray(table(i,:)) ',\n']); 
end

% close file
fprintf(fileId, '};\n');
fprintf(fileId, '#endif');

fclose(fileId);

end