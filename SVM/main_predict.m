% read the dataset
tic

[player_WS_label, player_WS_inst] = libsvmread('nba');
[N D] = size(player_WS_inst);
 
% determine the train and test index
T = N - round(N/10);
trainIndex = zeros(N,1);
trainIndex(1:T) = 1;   % last one-tenth of samples are used as test
testIndex = zeros(N,1);
testIndex((T+1) : N) = 1;
trainData = player_WS_inst(trainIndex==1,:);
trainLabel = player_WS_label(trainIndex==1,:);
testData = player_WS_inst(testIndex==1,:);
testLabel = player_WS_label(testIndex==1,:);

% Parameter selection using 10-fold cross validation
bestcv = 0;
for log2c = -1:1:3
  for log2g = -4:1:2
    cmd = ['-q -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
    cv = get_cv_ac(trainLabel, trainData, cmd,10);
    if (cv >= bestcv)
      bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
    end
    fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
  end
end

% Train the SVM in one-vs-rest (OVR) mode

%parameter t kernel, g gamma, c cost
%t = 0 -- Linear: K(u,v)=u'*v
%t = 1 -- Polynomial: K(u,v)=(gamma*u'*v + coef0)^d
%t = 2 -- RBF: K(u,v)=exp(-gamma*||u-v||^2)
%t = 3 -- sigmoid: K(u,v)=tanh(gamma*u'*v + coef0)
 
bestParam = ['-t 0 -q -c', num2str(bestc), ' -g ', num2str(bestg)];
model = ovrtrain(trainLabel, trainData, bestParam);
 
% Classify samples using OVR model
[predict_label, accuracy, prob_values] = ovrpredict(testLabel, testData, model);
fprintf('Accuracy = %g%%\n', accuracy * 100);
toc