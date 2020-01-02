function [x,y] = LatLon2xy(lat_deg,lon_deg,zoom)

% convert the degrees to radians
rho = pi/180;
lon_rad = lon_deg * rho;
lat_rad = lat_deg * rho;

n = 2 ^ zoom;
x = n * ((lon_deg + 180) / 360);
y = n * (1 - (log(tan(lat_rad) + sec(lat_rad)) / pi)) / 2;

% 
% % 1st phase
% x = lon_deg;
% y = log(tan(lat_deg*pi/180) + sec(lat_deg*pi/180));
% 
% % 2nd phase
% x = (1 + (x/180))/2;
% y = (1-(y/pi));
% 
% % y correction
% %y = y*0.423032756489355 - 0.182468064912218;
% % resize
% x = (2^zoom)*x;
% y = (2^zoom)*y;

end

%y = ((2^zoom)*(1 - (y/pi))/2)
%y = y * 0.8453805033 - 23880.78377510569;
%y = y*1.0008102974649112 - 16.319890515402637;

%y = (2^zoom)*(1 - (y/pi) - 0.489255402800395)/2;