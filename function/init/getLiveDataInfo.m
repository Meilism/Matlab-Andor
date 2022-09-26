function [Data,DataInfo] = getLiveDataInfo(ModeNumSave,ModeDat,ModeCal,ModeBkg,ModeCln)
% DataInfo.XPixel, YPixel, NumSave, NumSubImg, XSize
%          MeanBg, Lat
%          ModeDat, ModeLive
%
% If data does not contain background images: check ModeBkg
% - Default: Load default MeanBg for current NumSubImg
% - None/Current: Use zeros
% - Others: Load specific MeanBg file
    
    DataInfo.XPixel = 1024;
    DataInfo.YPixel = 1024;
    DataInfo.NumSubImg = 1;
    DataInfo.NumSave = ModeNumSave;
    
    DataInfo.ModeDat = ModeDat;
    DataInfo.ModeLive = true;
    DataInfo.ModeCln = ModeCln;
    
    switch ModeDat
        case 'Live 1'
            Data.SubImg = [1,1024];   
        case 'Live 2'
            DataInfo.NumSubImg = 2;
            Data.SubImg = [1,512;513,1024];
        case 'Live 4'
            DataInfo.NumSubImg = 4;
            Data.SubImg = [1,256;257,512;513,768;769,1024];
        case 'Live 8'
            DataInfo.NumSubImg = 8;
            Data.SubImg = [1,128;129,256;257,384;385,512;513,640;641,768;769,896;897,1024];
        case 'Live 1 Cropped'
            DataInfo.XPixel = 100;
            DataInfo.YPixel = 100;
            Data.SubImg = [1,100];
            DataInfo.ModeCln = false;
        otherwise
            error('Live mode not recongized')
    end
    DataInfo.XSize = DataInfo.XPixel/DataInfo.NumSubImg;
    DataInfo.Lat = initCal(ModeCal,ModeDat=ModeDat);

    % Initialize Data storage
    Data.Img = zeros(DataInfo.XPixel,DataInfo.YPixel,DataInfo.NumSave);
    Data.Bg = Data.Img;
    DataInfo.MeanBg = initMeanBg(ModeDat,X=DataInfo.XPixel,Y=DataInfo.YPixel);
    switch ModeBkg
        case {'Default','Current'}                             
        case 'None'
            Data.Bg = [];
        otherwise
            load(fullfile("saved",ModeBkg),"MeanBg")
            DataInfo.MeanBg = MeanBg;
    end

end