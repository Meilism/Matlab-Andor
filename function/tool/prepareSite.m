function [Site,NumSite] = prepareSite(XRange,YRange)
    [SiteY,SiteX] = meshgrid(YRange,XRange);
    Site = [SiteX(:),SiteY(:)];
    NumSite = size(Site,1);
end