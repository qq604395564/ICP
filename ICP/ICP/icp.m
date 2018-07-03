function [TR,TT,data] = icp(model,data,Iter)
%判断两个点集行列值大小
if (size(model,2)<size(model,1))
    model=model';
end

if (size(data,2)<size(data,1))
    data=data';
end

if size(model,1)~=size(data,1)
    error('The dimension of the model points and data points must be equal');
end

m=size(model,1);

N=size(data,2);

distance=zeros(N,1);
index=ones(N,1);
%初始姿态，可改，越接近金标准，结果越好
r = [0.08;0.15;0.4];
TR=rotationVectorToMatrix(r);
TT=zeros(m,1);
data = TR*data+TT;
for iter = 1 : Iter

    for i=1:N
        d = sqrt(sum((model - data(:,i)).^2));
        [distance(i),index(i)] = min(d);
    end

    meanData=mean(data,2);

    newmodel = model(:,index);
    meanModel=mean(newmodel,2);
%     for i=1:N
%         C=C+(data(:,i)*newmodel(:,i)'-meanData*newmodel(:,i)'-data(:,i)*meanModel'+meanData*meanModel');
%     end
    C = (data-meanData)*(newmodel - meanModel)';
    [U,~,V]=svd(C);
    Ri=V*U';
    if det(Ri)<0
        V(:,end)=-V(:,end);
        Ri=V*U';
    end
    Ti=meanModel-Ri*meanData;
    
    data=Ri*data + Ti;                       % Apply transformation
    
    TR=Ri*TR;                           % Update transformation
    TT=Ri*TT+Ti;

end
end

