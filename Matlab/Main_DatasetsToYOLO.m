% DataFolder='D:\FieldRobot\Datasets\LincolnBeet\';
% ImageSplitToYOLO(DataFolder,0);

%%
% DataFolder='D:\FieldRobot\Datasets\SugarBeets2016\OLD\CKA_weeds\images\rgb\';% 10000 20000
% DataFolderColorLabel='D:\FieldRobot\Datasets\SugarBeets2016\OLD\CKA_weeds\annotations\dlp\iMapCleaned\';
DataFolder='D:\FieldRobot\Datasets\SugarBeets2016\OLD\CKA_weeds\images\rgb\';% 10000 2
DataFolderColorLabel='D:\FieldRobot\Datasets\SugarBeets2016\OLD\CKA_weeds\annotations\dlp\iMapCleaned\';
% DataFolder='D:\FieldRobot\Datasets\SemCUT_DomainAdaption\uav-bonn\images\rgb\';%1 2
% DataFolderColorLabel='D:\FieldRobot\Datasets\SemCUT_DomainAdaption\uav-bonn\annotations\dlp\iMapDa\';
% DataFolder='D:\FieldRobot\Datasets\UAVZurich\images\';%10000 2
% DataFolderColorLabel='D:\FieldRobot\Datasets\UAVZurich\annotations\dlp\iMapDa\';
FileList=dir(DataFolderColorLabel);
Draw=0;
for f=3:length(FileList)
    ImageFileName=FileList(f).name;
    if contains(ImageFileName,'.jpg') || contains(ImageFileName,'.JPG') || contains(ImageFileName,'.png') || contains(ImageFileName,'.PNG')
        disp(ImageFileName);
        FileName0=ImageFileName(1:(length(ImageFileName)-4));
        if isfile([DataFolder FileName0 '.txt'])
            continue;
        end % figure; imshow(imread([DataFolder ImageFileName]));
        A=imread([DataFolderColorLabel ImageFileName]);% imshow(A); unique(A)

        MinSizeObject=100;
%         A1=A(:,:,2)==255;% imshow(A1);
%         A1=A(:,:)==1;%10000 % imshow(A1);
        A1=A(:,:)==10000;%1 % imshow(A1);
        [ListX,ListY,ListBeg,ListEnd,ListN]=ImageClusteringList(A1,1,MinSizeObject,Draw);
        BB1_h=zeros(ListN,1); BB1_w=zeros(ListN,1);
        BB1_ww=zeros(ListN,1); BB1_hh=zeros(ListN,1);
        Included1=zeros(ListN,1); Included1n=0;
        n1=0; 
        for i=1:ListN
%             cni=ListEnd(i)-ListBeg(i)+1;
%             if cni>MinSizeObject && isempty(find(Included1==i,1))
            if isempty(find(Included1==i,1))
                n1=n1+1;
                qi=ListBeg(i):ListEnd(i);
                xmin=min(ListX(qi)); xmax=max(ListX(qi));
                ymin=min(ListY(qi)); ymax=max(ListY(qi));
                for j=i+1:ListN
%                     cnj=ListEnd(j)-ListBeg(j)+1;
%                     if cnj>MinSizeObject && isempty(find(Included1==j,1))
                    if isempty(find(Included1==j,1))
                        qj=ListBeg(j):ListEnd(j);
                        if ClusterDistance(ListX(qi),ListY(qi),ListX(qj),ListY(qj))<15
                            xmin=min([xmin; ListX(qj)]);
                            xmax=max([xmax; ListX(qj)]);
                            ymin=min([ymin; ListY(qj)]);
                            ymax=max([ymax; ListY(qj)]);
                            Included1n=Included1n+1;
                            Included1(Included1n)=j;
% plot([ymin ymax ymax ymin ymin],[xmin xmin xmax xmax xmin]);
                        end
                    end
                end
                BB1_w(n1)=floor((ymax+ymin)/2);
                BB1_h(n1)=floor((xmax+xmin)/2);
                BB1_ww(n1)=floor((ymax-ymin));
                BB1_hh(n1)=floor((xmax-xmin));
% plot([ymin ymax ymax ymin ymin],[xmin xmin xmax xmax xmin]);
            end
        end

%         A2=A(:,:,1)==255;% imshow(A2);
%         A2=A(:,:)==2;%>=20000 % imshow(A2);
        A2=A(:,:)==2;%>=2 % imshow(A2);
        [ListX,ListY,ListBeg,ListEnd,ListN]=ImageClusteringList(A2,1,MinSizeObject,Draw);
        BB2_h=zeros(ListN,1); BB2_w=zeros(ListN,1);
        BB2_ww=zeros(ListN,1); BB2_hh=zeros(ListN,1);
        Included1=zeros(ListN,1); Included1n=0;
        n2=0; 
        for i=1:ListN
