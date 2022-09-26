function showFFTPeakFit(FFTPeakFit)
    figure(Units="normalized",OuterPosition=[0.1 0.2 0.8 0.5],Name="FFT peaks and fits")
    for i = 1:3
        subplot(1,3,i)
        plot(FFTPeakFit{i}{1},FFTPeakFit{i}{2},FFTPeakFit{i}{3})
        fprintf("FFT Peak %d\n",i)
        disp(FFTPeakFit{i}{4})
        title(sprintf('Peak %d\nAmp %.4g\nWidth (%.4g,%.4g)', ...
            i,FFTPeakFit{i}{1}.a,FFTPeakFit{i}{1}.b,FFTPeakFit{i}{1}.c))
    end
end