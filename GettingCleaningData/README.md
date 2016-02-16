# DataScie3

## Getting and cleaning data course project

### Introduction

This assignment involves the study of data collected from wearable computing and in particular data collected from the
accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to
prepare tidy data that can be used for later analysis.

The required articles to be submitted are:

1) a tidy data set as described below;

2) a link to a Github repository with your script for performing the analysis;

3) a code book that describes the variables, the data, and any transformations or work that you performed
to clean up the data called CodeBook.md.

The R script **run_analysis.R** includes code to do the following:

* Merges the training and the test sets to create one data set; 
* Extracts only the measurements on the mean and standard deviation for each measurement;
* Uses descriptive activity names to name the activities in the data set;
* Appropriately labels the data set with descriptive variable names;
* From the data set in the previous step, creates a second, independent tidy data set with the average of
each variable for each activity and each subject.

The tidy data is saved as a text file under the name **tidy_data.txt** and is also included in this repo.
