format = '%d%d%d%d%d%d%d%d%C%d%s%d%d%d%d%d%C%C%d%d%d%d%C%d%d%d%d%d%d';
table = readtable('dataset/2008.csv', ...
    'TreatAsEmpty', 'NA', ...
    'EmptyValue', 0, ...
    'Format', format);
clear format;

% Filter data from January to April
table = table(table.Month <= 4, :);

numericalCols = table2array(table(:, {'Distance', 'AirTime', ...
    'DayOfWeek', 'DayofMonth', 'Month', 'Year'}));
timeCols = intHmmToMinutes(table2array(table(:, ...
    {'DepTime', 'ArrTime'})));
y = table2array(table(:, 'ArrDelay'));
clear table;

save('dataset/y.mat','y');

X = horzcat(numericalCols, timeCols);
clear numericalCols timeCols;
save('dataset/X.mat','X');

function colsOut = intHmmToMinutes(colsIn)
    hours = floor(colsIn / 100);
    minutes = colsIn - hours*100;
    
    colsOut = hours*60 + minutes;
end