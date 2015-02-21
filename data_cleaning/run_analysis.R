# run_analysis.R
# Created February 22, 2015
# Course: Cleaning Data, Coursera
# Author: Amy Gelletich
#
# This script starts with the assumption that the Samsung data is available 
# in the working directory in an unzipped UCI HAR Dataset folder".
# This script: 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for 
#    each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.

# Read in files to R as tables
subj_test<-read.table("UCI HAR Dataset/test/subject_test.txt")# 24 people
x_test<-read.table("UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")

subj_train<-read.table("UCI HAR Dataset/train/subject_train.txt") # Values 1-30, for person id
x_train<-read.table("UCI HAR Dataset/train/X_train.txt") # Std values?
y_train<-read.table("UCI HAR Dataset/train/y_train.txt") # Values 1-6, for activity types

features<-read.table("UCI HAR Dataset/features.txt")

# Merge datasets. First testing, then training. Merge done using rbind/cbind. 
test<-cbind(subj_test,y_test,x_test)
train<-cbind(subj_train,y_train,x_train)
data_merged<-rbind(test,train)

# Name the measurement columns using the features.txt file
names(data_merged) <- c("Subject","Activity",as.character(features$V2))

# Get only the measurement columns that have -mean or -std in them
# Note: the '-' part was included because some variables used the mean
# in their calculation, but were not means themselves.
data_mean_std<-data_merged[ , grepl("-mean|-std", colnames(data_merged))]
#grep lost the activity and subject columns, so add them back in
data_mean_std2<-cbind(data_merged[,1:2],data_mean_std)

# Use gsub and activity.txt to create Activity names
data_activity<-gsub(1,"Walking",data_mean_std2$Activity)
data_activity<-gsub(2,"Walking_Upstairs",data_activity)
data_activity<-gsub(3,"Walking_Downstairs",data_activity)
data_activity<-gsub(4,"Sitting",data_activity)
data_activity<-gsub(5,"Standing",data_activity)
data_activity<-gsub(6,"Laying",data_activity)
data_mean_std2$Activity<-data_activity

# I renamed the variables to camel cases and corrected some errors in 
# the original features because I felt that would make it easier to see 
# the data was tidy
# Hadley Wickham, discusses his philosophy of tidy data in his 'Tidy Data' paper
# http://vita.had.co.nz/papers/tidy-data.pdf
data_rename<-gsub("tBody","TimeBody",names(data_mean_std2))
data_rename1<-gsub("tGravity","TimeGravity",data_rename)
data_rename2<-gsub("fBody","FrequencyBody",data_rename1)
data_rename3<-gsub("BodyBody","Body",data_rename2)
data_rename4<-gsub("-m","M",data_rename3)
data_rename5<-gsub("-s","S",data_rename4)
data_rename6<-gsub("\\()","",data_rename5)
data_rename7<-gsub("-","",data_rename6)
data_renamed<-data_mean_std2
names(data_renamed)<-data_rename7

# Clean up some of the variables
remove(data_mean_std,data_mean_std2,data_merged,features,subj_test,subj_train)
remove(test,train,x_test,x_train,y_test,y_train)

# Use the aggregate function to find the mean and standard deviation for all the data
tidy_data <- aggregate(data_renamed[,3:ncol(data_renamed)], by=list(subject=data_renamed$Subject,label = data_renamed$Activity), mean)

# Write the tidy data to a text file for upload
write.table(format(tidy_data, scientific=TRUE), "tidy_data.txt", row.names=FALSE, col.names=FALSE, quote=2)