%             cni=ListEnd(i)-ListBeg(i)+1;
%             if cni>MinSizeObject && isempty(find(Included1==i,1))
            if isempty(find(Included1==i,1))
                n2=n2+1;
                qi=ListBeg(i):ListEnd(i);
                xmin=min(ListX(qi)); xmax=max(ListX(qi));
                ymin=min(ListY(qi)); ymax=max(ListY(qi));
                for j=i+1:ListN
%                     cnj=ListEnd(j)-ListBeg(j)+1;
%                     if cnj>MinSizeObject && isempty(find(Included1==j,1))
                    if isempty(find(Included1==j,1))
                        qj=ListBeg(j):ListEnd(j);
                        if ClusterDistance(ListX(qi),ListY(qi),ListX(qj),ListY(qj))<15
                            xmin=min([xmin; ListX(qj)]);
                            xmax=max([xmax; ListX(qj)]);
                            ymin=min([ymin; ListY(qj)]);
                            ymax=max([ymax; ListY(qj)]);
                            Included1n=Included1n+1;
                            Included1(Included1n)=j;
% plot([ymin ymax ymax ymin ymin],[xmin xmin xmax xmax xmin]);
                        end
                    end
                end
                BB2_w(n2)=floor((ymax+ymin)/2);
                BB2_h(n2)=floor((xmax+xmin)/2);
                BB2_ww(n2)=floor((ymax-ymin));
                BB2_hh(n2)=floor((xmax-xmin));
% plot([ymin ymax ymax ymin ymin],[xmin xmin xmax xmax xmin]);
            end
        end

        [H,W,a]=size(A);
        BB_w=[BB1_w(1:n1); BB2_w(1:n2);];
        BB_h=[BB1_h(1:n1); BB2_h(1:n2)];
        BB_ww=[BB1_ww(1:n1); BB2_ww(1:n2)];
        BB_hh=[BB1_hh(1:n1); BB2_hh(1:n2)];

        Class=[zeros(n1,1); zeros(n2,1)+1];
        T=table(Class,BB_w/W,BB_h/H,BB_ww/W,BB_hh/H);
        writetable(T,[DataFolder FileName0 '.txt'],'WriteVariableNames',false,'Delimiter',' ');
    end
end

