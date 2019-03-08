addpath(genpath('../../'));

%% Load Dataset ----------
if or(~exist('X' , 'var'), ~exist('y' , 'var'))
    load('dataset/X.mat');
    load('dataset/y.mat');
    disp('Dataset loaded from secondary memory.')
end

[n, ~] = size(X);

%% Data shuffling ----------
dataset_shuffling = randperm(n, n);
X = X(dataset_shuffling, :);
y = y(dataset_shuffling, :);

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

% Hyperparameter optimization ----------
cobj = [];
callback = @(alpha, cobj) [];

%% Training ----------
memToUse = [];
useGPU = 1;

tic;
alpha = falkon(Xtr, C, kernel, Ytr, lambda, iterations, ...
    cobj, callback, ...
    memToUse, useGPU);
toc;

%% Testing

% TODO: what 20 is?
Ypred = KtsProd(Xts, C, alpha, 20, kernel);

RMSE = sqrt(mean((Yts - Ypred).^2));
disp(RMSE);
