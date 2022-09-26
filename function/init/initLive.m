function Live = initLive(DataInfo,Stat,Center,Radius,Threshold)
% Input: DataInfo.NumSave, NumSubImg
%        Stat.XRange, YRange

    % Initialize Live
    CenterR = round((Center-DataInfo.Lat.R)/DataInfo.Lat.V);
    Live.Center = Center;
    Live.XRange = CenterR(1)+(-Radius(1):Radius(1));
    Live.YRange = CenterR(2)+(-Radius(2):Radius(2));
    Live.XRange = Live.XRange(Live.XRange<=Stat.XRange(end) & Live.XRange>=Stat.XRange(1));
    Live.YRange = Live.YRange(Live.YRange<=Stat.YRange(end) & Live.YRange>=Stat.YRange(1));
    [Live.SiteIndex,Live.NumSite] = selectSite(Stat.XRange,Stat.YRange, ...
        Live.XRange,Live.YRange);

    Live.Error = nan(DataInfo.NumSave,1);
    Live.Loss = nan(DataInfo.NumSave,1);
    Live.Retention = nan(DataInfo.NumSave,1);
    Live.Number = nan(DataInfo.NumSave,DataInfo.NumSubImg); % Atom number
    Live.PSF = nan(DataInfo.NumSave,3); % Number, XWid, YWid
    Live.Signal = nan(DataInfo.NumSave,1); % Peak-1 fit position
    
    Live.Lat = DataInfo.Lat;
    Live.Threshold =  Threshold(1:DataInfo.NumSubImg);
    Live.TwoFit = cell();

    Live.Occup = nan(Live.NumSite,DataInfo.NumSubImg);
    Live.New = nan(Live.NumSite,DataInfo.NumSubImg);
    Live.Dis = nan(Live.NumSite,DataInfo.NumSubImg);

end