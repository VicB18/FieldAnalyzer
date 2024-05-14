function ImageSplitToYOLO(DataFolder,LabelDir)
ProcessingFolder='YOLOv8\';
ImageFolder='images\';
LabelFolder='labels\';
YOLOImageSize=1280*1;
MinOverlap=10*0;
if ~exist([DataFolder ProcessingFolder], 'dir')
    mkdir([DataFolder ProcessingFolder]);
end
ProcessedImagesFolder=[DataFolder ProcessingFolder ImageFolder];
if ~exist(ProcessedImagesFolder, 'dir')
    mkdir(ProcessedImagesFolder);
end
ProcessedLabesFolder=[DataFolder ProcessingFolder LabelFolder];
if ~exist(ProcessedLabesFolder, 'dir')
    mkdir(ProcessedLabesFolder);
end

FileList=dir([DataFolder]);% 'images\'
for f=3:length(FileList)
    ImageFileName=FileList(f).name;
    if contains(ImageFileName,'.jpg') || contains(ImageFileName,'.JPG') || contains(ImageFileName,'.png') || contains(ImageFileName,'.PNG')
        disp(ImageFileName);
        A=imread([DataFolder ImageFileName]);% 'images\' imshow(A);
        [H,W,a]=size(A);
        Hk=ceil(H/(YOLOImageSize));
        Wk=ceil(W/(YOLOImageSize));
        Hol=floor((YOLOImageSize*Hk-H)/(Hk-1));
        if Hol<MinOverlap
            Hk=Hk+1;
            Hol=floor((YOLOImageSize*Hk-H)/(Hk-1));
        end
        Wol=floor((YOLOImageSize*Wk-W)/(Wk-1));
        if Wol<MinOverlap
            Wk=Wk+1;
            Wol=floor((YOLOImageSize*Wk-W)/(Wk-1));
        end
        ScaleH=1;
        if Hk==1 && H~=YOLOImageSize
            A=imresize(A,[YOLOImageSize W]);% imshow(A);
            ScaleH=YOLOImageSize/H;
            H=YOLOImageSize;
            Hol=YOLOImageSize;
        end
        if Hk>1 && Hol/YOLOImageSize>0.9
            Hk=Hk-1;
            A=imresize(A,[YOLOImageSize*Hk W]);% imshow(A);
            ScaleH=YOLOImageSize/H;
            H=YOLOImageSize*Hk;
            Hol=YOLOImageSize;
        end
        ScaleW=1;
        if Wk==1 && W~=YOLOImageSize
            A=imresize(A,[H YOLOImageSize]);
            ScaleW=YOLOImageSize/W;
            W=YOLOImageSize;
            Wol=YOLOImageSize;
        end
        if Wk>1 && Wol/YOLOImageSize>0.9
            Wk=Wk-1;
            A=imresize(A,[H YOLOImageSize*Wk]);% imshow(A);
            ScaleW=YOLOImageSize/W;
            W=YOLOImageSize*Wk;
            Wol=YOLOImageSize;
        end

        FileName0=ImageFileName(1:(length(ImageFileName)-4));
        T=[];
        if isfile([DataFolder 'labels\' FileName0 '.txt'])
            T=readtable([DataFolder 'labels\' FileName0 '.txt']);
            if ~isempty(T)
                Class=table2array(T(:,1));
% DrawImageBB([DataFolder 'images\'],[DataFolder 'labels\'],ImageFileName,LabelDir);
                if LabelDir==1
                    BB_h=round(table2array(T(:,2))*H);
                    BB_w=round(table2array(T(:,3))*W);
                    BB_ww=round(table2array(T(:,4))*H);
                    BB_hh=round(table2array(T(:,5))*W);
                else
                    BB_w=round(table2array(T(:,2))*W);
                    BB_h=round(table2array(T(:,3))*H);
                    BB_ww=round(table2array(T(:,4))*W);
                    BB_hh=round(table2array(T(:,5))*H);
                end
            end
        end

        for i=1:Hk
            for j=1:Wk
                im_h=(i-1)*(YOLOImageSize-Hol)+1;
                im_w=(j-1)*(YOLOImageSize-Wol)+1;
                A1=imcrop(A,[im_w im_h YOLOImageSize-1 YOLOImageSize-1]);% imshow(A1);
                imwrite(A1,[ProcessedImagesFolder FileName0 '_' num2str(im_w) '_' num2str(im_h) ImageFileName(end-3:end)]);
                if ~isempty(T)
                    k=0.5;
                    q=0<BB_h-im_h+BB_hh/2*k & BB_h-im_h-BB_hh/2*k<YOLOImageSize & 0<BB_w-im_w+BB_ww/2*k & BB_w-im_w-BB_ww/2*k<YOLOImageSize;
                    h=(BB_h(q)-im_h)/YOLOImageSize;
                    w=(BB_w(q)-im_w)/YOLOImageSize;
                    bw=BB_ww(q)*ScaleH/YOLOImageSize;
                    bh=BB_hh(q)*ScaleW/YOLOImageSize;
                    c=Class(q);
                    for v=1:length(c)
                        if h(v)+bh(v)/2>1
                            bh(v)=1-h(v)+bh(v)/2;
                            h(v)=1-bh(v)/2;
                        end
                        if h(v)-bh(v)/2<0
                            bh(v)=h(v)+bh(v)/2;
                            h(v)=bh(v)/2;
                        end
                        if w(v)+bw(v)/2>1
                            bw(v)=1-w (v)+bw(v)/2;
                            w(v)=1-bw(v)/2;
                        end
                        if w(v)-bw(v)/2<0
                            bw(v)=w(v)+bw(v)/2;
                            w(v)=bw(v)/2;
                        end
                    end
                    T1=table(c,w,h,bw,bh);
                    writetable(T1,[ProcessedLabesFolder FileName0 '_' num2str(im_w) '_' num2str(im_h) '.txt'],'WriteVariableNames',false,'Delimiter',' ');
% DrawImageBB(ProcessedImagesFolder,ProcessedLabesFolder,[FileName0 '_' num2str(im_w) '_' num2str(im_h) ImageFileName(end-3:end)],1);
                end
            end
        end        
    end
end