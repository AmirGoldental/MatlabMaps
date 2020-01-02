function [Patch, xlim, ylim] = GetPatch(x,y,zoom)

y = floor(y);
x = floor(x);
z = zoom;
import matlab.net.*
import matlab.net.http.*
r = RequestMessage;
uri = URI(['https://api.maptiler.com/maps/hybrid/256/' ...
    num2str(z) '/' ...
    num2str(x) '/' num2str(y) '.jpg?key=6nsrijD9Py5TSsnaB3jR']);
resp = send(r,uri);
Patch = resp.Body.Data;
% DataBase = 'defined in ''\+Maps\MapsConfig.m''';
% Maps.MapsConfig
% if exist(fullfile(DataBase,num2str(z),num2str(x),[num2str(y) '.jpg']),'file')
%     % Fetch from database
%     Patch = imread(fullfile(DataBase,num2str(z),num2str(x),[num2str(y) '.jpg']));
% else
% %     try
% %         % Download
% %     catch
%         Patch = uint8(255*ones(256,256,3));
% %     end
% end
% if mean(Patch(:)) == 255
%     WorldMap = imread('+Maps/private/WorldMap.jpg');
%     [LatLim1,LonLim1] = xy2LatLon(x, y, zoom);
%     [LatLim2,LonLim2] = xy2LatLon(x+1, y+1, zoom);
%     LatLim = sort([LatLim1, LatLim2]);
%     LonLim = sort([LonLim1, LonLim2]);
%     Patch = WorldMap(round(1019/2 - LatLim(2)*1019/180):round(1019/2 - LatLim(1)*1019/180),round(2041/2 + LonLim(1)*2041/360):round(2041/2 + LonLim(2)*2041/360),:);
%     Patch = uint8(imresize(Patch,[256,256]));
%     imwrite(Patch,fullfile(DataBase,num2str(z),num2str(x),[num2str(y) '.jpg']))
% end
xlim = floor(x) + [0 1];
ylim = floor(y) + [0 1];
end