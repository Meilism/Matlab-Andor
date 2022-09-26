function [Data,DataInfo] = getDataInfo(Path,Filename,Options)
% DataInfo.XPixel, YPixel, NumSave, NumSubImg, XSize
%          MeanBg, MeanSig, Offset, 
%          Lat, MeanSum, FFTPeakFit
%          ModeDat, ModeLive
%
% If data does not contain background images: check ModeBkg
% - Default: Load default MeanBg for current NumSubImg
% - None/Current: Use zeros
% - Others: Load specific MeanBg file
    
    arguments
        Path
        Filename
        Options.ModeBkg = 'Default'
        Options.ModeCal = 'LatLowerCCD_20220805.mat';
    end
    
    FullPath = fullfile(Path,Filename);
    load(FullPath,"Data")
    fprintf("File loaded from date %s:\n %s\n",dir(FullPath).date,Filename)

    [DataInfo.XPixel,DataInfo.YPixel,DataInfo.NumSave] = size(Data.Img);
    DataInfo.NumSubImg = size(Data.SubImg,1);
    DataInfo.XSize = DataInfo.XPixel/DataInfo.NumSubImg;

    DataInfo.ModeLive = false;
    DataInfo.ModeCln = true;
    switch DataInfo.NumSubImg
        case 1
            if DataInfo.XPixel == 1024
                DataInfo.ModeDat = 'Live 1';
            elseif DataInfo.XPixel == 100
                DataInfo.ModeDat = 'Live 1 Cropped';
                DataInfo.ModeCln = false;
            else
                DataInfo.ModeDat = 'New';
                warning('No initialization stored for this setting. NumSubImg=1, XPixel=%d.',DataInfo.XPixel)
            end
        case 2
            DataInfo.ModeDat = 'Live 2';            
        case 4
            DataInfo.ModeDat = 'Live 4';            
        case 8
            DataInfo.ModeDat = 'Live 8';
        otherwise
            DataInfo.ModeDat = 'New';
            warning('No initialization stored for this setting. NumSubImg=%d.',DataInfo.NumSubImg)
    end

    if isempty(Data.Bg)
        % if Data does not contain background images
        switch Options.ModeBkg
            case {'Default','None','Current'}
                DataInfo.MeanBg = initMeanBg(DataInfo.ModeDat,XSize=DataInfo.XPixel,YSize=DataInfo.YPixel);
            otherwise
                load(fullfile("saved",Options.ModeBkg),"MeanBg")
                DataInfo.MeanBg = MeanBg;
        end
    else
        DataInfo.MeanBg = mean(Data.Bg,3);
    end
    DataInfo.MeanSig = mean(Data.Img,3)-DataInfo.MeanBg;
    DataInfo.Offset = cancelOffset(DataInfo.MeanSig,DataInfo.NumSubImg);

    % Pre-calibrate lattice vector with averaged image
    Lat = initCal(Options.ModeCal,ModeDat=DataInfo.ModeDat);
    switch Options.ModeCal
        case 'None'
            DataInfo.Lat = [];
        otherwise
            [DataInfo.Lat,DataInfo.FFTPeakFit,DataInfo.MeanSum] = ...
                getCalibration(DataInfo.MeanSig,Lat,'Full',DataInfo.NumSubImg);
            
            printCal(Lat,'Old lattice calibration:')
            printCal(DataInfo.Lat,'New lattice calibration:')
            
    end 

end