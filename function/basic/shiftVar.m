function [Data,Stat,Live] = shiftVar(Data,Stat,Live)
    Data.Img = circshift(Data.Img,-1,3);
    Data.Bg = circshift(Data.Bg,-1,3);

    Stat.LatOffset = circshift(Stat.LatOffset,-1,1);
    Stat.LatCount = circshift(Stat.LatCount,-1,3);
end