% ImageSplitToYOLO(DataFolder,0);
% load gong.mat
% sound(y)
return
%%
DatasetName='PaimioSB2023';
% DatasetName='SugarBeets2016';
DataFolder=['D:\FieldRobot\Datasets\' DatasetName '\'];
FileList=dir([DataFolder 'images\']);
FileList1={}; n=0;
% s='/scratch/project_2009576/SugarBeets2016/images/';
% s='/scratch/project_2009576/PaimioSB2023/images/';
s='D:/FieldRobot/Datasets/PaimioSB2023/images/';
for f=3:length(FileList)
    ImageFileName=FileList(f).name;
    if contains(ImageFileName,'.png') || contains(ImageFileName,'.jpg')
        n=n+1;
        FileList1{n}=[s FileList(f).name];
    end
end
q_train=randperm(n,floor(n*2/3));%q_train=sort(q_train);
q1=1:n;
q1(q_train)=0;
q_valid_test=q1(q1~=0);
q2=randperm(length(q_valid_test),floor(length(q_valid_test)*2/3));
q_valid=q_valid_test(q2);%q_valid=sort(q_valid);
q_valid_test(q2)=0;
q_test=q_valid_test(find(q_valid_test~=0));
q=[q_train q_valid q_test];
w=unique(q);
length(w)
writetable(table(FileList1(q_train)'),[DataFolder DatasetName '_train_Fold1.txt'],'WriteVariableNames',false,'Delimiter',' ');
writetable(table(FileList1(q_valid)'),[DataFolder DatasetName '_valid_Fold1_Local.txt'],'WriteVariableNames',false,'Delimiter',' ');
writetable(table(FileList1(q_test)'),[DataFolder DatasetName '_test_Fold1.txt'],'WriteVariableNames',false,'Delimiter',' ');
writetable(table(FileList1'),[DataFolder DatasetName '_All_Local.txt'],'WriteVariableNames',false,'Delimiter',' ');

%%
DataFolder='D:\FieldRobot\Datasets\PhenoBench\OLD\train\images\';
DataFolder1='D:\FieldRobot\Datasets\PhenoBench\OLD\train\plant_instances\';
DataFolder2='D:\FieldRobot\Datasets\PhenoBench\OLD\train\semantics\';
FileList=dir(DataFolder1);
Draw=0;
for f=3:length(FileList)
    ImageFileName=FileList(f).name;
    if contains(ImageFileName,'.jpg') || contains(ImageFileName,'.JPG') || contains(ImageFileName,'.png') || contains(ImageFileName,'.PNG')
        disp(ImageFileName);
        A=imread([DataFolder1 ImageFileName]);% imshow(A);
        B=imread([DataFolder2 ImageFileName]);% imshow(B);
        B1=B==1 | B==3;% imshow(B1);
%         B2=B==2;% imshow(B2);
        
        [H,W,a]=size(A);

        k=unique(A); k=k(2:end);
        BB_h=zeros(length(k),1); BB_w=zeros(length(k),1);
        BB_ww=zeros(length(k),1); BB_hh=zeros(length(k),1);
        Class=zeros(length(k),1);
        
        for i=1:length(k)
            A1=A(:,:)==k(i);% imshow(A1);
            V=A1 & B1;% imshow(V);
            if sum(sum(V))>100
                Class(i)=0;
            else
                Class(i)=1;
            end
%             V=A1 & B2;% imshow(V);
%             if sum(sum(V))>300
%                 Class(i)=1;
%             end
            Ay=sum(A1,2);
            q=find(Ay~=0);
            ymin=q(1); ymax=q(end);
            Ax=sum(A1,1);
            q=find(Ax~=0);
            xmin=q(1); xmax=q(end);
            BB_h(i)=floor((ymax+ymin)/2);
            BB_w(i)=floor((xmax+xmin)/2);
            BB_hh(i)=floor((ymax-ymin));
            BB_ww(i)=floor((xmax-xmin));
        end
        T=table(Class,BB_w/W,BB_h/H,BB_ww/W,BB_hh/H);
        FileName0=ImageFileName(1:(length(ImageFileName)-4));
        writetable(T,[DataFolder FileName0 '.txt'],'WriteVariableNames',false,'Delimiter',' ');
% DrawImageBB(DataFolder,DataFolder,ImageFileName,1);
    end
end


%%
DataFolder='D:\FieldRobot\Datasets\Uusi kansio\CropAndWeed\images\';
BBDataFolder='D:\FieldRobot\Datasets\Uusi kansio\CropAndWeed\bboxes\';
LabelDataFolder='D:\FieldRobot\Datasets\Uusi kansio\CropAndWeed\labels\';
mkdir(LabelDataFolder);
FileList=dir(DataFolder);
A=imread('D:\FieldRobot\Datasets\Uusi kansio\CropAndWeed\images\ave-0000-0001.jpg');
% imshow(A);
[H,W,a]=size(A);
for f=3:length(FileList)
    ImageFileName=FileList(f).name;
    FileName=ImageFileName(1:end-4);
    if contains(ImageFileName,'.jpg')
        disp(ImageFileName);
        T=readtable([BBDataFolder FileName '.csv']);
        if isempty(T)
            continue;
        end
        Class=table2array(T(:,5));
        l=table2array(T(:,1));
        t=table2array(T(:,2));
        r=table2array(T(:,3));
        b=table2array(T(:,4));
        BB_h=floor((t+b)/2); BB_h(BB_h>H)=H; BB_h(BB_h<1)=1;
        BB_w=floor((l+r)/2); BB_w(BB_w>W)=W; BB_w(BB_w<1)=1;
        BB_ww=floor((r-l));
        BB_hh=floor((b-t));
        q=Class==11 | Class==9 | Class==10 | Class==7 | Class==12;
        Class(q)=0; Class(~q)=1;
        T1=table(Class,round(BB_w/W,4),round(BB_h/H,4),round(BB_ww/W,4),round(BB_hh/H,4));
        if isempty(find(Class==0))
%             writetable(T1,[LabelDataFolder '_' FileName '.txt'],'WriteVariableNames',false,'Delimiter',' ');
        else
%             copyfile([DataFolder ImageFileName],[LabelDataFolder ImageFileName]);
            writetable(T1,[LabelDataFolder FileName '.txt'],'WriteVariableNames',false,'Delimiter',' ');
%             DrawImageBB(DataFolder,LabelDataFolder,ImageFileName,0);
        end            
    end
end

%%
DataFolder='D:\FieldRobot\Datasets\Uusi kansio\ImageWeeds\';
LabelFileName='weedcoco.json';
fid = fopen([DataFolder LabelFileName]); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 
val = jsondecode(str);
FileList={};
for i=1:length(val.images)
    FileList{i,1}=val.images(i).file_name;
end
bb=zeros(length(val.annotations),4);
imn=zeros(length(val.annotations),1);
for i=1:length(val.annotations)
    bb(i,:)=val.annotations(i).bbox;
    imn(i)=val.annotations(i).image_id+1;
end
W=val.images(1).width;
H=val.images(1).height;
for i=1:length(FileList)
    q=imn==i;
    bbi=bb(q,:);
    Class=ones(sum(q),1);
    T1=table(Class,round(bbi(:,1)/W,4),round(bbi(:,2)/H,4),round(bbi(:,3)/W,4),round(bbi(:,4)/H,4));
    writetable(T1,[DataFolder 'labels\' FileList{i}(1:end-4) '.txt'],'WriteVariableNames',false,'Delimiter',' ');
end