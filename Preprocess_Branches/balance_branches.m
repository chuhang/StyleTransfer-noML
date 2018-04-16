function [ branches_source_new,branches_style_new ] = balance_branches( branches_source,branches_style )
cc1=bwconncomp(branches_source>0);
cc2=bwconncomp(branches_style>0);
[ h1,hc,l1 ] = cc_hist( cc1 );
[ h2,~,l2 ] = cc_hist( cc2 );
h=min([h1;h2]);

keep1=ones(length(cc1.PixelIdxList),1);
keep2=ones(length(cc2.PixelIdxList),1);
for ii=1:(length(hc)-2)
    if h1(ii)>h(ii)
        ids=find((l1>=hc(ii))&(l1<hc(ii+1)));
        rp=randperm(numel(ids));
        ids=ids(rp);
        ids=ids(1:(h1(ii)-h(ii)));
        keep1(ids)=0;
    end
    if h2(ii)>h(ii)
        ids=find((l2>=hc(ii))&(l2<hc(ii+1)));
        rp=randperm(numel(ids));
        ids=ids(rp);
        ids=ids(1:(h2(ii)-h(ii)));
        keep2(ids)=0;
    end
end
[ branches_source_new ] = recon( branches_source,cc1,keep1 );
[ branches_style_new ] = recon( branches_style,cc2,keep2 );
end

function [ h,hc,l ] = cc_hist( cc )
l=zeros(length(cc.PixelIdxList),1);
for ii=1:length(cc.PixelIdxList)
    l(ii)=length(cc.PixelIdxList{ii});
end
[h,hc]=hist(l,0:2:30);
end

function [ bnew ] = recon( b,cc,keep )
bnew=zeros(size(b,1),size(b,2));
ct=1;
for ii=1:length(cc.PixelIdxList)
    if keep(ii)==1
        bnew(cc.PixelIdxList{ii})=ct;
        ct=ct+1;
    end
end
end