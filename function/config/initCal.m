function Lat = initCal(ModeCal,Options)
    arguments
        ModeCal
        Options.R (1,1) double = [200,512]
        Options.ModeDat = 'New'
    end
    
    switch ModeCal
        case 'Upper CCD'
            load("saved/LatUpperCCD_20210614.mat","Lat")
        case 'Lower CCD'
            load("saved/LatLowerCCD_20220805.mat","Lat")
        case 'None'
            Lat = [];
        otherwise
            load(fullfile("saved",ModeCal),"Lat")
    end
    
    switch Options.ModeDat
        case 'New'
            Lat.R = Options.R;
        case 'Live 1'
            Lat.R = [200,512];
        case 'Live 2'
            Lat.R = [150,512];
        case 'Live 4'
            Lat.R = [128,512];
        case 'Live 8'
            Lat.R = [64,512];
        case 'Live 1 Cropped'
            Lat.R = [50,50];
        otherwise
            error('Wrong ModeDat input. No default lattice center saved.')
    end
        
end