function IoU=IoUBB(bx1,by1,bw1,bh1,bx2,by2,bw2,bh2)
xmin1=bx1-bw1/2; xmax1=bx1+bw1/2;
xmin2=bx2-bw2/2; xmax2=bx2+bw2/2;
ymin1=by1-bh1/2; ymax1=by1+bh1/2;
ymin2=by2-bh2/2; ymax2=by2+bh2/2;

IoU=0;
if xmin1>xmax2 || xmin2>xmax1
    return;
end
if ymin1>ymax2 || ymin2>ymax1
    return;
end
S1=bw1*bh1;
S2=bw2*bh2;

% figure; hold on;
% plot([xmin1 xmax1 xmax1 xmin1 xmin1],[ymin1 ymin1 ymax1 ymax1 ymin1],'r');
% plot([xmin2 xmax2 xmax2 xmin2 xmin2],[ymin2 ymin2 ymax2 ymax2 ymin2],'b');

InnerPoits1=BB1insideBB2(xmin1,xmax1,ymin1,ymax1,xmin2,xmax2,ymin2,ymax2);

if sum(InnerPoits1)==0
    InnerPoits2=BB1insideBB2(xmin2,xmax2,ymin2,ymax2,xmin1,xmax1,ymin1,ymax1);
    if sum(InnerPoits2)==0
        if bw1>bw2
            SI=bw2*bh1;
        elseif bh1>bh2
            SI=bw1*bh2;
        end
    elseif sum(InnerPoits2)==2
        if InnerPoits2(1)~=0 && InnerPoits2(2)~=0
            SI=(xmax1-xmin2)*bh2;
        elseif InnerPoits2(2)~=0 && InnerPoits2(3)~=0
            SI=bw2*(ymax1-ymin2);
        elseif InnerPoits2(3)~=0 && InnerPoits2(4)~=0
            SI=(xmax2-xmin1)*bh2;
        elseif InnerPoits2(1)~=0 && InnerPoits2(4)~=0
            SI=bw2*(ymax2-ymin1);
        end
    elseif sum(InnerPoits2)==4
        SI=S2;
    end
elseif sum(InnerPoits1)==1
    if InnerPoits1(1)~=0
        SI=(xmax2-xmin1)*(ymax1-ymin2);
    elseif InnerPoits1(2)~=0
        SI=(xmax2-xmin1)*(ymax2-ymin1);
    elseif InnerPoits1(3)~=0
        SI=(xmax1-xmin2)*(ymax2-ymin1);
    elseif InnerPoits1(4)~=0
        SI=(xmax1-xmin2)*(ymax1-ymin2);
    end
elseif sum(InnerPoits1)==2
    if InnerPoits1(1)~=0 && InnerPoits1(2)~=0
        SI=(xmax2-xmin1)*bh1;
    elseif InnerPoits1(2)~=0 && InnerPoits1(3)~=0
        SI=bw1*(ymax2-ymin1);
    elseif InnerPoits1(3)~=0 && InnerPoits1(4)~=0
        SI=(xmax1-xmin2)*bh1;
    elseif InnerPoits1(1)~=0 && InnerPoits1(4)~=0
        SI=bw1*(ymax1-ymin2);
    end
elseif sum(InnerPoits1)==4
    SI=S1;
end

SU=S1+S2-SI;
IoU=SI/SU;

function InnerPoits=BB1insideBB2(xmin1,xmax1,ymin1,ymax1,xmin2,xmax2,ymin2,ymax2)
InnerPoits=zeros(4,1);
%bb1 top left corner inside bb2
if xmin2<xmin1 && xmin1<xmax2 && ymin2<ymax1 && ymax1<ymax2
    InnerPoits(1)=1;
end
%bb1 bottom left corner inside bb2
if xmin2<xmin1 && xmin1<xmax2 && ymin2<ymin1 && ymin1<ymax2
    InnerPoits(2)=1;
end
%bb1 bottom right corner inside bb2
if xmin2<xmax1 && xmax1<xmax2 && ymin2<ymin1 && ymin1<ymax2
    InnerPoits(3)=1;
end
%bb1 top right corner inside bb2
if xmin2<xmax1 && xmax1<xmax2 && ymin2<ymax1 && ymax1<ymax2
    InnerPoits(4)=1;
end