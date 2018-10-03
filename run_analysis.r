rm(list=ls())
setwd("~/Documents/Getting and tidy data/Peer_Review_Getting and Cleaning Data/UCI HAR Dataset")

#Merge the training and the test sets to create one date set
subject_train <- read.table("./train/subject_train.txt")
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
train_subject <- cbind(subject_train, y_train, x_train)

subject_test <- read.table("./test/subject_test.txt")
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
test_subject <- cbind(subject_test, y_test, x_test)

all_data <- rbind(train_subject, test_subject)

#Extract only the measurements on the mean and standard deviation for each measurement
features <- read.table("features.txt")
colnames(all_data) <- c("subject", "activity", as.character(features[,2]))
dat_mean <- grep("mean", colnames(all_data), value = TRUE)
dat_std <- grep("std", colnames(all_data), value = TRUE)
all_data_2 <- all_data[,c("subject", "activity", dat_mean, dat_std)] 


#Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("activity_labels.txt")
library(mgsub)
all_data_2$activity <- mgsub(all_data_2$activity, 1:6, activity_labels[,2])

#Creates a second, independent tidy data set with the average of each variables for each activity and each subject
library(reshape2)
all_data_3 <- melt(all_data_2, id = c("subject", "activity"))
all_data_4 <- dcast(all_data_3, subject + activity ~ variable, mean)

#Save the tidy_data.txt file
write.table(all_data_4, file = "tidy_data.txt",row.name=FALSE, sep = '\t')


         