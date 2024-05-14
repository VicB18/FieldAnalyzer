function CollectingDetectedPlants(DataFolder)
Draw=0;
warning off;
FieldImageData=GetImageParam(DataFolder,0);
ImageRectX=zeros(length(FieldImageData.ImageX),4);
ImageRectY=zeros(length(FieldImageData.ImageX),4);

DetectedPlantsX=zeros(length(FieldImageData.ImageX)*100,1); DetectedPlantsY=DetectedPlantsX;
DetectedPlantsW=DetectedPlantsX; DetectedPlantsH=DetectedPlantsX;
DetectedPlantsCounted=true(length(FieldImageData.ImageX)*100,1);
DetectedPlantsClass=DetectedPlantsX;
DetectedPlantsN=0;
PlantImageNo=zeros(length(FieldImageData.ImageX)*100,1);

A=imread([DataFolder FieldImageData.ImageList{1}]);
[ImageM,ImageN,~]=size(A);

for Image_i=length(FieldImageData.ImageX):-1:1%1:length(FieldImageData.ImageX)
    if FieldImageData.ImageDir(Image_i)==0
        continue;
    end
    FileName=FieldImageData.ImageList{Image_i};

    disp([FileName ' ' num2str(Image_i) ' / ' num2str(length(FieldImageData.ImageX))]);
    if ~isfile([DataFolder 'Detection\' FileName(1:end-4) '.txt'])
        disp('No BB file.');
        continue;
    end

    if Draw
        DrawImageBB(DataFolder,[DataFolder 'Detection\'],FileName);
    end
    
    T=readtable([DataFolder 'Detection\' FileName(1:end-4) '.txt']);
    Class=table2array(T(:,1));
    BB_cx_pix=round(table2array(T(:,2))*ImageN);
    BB_cy_pix=round(table2array(T(:,3))*ImageM);
    BB_w_pix=round(table2array(T(:,4))*ImageN);
    BB_h_pix=round(table2array(T(:,5))*ImageM);
    
    BB_cx_m=(BB_cx_pix-ImageN/2)/FieldImageData.ImageScaleK(Image_i);
    BB_cy_m=(ImageM/2-BB_cy_pix)/FieldImageData.ImageScaleK(Image_i);
    BB_w_m=BB_w_pix/FieldImageData.ImageScaleK(Image_i);
    BB_h_m=BB_h_pix/FieldImageData.ImageScaleK(Image_i);

    BB_cx=BB_cx_m*cos(FieldImageData.ImageDir(Image_i))-BB_cy_m*sin(FieldImageData.ImageDir(Image_i))+FieldImageData.ImageX(Image_i);
    BB_cy=BB_cx_m*sin(FieldImageData.ImageDir(Image_i))+BB_cy_m*cos(FieldImageData.ImageDir(Image_i))+FieldImageData.ImageY(Image_i);

    %{
    A=imread([DataFolder FileName]);
    MapPix_Meter=50; 
    ImageResizeK=MapPix_Meter/FieldImageData.ImageScaleK(Image_i);
    A1=imresize(A,ImageResizeK);
    A1=imrotate(A1,FieldImageData.ImageDir(Image_i)*180/pi,'bilinear','loose');
    figure; imshow(A1); hold on; [n,m,~]=size(A1);
    XImCorner=floor(M2PixX(FieldImageData.ImageX(Image_i),FieldImageData.FieldBoundary.MapXmin,MapPix_Meter)-m/2)+1;
    YImCorner=floor(M2PixY(FieldImageData.ImageY(Image_i),FieldImageData.FieldBoundary.MapYmax,MapPix_Meter)-n/2)+1;
    plot(M2PixX(BB_cx,FieldImageData.FieldBoundary.MapXmin,MapPix_Meter)-XImCorner,M2PixY(BB_cy,FieldImageData.FieldBoundary.MapYmax,MapPix_Meter)-YImCorner,'.r','MarkerSize',1);
    %}
    %{
    load([DataFolder 'Map'],'MapImage');
    imshow(MapImage); hold on;
    MapPix_Meter=50; 
    plot(M2PixX(BB_cx,FieldImageData.FieldBoundary.MapXmin,MapPix_Meter),M2PixY(BB_cy,FieldImageData.FieldBoundary.MapYmax,MapPix_Meter),'.r','MarkerSize',5);
    %}

    dpN=length(BB_cx_m);
    q=true(dpN,1);

    x=[-0.5 0.5 0.5 -0.5]*ImageN/FieldImageData.ImageScaleK(Image_i);
    y=[-0.5 -0.5 0.5 0.5]*ImageM/FieldImageData.ImageScaleK(Image_i);
    ImageRectX(Image_i,:)=x*cos(FieldImageData.ImageDir(Image_i))-y*sin(FieldImageData.ImageDir(Image_i))+FieldImageData.ImageX(Image_i);
    ImageRectY(Image_i,:)=x*sin(FieldImageData.ImageDir(Image_i))+y*cos(FieldImageData.ImageDir(Image_i))+FieldImageData.ImageY(Image_i);
% MapPix_Meter=50; plot(M2PixX(ImageRectX(Image_i,:),FieldImageData.FieldBoundary.MapXmin,MapPix_Meter),M2PixY(ImageRectY(Image_i,:),FieldImageData.FieldBoundary.MapYmax,MapPix_Meter),'b');
% plot(M2PixX(BB_cx,FieldImageData.FieldBoundary.MapXmin,MapPix_Meter),M2PixY(BB_cy,FieldImageData.FieldBoundary.MapYmax,MapPix_Meter),'.r','MarkerSize',5);
    poly_i=polyshape(ImageRectX(Image_i,:),ImageRectY(Image_i,:)); %plot(M2PixX(ImageRectX(Image_i,:),MapXmin,MapPix_Meter),M2PixY(ImageRectY(Image_i,:),MapYmax,MapPix_Meter))
    for Image_j=length(FieldImageData.ImageX):-1:Image_i+1 %check if the plants were already counted in the previous images
% MapPix_Meter=50; plot(M2PixX(ImageRectX(Image_j,:),FieldImageData.FieldBoundary.MapXmin,MapPix_Meter),M2PixY(ImageRectY(Image_j,:),FieldImageData.FieldBoundary.MapYmax,MapPix_Meter),'y');
        poly_j=polyshape(ImageRectX(Image_j,:),ImageRectY(Image_j,:)); %plot(M2PixX(ImageRectX(Image_j,:),FieldImageData.FieldBoundary.MapXmin,MapPix_Meter),M2PixY(ImageRectY(Image_j,:),FieldImageData.FieldBoundary.MapYmax,MapPix_Meter))
        polyout=intersect(poly_i,poly_j);
        if ~isempty(polyout.Vertices)
            qin=inpolygon(BB_cx,BB_cy,polyout.Vertices(:,1),polyout.Vertices(:,2));
            q=q & ~qin;
        end
    end
% plot(M2PixX(BB_cx(q),FieldImageData.FieldBoundary.MapXmin,MapPix_Meter),M2PixY(BB_cy(q),FieldImageData.FieldBoundary.MapYmax,MapPix_Meter),'.y','MarkerSize',5);

    DetectedPlantsX(DetectedPlantsN+(1:dpN))=BB_cx;
    DetectedPlantsY(DetectedPlantsN+(1:dpN))=BB_cy;
    DetectedPlantsW(DetectedPlantsN+(1:dpN))=BB_w_m;
    DetectedPlantsH(DetectedPlantsN+(1:dpN))=BB_h_m;
    PlantImageNo(DetectedPlantsN+(1:dpN))=Image_i;
    DetectedPlantsClass(DetectedPlantsN+(1:dpN))=Class;
    DetectedPlantsCounted(DetectedPlantsN+(1:dpN))=q;
    DetectedPlantsN=DetectedPlantsN+dpN;
end

DetectedPlantsX=round(DetectedPlantsX(1:DetectedPlantsN),4);
DetectedPlantsY=round(DetectedPlantsY(1:DetectedPlantsN),4);
DetectedPlantsW=round(DetectedPlantsW(1:DetectedPlantsN),4);
DetectedPlantsH=round(DetectedPlantsH(1:DetectedPlantsN),4);
DetectedPlantsCounted=DetectedPlantsCounted(1:DetectedPlantsN);
DetectedPlantsClass=DetectedPlantsClass(1:DetectedPlantsN);
PlantImageNo=PlantImageNo(1:DetectedPlantsN);

T=table(DetectedPlantsX,DetectedPlantsY,DetectedPlantsW,DetectedPlantsH,DetectedPlantsClass,DetectedPlantsCounted,PlantImageNo);
writetable(T,[DataFolder 'DetectedPlants.csv'],'Delimiter',';','WriteVariableNames',true);
warning on;

if Draw
    MapPix_Meter=50;%[pix/meter]
    figure; axis equal; hold on;
    load([DataFolder 'Map'],'MapImage');
    imshow(MapImage); hold on;
    ClassColor=[1 0 0; 0 0 1];
    q=DetectedPlantsClass==0 & DetectedPlantsCounted;
    scatter(M2PixX(DetectedPlantsX(q),FieldImageData.FieldBoundary.MapXmin,MapPix_Meter),M2PixY(DetectedPlantsY(q),FieldImageData.FieldBoundary.MapYmax,MapPix_Meter),1,ClassColor(1,:));
    q=DetectedPlantsClass==1 & DetectedPlantsCounted;
    scatter(M2PixX(DetectedPlantsX(q),FieldImageData.FieldBoundary.MapXmin,MapPix_Meter),M2PixY(DetectedPlantsY(q),FieldImageData.FieldBoundary.MapYmax,MapPix_Meter),1,ClassColor(2,:));
end
