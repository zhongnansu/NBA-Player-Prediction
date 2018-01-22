clear;
clc;
close all;

data = csvread('data_before_pca.csv');

tic;

[m n] = size(data); 
indices = crossvalind('Kfold',m,10); 
for i=1:10
    test=(indices==i);  
    train=~test;  
    trainingData=data(train,1:35);  
    trainingLabel=data(train,36);  
    testData=data(test,1:35);  
    testLabel=data(test,36); 
    for k = 1:220
        target = knnclassify(testData,trainingData,trainingLabel,k,'cosine','nearest');
        accurate_num = 0;
        for i = 1:size(target,1)
            if target(i) - testLabel(i) == 0
                 accurate_num = accurate_num + 1;
            end
            dist(i) = abs(target(i) - testLabel(i));
        end
        accuracy(k) = accurate_num/size(target,1);
        difference(k) = sum(dist,2)/size(target,1);
    end
end 


plot(accuracy);
title('accuracy')
xlabel('k')
ylabel('accuracy')
grid on

toc;