function printCal(Lat,Text)
    arguments
        Lat (1,1) struct
        Text = 'Lattice calibration:'
    end

    V1 = Lat.V(1,:);
    V2 = Lat.V(2,:);
    V3 = V1+V2;
    
    fprintf(Text)
    fprintf('\n\tV1=(%4.2f, %4.2f),\t|V1|=%4.2fpx\n',V1(1),V1(2),norm(V1))
    fprintf('\tV2=(%4.2f, %4.2f),\t|V2|=%4.2fpx\n',V2(1),V2(2),norm(V2))
    fprintf('\tV3=(%4.2f, %4.2f),\t|V3|=%4.2fpx\n',V3(1),V3(2),norm(V3))
    fprintf('\tAngle<V1,V2>=%4.2f deg\n',acosd(V1*V2'/(norm(V1)*norm(V2))))
    fprintf('\tAngle<V1,V3>=%4.2f deg\n\n',acosd(V1*V3'/(norm(V1)*norm(V3))))
    
end