function value=find_altitude(X,Y,Environnement)
Z=0*X;
for i=1:length(X)
[map_pos_row, map_pos_col]=find(abs(Environnement.map_x-X(i))< 2 & abs(Environnement.map_y-Y(i))< 2);

if(isempty(map_pos_row))
    map_z=Environnement.Start_Altitude;
else 
    map_z=Environnement.map_z(map_pos_row(1),map_pos_col(1));
end
Z(i)=map_z-Environnement.Start_Altitude;
end
value=Z;
end