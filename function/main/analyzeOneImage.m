function [Stat,Live] = analyzeOneImage(i,Stat,Live,Signal,DataInfo,Options)
    arguments
        i (1,1) double
        Stat (1,1) struct
        Live (1,1) struct
        Signal (:,:) double
        DataInfo (1,1) struct
        Options.AutoThreshold = false
        Options.ModeFig = true
    end

    % Get new offset calibration
    Live.Lat = getCalibration(Signal,Live.Lat,'Offset',DataInfo.NumSubImg);

    % Get new deconvolution
    Deconv = getDeconv(Live.Lat,Stat.Site,DataInfo.XSize,DataInfo.YPixel);

    AllCount = getCount(Signal,Deconv,DataInfo.NumSubImg);
    SubCount = AllCount(Live.SiteIndex,:);
    
    if Options.ModeFig
        % Get new threshold based on counts in a sub-region
        [Threshold,Live.TwoFit] = findThreshold(SubCount);
        if Options.AutoThreshold
            Live.Threshold = Threshold;
        end
    end

    % Get occup, error and loss
    
    
    % Update Stat and Live
    Stat.LatCount(:,:,i) = AllCount;
    Stat.LatOffset(i,:) = Live.Lat.R;
    
end