function rocket_location = locate_rocket(people)
%locate_rocket plot the triangulation of the rocket
%
%EXAMPLE 1
%   people.degrees = [340   210     80];
%   people.geopoints  = [geopoint(32.985593,-106.954124); geopoint(32.987885, -106.954984 ); geopoint(32.987005, -106.950297)];
%   rocket_location = locate_rocket(people)

people.lines = [];
for i =1:length(people.geopoints)
    people.lines(i).Latitude = [];
    people.lines(i).Longitude = [];
    
    for m = 0:0.0001:0.02
        people.lines(i).Latitude(end+1) =  people.geopoints.Latitude(i) + m * sind(90+people.degrees(i));
        people.lines(i).Longitude(end+1) = people.geopoints.Longitude(i) + m * cosd(90+people.degrees(i));
    end
end


lat = [people.geopoints.Latitude];
lon = [people.geopoints.Longitude];
latlim = [min(lat) max(lat)];
lonlim = [min(lon) max(lon)];
[latlim, lonlim] = bufgeoquad(latlim, lonlim, .005, .005);

states = geoshape(shaperead('usastatehi', 'UseGeoCoords', true));

figure
ax = usamap(latlim, lonlim);
setm(ax, 'Grid', 'on')
geoshow(states)
geoshow(people.geopoints)
for i =1:length(people.geopoints)
    geoshow(people.lines(i).Latitude, people.lines(i).Longitude);
end
title('Closeup of Spaceport America')

%Plot arrow
northArrowLat =  latlim(2)-0.005;
northArrowLon =  lonlim(2)-0.005;
northarrow('Latitude', northArrowLat, 'Longitude', northArrowLon);

%Ruler
%Set with ginput
    [xLoc, yLoc] = ginput(1);
%or
%xLoc = -1.4113e+03;
%yLoc = 3.8676e+06;
scaleruler('Units', 'mi', 'RulerStyle', 'patches',  ...
    'XLoc', xLoc, 'YLoc', yLoc);

peeps.degrees = people.degrees;
peeps.Latitude = people.geopoints.Latitude;
peeps.Longitude = people.geopoints.Longitude;
peeps.p = zeros(2,length(peeps.Latitude));
peeps.intersection = zeros(1,length(peeps.p));
peeps.length = length(people.degrees);

rocket_location = find_rocket_c(peeps);
rocket_location = geopoint(rocket_location(2),rocket_location(1));
figure(1)
geoshow(rocket_location);
end

