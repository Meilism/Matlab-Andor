clear
close all

Mode.Dat = 'Data';
% Mode.Dat = 'Live 1';
% Mode.Dat = 'Live 2';
% Mode.Dat = 'Live 4';
% Mode.Dat = 'Live 8';
% Mode.Dat = 'Live 1 Cropped';
% Mode.Dat = 'DMD Test';

% Imaging settings
Mode.Exp = 0.2; % Exposure time
Mode.NumSave = 40;

Mode.Bkg = 'Default';
% Mode.Bkg = 'Current';
% Mode.Bkg = 'None';

Mode.CCD = 'Lower CCD';
% Mode.CCD = 'Upper CCD';

Mode.Cal = 'LatUpperCCD_20210614.mat';
% Mode.Cal = 'LatLowerCCD_20220805.mat';
% Mode.Cal = 'None';

Mode.Fig = true;
% Mode.Fig = false;

Mode.Cln = true;
% Mode.Cln = false;

Mode.AutoThreshold = false;
% Mode.AutoThreshold = true;

% Analysis parameters
Mode.Center = [80,560];
Mode.Radius = [5,15];
Mode.Threshold = 250*[1,1,1,1,1,1,1,1];

%% Acquisition

[Data,Live,Stat,DataInfo,FileInfo] = runAnalysis(Mode);