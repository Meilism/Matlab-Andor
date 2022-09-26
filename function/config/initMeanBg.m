function MeanBg = initMeanBg(ModeDat,ModeCCD,Options)
    arguments
        ModeDat
        ModeCCD
        Options.XSize = 1024;
        Options.YSize = 1024;
    end
    
    switch ModeCCD
        case 'Upper CCD'
            switch ModeDat
                case 'Live 1'
                    load("saved\MeanBg1_20220621.mat","MeanBg")
                case 'Live 2'
                    load("saved\MeanBg2_20220224.mat","MeanBg")
                case 'Live 4'
                    load("saved\MeanBg4_20220127.mat","MeanBg")
                case 'Live 8'
                    load("saved\MeanBg8_20220623.mat","MeanBg")
                case 'Live 1 Cropped'
                    load("saved\MeanBg1_100x100_20211217.mat","MeanBg")
                case 'New'
                    warning('No background saved for current settings. Use zeros instead.')
                    MeanBg = zeros(Options.X,Options.Y);
            end

        case 'Lower CCD'
            switch ModeDat
                case 'Live 1'
                    load("saved\MeanBg1_20220621.mat","MeanBg")
                case 'Live 2'
                    load("saved\MeanBg2_20220224.mat","MeanBg")
                case 'Live 4'
                    load("saved\MeanBg4_20220127.mat","MeanBg")
                case 'Live 8'
                    load("saved\MeanBg8_20220623.mat","MeanBg")
                case 'Live 1 Cropped'
                    load("saved\MeanBg1_100x100_20211217.mat","MeanBg")
                case 'New'
                    warning('No background saved for current settings. Use zeros instead.')
                    MeanBg = zeros(Options.X,Options.Y);
            end

    end
    
end