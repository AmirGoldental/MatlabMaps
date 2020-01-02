function Start(LatLim,LonLim)
if ~exist('LatLim','var')
    LatLim = [29.5 33.5];
    LonLim = [32 38];
end
FigHndl = figure;
set(FigHndl,'units','normalized')
set(FigHndl,'position',[0.13 0.05 0.72 0.85])
FirstViewerDraw = 1;
Maps.Earth([-85 -95], [-85 -95] ,FigHndl)
AxisHndl = gca;
set(AxisHndl,'CameraViewAngle',10)
for Step = [0 1.05./(exp(linspace(3,-3,40))+1) 1]
    CamAngle = (1-Step)*10 + Step*0.228;
    if CamAngle > 1.144
        LatLimTemp = (1-Step)*[-85 -95] + Step*LatLim;
        LonLimTemp = (1-Step)*[-85 -95] + Step*LonLim;
        [x,y,z] = sph2cart((mean(LonLimTemp))*pi/180, (mean(LatLimTemp))*pi/180, 22.0405861362531);
        set(AxisHndl, 'CameraPosition', [x,y,z])
        set(gca,'CameraViewAngle',CamAngle)
        drawnow
        pause(1/30)
    elseif FirstViewerDraw
        Maps.Viewer((1-Step)*[-236.916911819379 56.9169118193791] + Step*LatLim,...
            (1-Step)*[-310.375367729069 130.375367729069] + Step*LonLim,FigHndl)
        drawnow
        FirstViewerDraw = 0;
    else
        axis([ (1-Step)*[-310.375367729069 130.375367729069] + Step*LonLim,...
            (1-Step)*[-236.916911819379 56.9169118193791] + Step*LatLim])
        pause(1/30)
    end
end

end