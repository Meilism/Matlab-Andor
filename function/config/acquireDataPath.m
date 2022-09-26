function [DataPath,Hostname] = acquireDataPath
    [~,Hostname] = system('hostname');
    Hostname = Hostname(1:end-1);
    switch Hostname
        case 'DESKTOP-UENQ0T8' % QMS Lab new PC
            DataPath = 'C:\Users\qmspc\Desktop\NewLabData\2022\';
        case {'Jiamei-Surfacepro8','Jiamei-ThinkCentre'} % Jiamei's PC
            DataPath = 'G:\My Drive\QMS lab\NewLab Data\2022\';
        otherwise
            warning('No default DataPath stored for this hostname: %s!',Hostname)
            try
                DataPath = matlabdrive;
            catch
                DataPath = '';
            end
    end
end