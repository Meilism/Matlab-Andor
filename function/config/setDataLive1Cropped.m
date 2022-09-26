function setDataLive1Cropped(Exposure)

    % Set acquisition mode; 1 for Single Scan
    [ret] = SetAcquisitionMode(1);
    CheckWarning(ret);
    
    %   Set trigger mode; 0 for internal, 1 for external
    [ret] = SetTriggerMode(1);
    CheckWarning(ret);
    
    % Set Pre-Amp Gain, 0 (1x), 1 (2x), 2 (4x).
    [ret] = SetPreAmpGain(2);
    CheckWarning(ret);
    
    % Set Horizontal speed. (0,0) = 5 MHz, (0,1) = 3 MHz, (0,2) = 1 MHz, (0,3) = 50 kHz
    [ret] = SetHSSpeed(0,1);
    CheckWarning(ret);
    
    % Set Vertical Shift speed. 0 = 2.25 us, 1 = 4.25 us, 2 = 8.25 us, 3 = 16.25 us, 4 = 32.25 us, 5 = 64.25 us
    [ret] = SetVSSpeed(1);
    CheckWarning(ret);
    
    % Set Crop mode. 1 = ON/0 = OFF; Crop height; Crop width; Vbin; Hbin
    [ret] = SetIsolatedCropMode(1,100,100,1,1);
    CheckWarning(ret)
    
    % Get detector size (with croped mode ON this may change)
    [ret,YPixels,XPixels] = GetDetector();
    CheckWarning(ret);
    
    % Set the image size
    [ret] = SetImage(1,1,1,YPixels,1,XPixels);
    CheckWarning(ret);
    
    % Set exposure time
    [ret] = SetExposureTime(Exposure);
    CheckWarning(ret);
   
    % Get readout time
    [ret,ReadoutTime] = GetReadOutTime();
    CheckWarning(ret);

    fprintf('\n***Cropped frame mode***\n')
    fprintf('Exposure time is %4.2fs\n',Exposure)
    fprintf('Readout time for 1 image is %5.3fs\n\n',ReadoutTime)

end