function [ newb ] = kill_dots( branches,level )
b=branches>0;
cc=bwconncomp(b);
newb=zeros(size(b,1),size(b,2));
for ii=1:length(cc.PixelIdxList)
    if length(cc.PixelIdxList{ii})>level
        newb(cc.PixelIdxList{ii})=1;
    end
end
end