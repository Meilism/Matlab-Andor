function [Data,Stat,Live] = initAnalysis(Data,DataInfo,Mode)
    
    Stat = struct();
    Live = struct();
    if ~strcmp(Mode.Cal,'None')
        Stat = initStat(DataInfo);
        if Mode.Fig
            Live = initLive(DataInfo,Stat,Mode.Center,Mode.Radius,Mode.Threshold);
        end
    end
    
end