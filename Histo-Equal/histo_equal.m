function [ img_source_new ] = histo_equal( img_source,img_style,do_hsv )
hsv1=rgb2hsv(img_source);
h1=hsv1(:,:,1);s1=hsv1(:,:,2);v1=hsv1(:,:,3);
hsv2=rgb2hsv(img_style);
h2=hsv2(:,:,1);s2=hsv2(:,:,2);v2=hsv2(:,:,3);
if do_hsv(1)==1
    [ hc_min,hc_max,hnew ] = histo_match( h1,h2,500 );
    [ h1_new ] = transform( h1,hc_min,hc_max,hnew );
else
    h1_new=h1;
end
if do_hsv(2)==1
    [ hc_min,hc_max,hnew ] = histo_match( s1,s2,500 );
    [ s1_new ] = transform( s1,hc_min,hc_max,hnew );
else
    s1_new=s1;
end
if do_hsv(3)==1
    [ hc_min,hc_max,hnew ] = histo_match( v1,v2,500 );
    [ v1_new ] = transform( v1,hc_min,hc_max,hnew );
else
    v1_new=v1;
end
hsv1_new=cat(3,h1_new,s1_new,v1_new);
img_source_new=hsv2rgb(hsv1_new);
img_source_new=uint8(img_source_new*255);
% subplot(1,3,1);imshow(img_source);
% subplot(1,3,2);imshow(img_style);
% subplot(1,3,3);imshow(img_source_new);
end

function [ newval ] = transform( val,hc_min,hc_max,hnew )
newval=val;newval(:)=0;
for ii=1:length(hnew)
    mask=(val>=hc_min(ii))&(val<hc_max(ii));
    newval(mask)=hnew(ii);
end
end

function [ hc_min,hc_max,hnew ] = histo_match( val1,val2,resolution )
[h1,hc1]=hist(val1(:),resolution);
tmp=(hc1(2:end)+hc1(1:end-1))/2;
hc_min=[-Inf,tmp];
hc_max=[tmp,Inf];
[h2,hc2]=hist(val2(:),resolution);
[ acc1 ] = h_acc( h1 );
[ acc2 ] = h_acc( h2 );
[D,I] = pdist2(acc2',acc1','euclidean','Smallest',1);
hnew=hc2(I);
end

function [ acc ] = h_acc( h )
k=0;
acc=h;acc(:)=0;
for ii=1:length(acc)
    k=k+h(ii);
    acc(ii)=k;
end
end