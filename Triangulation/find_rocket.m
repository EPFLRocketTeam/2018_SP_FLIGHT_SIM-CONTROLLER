function rocket_location = find_rocket(people)

%Latitude (North south)
%Longitude (East West)

people.degrees = [340   210    80];
people.geopoints  = [geopoint(32.985593,-106.954124); geopoint(32.987885, -106.954984 ); geopoint(32.987005, -106.950297)];

people.p = [];

figure; hold on; grid on;
for i =1:length(people.geopoints)
    lat = [people.geopoints.Latitude(i); people.geopoints.Latitude(i) + 0.02 * sind(90+people.degrees(i))];
    lon = [people.geopoints.Longitude(i); people.geopoints.Longitude(i) + 0.02 * cosd(90+people.degrees(i))];
    p = polyfit(lon,lat,1);
    people.p(:,end+1) = p';
    plot(people.geopoints.Longitude(i), people.geopoints.Latitude(i), 'r*');
    line(lon, lat);
end

P = zeros(2*length(people.p),length(people.p));
p = P;
k=1;
for i = 1:length(people.p)
    P(k:k+1,:) = circshift(people.p,i-1,2);
    p(k:k+1,:) = people.p;
    k = k+2;
end

diff_polynom = abs(P-p);

%calculate intersection
people.intersection = [];
for i = 1:length(people.p)
    lon_intersect = fzero(@(x) polyval(diff_polynom(3:4,i), x),people.geopoints.Longitude(i));
    lat_intersect = polyval(people.p(1:2,i),lon_intersect);
    plot(lon_intersect, lat_intersect,'g+');
    intersection(end+1) = geopoint(lat_intersect,lon_intersect);
end

f_inter = @(point) sum((intersection.Latitude - point(2)).^2 + (intersection.Longitude - point(1)).^2);
rocket_location = fminsearch(f_inter, [people.geopoints.Latitude(1), people.geopoints.Longitude(1)]);
plot(rocket_location(1), rocket_location(2), 'b*');


end