function [lat, lon] = xy2LatLon(x, y, zoom)

n = 2^zoom;
lon = x / n * 360.0 - 180.0;
lat_rad = atan(sinh(pi * (1 - 2 * y / n)));
lat = lat_rad * 180.0 / pi;
% 
% % resize:
% x = x/(2^zoom);
% y = y/(2^zoom);
% 
% % correct y:
% y = (y+ 0.182468064912218)/0.423032756489355;
% 
% lon = x*360 - 180;
% lat = atan(sinh(pi*(1 - y)))*180/pi;
% 
% % 2nd y correction
% y = y*0.423032756489355 - 0.182468064912218;
% y = (y+ 0.182468064912218)/0.423032756489355;
% lat = atan(sinh(pi*(1 - y)))*180/pi;

end