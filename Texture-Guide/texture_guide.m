function [ img_guided ] = texture_guide( img_deform,img_style,num_of_superpixel,sharpen_amount )
figure;
[l1,n1] = superpixels(img_deform,num_of_superpixel);
subplot(2,2,1);BW=boundarymask(l1);imshow(imoverlay(img_deform,BW,'cyan'),'InitialMagnification',67);
[l2,n2] = superpixels(img_style,num_of_superpixel);
subplot(2,2,2);BW=boundarymask(l2);imshow(imoverlay(img_style,BW,'cyan'),'InitialMagnification',67);
subplot(2,2,3);imshow(img_style);
img_style_sharp=imsharpen(img_style,'Amount',sharpen_amount);
subplot(2,2,4);imshow(img_style_sharp);

if n1>n2
    map=[1:n2,ceil(rand(1,n1-n2)*(n2-0.01)+0.01)];
else
    map=1:n1;
end
p=randperm(length(map));
map=map(p);

[xx,yy]=meshgrid(1:size(img_deform,2),1:size(img_deform,1));
img_guided=img_deform;
for ii=1:length(map)
    m1=(l1==ii);xs1=xx(m1);ys1=yy(m1);
    xmin1=min(xs1);xmax1=max(xs1);
    ymin1=min(ys1);ymax1=max(ys1);
    patch1=img_deform(ymin1:ymax1,xmin1:xmax1,:);
    m2=(l2==map(ii));xs2=xx(m2);ys2=yy(m2);
    xmin2=min(xs2);xmax2=max(xs2);
    ymin2=min(ys2);ymax2=max(ys2);
    patch2=img_style(ymin2:ymax2,xmin2:xmax2,:);
    patch2=imresize(patch2,[size(patch1,1),size(patch1,2)]);
    patch2=imsharpen(patch2,'Amount',sharpen_amount);
    patch1=patch1*0.65+patch2*0.35;
    patch1=imguidedfilter(patch1,patch2,'DegreeOfSmoothing',1e-10,'NeighborhoodSize',min([3,size(patch2,1),size(patch2,2)]));
    tmpimg=img_deform;
    tmpimg(ymin1:ymax1,xmin1:xmax1,:)=patch1;
    r=img_guided(:,:,1);g=img_guided(:,:,2);b=img_guided(:,:,3);
    rr=tmpimg(:,:,1);gg=tmpimg(:,:,2);bb=tmpimg(:,:,3);
    r(m1)=rr(m1);g(m1)=gg(m1);b(m1)=bb(m1);
    img_guided=cat(3,r,g,b);
end
figure;
imshow(img_guided);
end