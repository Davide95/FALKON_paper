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
clear X y; % Remove big matrixes from workspace

%% Preprocessing
renorm = @(W, Z) W*(diag(1./(std(Z))).^2);
recenter = @(W, Z) (renorm(W - ones(size(W,1),1)*mean(Z),Z));

XtrNotCentered = Xtr;
Xtr = recenter(XtrNotCentered, XtrNotCentered);
clear XtrNotCentered; % Useless, it's used only to recenter everything