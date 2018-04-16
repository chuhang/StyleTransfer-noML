function [ patches ] = get_patches( img,branches,radius,patch_size )
branches_mask=branches>0;
[xx,yy]=meshgrid(1:size(img,2),1:size(img,1));
xy=[xx(branches_mask),yy(branches_mask),radius(branches_mask)];
if ndims(img)==3
    patch_color=zeros(size(xy,1),patch_size,patch_size,3);
else
    patch_color=zeros(size(xy,1),patch_size,patch_size);
end
maxr=max(xy(:,3));
img=padarray(img,[maxr maxr],'symmetric','both');
for ii=1:length(xy)
    cx=xy(ii,1)+maxr;cy=xy(ii,2)+maxr;cr=xy(ii,3);
    xmin=cx-cr;
    xmax=cx+cr;
    ymin=cy-cr;
    ymax=cy+cr;
    if ndims(img)==3
        patch=img(ymin:ymax,xmin:xmax,:);
        patch_color(ii,:,:,:)=imresize(patch,[patch_size,patch_size]);
    else
        patch=img(ymin:ymax,xmin:xmax);
        patch_color(ii,:,:)=imresize(patch,[patch_size,patch_size]);
    end
end
patches.patch_xy=xy;
patches.patch_color=patch_color;
end