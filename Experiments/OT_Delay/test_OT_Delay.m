addpath(genpath('../../../'));

%% Load Dataset ----------
load('dataset/X.mat');
load('dataset/y.mat');

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
numberOfCenters = 10000;
centersI = randperm(nTr, numberOfCenters);
C = Xtr(centersI, :);

%% Hyperparameters ----------
sigma = 2;
kernel = gaussianKernel(sigma);
lambda = 1e-16;
iterations = 10;

%% Training ----------
memToUse = [];
useGPU = 1;
cobj = {Xvs, Yvs, C, kernel};
alpha = falkon(Xtr, C, kernel, Ytr, lambda, iterations, ...
    cobj, @hyperpars_tuning, ...
    memToUse, useGPU);

%% Testing
numBlocks = 5;
Ypred = KtsProd(Xts, C, alpha, numBlocks, kernel);

RMSE = sqrt(mean((Yts - Ypred).^2));
fprintf("RMSE test set: %f.\n", RMSE);

%% Custom functions ----------
function new_cobj = hyperpars_tuning(alpha, cobj)
    persistent counter
    if isempty(counter)
        counter = 0;
    end
    counter = counter + 1;

    numBlocks = 5;
    tic; Ypred = KtsProd(cobj{1}, cobj{3}, alpha, numBlocks, cobj{4}); toc
    
    RMSE = sqrt(mean((cobj{2} - Ypred).^2));
    fprintf('Iteration: %d, RMSE: %f.\n', counter, RMSE);
    
    new_cobj = cobj;
end
