DataFolder='C:\Users\03138529\Desktop\PaimioSugarBeet\';
% DataFolder='C:\Users\03138529\Desktop\PaimioSugarBeet\ControlChemical\';
% DataFolder='C:\Users\03138529\Desktop\PaimioSugarBeet\OLD\ControlWild\';
Draw=1;
GoPro2m=1380;%[pix/meter]
Drone4m=570;%[pix/meter]626
% PixToMeterK=Drone4m;
PixToMeterK=GoPro2m;
PlantDist=0.1;%m
RowMargin=0.05;%+-m distance from the row line to test weeds in the rows

FileList=dir(DataFolder);
for i=3:length(FileList)
    FileName=FileList(i).name;
    if contains(FileName,'.jpg') || contains(FileName,'.JPG')
        disp(FileName);
        if ~isfile([DataFolder FileName(1:end-4) '.txt'])
            disp('No BB file.');
            continue;
        end

        A=imread([DataFolder FileName]);
        [N,M,a]=size(A);
        if Draw
            DrawImageBB(DataFolder,DataFolder,FileName,PixToMeterK);
        end
        
        T=readtable([DataFolder FileName(1:end-4) '.txt']);
        Class=table2array(T(:,1));
        BB_cx=round(table2array(T(:,2))*N);
        BB_cy=round(table2array(T(:,3))*M);
        % BB_w=round(table2array(T(:,4))*N);
        % BB_h=round(table2array(T(:,5))*M);
        
        BB_cx=BB_cx/PixToMeterK;
        BB_cy=(N-BB_cy)/PixToMeterK;
        % BB_w=BB_w/PixToMeterK;
        % BB_h=BB_h/PixToMeterK;
        PlantBB_cx=BB_cx(Class==0);
        PlantBB_cy=BB_cy(Class==0);
        WeedBB_cx=BB_cx(Class==1);
        WeedBB_cy=BB_cy(Class==1);
        RowImageLen=N/PixToMeterK;
        
%         px1=PlantBB_cy; py1=PlantBB_cx;
%         [LinesK,LinesB,MinClusterN,MinClusterInd,Wmin]=KMeansClustering_ParallelLines(px1,py1,8,0,Draw);
%         RowPlantRelativeDensity=zeros(length(MinClusterN),1);
%         RowRowWeedDensity=zeros(length(MinClusterN),1);
%         q_WeedBetweenRows=true(length(WeedBB_cx),1);
%         
%         wx1=WeedBB_cy; wy1=WeedBB_cx;
%         for row_i=1:length(MinClusterN)
%         %     PlantR=PlantBB_cy(MinClusterInd(1:MinClusterN(row_i),row_i));
%         %     PlantR=sort(PlantR);
%             RowPlantRelativeDensity(row_i)=MinClusterN(row_i)/(RowImageLen/PlantDist);
%         
%             plot(PlantBB_cx(MinClusterInd(row_i,1:MinClusterN(row_i))),RowImageLen-PlantBB_cy(MinClusterInd(row_i,1:MinClusterN(row_i))),'g*');
%         
%             dy=wy1-(LinesK(row_i)*wx1+LinesB(row_i));
%             r=abs(dy./cos(atan(LinesK(row_i))));
%             q=abs(r)<RowMargin;
%         
%             plot(WeedBB_cx(q),RowImageLen-WeedBB_cy(q),'y*');
%             RowRowWeedDensity(row_i)=sum(q)/RowImageLen;
%         
%             q_WeedBetweenRows=q_WeedBetweenRows & ~q;
%         end
        
        % ImagePlantDensity=mean(RowPlantRelativeDensity);
        ImagePlantWeedRatio=length(PlantBB_cx)/length(WeedBB_cx);
        ImageWeedDensity=length(WeedBB_cx)/(RowImageLen*M/PixToMeterK);%1/m^2
        RowWeedDensity=mean(RowRowWeedDensity);%1/m
        BetweenRowWeedDensity=sum(q_WeedBetweenRows)/(RowImageLen*M/PixToMeterK);%1/m^2

        disp(['Total Image Weed Density = ' num2str(ImageWeedDensity) '/m2'])
        disp(['Row Weed Density = ' num2str(RowWeedDensity) '/m'])
        disp(['Between Row Weed Density = ' num2str(BetweenRowWeedDensity) '/m2'])
    end
end
