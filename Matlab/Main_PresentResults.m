ResultsFolder='C:\Users\03138529\Desktop\Results\';
T=readtable([ResultsFolder 'ValidationPSB23.csv']);

ModelName=T.ModelName;
ValidationDSName=T.ValidationDSName;
map50=T.map50;
F1SugarBeet=T.F1SugarBeet;
F1Weed=T.F1Weed;
F1Average=T.F1Average;
DSList={'LB','SB16','PB','PSB23'};%,'MixA'

Epoch=zeros(length(ModelName),1);
ModelDSName=cell(length(ModelName),1);
for i=1:length(ModelName)
    d=split(ModelName{i},'epoch');
    ModelDSName{i}=d{1};
    Epoch(i)=str2num(d{2});
end

figure
cla; hold on;
for DS_i=1:length(DSList)
    q=strcmp(ValidationDSName,DSList{DS_i}) & strcmp(ModelDSName,DSList{4});
    map50_i=map50(q);
    Epoch_i=Epoch(q);
    plot(Epoch_i,map50_i,'.-');
end
legend(DSList);

cla; hold on;
Tr=readtable([ResultsFolder DSList{4} '_Fold1\' 'train\results.csv'],'Delimiter',',');
epochTest=Tr.epoch;
mAP50Test=Tr.metrics_mAP50_B_;
plot(epochTest,mAP50Test,'.-','LineWidth',2);
xlabel('Epochs'); ylabel('map50'); legend([DSList [DSList{4} ' training']]);

%% SPSB23
m={'.','o','*','s'};
figure;
cla; hold on;
q=strcmp(ValidationDSName,'PSB23') & strcmp(ModelDSName,'PSB23');
Epoch_i=Epoch(q);
map50_i=map50(q);
F1SugarBeet_i=F1SugarBeet(q);
F1Weed_i=F1Weed(q);
F1Average_i=F1Average(q);
plot(Epoch_i,map50_i,m{1});
plot(Epoch_i,F1SugarBeet_i,m{2});
plot(Epoch_i,F1Weed_i,m{3});
plot(Epoch_i,F1Average_i,m{4});
legend('mAP50','F1_{SugarBeet}','F1_{Weed}','F1_{Average}','NumColumns',2);
xlabel('Epochs'); ylabel('mAP50, F1');
set(gcf,'Position',[50 100 400 300]);
xlim([0 100]);