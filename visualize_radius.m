function [ newimg ] = visualize_radius( img,branches,radius )
samples=100;
branches_mask=branches>0;
r=img(:,:,1)*0.7;
g=img(:,:,2)*0.7;
b=img(:,:,3)*0.7;
r(branches_mask)=255;
[xx,yy]=meshgrid(1:size(img,2),1:size(img,1));
xy=[xx(branches_mask),yy(branches_mask),radius(branches_mask)];
tmp=randperm(size(xy,1));
ids=tmp(1:samples);
xys=xy(ids,:);
for ii=1:samples
    cx=xys(ii,1);cy=xys(ii,2);cr=xys(ii,3);
    if (cr>=cx) || (cr>=cy) || ((cy+cr)>size(img,1)) || ((cx+cr)>size(img,2))
        continue;
    end
    g(cy,cx)=255;
    b((cy-cr):(cy+cr),cx-cr)=255;
    b((cy-cr):(cy+cr),cx+cr)=255;
    b(cy-cr,(cx-cr):(cx+cr))=255;
    b(cy+cr,(cx-cr):(cx+cr))=255;
    g((cy-cr):(cy+cr),cx-cr)=0;
    g((cy-cr):(cy+cr),cx+cr)=0;
    g(cy-cr,(cx-cr):(cx+cr))=0;
    g(cy+cr,(cx-cr):(cx+cr))=0;
    r((cy-cr):(cy+cr),cx-cr)=0;
    r((cy-cr):(cy+cr),cx+cr)=0;
    r(cy-cr,(cx-cr):(cx+cr))=0;
    r(cy+cr,(cx-cr):(cx+cr))=0;
end
newimg=img;
newimg(:,:,1)=r;
newimg(:,:,2)=g;
newimg(:,:,3)=b;
end