function [ label ] = playerLabel ( WS )
%UNTITLED7 此处显示有关此函数的摘要
%   此处显示详细说明
    [len, ~] = size(WS);
    label = zeros(len, 1);
    for i = 1:len
        if WS(i) >=7.3
            label(i,1) = 1;
         elseif WS(i) < 7.3 && WS(i)>3
             label(i,1) = 2;
        else
            label(i,1) = 3;
        end
    end

end

