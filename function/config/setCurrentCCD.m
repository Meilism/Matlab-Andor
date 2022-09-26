function setCurrentCCD(CurrentCCD)
% CurrentCCD = 'Upper CCD'
%            = 'Lower CCD'

    [ret, NumCameras] = GetAvailableCameras();
    CheckWarning(ret)
    for i = 1:NumCameras
            [ret,CameraHandle] = GetCameraHandle(i-1);
            CheckWarning(ret)
        
            [ret] = SetCurrentCamera(CameraHandle);
            CheckWarning(ret)
    
            [ret, Number] = GetCameraSerialNumber();
            CheckWarning(ret)
    
            if strcmp(CurrentCCD,'Upper CCD') && Number == 19330
                disp('Current CCD is Upper CCD')
                break
            elseif strcmp(CurrentCCD,'Lower CCD') && Number == 19331
                disp('Current CCD is Lower CCD')
                break
            end
    end
    disp('CCD not found')
end