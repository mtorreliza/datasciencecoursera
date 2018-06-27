
#Download Zip File
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,"UCI HAR Dataset.zip",mode = "wb")
unzip("UCI HAR Dataset.zip")

#Read Data files
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
activity_labels <-  read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

#Merges the training and the test sets to create one data set
measurement <- rbind(X_test,X_train)
names(measurement) <- features$V2
activity <- rbind(y_test,y_train)
names(activity) <- "activity"
subject <- rbind(subject_test,subject_train)
names(subject) <- "subject"

#Extracts only the measurements on the mean and standard deviation for each 
#measurement

MeanStd <- grep("mean()|std()",features$V2)
measurement <- measurement[,MeanStd]

dataset <-cbind(subject,activity,measurement)

#Uses descriptive activity names to name the activities in the data set

factor <- factor(dataset$activity)
levels(factor) <- activity_labels[,2]
dataset$activity <- factor

#From the data set in step 4, creates a second, independent tidy data set with 
#the average of each variable for each activity and each subject

library(reshape2)
dataset1 <- melt(dataset,id=c("subject","activity"),measure.vars = names(measurement))
dataset2 <- dcast(dataset1, subject + activity ~ variable, mean)
dataset_final <- melt(dataset2,id=c("subject","activity"),measure.vars = names(measurement))
colnames(dataset_final)[c(3,4)]<-c("measure","average")

write.table(dataset_final,"tidy_data.txt")
