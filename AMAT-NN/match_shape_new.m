function [ match_xy ] = match_shape_new( x_source,x_style,num_samples )
% do not use margin points
r=size(x_source.patch_color,2)/2;
t=x_source.patch_xy;
id1=t(:,1)>(min(t(:,1))+r);
id2=t(:,1)<(max(t(:,1))-r);
id3=t(:,2)>(min(t(:,2))+r);
id4=t(:,2)<(max(t(:,2))-r);
id=id1&id2&id3&id4;
x_source.patch_xy=x_source.patch_xy(id,:);
x_source.patch_color=x_source.patch_color(id,:,:);
r=size(x_style.patch_color,2)/2;
t=x_style.patch_xy;
id1=t(:,1)>(min(t(:,1))+r);
id2=t(:,1)<(max(t(:,1))-r);
id3=t(:,2)>(min(t(:,2))+r);
id4=t(:,2)<(max(t(:,2))-r);
id=id1&id2&id3&id4;
x_style.patch_xy=x_style.patch_xy(id,:);
x_style.patch_color=x_style.patch_color(id,:,:);

idx1=1:(size(x_source.patch_color,1)-1)/(num_samples(1)-1):size(x_source.patch_color,1);
idx2=1:(size(x_style.patch_color,1)-1)/(num_samples(2)-1):size(x_style.patch_color,1);
idx1=round(idx1);idx2=round(idx2);
xy_source=x_source.patch_xy(idx1,:);
xy_style=x_style.patch_xy(idx2,:);
in_source=x_source.patch_color(idx1,:,:);
in_style=x_style.patch_color(idx2,:,:);

[ feature_source ] = log_bin_feature( in_source );
[ feature_style ] = log_bin_feature( in_style );

match_xy=zeros(size(in_source,1),4);
match_xy(:,1:2)=xy_source(:,1:2);
for ii=1:size(in_source,1)
    now_source=repmat(feature_source(ii,:),size(feature_style,1),1);
    now_dis=((now_source-feature_style).^2)./(now_source+feature_style);
    now_dis(isnan(now_dis))=0;
    now_score=sum(sum(now_dis,3),2);
    [sorted_score,idx]=sort(now_score,'ascend');
    match_xy(ii,3:4)=xy_style(idx(1),1:2);
end
end