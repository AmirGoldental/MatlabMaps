function WorldMap = GetShadedEarthMap()
WorldMap = double(imread('+Maps/private/WorldMap.jpg'))/256;
WorldMap_night = double(imread('+Maps/private/WorldMap_night.jpg'))/256;
Time = clock;
DaylightSave = 0;
UTCTime = Time;
UTCTime(4) = UTCTime(4) - DaylightSave - 2;
SunAzimuth = 2*pi*(UTCTime(4) + UTCTime(5)/60)/24;
SunElevation = (-23*pi/180)*cos(2*pi*(UTCTime(2) + UTCTime(3)/30 - 21/30)/12);
[A,B,C] =  sph2cart(SunAzimuth, SunElevation, 1);
x_f = @(Azimuth, Elevation) cos(Elevation)*cos(Azimuth);
y_f = @(Azimuth, Elevation) cos(Elevation)*sin(Azimuth);
z_f = @(Azimuth, Elevation) sin(Elevation);
data = [];
Elevations = [];
idx = 0;
Shade = ones(size(WorldMap,1),size(WorldMap,2));
WindowSize = 5;
for Azimuth = linspace(0,2*pi,size(Shade,2))
    idx = idx + 1;
    Elevations(end+1) = fzero(@(Elevation) [A,B,C]*[x_f(Azimuth, Elevation),y_f(Azimuth, Elevation),z_f(Azimuth, Elevation)]',0);
    data(end+1) = 0.5*(1-Elevations(end)/(pi/2))*size(Shade,1);
    if SunElevation<0
        Shade(1:round(data(end)),end-idx+1) = 0.15;        
    else
        Shade(round(data(end)):size(Shade,1),end-idx+1) = 0.15;
    end
end
PixPerHour = round(size(WorldMap,2)/24);
ShadeSigam = PixPerHour/3;
ShadeGauusian = (1/(ShadeSigam*sqrt(2*pi)))*exp(-0.5*(((-3*PixPerHour):(3*PixPerHour))/ShadeSigam).^2);
Shade = 0.5*conv2([Shade Shade Shade], ShadeGauusian, 'same') + 0.5*conv2([Shade Shade Shade], ShadeGauusian', 'same');
Shade = Shade(:,size(WorldMap,2)+1:2*size(WorldMap,2));
WorldMap = WorldMap .*repmat(Shade,1,1,3) + 0.7*WorldMap_night.*repmat((1-Shade),1,1,3);
end

