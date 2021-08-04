function wind_ch(wind_v,altitudes,azimuth,variance,environment_name)
% %INPUT: array of altitudes
%         array of wind for altitudes
%         azimuth (single value)
%         variance of the wind value
%This method changes the environment definition file for wind value
%and azimuth angle value given as input
input=readlines(environment_name,"EmptyLineRule","skip");
replace1=['V_inf ' num2str(altitudes(1))];
replace2=['V_Azimuth ',num2str(azimuth)];
replace4=['Rail_Azimuth ', num2str(180+azimuth)]; 
replace3=['multilayerwind ',num2str(size(wind_v,2)),' '];
for i=1:size(wind_v,2)
replace3= [replace3 , num2str(altitudes(i)) ,' ' , num2str(wind_v(i)) ,...
    ' ', num2str(azimuth) , ' ', num2str(variance) ,' '];
end
replace3=[replace3, '// number of datapoint; altitude [m]; total wind speed [m/s]; azimuth; standart deviation; ... time number of point'];

input(8,1)=replace1;
input(9,1)= replace2;
input(15,1) = replace3;
input(14,1)=replace4;
fid= fopen(environment_name, 'w+');
fwrite(fid, strjoin(input, '\n'));
fclose(fid);


