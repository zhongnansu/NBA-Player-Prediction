function [ ] = plotResult( dataSqrt, dataLog2, dataNone)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
figure;
hold on 

plot(1:3:150,dataSqrt(1:50,:), 'r');
plot(1:3:150, dataLog2(1:50,:), 'g');
plot(1:3:150, dataNone(1:50,:), 'b');

legend( "max\_feature = 'sqrt'", "max\_feature = 'log2'", "max\_feature = 'None'")

end

