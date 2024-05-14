function FieldImageData=GetImageParam(DataFolder,Draw)
GoPro2m=1380;%[pix/meter]
Drone4m=570;%[pix/meter]626
% ImageX,ImageY,ImageDir,ImageScaleK,ImageList,FieldBoundary

if isfile([DataFolder 'ImageParam.csv'])
    T=readtable([DataFolder 'ImageParam.csv']);
    ImageList=table2array(T(:,1));
    ImageX=table2array(T(:,2));
    ImageY=table2array(T(:,3));
    ImageDir=table2array(T(:,4));
    ImageScaleK=table2array(T(:,5));
    ImageRow=table2array(T(:,6));

    RowN=max(ImageRow);
    if Draw
        figure;
        cla; hold on; axis equal; xlabel('E-W [m]'); ylabel('N-S [m]');
        plot(ImageX,ImageY,'*');
        for i=1:RowN
            a=find(ImageRow==i,1,'first');
            c=find(ImageRow==i,1,'last');
            [b,k]=LinRegression(ImageX(a:c),ImageY(a:c),0,0);
            plot([ImageX(a) ImageX(c)],[ImageX(a) ImageX(c)]*k+b);
        end
    end
else
    
    FileList=dir(DataFolder);
    PHI_la=zeros(length(FileList),1);
    Lambda_lo=zeros(length(FileList),1);
    ImageList=cell(length(FileList),1);
    % ImageDir=zeros(length(FileList),1);
    % ImageScaleK=zeros(length(FileList),1);
    % RowList=zeros(10,2); RowN=0;
    % ImageRow=zeros(length(FileList),1);
    
%     if contains(DataFolder,'SjT_SB_2023_06_27') && contains(DataFolder,'GoPro')
%         GoPro2m=1380;%[pix/meter]
%         RobotRowWidth=3;%m
%         LeftBottomPla=60.402065; LeftBottomPlo=22.663145;
% %         laOffs=LeftBottomPla; loOffs=LeftBottomPlo;
%         laOffs=60.401901; loOffs=22.662655;
%         [LeftBottomPX,LeftBottomPY]=LaLo2CoordOffs(LeftBottomPla,LeftBottomPlo,laOffs,loOffs);
%         [x,y]=LaLo2CoordOffs(60.402027,22.665692,laOffs,loOffs);
%         LowLineDir=atan((LeftBottomPY-y)/(LeftBottomPX-x));
%         [x1,y1]=LaLo2CoordOffs(60.402080,22.662714,laOffs,loOffs);
%         [x2,y2]=LaLo2CoordOffs(60.403227,22.662923,laOffs,loOffs);
%         LeftLineDir=atan((y1-y2)/(x1-x2));
%         [x1,y1]=LaLo2CoordOffs(60.402203,22.665757,laOffs,loOffs);
%         [x2,y2]=LaLo2CoordOffs(60.403125,22.663386,laOffs,loOffs);
%         RightLineDir=atan((y1-y2)/(x1-x2))+pi;
%         LowLineLength=140;%m
%         
%         N=0;
%         RowList=zeros(10,2);
%         RowN=0;
%         for f=3:length(FileList)
%             ImageFileName=FileList(f).name;
%             if contains(ImageFileName,'.jpg') || contains(ImageFileName,'.JPG')
%                 disp(ImageFileName);
%                 handsInfo=imfinfo([DataFolder ImageFileName]);
%                 lo=handsInfo.GPSInfo.GPSLongitude;
%                 la=handsInfo.GPSInfo.GPSLatitude;
%                 N=N+1;
%                 PHI_la(N)=(la(1)+la(2)/60+la(3)/60/60);
%                 Lambda_lo(N)=(lo(1)+lo(2)/60+lo(3)/60/60);
%                 ImageList{N}=ImageFileName;
%         
%                 if contains(ImageFileName,'_b')
%                     RowN=RowN+1;
%                     RowList(RowN,1)=N;
%                 elseif contains(ImageFileName,'_e')
%                     RowList(RowN,2)=N;
%         %             N=N+1;
%                 end
%         %         if (RowList(RowN,1)==0 && RowList(RowN,2)==0) || (RowList(RowN,1)~=0 && RowList(RowN,2)~=0)
%         %             N=N-1;
%         %         end
%             end
%         end
%         PHI_la=PHI_la(1:N); Lambda_lo=Lambda_lo(1:N);
%         ImageList=ImageList(1:N);
%         RowN=RowN-1;
%         
%         [ImageX,ImageY]=LaLo2CoordOffs(PHI_la,Lambda_lo,laOffs,loOffs);
%         ImageDir=zeros(length(ImageX),1);
%         ImageScaleK=zeros(length(ImageX),1);
%         ImageRow=zeros(length(ImageX),1);
%     
%         id=-pi/2;
%         for i=1:RowN
%             rn=RowList(i,2)-RowList(i,1)+1;
%             lbpx=0+(i-1)*RobotRowWidth*cos(LeftLineDir);
%             lbpy=0+(i-1)*RobotRowWidth*sin(LeftLineDir);
%             x1=(i-1)*RobotRowWidth/tan(RightLineDir);
%             y1=(i-1)*RobotRowWidth;
%             rbpx=0+LowLineLength*cos(LowLineDir)+x1*cos(LowLineDir)-y1*sin(LowLineDir);
%             rbpy=0+LowLineLength*sin(LowLineDir)+x1*sin(LowLineDir)+y1*cos(LowLineDir);
%             ImageX(RowList(i,1):RowList(i,2))=linspace(lbpx,rbpx,rn);
%             ImageY(RowList(i,1):RowList(i,2))=linspace(lbpy,rbpy,rn);
%             ImageDir(RowList(i,1):RowList(i,2))=id+LowLineDir; id=id+pi;
%             ImageScaleK(RowList(i,1):RowList(i,2))=GoPro2m;
%             ImageRow(RowList(i,1):RowList(i,2))=i;
%         end
%     
%     
%     elseif contains(DataFolder,'Drone')
%         Drone4m=570;%[pix/meter]626
    
        N=0;
        for f=3:length(FileList)
            ImageFileName=FileList(f).name;
            if contains(ImageFileName,'.jpg') || contains(ImageFileName,'.JPG')
                disp(ImageFileName);
                N=N+1;
    
                handsInfo=imfinfo([DataFolder ImageFileName]);
                lo=handsInfo.GPSInfo.GPSLongitude;
                la=handsInfo.GPSInfo.GPSLatitude;
                PHI_la(N)=(la(1)+la(2)/60+la(3)/60/60);
                Lambda_lo(N)=(lo(1)+lo(2)/60+lo(3)/60/60);
                ImageList{N}=ImageFileName;
        
            end
        end
        PHI_la=PHI_la(1:N); Lambda_lo=Lambda_lo(1:N);
        ImageList=ImageList(1:N);
    %     LeftBottomPla=60.401937; LeftBottomPlo=22.662751;
    %     laOffs=LeftBottomPla; loOffs=LeftBottomPlo;
    %     laOffs=min(PHI_la); loOffs=min(Lambda_lo);
        laOffs=60.401901; loOffs=22.662655;
        [ImageX,ImageY]=LaLo2CoordOffs(PHI_la,Lambda_lo,laOffs,loOffs);
    
        ImageDir=zeros(length(ImageX),1);
        ImageScaleK=zeros(length(ImageX),1);
        ImageRow=zeros(length(ImageX),1);

        if contains(DataFolder,'Drone')
            [RowList,RowN]=FindLinesInScanningTrajectory(ImageX,ImageY);
            CameraPixOnMeter=Drone4m;
        elseif contains(DataFolder,'GoPro')
            CameraPixOnMeter=GoPro2m;
            RowN=0;
            RowList=zeros(10,2);
            for Image_i=1:N%ImageList{N}=ImageFileName;
                if contains(ImageList{Image_i},'_b')
                    RowN=RowN+1;
                    RowList(RowN,1)=Image_i;
                elseif contains(ImageList{Image_i},'_e')
                    RowList(RowN,2)=Image_i;
                end
