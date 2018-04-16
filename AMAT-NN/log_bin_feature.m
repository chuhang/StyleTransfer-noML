function [ output ] = log_bin_feature( input )
[xx,yy]=meshgrid(1:size(input,3),1:size(input,2));
xx=xx-0.5;yy=yy-0.5;
cx=size(input,3)/2;cy=size(input,2)/2;
r=sqrt((xx-cx).^2+(yy-cy).^2);
a=atan2(yy-cy,xx-cx);
rbins=[0,4,8,16,32];
abins=[-pi,-pi/4*3,-pi/2,-pi/4,0,pi/4,pi/2,pi/4*3,pi];
mask=zeros((numel(rbins)-1)*(numel(abins)-1),size(input,2),size(input,3));
ct=1;
for ii=1:numel(rbins)-1
    for jj=1:numel(abins)-1
        id1=(r>=rbins(ii));
        id2=(r<rbins(ii+1));
        id3=(a>=abins(jj));
        id4=(a<abins(jj+1));
        id=id1&id2&id3&id4;
        mask(ct,:,:)=id;
        ct=ct+1;
    end
end

output=zeros(size(input,1),size(mask,1));
for ii=1:size(mask,1)
    nowmask=repmat(mask(ii,:,:),size(input,1),1,1);
    num=nowmask.*input;
    nums=sum(sum(num,3),2);
    output(:,ii)=nums;
end
end