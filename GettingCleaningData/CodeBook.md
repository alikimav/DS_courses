# Getting and cleaning data course project: Code Book

## Data description

We use a data set collected from the accelerometers from the Samsung S smartphone. The data was collected from 30
voluteers within an age bracket of 19-48 years, each performing one of six activities wearing a smartphone (Samsung Galaxy S II) on the waist:

1) LAYING
2) SITTING
3) STANDING
4) WALKING
5) WALKING_DOWNSTAIRS
6) WALKING_UPSTAIRS

Using the smartphone's embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record, the following is provided:

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

The data was split into a training and a testing data set. The splitting was carried out by taking the data corresponding to 70% of the voluteers to make up the training set leaving the remaining 30% to make up the testing set.

### UCI HAR Dataset

The UCI HAR Dataset includes the following:
1. Activity labels (activity_labels.txt): codebook assigning a number 1-6 to each activity monitored (6 activities)
2. Features (features.txt): a list of features used (561 features)
3. Test set:
  3.1 subject_train.txt: ranges from 1-30 and corresponds to the volunteer ID
  3.2 X_test.txt: contains observations corresponding to the variables (features) measured (see below for features info) 
  3.3 y_test.txt: true activity labels 
4. Train set: as in 3 above for training set
5. Note that **inertial signals** data are not used in this project

### Feature Selection 

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'

## Project deliverables

### 1. MERGE TRAINING AND TEST DATA SETS  

Our training and test data are given in **X_train.txt** and **X_test.txt**, respectively. However, as it is, the data does not comply with what we expect from a *tidy data* set.

We therefore proceed as follows:
I. Merge train and test data sets to create a signle data set called "dataset".
II. Merge subject id's from test and train and append a subject ID column to "dataset"
III. Merge activity labels from test and train and append an activity label column to "dataset"
IV. Add column names to dataset

### 2. SUBSET SELECTED COLUMNS

Note that in our merged data frame, we have 561 features and, in this part of the exercise, we are 
interested in those features that either give a mean or std statistic. We therefore need to subset
according to variables which include "mean" or "std" in the feature names.

We proceed as follows:
I. We already have a vector with the features names. The indices correspond to the number of columns in our
data frame "dataset". We read through our features vector to obtain the indices of those features that give the
mean or std of a measurement.
II. We subset by keeping the columns numbers corresponding to the indices from step 1 as well as the last 2 
columns corresponding to subjectID and activity label

### 3. ADD DESCRIPTIVE NAMES TO ACTIVITY LABELS

Currently, the **activity_label** variable is given a value from 1 to 6 corresponding to one of six activities
measured. We would like to replace the numerical value with the descriptive name attached to each number.
Read in the activity labels information from the relevant text file (*activity_labels.txt*) and give the name 
"activity_label" to the integer value corresponding to activity type so that we can merge our data frame (DF) with
the activity data frame by the column "activity_label"

### 4. DESCRIPTIVE VARIABLE NAMES 

Part of what constitutes a tidy data set is that the features are appropriately given human readable
names which is something that our current data frame, DF, is lacking. 

Observations & changes to be implemented:

I. The 't' prefix denotes time - We will change to Time-
II. The 'f' prefix denotes frequenct - We will change to Freq-
III. The mean() and std() will be replaced by Mean and StDev, respectively
IV. Duplicate of "Body" in variable name removed where it exists
V. Finally, we'll change "Mag" to "Magnitude" 

### 5. AVERAGED DATA SET PER ACTIVITY PER SUBJECT

The final part of the course project requires the creation of a second data set (we call this aggdata) where we
have a data frame wherein we have the averaged values of each variable grouped by depending on labelled
activity type (there are 6) and for each subject (there are 30 volunteers). 

Finally, as per the instructions, we write the tidy data set to a text file.
