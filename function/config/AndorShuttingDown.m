function AndorShuttingDown

    [ret, NumCameras] = GetAvailableCameras();
    CheckWarning(ret)

    for i = 1:NumCameras
    
        % Set current camera
        [ret,CameraHandle] = GetCameraHandle(i-1);
        CheckWarning(ret)
    
        [ret] = SetCurrentCamera(CameraHandle);
        CheckWarning(ret)
    
    
        % Abort data acquisition
        [ret,Status] = GetStatus();
        CheckWarning(ret)
        
        if Status == 20072
            [ret] = AbortAcquisition;
            CheckWarning(ret)
        end
    
        % Close shutter
        [ret] = SetShutter(1, 2, 1, 1);
        CheckWarning(ret);
    
        % Temperature is maintained on shutting down.
        % 0 - Returns to ambient temperature on ShutDown
        % 1 - Temperature is maintained on ShutDown
        [ret] = SetCoolerMode(1);
        CheckWarning(ret)
    
    
        [ret, Number] = GetCameraSerialNumber();
        CheckWarning(ret)
        fprintf('\nSerial Number: %d\n',Number)
    
        % Shut down current camera
        [ret] = AndorShutDown;
        CheckWarning(ret);
    
        fprintf(['Camera %d is shut down\n' ...
            'Temperature is maintained on shutting down.\n'],i)
    
    end
end