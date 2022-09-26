function [Lat,FFTPeakFit,SignalSum] = getCalibration(Signal,Lat,Mode,NumSubImg)
    arguments
        Signal (:,:) double
        Lat (1,1) struct
        Mode
        NumSubImg (1,1) double = 1
    end

    % Parameters
    LatChangeThreshold = 0.002;
    CalBkgMin = 20*sqrt(NumSubImg);
    CalBkgMax = 1000*NumSubImg;
    RFit = 7;
    

    XSize = floor(size(Signal,1)/NumSubImg);
    SignalSum = zeros(XSize,size(Signal,2));
    for i = 1:NumSubImg
        SignalSum = SignalSum+Signal((i-1)*XSize+(1:XSize),:);
    end
    
    % Calculate RFFT based on the ROI center position
    YSize = size(Signal,2);
    Corner = [1,1;1,YSize;XSize,1;XSize,YSize];
    RFFT = min(round(min(abs(Corner-Lat.R)))-10,[200 200]);
    if any(RFFT<0)
        error('Lattice center is too close to the image edge!')
    elseif all(RFFT<10)
        warning('Lattice center is too close to the image edge! RFFT = %d',min(RFFT))
    end

    [SignalBox,FFTX,FFTY] = prepareBox(SignalSum,round(Lat.R),RFFT);

    if strcmp(Mode,'Full')
        PeakPosInit = (2*RFFT+1).*Lat.K+RFFT+1;
        [PeakPos,FFTPeakFit] = signalFFT(SignalBox,PeakPosInit,RFit);
        
        Lat.K = (PeakPos-RFFT-1)./(2*RFFT+1);
        Lat.V = (inv(Lat.K(1:2,:)))';

        VDis = vecnorm(Lat.V'-Lat.V')./vecnorm(Lat.V');
        if any(VDis>LatChangeThreshold)
            warning('off','backtrace')
            warning('Lattice vector length changed significantly by %.2f%%.',...
                100*(max(VDis)))
            warning('on','backtrace')
            A = [confint(FFTPeakFit{1}{1},0.95);...
                confint(FFTPeakFit{2}{1},0.95);...
                confint(FFTPeakFit{3}{1},0.95)];
            A = (A([2,4,6],[5,6])-A([1,3,5],[5,6]));
            A = A./(vecnorm(Lat.K')'*(2*RFFT+1));
            if all(A<LatChangeThreshold)
                save(sprintf('NewLatCal_%s.mat',datestr(now,'yyyymmdd')),'Lat')
                fprintf('\nNew lattice calibration saved\n')
            end
        end
    else
        FFTPeakFit = cell(0);
    end
    
    % Extract lattice center coordinates from phase at FFT peak
    [Y,X] = meshgrid(FFTY,FFTX);
    Phase = zeros(1,2);
    SignalModified = SignalBox;
    SignalModified(SignalBox<CalBkgMin | SignalBox>CalBkgMax) = 0;
    for i = 1:2
        PhaseMask = exp(-1i*2*pi*(Lat.K(i,1)*X+Lat.K(i,2)*Y));
        Phase(i) = angle(sum(PhaseMask.*SignalModified,'all'));
    end
    Lat.R = (round(Lat.R*Lat.K(1:2,:)'+Phase/(2*pi))-1/(2*pi)*Phase)*Lat.V;

end

function [PeakPos,FFTPeakFit] = signalFFT(Data,PeakPosInit,RFit)
       
    PeakPos = PeakPosInit;
    FFTPeakFit = cell(1,3);
    
    FFT = abs(fftshift(fft2(Data)));
    for i = 1:3       
        XC = round(PeakPosInit(i,1));
        YC = round(PeakPosInit(i,2));
        PeakX = XC+(-RFit(1):RFit(1));
        PeakY = YC+(-RFit(end):RFit(end));
        PeakData = FFT(PeakX,PeakY);
        
        % Fitting FFT peaks
        [PeakFit,GOF,X,Y,Z] = fit2DGaussian(PeakData,-RFit(1):RFit(1),-RFit(end):RFit(end)); 
        FFTPeakFit{i} = {PeakFit,[X,Y],Z,GOF};

        if GOF.rsquare<0.5
            PeakPos = PeakPosInit;
            warning('off','backtrace')
            warning('FFT peak fit might be off (rsquare=%.2f), not updating.',...
                GOF.rsquare)
            warning('on','backtrace')
            return
        else
            PeakPos(i,:) = [PeakFit.u0,PeakFit.v0]+[XC,YC];
        end
    end

end