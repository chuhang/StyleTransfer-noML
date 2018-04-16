function [ img_deform ] = paint_patches_deform( img_source,radius_source,radius_source_new,deform_xy )
maxr1=max(radius_source(:));
maxr2=max(radius_source_new(:));
maxr=max([maxr1,maxr2]);
img1=padarray(img_source,[maxr maxr],'symmetric','both');
newimg=img1;newimg(:)=0;
for ii=1:size(deform_xy)
    cx1=deform_xy(ii,1)+maxr;cy1=deform_xy(ii,2)+maxr;cr1=radius_source(deform_xy(ii,2),deform_xy(ii,1));
    cx2=deform_xy(ii,3)+maxr;cy2=deform_xy(ii,4)+maxr;cr2=radius_source_new(deform_xy(ii,4),deform_xy(ii,3));
    xmin1=cx1-cr1;xmax1=cx1+cr1;
    ymin1=cy1-cr1;ymax1=cy1+cr1;
    xmin2=cx2-cr2;xmax2=cx2+cr2;
    ymin2=cy2-cr2;ymax2=cy2+cr2;
    if (xmax1==xmin1) || (ymax1==ymin1) || (xmax2==xmin2) || (ymax2==ymin2)
        continue;
    end
    patch1=img1(ymin1:ymax1,xmin1:xmax1,:);
    patch2=imresize(patch1,[ymax2-ymin2+1,xmax2-xmin2+1]);
    newimg(ymin2:ymax2,xmin2:xmax2,:)=patch2;
end
img_deform=newimg(maxr+1:end-maxr,maxr+1:end-maxr,:);
end