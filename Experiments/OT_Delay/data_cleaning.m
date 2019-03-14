%% Load Dataset ----------
formatData = '%d%d%d%d%d%d%d%d%C%d%s%d%d%d%d%d%C%C%d%d%d%d%C%d%d%d%d%d%d';
table = readtable('dataset/2008.csv', ...
    'TreatAsEmpty', 'NA', ...
    'EmptyValue', 0, ...
    'Format', formatData);

%% Filter data from January to April ----------
table = table(table.Month <= 4, :);

%% Supervisory signal extraction ----------
y = double(table2array(table(:, 'ArrDelay')));

%% Manual features selection ----------
numericalCols = table2array(table(:, {'Distance', 'AirTime', ...
    'DayOfWeek', 'DayofMonth', 'Month'}));
timeCols = intHmmToMinutes(table2array(table(:, ...
    {'CRSDepTime', 'CRSArrTime'})));

%% Training data extraction ----------
X = double(horzcat(numericalCols, timeCols));

%% Data shuffling
[n, ~] = size(X);
dataset_shuffling = randperm(n, n);
X = X(dataset_shuffling, :);
y = y(dataset_shuffling, :);

%% Data saving
save('dataset/X.mat','X');
save('dataset/y.mat','y');

%% Custom functions ----------
function colsOut = intHmmToMinutes(colsIn)
    hours = floor(colsIn / 100);
    minutes = colsIn - hours*100;
    
    colsOut = hours*60 + minutes;
end