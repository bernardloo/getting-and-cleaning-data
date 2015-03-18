#######################

#Bernardloo M3- Course Proj 

#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names. 

#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##############################

#set working directory
setwd("c:/A_R/3 CourseProj")

## create results folder in working directory
resultsfolder <- "results"

if(!file.exists(resultsfolder)){
    print("create results folder")
    dir.create(resultsfolder)
}


#read txt file and convert to data.frame
gettables <- function (filename,cols = NULL){
    print(paste("Getting table:", filename))
    f <- paste("UCI HAR Dataset",filename,sep="/")
    data <- data.frame()
    if(is.null(cols)){
        data <- read.table(f,sep="",stringsAsFactors=F)
    } else {
        data <- read.table(f,sep="",stringsAsFactors=F, col.names= cols)
    }
    data
}

#run features.txt file and check gettables
features <- gettables("features.txt")

#read data and build database
getdata <- function(type, features){
    print(paste("Getting data", type))
    subject_data <- gettables(paste(type,"/","subject_",type,".txt",sep=""),"id")
    x_data <- gettables(paste(type,"/","X_",type,".txt",sep=""),features$V2)
    y_data <- gettables(paste(type,"/","y_",type,".txt",sep=""),"activity")
    
    return (cbind(subject_data,y_data,x_data))
}

#run and check getdata for test and train datasets
    train <- getdata("train", features)
    test <- getdata("test", features)


#save the resulting data in the indicated folder
save_result <- function (data,name){
    print(paste("saving results", name))
    file <- paste("results", "/", name,".csv" ,sep="")
    write.csv(data,file)
}

#1) To Merge the train and the test sets to create one data set.

library(plyr)
data <- rbind(train, test)
data <- arrange(data, id)

#2) Extracts only the measurements on the mean and standard deviation for each measurement.
mean_n_stdDV <- data[,c(1,2,grep("std", colnames(data)), grep("mean", colnames(data)))]
save_result(mean_n_stdDV,"mean_and_stdDV")

#3) Uses descriptive activity names to name the activities in the data set
activity_labels <- gettables("activity_labels.txt")


#4) Appropriately labels the data set with descriptive variable names.
data$activity <- factor(data$activity, levels=activity_labels$V1, labels=activity_labels$V2)


#5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_dataset <- ddply(mean_n_stdDV, .(id, activity), .fun=function(x){ colMeans(x[,-c(1:2)]) })
colnames(tidy_dataset)[-c(1:2)] <- paste(colnames(tidy_dataset)[-c(1:2)], "_mean", sep="")
save_result(tidy_dataset,"tidy_dataset")
