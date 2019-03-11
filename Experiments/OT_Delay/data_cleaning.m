%% Load Dataset ----------
format = '%d%d%d%d%d%d%d%d%C%d%s%d%d%d%d%d%C%C%d%d%d%d%C%d%d%d%d%d%d';
table = readtable('dataset/2008.csv', ...
    'TreatAsEmpty', 'NA', ...
    'EmptyValue', 0, ...
    'Format', format);
clear format;

%% Filter data from January to April ----------
table = table(table.Month <= 4, :);

%% Supervisory signal extraction ----------
y = double(table2array(table(:, 'ArrDelay')));
save('dataset/y.mat','y');

%% Manual features selection ----------
numericalCols = table2array(table(:, {'Distance', 'AirTime', ...
    'DayOfWeek', 'DayofMonth', 'Month'}));
timeCols = intHmmToMinutes(table2array(table(:, ...
    {'DepTime', 'ArrTime'})));

%% Clean unused variables ----------
clear table;

%% Training data extraction ----------
X = double(horzcat(numericalCols, timeCols));
save('dataset/X.mat','X');

%% Clean unused variables ----------
clear numericalCols timeCols;

%% Custom functions ----------
function colsOut = intHmmToMinutes(colsIn)
    hours = floor(colsIn / 100);
    minutes = colsIn - hours*100;
    
    colsOut = hours*60 + minutes;
end