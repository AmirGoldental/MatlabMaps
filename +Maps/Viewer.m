function Viewer(LatLim,LonLim,FigHndl)
if ~exist('FigHndl','var')
    FigHndl = figure;
    set(FigHndl,'units','normalized')
    set(FigHndl,'position',[0.13 0.05 0.72 0.85])
end
if ~exist('LatLim','var')
    LatLim = [31 33];
    LonLim = [33.5 36.5];
end
set(FigHndl,'color',[0.9 0.9 0.9]);
delete(get(FigHndl,'Children'))
set(pan(FigHndl),'ActionPostCallback',{})
set(zoom(FigHndl),'ActionPostCallback',{})
hold on
AxisHndl = subplot(1,1,1);
WorldMap = imread('+Maps/private/WorldMap.jpg');
WorldMap = GetShadedEarthMap();
imagesc([-180,180],[90 -90],WorldMap);
%axis equal
set(AxisHndl, 'Position', [0 0 1 1])
set(AxisHndl, 'ydir', 'normal')
set(AxisHndl, 'xlim', LonLim)
set(AxisHndl, 'ylim', LatLim)
HndlPatch = imagesc(LatLim(1) + [0 .001], LonLim(1) + [0 .001], 0);
UserData = get(HndlPatch,'UserData');
UserData.Z = 10;
set(HndlPatch,'UserData',UserData);
set(pan(FigHndl),'ActionPostCallback',{@Update, AxisHndl, HndlPatch})
set(zoom(FigHndl),'ActionPostCallback',{@Update, AxisHndl, HndlPatch})
set(datacursormode(FigHndl),'UpdateFcn',@DataCursorMode)
MenuHandle = uimenu(FigHndl,'label','Map Tools');
uimenu(MenuHandle,'label','Show gpxs','callback',@ShowGPXsCallback);
uimenu(MenuHandle,'label','Calibrate','callback',@CalibrationCallBack);

drawnow
end

function Update(~,~,AxisHndl,HndlPatch)
title('Updating')
%drawnow
UserData = get(HndlPatch,'UserData');
Z = UserData.Z;
Xlim = get(HndlPatch,'XData');
Ylim = get(HndlPatch,'YData');
MyAxis = axis(AxisHndl);
New_Xlim = MyAxis(1:2);
New_Ylim = MyAxis(3:4);
Span = min(diff(New_Xlim),diff(New_Ylim));
NewZ = floor(10-log(Span)/log(2))-3 ;
if (NewZ>Z || New_Xlim(1)<Xlim(1) || max(New_Ylim)>max(Ylim) || New_Xlim(2)>Xlim(2) || min(New_Ylim)<min(Ylim)) && NewZ>4
    set(HndlPatch,'AlphaData',1)
    [Map, New_LatLim, New_LonLim] = Maps.GetMap(New_Ylim,New_Xlim,NewZ);
    set(HndlPatch,'CData',Map)
    if NewZ > 10
        %set(HndlPatch,'AlphaData',AlphaLambda(Map))
    end
    set(HndlPatch,'XData',New_LonLim)
    set(HndlPatch,'YData',New_LatLim)
    UserData = get(HndlPatch,'UserData');
    UserData.Z = NewZ;
    set(HndlPatch,'UserData',UserData);
    UserData = get(AxisHndl,'UserData');
    UserData.Z = NewZ;
    set(AxisHndl,'UserData',UserData);
elseif 3<=NewZ &&  NewZ<=4
    set(HndlPatch,'AlphaData',0)
elseif NewZ<3
    Maps.Earth(MyAxis(3:4),MyAxis(1:2),get(AxisHndl,'parent'))
end
title(['Ready, zoom: '  num2str(NewZ)])
end

function ShowGPXsCallback(~,~)
[files,diractory] = uigetfile('*.gpx','SelectGPXs','MultiSelect', 'on');
for FileIdx = 1:length(files)
    gpx = gpxread(fullfile(diractory,files));
    hold on
    plot(gpx.Longitude,gpx.Latitude,'.-')
end
end

function CalibrationCallBack(~,~)
[Current_Lon,Current_Lat] = ginput(1);
if ~isempty(Current_Lon)
    answer = inputdlg('Lat');
    if ~isempty(answer)
        Calibrate(str2double(answer{1}),Current_Lon,Current_Lat,Current_Lon)
    end
end
end

function output_txt = DataCursorMode(~,event_obj)
pos = get(event_obj,'Position');
output_txt = {['Lat: ',num2str(pos(2),8)],...
    ['Lon: ',num2str(pos(1),8)]};

end

function AlphaVals = AlphaLambda(Image)
    WhiteAreas = conv2(1*(sum(Image,3)>725), ones(7)/(7^2), 'same') > 0.9;
    BlackAreas = conv2(1*(sum(Image,3)<30), ones(7)/(7^2), 'same') > 0.9;
    AlphaVals = conv2(WhiteAreas+BlackAreas,ones(15),'same')==0;
end