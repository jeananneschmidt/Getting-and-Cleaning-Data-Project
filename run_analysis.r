#GCD Project
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "SmartPhoneData")
setwd("Z:/Public/Departments/Research/JA Schmidt 2018/Homegrown/Homegrown200")
library(dplyr)
library(tidyverse)
#getwd()

#test folder
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
#View(x_test)

y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
#View(y_test)

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")


#train folder
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
#View(x_train)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
#View(y_train)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")


#read in column names
HARVariables <- read.table("./UCI HAR Dataset/features.txt")
#Remove first column
HARVariables <- subset(HARVariables, select = -V1)
HARactivities <- read.table("./UCI HAR Dataset/activity_labels.txt")

#Merge the training and test sets to create one data set
#rbind: newdf <- rbind(data1, data2)
#y=labels  x=data  subject=?

merged_HAR_X <- rbind(x_test, x_train)
#Appropriately labels the data set with descriptive variable names. 
colnames(merged_HAR_X) <- HARVariables$V2


merged_HAR_Y <- rbind(y_test, y_train)
names(merged_HAR_Y)[1]<-"Y"
glimpse(merged_HAR_Y)
class(merged_HAR_Y)
mergedY_HAR_withactivities <- left_join(merged_HAR_Y, HARactivities, by = c("Y" = "V1"))
glimpse(mergedY_HAR_withactivities)

merged_HAR_S <- rbind(subject_test, subject_train)
names(merged_HAR_S)[1]<-"Subject"
tidydf_HAR <- cbind(merged_HAR_X, merged_HAR_S)
tidydf_HAR <- cbind(tidydf_HAR, mergedY_HAR_withactivities)
glimpse(tidydf_HAR)

#Uses descriptive activity names to name the activities in the data set
names(tidydf_HAR)[564]<-"Activities"

#Extracts only the measurements on the mean and standard deviation for each measurement.
keep.variables = tidydf_HAR[, grepl("mean|std|Subject|Activities", names(tidydf_HAR))]
class(keep.variables)
glimpse(keep.variables)

#From the data set in step 4, creates a second, independent tidy data set with the average
total_mean <- keep.variables %>%
  group_by(Activities, Subject) %>% 
  summarize_all(funs(mean))

write.table(total_mean, file = "tidydata.txt", row.names = FALSE)

