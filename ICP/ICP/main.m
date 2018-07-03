data = importdata('Head1.txt');

model = importdata('Head2.txt');


figure;
plot3(data(1,:),data(2,:),data(3,:),'r.');
hold on;
plot3(model(1,:),model(2,:),model(3,:),'g.');
title('初始位置');
tic
[~,~,newdata] = icp(model,data,1000);
time = toc
TRE = sqrt(sum(sum((model-newdata).^2)))/size(model,2)
figure;
plot3(newdata(1,:),newdata(2,:),newdata(3,:),'r+');
hold on;
plot3(model(1,:),model(2,:),model(3,:),'g.');
title('配准后图像');