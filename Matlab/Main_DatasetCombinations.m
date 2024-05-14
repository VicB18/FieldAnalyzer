DataFolderRoot='D:\FieldRobot\Datasets\';
DataFolderList={}; DatasetName={}; n=0;
n=n+1; DataFolderList{n}=[DataFolderRoot 'SugarBeets2016\images\']; DatasetName{n}='SB16';
n=n+1; DataFolderList{n}=[DataFolderRoot 'LincolnBeet\images\']; DatasetName{n}='LB';
n=n+1; DataFolderList{n}=[DataFolderRoot 'PhenoBench\images\']; DatasetName{n}='PB';
n=n+1; DataFolderList{n}=[DataFolderRoot 'PaimioSB2023\images\']; DatasetName{n}='PSB';
DatasetN=n;
FileList=cell(DatasetN,1);
for i=1:DatasetN
    FileList_i=dir(DataFolderList{i});
    FileListStr={};
    n=0;
    for f=3:length(FileList_i)
        ImageFileName=FileList_i(f).name;
        if contains(ImageFileName,'.jpg') || contains(ImageFileName,'.JPG') || contains(ImageFileName,'.png') || contains(ImageFileName,'.PNG')
            n=n+1;
            FileListStr{n,1}=[DataFolderList{i} ImageFileName];
        end
    end
    FileList{i}=FileListStr;
end

%% dataset-fold
for i=1:DatasetN
    FileListStr={};
    s='Mix';
    for j=1:DatasetN
        if i~=j
            FileListStr=[FileListStr; FileList{i}];
            s=[s '_' DatasetName{j}];
        end
    end
    n=length(FileListStr);
    q_train=randperm(n,floor(n*3/4));%q_train=sort(q_train);
    FileListStr_train=FileListStr(q_train);
    q1=1:n;
    q1(q_train)=0;
    q_test=q1(q1~=0);
    FileListStr_test=FileListStr(q_test);

    T=table(FileListStr_train);
    writetable(T,[DataFolderRoot s '_train_Local.txt'],'WriteVariableNames',false,'Delimiter',';');
    T=table(FileListStr_test);
    writetable(T,[DataFolderRoot s '_test_Local.txt'],'WriteVariableNames',false,'Delimiter',';');
end

%% progressive transfer learning
TLDataN=[1 2 4 8 16 32 64 128 512 1024 2048 4096];
for i=1:DatasetN
    FileListStr=FileList{i};
    FileListStr_comb_train={};
    FileListStr_comb_test={};
    for j=1:(length(TLDataN)-1)
        n=length(FileListStr);
        q=randperm(n,TLDataN(j));
        FileListStr_comb=FileListStr(q);
        w=1:n;
        w(q)=0;
        q1=find(w~=0);
        FileListStr=FileListStr(q1);
        q_train=randperm(TLDataN(j),ceil(TLDataN(j)*3/4));
        e=1:TLDataN(j);
        e(q_train)=0;
        q_test=find(e~=0);
        FileListStr_comb_train=[FileListStr_comb_train; FileListStr_comb(q_train)];
        FileListStr_comb_test=[FileListStr_comb_test; FileListStr_comb(q_test)];
        T=table(FileListStr_comb_train);
        writetable(T,[DataFolderRoot DatasetName{i} '_' num2str(TLDataN(j+1)) '_train_Local.txt'],'WriteVariableNames',false,'Delimiter',';');
        T=table(FileListStr_comb_test);
        writetable(T,[DataFolderRoot DatasetName{i} '_' num2str(TLDataN(j+1)) '_test_Local.txt'],'WriteVariableNames',false,'Delimiter',';');
    end
end