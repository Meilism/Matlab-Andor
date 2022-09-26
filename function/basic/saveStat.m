function saveStat(Path,File,Stat)
    StatPath = fullfile(Path,'Stat');
    if ~exist(StatPath,"dir")
        mkdir(StatPath)
    end
    Filename = fullfile(StatPath,sprintf('Stat_%s',File));
    save(Filename,"Stat")
end