# Airline on-time performance

The experiment is composed of different phases:

## Data preparation

Due to the fact that the size of the dataset is huge, it will not be uploaded in the repository.

The dataset can be downloaded from [http://stat-computing.org/dataexpo/2009/](http://stat-computing.org/dataexpo/2009/).

To merge all the files in a trivial way, you can:

1. import them in a dbms (e.g. http://stat-computing.org/dataexpo/2009/sqlite.html);
2. export them as a csv file (e.g. http://www.sqlitetutorial.net/sqlite-tutorial/sqlite-export-csv/).

# Data cleaning

Data cleaning is performed through the [data_cleaning.m](data_cleaning.m) script.

The result is saved onto `dataset/X.mat` and `dataset/y.mat` after its execution.
