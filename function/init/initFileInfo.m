function FileInfo = initFileInfo(Options)
    arguments
        Options.GetVarInfo = true
        Options.GetVarTable = true
        Options.GetScriptInfo = true
    end

    FileInfo = getFileInfo(acquireDataPath,'*.mat');
    if Options.GetVarInfo
        FileInfo.VarInfo = getVarInfo(FileInfo,Options.GetVarTable);
    end
    if Options.GetScriptInfo
        FileInfo.ScriptInfo = getFileInfo(matlab.project.rootProject().RootFolder,'*.m');
    end
end


function FileInfo = getFileInfo(DefaultPath,FileExtension)

    [File,Path] = uigetfile(FileExtension,'Select Data Files',DefaultPath,MultiSelect="on");
    if isnumeric(File) && File == 0
        FileInfo.File = {''};
        FileInfo.Path = DefaultPath;
        FileInfo.NumFile = 0;
        FileInfo.NumVar = 0;
        FileInfo.Var = {''};
    else
        if ischar(File)
            FileInfo.File = {File};
            FileInfo.Path = Path;
            FileInfo.NumFile = 1;
        else
            FileInfo.File = File;
            FileInfo.Path = Path;
            FileInfo.NumFile = numel(File);
        end
    end
end


function VarInfo = getVarInfo(FileInfo,GetVarTable)
    
    VarInfo.Var = inputdlg({'Enter the names of parameters (each occupies a new line):'},...
        'Parameters',[5,100],{''});
    if ~isempty(VarInfo.Var) && ~isempty(VarInfo.Var{1}) 
        VarInfo.Var = cellstr(VarInfo.Var{1});
        VarInfo.NumVar = numel(VarInfo.Var);
    else
        VarInfo.Var = {''};
        VarInfo.NumVar = 0;
    end
    
    VarInfo.VarTable = nan(FileInfo.NumFile,VarInfo.NumVar);
    if GetVarTable && VarInfo.NumVar>0
        for i = 1:FileInfo.NumFile
            Prompt = cell(1,VarInfo.NumVar);
            for j = 1:VarInfo.NumVar
                Prompt{j} = sprintf('Value of %s for file %s', ...
                    VarInfo.Var{j},FileInfo.File{i});
            end
            VarInfo.VarTable(i,:) = cellfun(@str2double,inputdlg(Prompt,'Parameters',[1,50]));
        end
    end

end