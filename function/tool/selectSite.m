function [SiteIndex,NewNumSite] = selectSite(OldX,OldY,NewX,NewY)
    if OldX(1)>NewX(1) || OldX(end)<NewX(end) || OldY(1)>NewY(1) || OldY(end)<NewY(end)
         error(['Wrong size conversion.\nOld size: X=%d:%d, Y=%d:%d\n' ...
             'New size: X=%d:%d, Y=%d:%d'],OldX(1),OldX(end),OldY(1),OldY(end), ...
             NewX(1),NewX(end),NewY(1),NewY(end))
    end
    SiteIndex = NewX'+(1-OldX(1))+(NewY-OldY(1))*length(OldX);
    SiteIndex = SiteIndex(:);
    NewNumSite = size(SiteIndex,1);
end