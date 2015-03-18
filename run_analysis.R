#######################

#Bernardloo 3- Course Proj 

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


#run and check gettables
features <- gettables("features.txt")
