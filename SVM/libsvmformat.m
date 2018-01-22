TARGET = csvread('data_pca_3.csv'); % read csv file
 labels = TARGET(:, 12); % labels from the last column
 features = TARGET(:, 1:11); 
 sparse_matrix = sparse(features); % sparse matrix uses less memory storage
 libsvmwrite('nba', labels, sparse_matrix);