function ImageYOLOSlice(DataFolder,FileName,SlicedDir)
YOLOImageN=1280;
MinOverLap=100;

A=imread([DataFolder FileName]);% imshow(A);
[N,M,a]=size(A);
Nk=ceil(N/(YOLOImageN));
Mk=ceil(M/(YOLOImageN));
Nol=floor((YOLOImageN*Nk-N)/(Nk-1));
if Nol<MinOverLap
    Nk=Nk+1;
    Nol=floor((YOLOImageN*Nk-N)/(Nk-1));
end
Mol=floor((YOLOImageN*Mk-M)/(Mk-1));
if Mol<MinOverLap
    Mk=Mk+1;
    Mol=floor((YOLOImageN*Mk-M)/(Mk-1));
end

FileName0=FileName(1:end-4);
% mkdir(SlicedDir);
for i=1:Nk
    for j=1:Mk
        im_x=(i-1)*(YOLOImageN-Nol)+1;
        im_y=(j-1)*(YOLOImageN-Mol)+1;
        A1=imcrop(A,[im_y im_x YOLOImageN-1 YOLOImageN-1]);% imshow(A);
        imwrite(A1,[SlicedDir FileName0 '_' num2str(im_y) '_' num2str(im_x) FileName(end-3:end)]);
        if isfile([DataFolder FileName0 ".txt"])

        end
    end
end