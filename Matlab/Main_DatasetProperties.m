% DataFolder='C:\Users\03138529\Desktop\Datasets\PaimioSB2023\labels\';
% DataFolder='C:\Users\03138529\Desktop\Datasets\PhenoBench\labels\';
% DataFolder='C:\Users\03138529\Desktop\Datasets\LincolnBeet\labels\';
% DataFolder='C:\Users\03138529\Desktop\Datasets\SugarBeets2016\labels\';
DataFolder='C:\Users\03138529\Desktop\Datasets\MixA\labels\';

FileList=dir(DataFolder);
SB_N=0; SB_A=0;
We_N=0; We_A=0;
ImageN=0;

for f=3:length(FileList)
    disp([num2str(f) ' / ' num2str(length(FileList))])
    FileName=FileList(f).name;
    if contains(FileName,'.txt') && ~contains(FileName,'labels.txt')
            Tp=readtable([DataFolder FileName]);
            if isempty(Tp)
                continue;
            end
            ImageN=ImageN+1;
            Class=table2array(Tp(:,1));
            BB_h=table2array(Tp(:,2));
            BB_w=table2array(Tp(:,3));
            BB_ww=table2array(Tp(:,4));
            BB_hh=table2array(Tp(:,5));

            for i=1:length(Class)
                if Class(i)==0
                    SB_N=SB_N+1;
                    SB_A=SB_A+BB_ww(i)*BB_hh(i);
                else
                    We_N=We_N+1;
                    We_A=We_A+BB_ww(i)*BB_hh(i);
                end
            end
    end
end

disp(['Image number = ' num2str(ImageN)]);
disp(['Sugar beet number = ' num2str(SB_N) ', total BB area = ' num2str(SB_A/ImageN*100,2) '%']);
disp(['Weeds number = ' num2str(We_N) ', total BB area = ' num2str(We_A/ImageN*100,2) '%']);
