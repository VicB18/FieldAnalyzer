function RowsInImageAnalysis(DataFolder,RowWidth)
% PlantDist=0.1;%m
% RowMargin=0.05;%+-m distance from the row line to test weeds in the rows

FieldImageData=GetImageParam(DataFolder,0);

T=readtable([DataFolder 'DetectedPlants.csv'],'Delimiter',';');
DetectedPlantsX=table2array(T(:,1));
DetectedPlantsY=table2array(T(:,2));
DetectedPlantsClass=table2array(T(:,5));
% DetectedPlantsCounted=table2array(T(:,6));
PlantImageNo=table2array(T(:,7));

% MapPix_Meter=50;%[pix/meter]
%     figure; axis equal; hold on;
%     load([DataFolder 'Map'],'MapImage');
%     imshow(MapImage); hold on;
% ClassColor=[1 0 0; 0 0 1];
LineTheta=zeros(length(FieldImageData.ImageX),1);
RowDist=zeros(length(FieldImageData.ImageX),1);
FirstRowToOrigin=LineTheta; RowN=LineTheta;

% load("LineTheta",'LineTheta','RowDist','FirstRowToOrigin','RowN');
for Image_i=1:length(FieldImageData.ImageX)
    disp([num2str(Image_i) ' / ' num2str(length(FieldImageData.ImageX))]);
%     figure; imshow(imread([DataFolder FieldImageData.ImageList{Image_i}]));
    
    q=DetectedPlantsClass==0 & PlantImageNo==Image_i;
    if sum(q)>50%minimal amount of detected plants
        PlantX=DetectedPlantsX(q);
        PlantY=DetectedPlantsY(q);
    %     scatter(M2PixX(PlantX,FieldImageData.FieldBoundary.MapXmin,MapPix_Meter),M2PixY(PlantY,FieldImageData.FieldBoundary.MapYmax,MapPix_Meter),1,ClassColor(1,:));
    % figure; title(num2str(Image_i));
        [LineTheta(Image_i),RowDist(Image_i),FirstRowToOrigin(Image_i),RowN(Image_i)]=FindPlantRowsInImage(PlantX,PlantY);
    %     a_av=mean(LinesK);%,MinClusterN,MinClusterInd,Wmin
    %     RowD=diff(LinesB)*cos(a_av);
    %     disp(RowD/0.5)
    %     RowPlantRelativeDensity=zeros(length(MinClusterN),1);
    %     RowRowWeedDensity=zeros(length(MinClusterN),1);
% save("LineTheta",'LineTheta','RowDist','FirstRowToOrigin','RowN');
    end
end

% figure; hold on;
% PlantX1=PlantX*cos(pi/2-LineTheta(Image_i))-PlantY*sin(pi/2-LineTheta(Image_i));
% PlantY1=PlantX*sin(pi/2-LineTheta(Image_i))+PlantY*cos(pi/2-LineTheta(Image_i));
% plot(PlantX1,PlantY1,'.');
% for i=1:RowN(Image_i)
%     b=FirstRowToOrigin(Image_i)-RowDist(Image_i)*(i-1);
%     plot([min(PlantX1) max(PlantX1)],[b b]);
% end

% figure; hold on; plot(LineTheta,'.'); plot(RowDist,'*');
% load("LineTheta",'LineTheta','RowDist','FirstRowToOrigin','RowN');
OutlyerLineTheta=ClustersOrdered(LineTheta,5/180*pi,7);
OutlyerRowDist=ClustersOrdered(RowDist,0.1,7);
for Image_i=1:length(FieldImageData.ImageX)
    if OutlyerLineTheta(Image_i)==1 || OutlyerRowDist(Image_i)==1
        disp([num2str(Image_i) ' / ' num2str(length(FieldImageData.ImageX))]);
