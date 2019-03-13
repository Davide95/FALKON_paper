addpath(genpath('../../../'));

%% Load Dataset ----------
if or(~exist('X' , 'var'), ~exist('y' , 'var'))
    load('dataset/X.mat');
    load('dataset/y.mat');
    disp('Dataset loaded from secondary memory.')
end

%% Data splitting ----------
ts_size = 100000;
Xvs = X(1:ts_size, :);
Yvs = y(1:ts_size);
Xts = X(ts_size+1:2*ts_size, :);
Yts = y(ts_size+1:2*ts_size);
Xtr = X(2*ts_size+1:end, :);
Ytr = y(2*ts_size+1:end);

[nTr, ~] = size(Xtr);

%% Clean unused variables ----------
clear X y; % Remove big matrixes from workspace

%% Centering ----------
renorm = @(W, Z) W*(diag(1./(std(Z))).^2);
recenter = @(W, Z) (renorm(W - ones(size(W,1),1)*mean(Z),Z));

XtrNotCentered = Xtr;
Xtr = recenter(XtrNotCentered, XtrNotCentered);
Xvs = recenter(Xvs, XtrNotCentered);
Xts = recenter(Xts, XtrNotCentered);
clear XtrNotCentered; % Useless, it's used only to recenter everything

%% Nystrom centers ----------
numberOfCenters = 1480;
centersI = randperm(nTr, numberOfCenters);
C = Xtr(centersI, :);

%% Hyperparameters ----------
sigma = 4;
kernel = gaussianKernel(sigma);
lambda = 0.00067585821;
iterations = 6;

%% Training ----------
memToUse = [];
useGPU = 1;
counter = 1;
alpha = falkon(Xtr, C, kernel, Ytr, lambda, iterations, ...
    counter, @hyperpars_tuning, ...
    memToUse, useGPU);

%% Testing
numBlocks = 5;
Ypred = KtsProd(Xts, C, alpha, numBlocks, kernel);

RMSE = sqrt(mean((Yts - Ypred).^2));
fprintf("RMSE test set: %f.", RMSE);

%% Custom functions ----------
function new_counter = hyperpars_tuning(alpha, counter)
    numBlocks = 5;
    tic; Ypred = KtsProd(Xvs, C, alpha, numBlocks, kernel); toc
    
    RMSE = sqrt(mean((Yvs - Ypred).^2));
    fprintf('Iteration: %d, RMSE: %f.\n', counter, RMSE);
    
    new_counter = counter + 1;
end
