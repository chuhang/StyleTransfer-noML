function visualize_match( img_source,branches_source,img_style,branches_style,match_xy )
branches_mask=branches_source>0;
r1=img_source(:,:,1)*0.7;
g1=img_source(:,:,2)*0.7;
b1=img_source(:,:,3)*0.7;
r1(branches_mask)=255;
img1=cat(3,r1,g1,b1);
branches_mask=branches_style>0;
r2=img_style(:,:,1)*0.7;
g2=img_style(:,:,2)*0.7;
b2=img_style(:,:,3)*0.7;
r2(branches_mask)=255;
img2=cat(3,r2,g2,b2);
img=cat(2,img1,img2);
imshow(img);
hold on;
for ii=1:size(match_xy,1)
    plot([match_xy(ii,1),match_xy(ii,3)+size(img_source,2)],[match_xy(ii,2),match_xy(ii,4)],'g');
end
hold off;
end