% figure; imshow(imread([DataFolder ImageList{Image_i}]));
        q=DetectedPlantsClass==0 & PlantImageNo==Image_i;
        if sum(q)>50%minimal amount of detected plants
            PlantX=DetectedPlantsX(q);
            PlantY=DetectedPlantsY(q);
            [LineTheta(Image_i),RowDist(Image_i),FirstRowToOrigin(Image_i),RowN(Image_i)]=FindPlantRowsInImage(PlantX,PlantY);
% save("LineTheta",'LineTheta','RowDist','FirstRowToOrigin','RowN');
% plot(Image_i,LineTheta(Image_i),'^');
% plot(Image_i,RowDist(Image_i),'v');
        end
    end
end
% load("LineTheta",'LineTheta','RowDist','FirstRowToOrigin','RowN');
OutlyerLineTheta=ClustersOrdered(LineTheta,5/180*pi,20);
OutlyerRowDist=ClustersOrdered(RowDist,0.1,20);
% w=1:length(LineTheta); t=OutlyerLineTheta==1; r=OutlyerRowDist==1; tr=t | r;
% plot(w(t),LineTheta(t),'o');
% plot(w(r),RowDist(r),'o');
% figure; hold on; plot(w(~tr),LineTheta(~tr),'.'); plot(w(~tr),RowDist(~tr),'.');

if isfile([DataFolder 'ImageParam.csv'])
    T=readtable([DataFolder 'ImageParam.csv']);
    if height(T)~=length(LineTheta)
        disp('??');
    end
    for i=1:height(T)
        if OutlyerLineTheta(i)==0 && OutlyerRowDist(i)==0
            T.LineTheta(i)=LineTheta(i);
            T.RowDist(i)=RowDist(i);
            T.ImageScaleK(i)=T.ImageScaleK(i)*RowDist(i)/RowWidth;
            T.FirstRowToOrigin(i)=FirstRowToOrigin(i);
            T.RowN(i)=RowN(i);
        end
    end
    writetable(T,[DataFolder 'ImageParam.csv'],'Delimiter',';');
end


%     wx1=WeedBB_cy; wy1=WeedBB_cx;
%     for row_i=1:length(MinClusterN)
%     %     PlantR=PlantBB_cy(MinClusterInd(1:MinClusterN(row_i),row_i));
%     %     PlantR=sort(PlantR);
%         RowPlantRelativeDensity(row_i)=MinClusterN(row_i)/(RowImageLen/PlantDist);
%     
%         plot(PlantBB_cx(MinClusterInd(row_i,1:MinClusterN(row_i))),RowImageLen-PlantBB_cy(MinClusterInd(row_i,1:MinClusterN(row_i))),'g*');
%     
%         dy=wy1-(LinesK(row_i)*wx1+LinesB(row_i));
%         r=abs(dy./cos(atan(LinesK(row_i))));
%         q=abs(r)<RowMargin;
%     
% %         plot(WeedBB_cx(q),RowImageLen-WeedBB_cy(q),'y*');
%         RowRowWeedDensity(row_i)=sum(q)/RowImageLen;
%     
%         q_WeedBetweenRows=q_WeedBetweenRows & ~q;
%     end
%     
%     % ImagePlantDensity=mean(RowPlantRelativeDensity);
%     ImagePlantWeedRatio=length(PlantBB_cx)/length(WeedBB_cx);
%     ImageWeedDensity=length(WeedBB_cx)/(RowImageLen*ImageM/ImageScaleK(i));%1/m^2
%     RowWeedDensity=mean(RowRowWeedDensity);%1/m
%     BetweenRowWeedDensity=sum(q_WeedBetweenRows)/(RowImageLen*ImageM/ImageScaleK(i));%1/m^2

%     disp(['Total Image Weed Density = ' num2str(ImageWeedDensity) '/m2'])
%     disp(['Row Weed Density = ' num2str(RowWeedDensity) '/m'])
%     disp(['Between Row Weed Density = ' num2str(BetweenRowWeedDensity) '/m2'])
