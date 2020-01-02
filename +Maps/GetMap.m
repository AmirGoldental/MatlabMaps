function [Map, LatLim, LonLim, zoom, xlim, ylim] = GetMap(LatLim,LonLim,zoom)
if ~exist('zoom','var')
    zoom = 18;
    [xlim1,ylim1] = LatLon2xy(max(LatLim),min(LonLim),zoom);
    [xlim2,ylim2] = LatLon2xy(min(LatLim),max(LonLim),zoom);
    xlim = [floor(xlim1) ceil(xlim2)];
    ylim = [floor(ylim1) ceil(ylim2)];
    
    Span = min(diff(xlim),diff(ylim));
    zoom = floor(19 - log(Span)/log(2));
end
if zoom > 18
    zoom = 18;
end
[xlim1,ylim1] = LatLon2xy(max(LatLim),min(LonLim),zoom);
[xlim2,ylim2] = LatLon2xy(min(LatLim),max(LonLim),zoom);
xlim = [floor(xlim1) ceil(xlim2)];
ylim = [floor(ylim1) ceil(ylim2)];

Map = cell(ylim(2)-ylim(1)+1,xlim(2)-xlim(1)+1);
a = xlim(1);
b = ylim(1);
for i = 1:size(Map,1)
    for j = 1:size(Map,2)
        Map{i,j} = GetPatch(a+j-1, b+i-1, zoom);
    end
end
Map = cell2mat(Map);
xlim = xlim + [0 1];
ylim = ylim + [0 1];
[LatLim, LonLim] = xy2LatLon(xlim,ylim,zoom);
end

