function [BgOffset,STD] = cancelOffset(Signal,NumSubImg,Options)
    arguments
        Signal
        NumSubImg (1,1)
        Options.YBgSize (1,1) double = 100
    end
   
    [XPixels,YPixels] = size(Signal);
    XSize = XPixels/NumSubImg;

    BgOffset = zeros(XPixels,YPixels);
    STD = zeros(NumSubImg,2);

    if YPixels<2*Options.YBgSize+200
        warning('Not enough space to cancel background offset!')
        return
    end

    YRange1 = 1:Options.YBgSize;
    YRange2 = YPixels+(-Options.YBgSize:0);
    for i = 1:NumSubImg
        XRange = (i-1)*XSize+(1:XSize);
        BgBox1 = Signal(XRange,YRange1);
        BgBox2 = Signal(XRange,YRange2);
        [XOut1,YOut1,ZOut1] = prepareSurfaceData(XRange,YRange1',BgBox1');
        [XOut2,YOut2,ZOut2] = prepareSurfaceData(XRange,YRange2',BgBox2');
        XOut = [XOut1;XOut2];
        YOut = [YOut1;YOut2];
        ZOut = [ZOut1;ZOut2];
        XYFit = fit([XOut,YOut],ZOut,'poly11');
        
        % Background offset canceling with fitted plane
        BgOffset(XRange,:) = XYFit.p00+XYFit.p10*XRange'+XYFit.p01*(1:YPixels);

        BgBoxNew1 = BgBox1-BgOffset(XRange,YRange1);
        BgBoxNew2 = BgBox2-BgOffset(XRange,YRange2);
        STD(i,:) = [std(BgBoxNew1(:)),std(BgBoxNew2(:))];

    end
    
    warning('off','backtrace')
    if any(abs(BgOffset)>2)
        warning('Noticable background offset after subtraction: %4.2f.\nCheck imaging conditions.',max(BgOffset(:)))
    end
    if any(STD>6)
        warning('Noticable background noise after cancellation: %4.2f',max(STD(:)))
    end
    warning('on','backtrace')
end