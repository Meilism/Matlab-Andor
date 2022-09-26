function updateGraphics(Fig,Signal,Stat,Live,CurrentImg)
    figure(Fig)
    subplot(2,2,1)
    imagesc(Signal)
    daspect([1 1 1])
    colorbar
end
