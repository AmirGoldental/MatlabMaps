function RotatingGlobe()
FigHndl = figure;
set(FigHndl, 'Units' ,'normalized')
set(FigHndl, 'Position', [0.3 0.1 0.61 0.85])
set(FigHndl, 'ToolBar', 'none')
set(FigHndl, 'MenuBar', 'none')
Lon = 0;
LastUpdateTimeSec = inf;
while ishandle(FigHndl)
    tic
    LastUpdateTimeSec = LastUpdateTimeSec + 1/30;
    if LastUpdateTimeSec > 60
        Maps.Earth(Lon + [-70 70], [-35 35], FigHndl)
        AxisHndl = gca;
        set(AxisHndl,'Visible', 'off')
        LastUpdateTimeSec = 0;
    end
    Lon = Lon - 1;
    [x,y,z] = sph2cart((Lon)*pi/180, 0, 22.0405861362531);
    set(AxisHndl, 'CameraPosition', [x,y,z])
    drawnow
    pause(1/30-toc)
end
end