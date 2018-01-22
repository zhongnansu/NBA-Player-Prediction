clear;
clc;
close all;


data = csvread('data_reducted.csv');

tic;

[m n] = size(data); 
indices = crossvalind('Kfold',m,10); 
for i=1:10 
    test=(indices==i);  
    train=~test;  
    trainingData=data(train,1:11);  
    trainingLabel=data(train,12);  
    testData=data(test,1:11);  
    testLabel=data(test,12); 
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

 plot(difference);
 title('difference')
 xlabel('k')
 ylabel('score_difference')
 grid on
 figure;
 plot(accuracy);
 title('accuracy')
 xlabel('k')
 ylabel('accuracy')
 grid on
figure;
plot(target);
title('predict group')
xlabel('k')
ylabel('predict_group')
grid on

toc;