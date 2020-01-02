function Earth(LatLim,LonLim,FigHndl)
if ~exist('FigHndl','var')
    FigHndl = figure;
    set(FigHndl,'units','normalized')
    set(FigHndl,'position',[0.13 0.05 0.72 0.85])
end
if ~exist('LatLim','var')
    LatLim = 32 + 10 * [-1, 1];
    LonLim = 35 + 10 * [-1, 1];
end
set(FigHndl,'color',[0.075 0.075 0.075]);
delete(get(FigHndl,'Children'))
set(pan(FigHndl),'ActionPostCallback',{})
set(zoom(FigHndl),'ActionPostCallback',{})
hold on

AxisHndl = subplot(1,1,1);
set(AxisHndl,'Visible','off')
axis equal
axis auto
view(90+32,34)
view(0,0)
[x_t,y_t,z_t] = sphere(24);
z_t = -z_t;
Globe = surf(x_t,y_t,z_t);
clear x_t y_t z_t
WorldMap = imread('+Maps/private/WorldMap_Small.jpg');
WorldMap = GetShadedEarthMap();
set(Globe,'FaceColor','texturemap','CData',WorldMap,'FaceAlpha',1,'EdgeColor','none')

Altitude = 21.0405;
ViewRadius = (abs(diff(LatLim))/2)/0.44;
CamAngle = atand(ViewRadius/(90*Altitude));

[x,y,z] = sph2cart((mean(LonLim))*pi/180, (mean(LatLim))*pi/180, 22.0405861362531);
set(AxisHndl, 'CameraPosition', [x,y,z])
set(AxisHndl, 'CameraViewAngle', CamAngle)

axis vis3d
set(AxisHndl,'Clipping','off')
TmpZoom = zoom();
try
    TmpZoom.setAxes3DPanAndZoomStyle(gca,'camera')
end
TmpPan = pan();
TmpPan.setAllowAxesPan(gca,false)
clear TmpZoom TmpPan
set(pan(FigHndl),'ActionPostCallback',{@UpdateGlobe, AxisHndl, FigHndl})
set(zoom(FigHndl),'ActionPostCallback',{@UpdateGlobe, AxisHndl, FigHndl})
end


function UpdateGlobe(~,~,AxisHndl,FigHndl)
%set(AxisHndl,'cameraTarget',[0 0 0]);
CamAngle = get(AxisHndl,'CameraViewAngle');
if CamAngle < 0.54
    CamPos = get(AxisHndl,'CameraPosition');
    [Azimuth,Elevation,Altitude] = cart2sph(CamPos(1),CamPos(2),CamPos(3));
    Azimuth = Azimuth*180/pi;
    Elevation = Elevation*180/pi;
    Altitude = norm(CamPos) - 1;
    ViewRadius = 90 * tand(CamAngle) * Altitude;
    LatLim = Elevation + 0.44*ViewRadius*[-1, 1];
    LonLim = Azimuth + 0.66*ViewRadius*[-1, 1];
    Maps.Viewer(LatLim,LonLim,FigHndl);
end
end