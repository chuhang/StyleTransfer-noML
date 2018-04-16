function [ radius ] = get_radius( branches )
[d,idx]=bwdist(branches>0);
radius=zeros(size(branches,1),size(branches,2));
list=find(branches>0);
for ii=1:length(list)
    id=list(ii);
    mask=(idx==id);
    maskd=d(mask);
    if isempty(maskd)
        r=0;
    else
        r=ceil(max(maskd));
    end
    radius(id)=r;
end
end