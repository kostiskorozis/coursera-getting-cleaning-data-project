# coursera-getting-cleaning-data-project

## run_analysis.R does all the work in the following order:

- downloading, unzipping and reading in activity and feature tables
- extracting just the mean and standard deviation values from 500+ columns down to 79
- polishing the strings in activities and features table to be more descriptive
- reading and subsetting train and test data
- column binding X Y and subject table for each set and then row binding to merge train and test data
- using reshape2 package to melt and cast the merged data into a tidy set grouped for pairs of activity and subject and calculating the mean for each value
- finally writing the tidy set into a .txt file
