function [ branches_source_new,radius_source_new,deform_xy ] = axis_deform( match_xy,branches_source,branches_style )
w=20;
% compute shift offset
b1=(branches_source>0);
b2=(branches_style>0);
uimg=zeros(size(b1,1),size(b1,2));
vimg=zeros(size(b1,1),size(b1,2));
[b2dist,idx]=bwdist(b2);
[xx,yy]=meshgrid(1:size(b2,2),1:size(b2,1));
newxx=xx(idx);newyy=yy(idx);
uu=newxx-xx;vv=newyy-yy;
%figure;quiver(xx,yy,uu,vv);
for ii=1:size(match_xy,1)
    x1=match_xy(ii,1);y1=match_xy(ii,2);
    x2=match_xy(ii,3);y2=match_xy(ii,4);
    win1=b1(y1-w:y1+w,x1-w:x1+w);
    u2=uu(y2-w:y2+w,x2-w:x2+w);
    v2=vv(y2-w:y2+w,x2-w:x2+w);
    u1=zeros(w*2+1,w*2+1);
    v1=zeros(w*2+1,w*2+1);
    u1(win1>0)=u2(win1>0);
    v1(win1>0)=v2(win1>0);
    uimg(y1-w:y1+w,x1-w:x1+w)=u1;
    vimg(y1-w:y1+w,x1-w:x1+w)=v1;
end
figure;imshow(b1);hold on;quiver(xx,yy,uimg,vimg,'LineWidth',3);

% smooth along geodesic
cc=bwconncomp(b1);
uimg2=zeros(size(b1,1),size(b1,2));
vimg2=zeros(size(b1,1),size(b1,2));
for ii=1:length(cc.PixelIdxList)
    ids=cc.PixelIdxList{ii};
    disimg=bwdistgeodesic(b1,ids(1));
    disimg(isinf(disimg))=NaN;
    unow=zeros(size(b1,1),size(b1,2));
    vnow=zeros(size(b1,1),size(b1,2));
    unow(:)=NaN;vnow(:)=NaN;
    unow(~isnan(disimg))=uimg(~isnan(disimg));
    vnow(~isnan(disimg))=vimg(~isnan(disimg));
    unow2=smooth2a(unow,2);
    vnow2=smooth2a(vnow,2);
    unow2(isnan(disimg))=0;
    vnow2(isnan(disimg))=0;
    uimg2(~isnan(disimg))=unow2(~isnan(disimg));
    vimg2(~isnan(disimg))=vnow2(~isnan(disimg));
end
figure;imshow(b1);hold on;quiver(xx,yy,uimg2,vimg2,'LineWidth',3);

% get new axis and radius
xxs=round(xx(b1)+uimg2(b1));
yys=round(yy(b1)+vimg2(b1));
xxs(xxs<1)=1;xxs(xxs>size(b1,2))=size(b1,2);
yys(yys<1)=1;yys(yys>size(b1,1))=size(b1,1);
branches_source_new=zeros(size(b1,1),size(b1,2));
ind=sub2ind(size(b1),yys,xxs);
branches_source_new(ind)=1;
cd ../Preprocess_Branches
[ radius_source_new ] = get_radius( branches_source_new );
cd ../AMAT-NN
deform_xy=[xx(b1),yy(b1),xxs,yys];
end