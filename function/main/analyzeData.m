function [Data,Stat,Live] = analyzeData(Data,DataInfo)

    [Data,Stat,Live] = initAnalysis(Data,DataInfo);
   
    if DataInfo.ModeLive
        Max = Inf;
    else
        Max = DataInfo.NumSave;
    end

    for i = 1:Max
        fprintf('Image %d/%d\n',i,DataInfo.NumSave)

        if i>DataInfo.NumSave
            [Data,Stat,Live] = shiftVar(Data,Stat,Live);
            CurrentImg = DataInfo.NumSave;
        else
            CurrentImg = i;
        end
        [Signal,Data] = getSignal(Data,DataInfo,CurrentImg);
        
        if ~strcmp(Mode.Cal,'None')
            [Stat,Live] = analyzeOneImage(Stat,Live,CurrentImg,Signal,DataInfo);
        end
        
        if Mode.Fig
            updateGraphics(Signal,Stat,Live,CurrentImg)
        end
    end
    
end