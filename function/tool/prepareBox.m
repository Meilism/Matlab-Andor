function [DataBox,DataX,DataY] = prepareBox(Data,RC,R)
    DataX = RC(1)+(-R(1):R(1));
    DataY = RC(2)+(-R(end):R(end));
    DataBox = Data(DataX,DataY);
end