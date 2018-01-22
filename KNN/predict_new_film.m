clear;
clc;
close all;

data = csvread('data_reducted.csv');
trainingData = data(:,1:11);
trainingLabel = data(:,12);
testData = xlsread('data_test.xlsx');
k = 7;

target = knnclassify(testData,trainingData,trainingLabel,k,'cosine','nearest');

