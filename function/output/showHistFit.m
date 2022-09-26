function varargout = showHistFit(ThresholdSingle,TwoFitSingle)

    Bin = TwoFitSingle{1};
    HistCount = TwoFitSingle{2};
    Fit0 = TwoFitSingle{3};
    Fit1 = TwoFitSingle{4};
    BinRange = Bin(1):Bin(end);
    BinCenter = (Bin+circshift(Bin,-1))/2;
    BinCenter = BinCenter(1:end-1);

    Index0 = BinCenter<ThresholdSingle(1);
    Index1 = BinCenter>ThresholdSingle(end);
    IndexNull = BinCenter>=ThresholdSingle(1) & BinCenter<=ThresholdSingle(end);
    Count0 = zeros(1,length(BinCenter));
    Count1 = zeros(1,length(BinCenter));
    CountNull = zeros(1,length(BinCenter));
    Count0(Index0) = HistCount(Index0);
    Count1(Index1) = HistCount(Index1);
    CountNull(IndexNull) = HistCount(IndexNull);
    
    box on
    hold on
    histogram('BinCounts',Count0,'BinEdges',Bin,'FaceColor',[0 0.4470 0.7410],'EdgeColor','none');
    histogram('BinCounts',Count1,'BinEdges',Bin,'FaceColor',[0.8500 0.3250 0.0980],'EdgeColor','none');
    histogram('BinCounts',CountNull,'BinEdges',Bin,'FaceColor',[0.4660 0.6740 0.1880],'EdgeColor','none')
    plot(BinRange,Fit0(BinRange),'Color','b','LineWidth',2)
    plot(BinRange,Fit1(BinRange),'Color','r','LineWidth',2)
    CurrentAxes = gca();
    CurrentAxes.YLimMode = 'manual';
    CurrentAxes.LineWidth = 1;
    line([ThresholdSingle(1),ThresholdSingle(1)],CurrentAxes.YLim,'LineWidth',2,...
        'LineStyle','--','Color','k')
    line([ThresholdSingle(end),ThresholdSingle(end)],CurrentAxes.YLim,'LineWidth',2,...
        'LineStyle','--','Color','k')
    hold off
    
    if nargout == 1
        varargout{1} = CurrentAxes;
    end
    
end