function [RowList,RowN]=FindLinesInScanningTrajectory(X,Y)
N=length(X);
RowN=0;
RowList=zeros(10,2);
aRow=1; bRow=aRow+1;
while bRow<N
    w=zeros(1,N)+1;
    a=bRow+1;
    for b=a+3:N
        x=X(a:b);
        y=Y(a:b);
        [b1,k,R2,RMSE,NRMSE]=LinRegression(x,y,0,0);
        w(b)=RMSE/(b-a);
    end
%     plot(w,'.');
    [e,bRow]=min(w);
    w=zeros(1,N)+1;
    for a=aRow:(bRow-3)
        [b1,k,R2,RMSE,NRMSE]=LinRegression(X(a:bRow),Y(a:bRow),0,0);
        w(a)=RMSE/(bRow-a);
    end
%     plot(w,'.');
    [e,aRow]=min(w);
    [b1,k,R2,RMSE,NRMSE]=LinRegression(X(aRow:bRow),Y(aRow:bRow),0,0);
    %fine tuning the interval ends
    while aRow<bRow && abs(k*X(aRow)+b1-Y(aRow))>RMSE*1.5
        aRow=aRow+1;
    end
    while aRow<bRow && abs(k*X(bRow)+b1-Y(bRow))>RMSE*1.5
        bRow=bRow-1;
    end
    RowN=RowN+1;
    RowList(RowN,1)=aRow;
    RowList(RowN,2)=bRow;
end

% figure; hold on; plot(X,Y,'.');
% text(X,Y,string(1:N));
% plot([X(RowList(RowN,1)) X(RowList(RowN,2))],[Y(RowList(RowN,1)) Y(RowList(RowN,2))])
