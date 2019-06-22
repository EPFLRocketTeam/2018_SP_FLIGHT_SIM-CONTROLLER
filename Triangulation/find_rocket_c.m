function rocket_location = find_rocket_c(people)

%Latitude (North south)
%Longitude (East West)
%Up to 4 positionings
max_length = 4;

people.degrees = people.degrees + 8.33;

figure; hold on; grid on;
for i =1:people.length
    lat = [people.Latitude(i); people.Latitude(i) + 0.02 * sind(90+people.degrees(i))];
    lon = [people.Longitude(i); people.Longitude(i) + 0.02 * cosd(90+people.degrees(i))];
    p = polyfit(lon,lat,1);
    people.p(:,i) = p';
    plot(people.Longitude(i), people.Latitude(i), 'r*');
    line(lon, lat);
end

%alternative to circshift
P = zeros(2,max_length);
for i = 1:people.length
    P(:,i) = people.p(:, mod(i, people.length)+1);
end

diff_polynom = abs(P-people.p);

intersection.Latitude = zeros(1,max_length);
intersection.Longitude = zeros(1,max_length);
%calculate intersection
for i = 1:people.length
    lon_intersect = fzero(@(x) polyval(diff_polynom(:,i), x),people.Longitude(i));
    lat_intersect = polyval(people.p(1:2,i),lon_intersect);
    plot(lon_intersect, lat_intersect,'g+');
    intersection.Latitude(i) = lat_intersect;
    intersection.Longitude(i) = lon_intersect;
end

f_inter = @(point) sum((intersection.Latitude - point(2)).^2 + (intersection.Longitude - point(1)).^2);
rocket_location = fminsearch(f_inter, [people.Latitude(1), people.Longitude(1)]);
plot(rocket_location(1), rocket_location(2), 'b*');

end