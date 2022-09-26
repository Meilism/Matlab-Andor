function Count = getCount(Signal,Deconv,NumSubImg)
    XPixels = size(Signal,1);
    XSize = XPixels/NumSubImg;
    NumSite = size(Deconv,1);
    Count = zeros(NumSite,NumSubImg);

    for i = 1:NumSite
        List = Deconv{i,1}+XPixels*(Deconv{i,2}-1);
        if size(List,1)>0
            for j = 1:NumSubImg
                Count(i,j) = Deconv{i,3}'*Signal(List+(j-1)*XSize);
            end
        end
    end
end