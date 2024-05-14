function DetectedImageAssembling(DataFolder)
ProcessingFolder='YOLOv8\';
% TrainFolder='images\';
LabelFolder='labels\';
YOLOImageRes=1280;
% GoPro2m=1380;%[pix/meter]
% Drone4m=570;%[pix/meter]626
Draw=0;
% ClassColor=[1 0 0; 0 0 1];
if ~exist([DataFolder 'Detection\'], 'dir')
    mkdir([DataFolder 'Detection\']);
end

SplitImageFileList=cell(1,1);
FileList=dir([DataFolder ProcessingFolder LabelFolder]);
j=0;
for i=3:length(FileList)
    FileName=FileList(i).name;
    if contains(FileName,'.txt')% || contains(FileName,'.JPG')
        j=j+1;
        SplitImageFileList{j,1}=FileName;
    end
end

FieldImageData=GetImageParam(DataFolder,0);
ImageList=FieldImageData.ImageList;%(1:N)

A=imread([DataFolder ImageList{1}]);
[ImageM,ImageN,~]=size(A);

for Image_i=1:length(ImageList)
    ImageFileName=ImageList{Image_i};
    disp([ImageFileName ', ' num2str(Image_i) ' / ' num2str(length(ImageList))])
%     if ImageScaleK(Image_i)~=0
        Class=[]; BB_x=[]; BB_y=[]; BB_w=[]; BB_h=[]; NearBorder=[];
%         A=imread([DataFolder ImageFileName]);
% %         [ImageN,ImageM,a]=size(A);
%         [ImageM,ImageN,~]=size(A);

        q=find(contains(SplitImageFileList,ImageFileName(1:end-4)));
        FileList=SplitImageFileList(q);
        for i=1:length(FileList)
            SplitImageFileName=FileList{i};
            w=split(SplitImageFileName(1:end-4),'_');
            offset_x=str2num(w{length(w)-1});
            offset_y=str2num(w{length(w)});
%                 A=imread([DataFolder ProcessingFolder TrainFolder SplitImageFileName]);
%                 [N,M,a]=size(A);
%                 T=readtable([DataFolder ProcessingFolder LabelFolder SplitImageFileName(1:end-4) '.txt']);
            T=readtable([DataFolder ProcessingFolder LabelFolder SplitImageFileName]);
            if isempty(T)
                disp('Empty label file.');
                continue;
            end
            Class_i=table2array(T(:,1));
            BB_x_i=round(table2array(T(:,2))*YOLOImageRes);
            BB_y_i=round(table2array(T(:,3))*YOLOImageRes);
            BB_w_i=round(table2array(T(:,4))*YOLOImageRes);
            BB_h_i=round(table2array(T(:,5))*YOLOImageRes);
            q=true(length(Class_i),1);
%                 DrawImageBB([DataFolder ],[DataFolder LabelFolder],[SplitImageFileName(1:end-4) '.jpg'],1);
            %BB is not on a boundary
            for j=1:length(Class_i)
                if offset_x>1
                    if BB_x_i(j)-BB_w_i(j)/2<10
                        q(j)=false;
                    end
                end
                if offset_y>1
                    if BB_y_i(j)-BB_h_i(j)/2<10
                        q(j)=false;
                    end
                end
                if offset_x+YOLOImageRes>ImageN
                    if BB_x_i(j)+BB_w_i(j)/2>ImageN-10
                        q(j)=false;
                    end
                end
                if offset_y+YOLOImageRes>ImageM
                    if BB_y_i(j)+BB_h_i(j)/2>ImageM-10
                        q(j)=false;
                    end
                end
            end
    
            Class=[Class; Class_i(q)];
            BB_x=[BB_x; BB_x_i(q)+offset_x-1];
            BB_y=[BB_y; BB_y_i(q)+offset_y-1];
            BB_w=[BB_w; BB_w_i(q)];
            BB_h=[BB_h; BB_h_i(q)];
        end

        BBN=length(Class);
        q=true(BBN,1);
        for i=1:BBN-1
            xi=BB_x(i)+BB_w(i)/2*[-1 1 1 -1];
            yi=BB_y(i)+BB_h(i)/2*[-1 -1 1 1];
            hi=abs(yi(1)-yi(3)); wi=abs(xi(1)-xi(3));
            for j=i+1:BBN
                xj=BB_x(j)+BB_w(j)/2*[-1 1 1 -1];
                yj=BB_y(j)+BB_h(j)/2*[-1 -1 1 1];
                hj=abs(yj(1)-yj(3)); wj=abs(xj(1)-xj(3));
                f=Class(i)==Class(j);
                f=f && ((hi/hj>0.5 && hj/hi>0.5) || ((wi/wj>0.5 && wj/wi>0.5)));
%                 f=f && (PointInsidePolygon(BB_x(i),BB_y(i),xj,yj) || PointInsidePolygon(BB_x(j),BB_y(j),xi,yi));
                f=f && sqrt((BB_x(i)-BB_x(j))^2+(BB_y(i)-BB_y(j))^2)<sqrt(wi*hj)/5;
                if f
                    if wj*hj<wi*hi
                        q(j)=false;
                    else
                        q(i)=false;
                    end
                end
            end
        end
%         A=imread([DataFolder ImageFileName]); figure; title(FileName); imshow(A); hold on;
%         plot(xi,yi,'b'); plot(xj,yj,'g');
        Class=Class(q);
        BB_x=BB_x(q);
        BB_y=BB_y(q);
        BB_w=BB_w(q);
        BB_h=BB_h(q);
        
        T=table(Class,BB_x/ImageN,BB_y/ImageM,BB_w/ImageN,BB_h/ImageM);
        writetable(T,[DataFolder 'Detection\' ImageFileName(1:end-4) '.txt'],'Delimiter',' ','WriteVariableNames',false);
        
        if Draw
            DrawImageBB(DataFolder,[DataFolder 'Detection\'],ImageFileName);%,LabelDir
        end
%     end
end