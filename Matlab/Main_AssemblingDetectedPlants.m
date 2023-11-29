% DataFolder='C:\Users\03138529\Desktop\PaimioSugarBeet\';
% DataFolder='C:\Users\03138529\Desktop\PaimioSugarBeet\ControlChemical\';
DataFolder='C:\Users\03138529\Desktop\PaimioSugarBeet\ControlWild\';
TrainFolder='train\';
LabelFolder='Labels\';
YOLOImageN=1280;
GoPro2m=1380;%[pix/meter]
Drone4m=570;%[pix/meter]626
Draw=1;
ClassColor=[1 0 0; 0 0 1];

SplitImageFileList=cell(1,1);
FileList=dir([DataFolder TrainFolder]);
j=0;
for i=3:length(FileList)
    FileName=FileList(i).name;
    if contains(FileName,'.jpg') || contains(FileName,'.JPG')
        j=j+1;
        SplitImageFileList{j,1}=FileName;
    end
end

ImageFileList=dir(DataFolder);
for Image_i=3:length(ImageFileList)
    ImageFileName=ImageFileList(Image_i).name;
    if contains(ImageFileName,'.jpg') || contains(ImageFileName,'.JPG')
        Class=[];
        BB_x=[];
        BB_y=[];
        BB_w=[];
        BB_h=[];
        NearBorder=[];
        A=imread([DataFolder ImageFileName]);
        [ImageN,ImageM,a]=size(A);

        q=find(contains(SplitImageFileList,ImageFileName(1:end-4)));
        FileList=SplitImageFileList(q);
        for i=1:length(FileList)
            SplitImageFileName=FileList{i};
            if contains(SplitImageFileName,'.jpg') || contains(SplitImageFileName,'.JPG')
                if ~isfile([DataFolder LabelFolder SplitImageFileName(1:end-4) '.txt'])
                    disp('No label file.');
                    continue;
                end
                w=split(SplitImageFileName(1:end-4),'_');
                dx=str2num(w{length(w)-1});
                dy=str2num(w{length(w)});
                A=imread([DataFolder TrainFolder SplitImageFileName]);
                [N,M,a]=size(A);
                T=readtable([DataFolder LabelFolder SplitImageFileName(1:end-4) '.txt']);
                Class_i=table2array(T(:,1));
                BB_x_i=round(table2array(T(:,2))*N);
                BB_y_i=round(table2array(T(:,3))*M);
                BB_w_i=round(table2array(T(:,4))*N);
                BB_h_i=round(table2array(T(:,5))*M);
                q=true(length(Class_i),1);
%                 DrawBB([DataFolder TrainFolder],[DataFolder LabelFolder],SplitImageFileName,GoPro2m);
                %BB is not on a boundary
                for j=1:length(Class_i)
                    if dx>1
                        if BB_x_i(j)-BB_w_i(j)/2<10
                            q(j)=false;
                        end
                    end
                    if dy>1
                        if BB_y_i(j)-BB_h_i(j)/2<10
                            q(j)=false;
                        end
                    end
                    if dx+YOLOImageN>ImageN
                        if BB_x_i(j)+BB_w_i(j)/2>ImageN-10
                            q(j)=false;
                        end
                    end
                    if dy+YOLOImageN>ImageM
                        if BB_y_i(j)+BB_h_i(j)/2>ImageM-10
                            q(j)=false;
                        end
                    end
                end
        
                Class=[Class; Class_i(q)];
                BB_x=[BB_x; BB_x_i(q)+dx-1];
                BB_y=[BB_y; BB_y_i(q)+dy-1];
                BB_w=[BB_w; BB_w_i(q)];
                BB_h=[BB_h; BB_h_i(q)];
            end
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
                f=f && (hi/hj>0.5 && hj/hi>0.5) || ((wi/wj>0.5 && wj/wi>0.5));
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
        writetable(T,[DataFolder ImageFileName(1:end-4) '.txt'],'Delimiter',' ','WriteVariableNames',false);
        
        if Draw
            DrawImageBB(DataFolder,DataFolder,ImageFileName,GoPro2m);
        end
    end
end