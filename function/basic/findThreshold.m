function [Threshold,TwoFit] = findThreshold(LatCount,Options)
% ThresholdMode = 0: Single threshold
% ThresholdMode = [2,2]: Two threshold based on 2-sigma of fits
% MaxIgnore: Number of ignored data for binning
% - increase stability with occasional bad pixels
% - need to be cautious when filling fraction is low

    arguments
        LatCount
        Options.ThresholdMode (1,:) double = 0
        Options.MaxIgnore (1,1) int16 = 1
        Options.AbsMax (1,1) double = 5000
        Options.AbsMin (1,1) double = -300
        Options.ThresholdMin (1,1) double = 200
        Options.ThresholdMax (1,1) double = 600
        Options.IgnoreSubImg (1,1) logical = false
    end

    [NumSite,NumSubImg,NumSave] = size(LatCount);
    if Options.IgnoreSubImg
        LatCount = reshape(LatCount,NumSite*NumSubImg,1,NumSave);
        NumSite = NumSite*NumSubImg;
        NumSubImg = 1;
    end

    Threshold = nan(1,NumSubImg);
    TwoThreshold = nan(2,NumSubImg);
    TwoFit = cell(1,NumSubImg);

    % Number of bins for fitting two Gaussians
    NumBinEdge = round(max(min(50,NumSite*NumSave/20),200))+1;

    for i = 1:NumSubImg

        % Filtered out 0-counts (probably because of too large ROI)
        LatCountSub = reshape(LatCount(:,i,:),1,[]);
        AllCount = LatCountSub(LatCountSub~=0);
        
        % Create bins for histogram
        BinMin = max(floor(min(AllCount))-100,Options.AbsMin);
        BinMax = min(ceil(kthMax(AllCount,Options.MaxIgnore+1))+100,Options.AbsMax);
        Bin = linspace(BinMin,BinMax,NumBinEdge);
        BinWidth = Bin(2)-Bin(1);
        BinCenter = (Bin(1:end-1)+Bin(2:end))/2;

        HistCount = histcounts(AllCount,Bin);
        [ThresholdSingle,Fit0,Fit1] = fitTwoGaussian(BinCenter',HistCount');
        
        if ThresholdSingle<Options.ThresholdMax
            if ThresholdSingle>Options.ThresholdMin
                Threshold(i) = ThresholdSingle;
            else
                Threshold(i) = Options.ThresholdMin;
            end
        else
            Threshold(i) = Options.ThresholdMax;
        end

        N00 = integrate(Fit0,Threshold(i),Bin(1))/BinWidth;
        N01 = integrate(Fit0,Bin(end),Threshold(i))/BinWidth;
        N10 = integrate(Fit1,Threshold(i),Bin(1))/BinWidth;
        N11 = integrate(Fit1,Bin(end),Threshold(i))/BinWidth;

        TwoFit{i} = {Bin,HistCount,Fit0,Fit1,{N00,N01,N10,N11}};
        
        TwoThreshold(1,i) = min(Fit0.b1+Options.ThresholdMode(1)*Fit0.c1,Threshold(i));
        TwoThreshold(2,i) = max(Fit1.b1-Options.ThresholdMode(end)*Fit1.c1,Threshold(i));
    end
    if Options.ThresholdMode
        Threshold = TwoThreshold;
    end
end

function [ThresholdSingle,Fit0,Fit1] = fitTwoGaussian(X,Signal)

    % First fit a Gaussian to the highest peak (0-peak)
    [Max0,I0] = max(Signal);
    X0 = X(I0);
    Index0 = X<(X0+200);
    X0All = X(Index0);
    Signal0 = Signal(Index0);
    
    % Fit parameters. Nonlinear weight for rising edge
    FitOption0 = fitoptions('gauss1');
    FitOption0.Lower = [0.8*Max0,X0-100,10];
    FitOption0.Upper = [1.2*Max0,X0+100,500];
    FitOption0.StartPoint = [Max0,X0,100];
    FitOption0.Weight = exp(-(X0All-X0)/200);
    FitOption0.Display = 'off';
    
    Fit0 = fit(X0All,Signal0,'gauss1',FitOption0);

    % Fit a Gaussian to residual of 0-peak fit

    % Check the distance between 0-peak center and the max range
    Dist = (X(end)-Fit0.b1)/Fit0.c1;
    if Dist>10
        Index1 = X>(Fit0.b1+Dist/4*Fit0.c1);
    else
        Index1 = X>(Fit0.b1+1.5*Fit0.c1);
    end

    X1All = X(Index1);
    Signal1 = Signal(Index1)-Fit0(X1All);
    DistNorm = (X1All-Fit0.b1)/min(200,2*Fit0.c1);
    DistNorm(DistNorm>5) = 5;
        
    % Nonlinear weight for 1-peak
    if size(X1All,1)<5
        Fit1 = cfit(fittype('gauss1'),0,Fit0.b1+Fit0.c1,200);
        ThresholdSingle = Fit0.b1+Fit0.c1;
        warning('No signal for the 1-peak')
    else
        FitOption1 = fitoptions('gauss1');
        FitOption1.Lower = [0,Fit0.b1+100,Fit0.c1];
        FitOption1.Upper = [Max0,max(Fit0.b1+100,X1All(end)-Fit0.c1),...
            max(Fit0.c1,X1All(end)-(Fit0.b1+Fit0.c1))];
        FitOption1.StartPoint = [mean(Signal1),X1All(end)-100,200];
        FitOption1.Weight = exp(DistNorm-1);
        FitOption1.Display = 'off';
    
        Fit1 = fit(X1All,Signal1,'gauss1',FitOption1);

        FuncDif = @(x) (Fit0.a1-Fit1(Fit0.b1))*(x<Fit0.b1)+ ...
            (Fit0(x)-Fit1(x))*(x>Fit0.b1);
        FuncZero = fzero(FuncDif,(Fit0.b1+Fit1.b1)/2);

        if Dist>10
            ThresholdSingle = max([FuncZero,Fit0.b1+2*Fit0.c1, ...
                2/3*Fit0.b1+1/3*Fit1.b1,4/5*Fit0.b1+1/5*X(end)]);
        else
            ThresholdSingle = max([FuncZero,Fit0.b1+Fit0.c1]);
        end
    end
end