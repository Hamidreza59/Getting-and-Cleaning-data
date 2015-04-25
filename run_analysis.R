## This is a R script name run_analysis.R that does the following:
## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(plyr)
library(reshape2)


## Step 1
## Loading and merging traing and test datasets
trainX <- read.table("X_train.txt")
trainY <- read.table("y_train.txt")
testX <- read.table("X_test.txt")
testY <- read.table("y_test.txt")
S_train <- read.table("subject_train.txt")
S_test <- read.table("subject_test.txt")

# combine training and testing datasets
x_data <- rbind(trainX, testX)
y_data <- rbind(trainY, testY)
S_data <- rbind(S_train, S_test)

## Step 2
##  Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("features.txt")

## we want get only those column that has mean and std in names with grep function
extract_features <- grep("mean|std", features[, 2])

## change datasets variables name
names(x_data) <- features[, 2]
x_data <- x_data[, extract_features]

## Step 3
## Uses descriptive activity names to name the activities in the data set

Activity <- read.table("activity_labels.txt")
y_data[,2] <- Activity[y_data[,1], 2]


## Step 4
## Appropriately labels the data set with descriptive variable names. 

## Change y_data variable name
names(y_data) <- c("Activity_id", "Activity")

## Change subject data variable name
names(S_data) <- "Subject"

# Combine all data sets together
my_data <- cbind(x_data, y_data, S_data)

# Step 5
## Creates a tidy data set with the average of each variable for each activity and each subject.

## Use melt and dcast function in for reshaping data
colnames <- names(x_data)
melting <- melt(my_data, id=c("Activity", "Subject"), measure.vars = colnames)
tidy_data <- dcast(melting, Subject + Activity ~ variable, mean)

## writing the R file 
write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)
