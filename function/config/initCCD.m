function initCCD(DataMode,CurrentCCD,Exposure)
    setCurrentCCD(CurrentCCD);
    switch DataMode
        case 'Live 1'
            setDataLive1(Exposure)
        case 'Live 2'
            setDataLive2(Exposure)
        case 'Live 4'
            setDataLive4(Exposure)
        case 'Live 8'
            setDataLive8(Exposure)
        case {'Live 1 Cropped','DMD Test'}
            setDataLive1Cropped(Exposure)
    end
end