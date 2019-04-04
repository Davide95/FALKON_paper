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

%% Nystrom centers ----------
numberOfCenters = 10000;
if ~exist('centersI' , 'var')
    centersI = randperm(nTr, numberOfCenters);
    disp("Random picking centers...");
end
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

    numBlocks = 5;
    tic; Ypred = KtsProd(cobj{1}, cobj{3}, alpha, numBlocks, cobj{4}); toc
    
    RMSE = sqrt(mean((cobj{2} - Ypred).^2));
    fprintf('Iteration: %d, RMSE: %f.\n', counter, RMSE);
    
    new_cobj = cobj;
	counter = counter + 1;
end