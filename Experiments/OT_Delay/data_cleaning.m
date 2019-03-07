format = '%d%d%d%d%d%s%d%s%C%d%d%d%d%d%d%d%C%C%d%d%d%d%C%d%d%d%d%d%d';
table = readtable('dataset/1987.csv', ...
    'TreatAsEmpty', 'NA', ...
    'EmptyValue', 0, ...
    'Format', format);
clear format;

numericalCols = table2array(table(:, {'Distance', 'AirTime', ...
    'DayOfWeek', 'DayofMonth', 'Month', 'Year'}));
timeCols = intHmmToMinutes(table2array(table(:, ...
    {'DepTime', 'ArrTime'})));
y = table2array(table(:, 'ArrDelay'));
clear table;

save('dataset/y.mat','y');
clear y;

X = horzcat(numericalCols, timeCols);
clear numericalCols timeCols;
save('dataset/X.mat','X');

function colsOut = intHmmToMinutes(colsIn)
    hours = floor(colsIn / 100);
    minutes = colsIn - hours*100;
    
    colsOut = hours*60 + minutes;
end