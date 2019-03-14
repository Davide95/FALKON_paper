# Airline on-time performance

The experiment is composed of different phases:

## Data preparation

Due to the fact that the size of the dataset is huge, it will not be uploaded in the repository.

The datasets can be downloaded from [http://stat-computing.org/dataexpo/2009/2008.csv.bz2](http://stat-computing.org/dataexpo/2009/2008.csv.bz2) and [http://stat-computing.org/dataexpo/2009/plane-data.csv](http://stat-computing.org/dataexpo/2009/plane-data.csv).

# Data cleaning

Data cleaning is performed through the [data_cleaning.m](data_cleaning.m) script.

We'll consider only flights between January and April in 2008.

The result is saved onto `dataset/X.mat` and `dataset/y.mat` after its execution.

# Run experiment

Execute the script [test_OT_Delay.m](test_OT_Delay.m) to run the training.

# Result
With 10K centers, after hyperparameters tuning, the RSME of the test set is equals to 36.73.