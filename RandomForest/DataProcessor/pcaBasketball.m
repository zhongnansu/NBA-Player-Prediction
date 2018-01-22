%input data, theshold=0%
%output data-jiangwei(if theshold = 0 return orig data) coeff information of each dimsion %

function [processedData, coeff, explained] = pcaBasketball( originalData, theshold )

[m, n] = size(originalData);
data = zeros(m, n);

%standarized%
for col = 1:n
   tempMean = mean(originalData(:,col));
   tempStd = std(originalData(:, col));
   data(:,col) = (originalData(:,col) - tempMean) ./ tempStd;
end
%data: standarized%

[coeff,~,~,~,explained] = pca(data);

if theshold ~= 0
    sum = 0;
    i = 1;
    while sum < theshold
        sum = sum + explained(i);
        i = i + 1;
    end
    
    processedData = data * coeff(:,1:i);

else
    processedData = data;
end  
csvwrite("dataAfterPCA.csv", processedData);

end


  
    

