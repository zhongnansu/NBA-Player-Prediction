thshd_31 = 3;
thshd_32 = 7.3;
content_saved = 90;
% get data from excel 
fileName = 'final.xlsx';
[data,titles,~] = xlsread(fileName);
titles = titles(1,:);
data_ori = data;

% get ws score out of data
col = strcmp(titles,'WS');
score = data(:,col);
data = data(:,~col);
titles = titles(:,~col);
data_copy = data;
numOfSample = size(data,1);

% set different class
idx_2 = find(score>=thshd_32);
idx_1 = find(score>=thshd_31 & score<thshd_32);
score_3 = zeros(numOfSample,1);
score_3(idx_1) = 1;
score_3(idx_2) = 2;

% before pca, do feature normalization
mu = mean(data);
sigma = std(data);
data_norm = bsxfun(@minus, data, mu);
data_norm = bsxfun(@rdivide, data_norm, sigma); % -mu /sigma

% writre data before pca out
csv_filename = 'data_before_pca.csv';
fid = fopen(csv_filename, 'w') ;
fprintf(fid, '%s,', titles{1,1:end-1}) ;
fprintf(fid, '%s\n', titles{1,end}) ;
fclose(fid) ;
dlmwrite(csv_filename, data_norm, '-append') ; % appends the matrix to the file

% do pca 0.9
[data_reducted_trn, trsfm_mtx, explained] = dms_rdct(data_norm, content_saved);
explained_plot = zeros(size(explained));
for i = 1: size(explained)
    explained_plot(i) = sum(explained(1:i)) ;
end

figure(1);
plot(1:size(explained), explained_plot);
xlabel('dimension', 'FontSize', 12);
ylabel('percentages of original data(%)', 'FontSize', 12);
title('Result of PCA', 'FontSize', 15);
grid on;

csv_file = 'data_reducted.csv';
% csvwrite(csv_file, data_reducted_trn, 0, 0);

data_write = [ data_reducted_trn score_3];
dlmwrite(csv_file, data_write);

save('result.mat', 'mu', 'sigma', 'trsfm_mtx');