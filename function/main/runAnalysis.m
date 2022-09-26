function [Data,Live,Stat,DataInfo,FileInfo] = runAnalysis(Mode)
    
    % Initialize all outputs
    DataInfo = struct();
    FileInfo = struct();
    Live = struct();
    Stat = struct();
    Data = struct();

    switch Mode.Dat
        case {'Data','DMD Test'}
            
            if strcmp(Mode.Dat,'DMD Test')
                initCCD(Mode.Dat,Mode.CCD,Mode.Exp)
            end

            FileInfo = initFileInfo();
            
            for i = 1:FileInfo.NumFile

                fprintf('Start loading dataset %d\n',i)
                [Data,DataInfo] = getDataInfo(FileInfo.Path,FileInfo.File{i}, ...
                    ModeBkg=Mode.Bkg,ModeCal=Mode.Cal);
                
                % Run through each dataset
                [Data,Stat,Live] = analyzeData(Data,DataInfo);

                % Save Stat
                saveStat(FileInfo.Path,FileInfo.File{i},Stat)
                
            end

            % Run post-processing scripts
            post_process
            
        case {'Live 1','Live 2','Live 4','Live 8','Live 1 Cropped'}
            initCCD(Mode.Dat,Mode.CCD,Mode.Exp)

            [Data,DataInfo] = getLiveDataInfo(Mode.NumSave,Mode.Dat,Mode.Cal,...
                Mode.Bkg,Mode.CCD);
            [Data,Stat,Live] = analyzeData(Data,DataInfo);

    end
end