function [X,Y,ImageDir,ImageScaleK,ImageList]=GetImageParam(DataFolder)
FileList=dir(DataFolder);
PHI_la=zeros(length(FileList),1);
Lambda_lo=zeros(length(FileList),1);
ImageList=cell(length(FileList),1);
ImageDir=zeros(length(FileList),1);
ImageScaleK=zeros(length(FileList),1);
RowList=zeros(10,2); RowN=0;

if contains(DataFolder,'SjT_SB_2023_06_27') && contains(DataFolder,'GoPro')
    GoPro2m=1380;%[pix/meter]
    RobotRowWidth=3;%m
    LeftBottomPla=60.402065; LeftBottomPlo=22.663145;
    laOffs=LeftBottomPla; loOffs=LeftBottomPlo;
    [LeftBottomPX,LeftBottomPY]=LaLo2CoordOffs(LeftBottomPla,LeftBottomPlo,laOffs,loOffs);
    [x,y]=LaLo2CoordOffs(60.402027,22.665692,laOffs,loOffs);
    LowLineDir=atan((LeftBottomPY-y)/(LeftBottomPX-x));
    [x1,y1]=LaLo2CoordOffs(60.402080,22.662714,laOffs,loOffs);
    [x2,y2]=LaLo2CoordOffs(60.403227,22.662923,laOffs,loOffs);
    LeftLineDir=atan((y1-y2)/(x1-x2));
    [x1,y1]=LaLo2CoordOffs(60.402203,22.665757,laOffs,loOffs);
    [x2,y2]=LaLo2CoordOffs(60.403125,22.663386,laOffs,loOffs);
    RightLineDir=atan((y1-y2)/(x1-x2))+pi;
    LowLineLength=140;%m
    
    N=0;
    for f=3:length(FileList)
        ImageFileName=FileList(f).name;
        if contains(ImageFileName,'.jpg') || contains(ImageFileName,'.JPG')
            disp(ImageFileName);
            handsInfo=imfinfo([DataFolder ImageFileName]);
            lo=handsInfo.GPSInfo.GPSLongitude;
            la=handsInfo.GPSInfo.GPSLatitude;
            N=N+1;
            PHI_la(N)=(la(1)+la(2)/60+la(3)/60/60);
            Lambda_lo(N)=(lo(1)+lo(2)/60+lo(3)/60/60);
            ImageList{N}=[DataFolder ImageFileName];
    
            if contains(ImageFileName,'_b')
                RowN=RowN+1;
                RowList(RowN,1)=N;
            elseif contains(ImageFileName,'_e')
                RowList(RowN,2)=N;
    %             N=N+1;
            end
    %         if (RowList(RowN,1)==0 && RowList(RowN,2)==0) || (RowList(RowN,1)~=0 && RowList(RowN,2)~=0)
    %             N=N-1;
    %         end
        end
    end
    PHI_la=PHI_la(1:N); Lambda_lo=Lambda_lo(1:N);
    RowN=RowN-1;
    
    [X,Y]=LaLo2CoordOffs(PHI_la,Lambda_lo,laOffs,loOffs);
    
    id=-pi/2;
    for i=1:RowN
        rn=RowList(i,2)-RowList(i,1)+1;
        lbpx=0+(i-1)*RobotRowWidth*cos(LeftLineDir);
        lbpy=0+(i-1)*RobotRowWidth*sin(LeftLineDir);
        x1=(i-1)*RobotRowWidth/tan(RightLineDir);
        y1=(i-1)*RobotRowWidth;
        rbpx=0+LowLineLength*cos(LowLineDir)+x1*cos(LowLineDir)-y1*sin(LowLineDir);
        rbpy=0+LowLineLength*sin(LowLineDir)+x1*sin(LowLineDir)+y1*cos(LowLineDir);
        X(RowList(i,1):RowList(i,2))=linspace(lbpx,rbpx,rn);
        Y(RowList(i,1):RowList(i,2))=linspace(lbpy,rbpy,rn);
        ImageDir(RowList(i,1):RowList(i,2))=id+LowLineDir; id=id+pi;
        ImageScaleK(RowList(i,1):RowList(i,2))=GoPro2m;
    end
elseif contains(DataFolder,'Drone')
    LeftBottomPla=60.401937; LeftBottomPlo=22.662751;
    laOffs=LeftBottomPla; loOffs=LeftBottomPlo;
    Drone4m=570;%[pix/meter]626

    N=0;
    for f=3:length(FileList)
        ImageFileName=FileList(f).name;
        if contains(ImageFileName,'.jpg') || contains(ImageFileName,'.JPG')
    %         m=['P1' ImageFileName(6:end)];
    %         movefile([DataFolder '103MEDIA\' ImageFileName],[DataFolder m]);
            disp(ImageFileName);
            handsInfo=imfinfo([DataFolder ImageFileName]);
            lo=handsInfo.GPSInfo.GPSLongitude;
            la=handsInfo.GPSInfo.GPSLatitude;
            N=N+1;
            PHI_la(N)=(la(1)+la(2)/60+la(3)/60/60);
            Lambda_lo(N)=(lo(1)+lo(2)/60+lo(3)/60/60);
            ImageList{N}=[DataFolder ImageFileName];
    
%             if contains(ImageFileName,'_b')
%                 RowN=RowN+1;
%                 RowList(RowN,1)=N;
%             elseif contains(ImageFileName,'_e')
%                 RowList(RowN,2)=N;
%             end
        end
    end
    PHI_la=PHI_la(1:N); Lambda_lo=Lambda_lo(1:N);
    [X,Y]=LaLo2CoordOffs(PHI_la,Lambda_lo,laOffs,loOffs);

%     q=true(length(X),1);
%     h=min(10,length(X)); dd=sqrt((X(1)-X(h))^2+(X(1)-X(h))^2)/h/5;
%     for i=1:length(X)-1
%         for j=i+1:length(X)
%             if sqrt((X(i)-X(j))^2+(Y(i)-Y(j))^2)<dd
%                 q(j)=false;
%             end
%         end
%     end
%     X=X(q);
%     Y=Y(q);

    [RowList,RowN]=FindLinesInScanningTrajectory(X,Y);

    for i=1:RowN
        [b,k]=LinRegression(X(RowList(i,1):RowList(i,2)),Y(RowList(i,1):RowList(i,2)),0,0);
        if abs(atan(k))<45/180*pi
            if X(RowList(i,1))>X(RowList(i,2))
                ImageDir(RowList(i,1):RowList(i,2))=atan(k)+pi/2;
            else
                ImageDir(RowList(i,1):RowList(i,2))=atan(k)-pi/2;
            end
        end
        ImageScaleK(RowList(i,1):RowList(i,2))=Drone4m;
    end
end

figure;
cla; hold on; axis equal; xlabel('E-W [m]'); ylabel('N-S [m]');
plot(X,Y,'*');
for i=1:RowN
    plot([X(RowList(i,1)) X(RowList(i,2))],[Y(RowList(i,1)) Y(RowList(i,2))])
end