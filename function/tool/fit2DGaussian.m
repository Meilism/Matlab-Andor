function [Fit,GOF,X,Y,Z] = fit2DGaussian(Signal,varargin)
    [XSize,YSize] = size(Signal);

    switch nargin
        case 3
            XRange = varargin{1};
            YRange = varargin{2};
            XSize = XRange(end)-XRange(1);
            YSize = YRange(end)-YRange(1);
        case 2
            XRange = varargin{1};
            YRange = varargin{1};
            XSize = XRange(end)-XRange(1);
            YSize = XSize;
        case 1
            XRange = 1:XSize;
            YRange = 1:YSize;
        otherwise
            error("Wrong number of inputs")
    end

    [Y,X,Z] = prepareSurfaceData(YRange,XRange,Signal);
    Max = max(Signal(:))+1;
    Min = min(Signal(:))-1;
    Diff = Max-Min;

    % Define 2D Gaussian fit type
    PeakFT = fittype('a*exp(-0.5*((u-u0)^2/b^2+(v-v0)^2/c^2))+d',...
                    'independent',{'u','v'},...
                    'coefficient',{'a','b','c','d','u0','v0'});
    PeakFO = fitoptions(PeakFT);

    PeakFO.Upper = [5*Diff,XSize,YSize,Max,XRange(end),YRange(end)];
    PeakFO.Lower = [0,0,0,Min,XRange(1),YRange(1)];
    PeakFO.StartPoint = [Diff,XSize/10,YSize/10,Min, ...
        (XRange(1)+XRange(end))/2,(YRange(1)+YRange(end))/2];
    PeakFO.Display = "off";

    [Fit,GOF] = fit([X,Y],Z,PeakFT,PeakFO);
end