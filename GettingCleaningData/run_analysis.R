#---------------------------------------------------------------------------------------------------------------
## Getting and cleaning data: Course Project

# The objective of this course project is to prepare tidy data for future analysis.
#---------------------------------------------------------------------------------------------------------------

#========================================  0. COLLECT THE DATA  ==================================================

# We use a data set collected from the accelerometers from the Samsung S smartphone. The data was collected from 30
# voluteers, each performing one of six activities. The data was split into a training and a testing data set and the 
# the splitting was carried out by taking the data corresponding to 70% of the voluteers to make up the training set.
# The testing set was made up of the data correspondong to the remaining volunteers.
# We are given a zip folder containing relevant data. Here, we download and unzip the contents in R.

rm(list=ls())
wd <- dirname(sys.frame(1)$ofile)
setwd(dir = wd)

fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./data.zip")){
  download.file(fileurl, destfile = "./data.zip", method = "curl")
}
unzip("./data.zip")

# First glance at the data - the UCI HAR Dataset includes the following:
# 1. Activity labels (activity_labels.txt): codebook assigning a number 1-6 to each activity monitored (6 activities)
# 2. Features (features.txt): a list of features used (561 features)
# 3. Test set:
#   3.1 subject_train.txt: ranges from 1-30 and corresponds to the volunteer ID
#   3.2 X_test.txt: contains observations corresponding to the variables (features) measured 
#   3.3 y_test.txt: true activity labels 
# 4. Train set: as in 3 above
# 5. Note that *inertial signals* data is not used in this project

# We are now ready to start on the project deliverables.

#========================================  1. MERGE TRAINING AND TEST DATA SETS  ==================================================

# Our training and test data are given in X_train.txt and X_test.txt, respectively. However, as it is, the data does not comply
# with what we expect from a *tidy data* set. We therefore proceed as follows:
# I. Merge train and test data sets to create a signle data set called "dataset".
# II. Merge subject id's from test and train and append a subject ID column to "dataset"
# III. Merge activity labels from test and train and append an activity label column to "dataset"
# IV. Add column names to dataset

#================================================================================================================================= 

# I. Merge Xtest and Xtrain data sets

features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, colClasses = c("integer", "character"))
features <- features[,2] #vector of features names

Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)

dataset <- rbind(Xtrain, Xtest)

# # II. Add subject id column to dataset
# 
 subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
 subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
# 
subjectID <- rbind(subjecttrain, subjecttest)
dataset <- cbind(dataset, subjectID)

# # III. Add label column to dataset

ytest <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
 
y <- rbind(ytrain, ytest)
dataset <- cbind(dataset, y)

# IV. Add column names to dataset

features <- c(features, "subjectID", "activity_label")
features <- cbind(features)

colnames(dataset) <- features

# We now have a complete dataset of 563 variables (561 features, subject ID, and activity labels)

#========================================  2. SUBSET SELECTED COLUMNS  ================================

# Note that in our merged data frame, we have 561 features and, in this part of the exercise, we are 
# interested in those features that either give a mean or std statistic. We therefore need to subset
# according to variables which include "mean" or "std" in the feature names.

#=======================================================================================================

# We proceed as follows:
# 1. We already have a vector with the features names. The indices correspond to the number of columns in our
# data frame "dataset". We read through our features vector to obtain the indices of those features that give the
# mean or std of a measurement.

# we want to keep features which have -mean() and -std() (nospaces) in the string:
featuresind <- grep("-mean\\(\\)|-std\\(\\)", features, value = FALSE) # note: \\  = no space

# 2. We subset by keeping the columns numbers corresponding to the indices from step 1 as well as the last 2 
# columns corresponding to subjectID and activity label
colstokeep <- c(featuresind, 562, 563)

DF <- dataset[, colstokeep]


#===================================  3. ADD DESCRIPTIVE NAMES TO ACTIVITY LABELS  ================================

# Currently, the activity_label variable is given a value from 1 to 6 corresponding to one of six activities
# measured. We would like to replace the numerical value with the descriptive name attached to each number.

# Read in the activity labels information from the relevant text file (activity_labels.txt) and give the name 
# "activity_label" to the integer value corresponding to activity type so that we can merge our data frame (DF) with
# the activity data frame by the column "activity_label"
#=======================================================================================================

activity <- read.table("./UCI HAR Dataset/activity_labels.txt",
                       header = FALSE, colClasses = c("integer", "character"))
colnames(activity) <- c("activity_label", "Activity") 

# Merge by "activity_label"
library(dplyr)
DF <- merge(DF, activity, by = intersect(names(DF), names(activity)), all = TRUE)
DF <- dplyr::select(DF, -activity_label) # remove old activity_label column

#===================================  4. DESCRIPTIVE VARIABLE NAMES  ================================

# Part of what constitutes a tidy data set is that the features are appropriately given human readable
# names which is something that our current data frame, DF, is lacking. 

# Observations & changes to be implemented:

# The 't' prefix denotes time - We will change to Time-
# The 'f' prefix denotes frequenct - We will change to Freq-
# The mean() and std() will be replaced by Mean and StDev, respectively
# Duplicate of "Body" in variable name removed where it exists
# Finally, we'll change "Mag" to "Magnitude" 
# The above remove some ambiguity in the names. The interested user may refer to the codebook for more details
# on the resulting data set. We will be using the *gsub* command for the aforementioned changes.
#=======================================================================================================


namevec <- names(DF)
namevec <- gsub("^t", "Time-", namevec)
namevec <- gsub("^f", "Freq-", namevec)
namevec <- gsub("mean\\(\\)", "Mean", namevec)
namevec <- gsub("std\\(\\)", "StDev", namevec)
namevec <- gsub("std\\(\\)", "StDev", namevec)
namevec <- gsub("Mag", "Magnitude", namevec)
namevec <- gsub("(Body){2}", "Body", namevec)

colnames(DF) <- namevec 

#============================== 5. AVERAGED DATA SET PER ACTIVITY PER SUBJECT  ================================

# The final part of the course project requires the creation of a second data set (we call this aggdata) where we
# have a data frame wherein we have the averaged values of each variable grouped by depending on labelled
# activity type (there are 6) and for each subject (there are 30 volunteers). 

#=======================================================================================================


DF$Activity <- as.factor(DF$Activity)
DF$subjectID <- as.factor(DF$subjectID)

# Using the aggregate function we find the mean value of all variables in DF (excluding our factor variables
# subjectID and Activity) depenging on activity type and subject ID.
sum(is.na(DF)) # before we compute the mean, we check that there are no missing values.

aggdata <- aggregate(DF[-c(67:68)], by = list(subjectID = DF$subjectID, Activity = DF$Activity),
                    FUN = mean)

# Finally, as per the instructions, we write the tidy data set (aggdata) to a text file.

write.table(aggdata, file = "tidy_data.txt", row.names = FALSE, sep = "\t")