%                 ImageRow(Image_i)=RowN;
%                 ImageScaleK(Image_i)=GoPro2m;
            end            
        end

        K=zeros(RowN,1);
        B=zeros(RowN,1);
        for i=1:RowN
            [B(i),K(i)]=LinRegression(ImageX(RowList(i,1):RowList(i,2)),ImageY(RowList(i,1):RowList(i,2)),0,0);
            if abs(atan(K(i)))<45/180*pi
                if ImageX(RowList(i,1))>ImageX(RowList(i,2))
                    ImageDir(RowList(i,1):RowList(i,2))=atan(K(i))+pi/2;
                else
                    ImageDir(RowList(i,1):RowList(i,2))=atan(K(i))-pi/2;
                end
            end
            ImageScaleK(RowList(i,1):RowList(i,2))=CameraPixOnMeter;
            ImageRow(RowList(i,1):RowList(i,2))=i;
        end
            %     end    
    T=table(ImageList,ImageX,ImageY,ImageDir,ImageScaleK,ImageRow);
    writetable(T,[DataFolder 'ImageParam.csv'],'Delimiter',';');
end

A=imread([DataFolder ImageList{1}]);
[h,w,a]=size(A);
i=1; while i<length(ImageX) && ImageScaleK(i)==0, i=i+1; end
ImageRm=sqrt(w*w+h*h)/2/ImageScaleK(i);%meters
MapXmin=min(ImageX)-ImageRm; MapXmax=max(ImageX)+ImageRm;
MapYmin=min(ImageY)-ImageRm; MapYmax=max(ImageY)+ImageRm;
% MapDxm=MapXmax-MapXmin; MapDym=MapYmax-MapYmin;
% FieldBoundary.ImageRm=ImageRm;

FieldImageData.ImageX=ImageX;
FieldImageData.ImageY=ImageY;
FieldImageData.ImageDir=ImageDir;
FieldImageData.ImageScaleK=ImageScaleK;
FieldImageData.ImageList=ImageList;
FieldImageData.ImageRow=ImageRow;
FieldImageData.FieldBoundary.MapXmin=MapXmin;
FieldImageData.FieldBoundary.MapXmax=MapXmax;
FieldImageData.FieldBoundary.MapYmin=MapYmin;
FieldImageData.FieldBoundary.MapYmax=MapYmax;

if Draw
    figure;
    cla; hold on; axis equal; xlabel('E-W [m]'); ylabel('N-S [m]');
    plot(ImageX,ImageY,'*');
    for i=1:RowN
        plot([ImageX(RowList(i,1)) ImageX(RowList(i,2))],[ImageX(RowList(i,1)) ImageX(RowList(i,2))]*K(i)+B(i))
    end
end