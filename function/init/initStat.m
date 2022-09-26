function Stat = initStat(DataInfo)
% Input: DataInfo.Lat, XSize, YPixel, NumSubImg, NumSave
% Output: Stat.XRange, YRange, Site, NumSite, Lat, LatOffset, LatCount

    % Check the index of lattice sites on the center line
    Corner = [1,DataInfo.YPixel/2-200;
        1,DataInfo.YPixel/2+200;
        min(DataInfo.XSize,400),DataInfo.YPixel/2-200;
        min(DataInfo.XSize,400),DataInfo.YPixel/2+200];

    % Chose lattice size to cover the center line
    Index = (Corner-DataInfo.Lat.R)/DataInfo.Lat.V;
    XMin = min(floor(Index(:,1)));
    XMax = max(ceil(Index(:,1)));
    YMin = min(floor(Index(:,2)));
    YMax = max(ceil(Index(:,2)));

    % Initialize Stat
    Stat.XRange = XMin:XMax;
    Stat.YRange = YMin:YMax;
    [Stat.Site,Stat.NumSite] = prepareSite(Stat.XRange,Stat.YRange);
    
    Stat.Lat = DataInfo.Lat;
    Stat.SigmaDeconv = 1.6;
    
    Stat.LatOffset = nan(DataInfo.NumSave,2);
    Stat.LatCount = nan(Stat.NumSite,DataInfo.NumSubImg,DataInfo.NumSave);
    
end