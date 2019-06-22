%Latitude (North south)
%Longitude (East West)

peeps.geopoints  = [geopoint(32.985593,-106.954124); geopoint(32.987885, -106.954984 ); geopoint(32.987005, -106.950297); geopoint(32.980584, -106.947162)];

people.length = 4;
people.degrees = [340   210     80  37];
people.Latitude = peeps.geopoints.Latitude;
people.Longitude = peeps.geopoints.Longitude;
people.p = zeros(2,length(people.Latitude));
people.intersection = zeros(1,length(people.p));

find_rocket_c(people);