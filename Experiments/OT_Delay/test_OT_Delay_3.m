addpath(genpath('../../../'));

%% Load Dataset ----------
% Download the dataset from https://www.dropbox.com/s/32lz1vnjx3bg9hd/airline.pickle.zip
% and then use the pickle_to_mat.ipynb utility.
load('dataset/airline.mat');

%% Features extraction ----------
month = double(transpose(dataset.Month));
dayOfMonth = double(transpose(dataset.DayofMonth));
dayOfWeek = double(transpose(dataset.DayOfWeek));
depTime = transpose(dataset.DepTime);
depTime = 60 * floor(depTime/100) + mod(depTime, 100);
arrTime = transpose(dataset.ArrTime);
arrTime = 60 * floor(arrTime/100) + mod(arrTime, 100);
airTime = transpose(dataset.AirTime);
distance = double(transpose(dataset.Distance));
planeAge = transpose(dataset.plane_age);
X = [month dayOfMonth dayOfWeek depTime arrTime airTime distance planeAge];
y = transpose(dataset.ArrDelay);

%% Subsampling ----------
subIdx = month <= 4;
X = X(subIdx, :);
y = y(subIdx);

%% Data shuffling
[n, ~] = size(X);
if ~exist('dataset_shuffling' , 'var')
    dataset_shuffling = randperm(n, n);
    disp("Random shuffling X...");
end
X = X(dataset_shuffling, :);
y = y(dataset_shuffling);

%% Data splitting ----------
ts_size = 100000;
Xvs = X(1:ts_size, :);
Yvs = y(1:ts_size);
Xts = X(ts_size+1:2*ts_size, :);
Yts = y(ts_size+1:2*ts_size);
Xtr = X(2*ts_size+1:end, :);
Ytr = y(2*ts_size+1:end);
[nTr, ~] = size(Xtr);

%% Centering ----------
renorm = @(W, Z) W*(diag(1./(std(Z))));
recenter = @(W, Z) (renorm(W - ones(size(W,1),1)*mean(Z),Z));

XtrNotCentered = Xtr;
Xtr = recenter(XtrNotCentered, XtrNotCentered);
Xvs = recenter(Xvs, XtrNotCentered);
Xts = recenter(Xts, XtrNotCentered);

%% Find best sigma params ----------
sigmas = fminunc(@(sigma) minProblem(Xvs, Yvs, ...
    [sigma(1), sigma(2), sigma(3), ...
    sigma(4), sigma(5), sigma(6), sigma(7), sigma(8)]), ...
    [1 1 1 1 1 1 1 1]);

kernel = gaussianKernel_MWs(diag(exp(sigmas)));

%% Nystrom centers ----------
numberOfCenters = 10000;
if ~exist('centersI' , 'var')
    centersI = randperm(nTr, numberOfCenters);
    disp("Random picking centers...");
end
C = Xtr(centersI, :);

%% Hyperparameters ----------
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

%% Function to be minimized to estimate sigma parameters ----------
function minFunc = minProblem(Xvs, Yvs, sigmas)
    kernel = gaussianKernel_MWs(diag(exp(sigmas)));
    c = (kernel(Xvs, Xvs))^(-1) * Yvs;
    w = transpose(Xvs) * c;
    Ypred = Xvs * w;
    minFunc = sum((Yvs - Ypred).^2);
end