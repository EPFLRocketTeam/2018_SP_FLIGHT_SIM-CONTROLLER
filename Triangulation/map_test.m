%Latitude (North south)
%Longitude (East West)

%Person 1
%32.985593, -106.954124

%Person 2
%32.987885, -106.954984

%Person 3
%32.987005, -106.950297

%Person 4
%32.980584, -106.947162

clear; close all;clc;

people.degrees = [340   210     80  37];
people.geopoints  = [geopoint(32.985593,-106.954124); geopoint(32.987885, -106.954984 ); geopoint(32.987005, -106.950297); geopoint(32.980584, -106.947162)];

rocket_location = locate_rocket(people)