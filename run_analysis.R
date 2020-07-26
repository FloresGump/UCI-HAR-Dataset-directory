## Download zip from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## Descompress this file and keep into UCI HAR Dataset directory
## This scrip run in that directory

## Step1 .- Read feature names and activity labels
features_name <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")
 
## Step2 .- Read test data
test1 <- read.table("test/X_test.txt", col.names = features_name$V2)
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
activity_test <- read.table("test/y_test.txt", col.names = "activity")

for (i in activity_labels$V1) {
        activity_test$activity[which (activity_test$activity ==i)] <- activity_labels$V2[i]
}
set <- as.vector(replicate(nrow(test1), "test"))
test_final <- cbind(activity_test$activity,subject_test$subject,set,test1)
colnames(test_final)[c(1,2)] <- c("activity", "subject")

## Step3 ,. Read train data
train1 <- read.table("train/X_train.txt", col.names = features_name$V2)
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
activity_train <- read.table("train/y_train.txt", col.names = "activity")

for (i in activity_labels$V1) {
        activity_train$activity[which (activity_train$activity ==i)] <- activity_labels$V2[i]
}
set <- as.vector(replicate(nrow(train1), "train"))
train_final <- cbind(activity_train$activity, subject_train$subject, set, train1)
colnames(train_final)[c(1,2)] <- c("activity", "subject")

## Step4.- Merge train and test data and do averages analysis
global_data <- rbind(train_final, test_final)

library(dplyr)
struct_data <- global_data %>% group_by(activity, subject) %>% summarise_each(funs(mean), c(4:562))

write.table(struct_data, "struct_data.txt", row.names = FALSE, col.names = TRUE)