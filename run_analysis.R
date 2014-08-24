# This function cleans the test and train data_set and creates 2 data sets
# general_data has all data on mean and std measures for all subjects and activities
# tidy_data has only the averages of the mean and std measures per subject-activity-combination
#
# Function input is the relative or absolute location of the data home dir (/UCI HAR Dataset/)
# Function runs in two steps: 
#  - clean_samsung_data(loc='./') creates a general data set ehich can then be used with
#  - samsung_tidy_data(general_data) 

clean_samsung_data <- function(loc='./') {

#Include datatable library because this is useful for parsing
      library(data.table)

#set urls for different files
      url_features <- paste(loc,"features.txt",sep="")

      url_test_file <- paste(loc,"test/X_test.txt",sep="")
      url_activity_test <- paste(loc,"test/y_test.txt",sep="")
      url_subject_test <- paste(loc,"test/subject_test.txt",sep="")
      
      url_train_file <- paste(loc,"train/X_train.txt",sep="")
      url_activity_train <- paste(loc,"train/y_train.txt",sep="")
      url_subject_train <- paste(loc,"train/subject_train.txt",sep="")
      
      url_activity_labels <- paste(loc,"activity_labels.txt",sep="")


# Read test file and create Data Table
      df <- read.fwf(url_test_file,width=rep(16,each=561))
      DT_test <- data.table(df)
      print("First set parsed to DT") #For logging purposes
      print(Sys.time())

# Headers for columns come from features.txt
      col_nms<-read.fwf(url_features,width=48)
      setnames(DT_test,as.vector(col_nms[,1]))

# Get only columns with 'mean' or 'std'
      DT_test <- DT_test[,grep("mean()|std()", col_nms[,1]), with = FALSE]

# add column for activity
      activity <- read.fwf(url_activity_test,width=1)
      DT_test <- data.table(cbind(activity,DT_test))
      setnames(DT_test, "V1", "Act_number")

# add column for subject
      subject <- read.fwf(url_subject_test,width=2)
      DT_test <- data.table(cbind(subject,DT_test))
      setnames(DT_test, "V1", "Subject_number")

# Clear memory
      rm(df,activity,subject)
      print("First set ready for merge")
      print(Sys.time())



# Read train file and create Data Table
      df <- read.fwf(url_train_file,width=rep(16,each=561))
      DT_train <- data.table(df)
      print("Second set parsed to DT")
      print(Sys.time())

# Headers for columns come from features.txt
      setnames(DT_train,as.vector(col_nms[,1]))

# Get only columns with 'mean' or 'std'
      DT_train <- DT_train[,grep("mean()|std()", col_nms[,1]), with = FALSE]

# add column for activity
      activity <- read.fwf(url_activity_train,width=1)
      DT_train <- data.table(cbind(activity,DT_train))
      setnames(DT_train, "V1", "Act_number")

# add column for subject
      subject <- read.fwf(url_subject_train,width=2)
      DT_train <- data.table(cbind(Subject_number=subject,DT_train))
      setnames(DT_train, "V1", "Subject_number")

#clean memory
      rm(df,activity,subject)
      print("Second set ready for merge")
      print(Sys.time())



# Combine two data tables
      DT_tidy <- data.table(rbind(DT_test,DT_train))
      print("Data sets combined")
      print(Sys.time())

#load and merge activity labels and delete first (obsolete) column
      act_labels <- read.fwf(url_activity_labels,width=c(1,24))
      general_data <- merge(act_labels,DT_tidy,by.x="V1",by.y="Act_number")
      general_data$V1 <- NULL
      setnames(general_data, "V2", "Activity")
#return general_data from function
      print("Function complete")
      print(Sys.time())
      general_data
}

#general_data is now complete. The rest of the code handles the parsing of the general_data to the tidy_data set
samsung_tidy_data <- function(general_data){

#Create a set of unique combinations of activity and subject
      unique_cases <- unique(general_data[,c("Activity","Subject_number")])
      print("Unique cases selected")
      print(Sys.time())

#Create table for tidy_data with correct names 
      tidy_data <- general_data[0,]

#for each other row of unique_cases add to tidy_data the mean per column
      for (u in 1:nrow(unique_cases)){
            activity <- unique_cases[u,1]
            subject <- unique_cases[u,2]
            subset <- general_data[which(general_data$Activity==activity & general_data$Subject_number==subject),]
            tidy_data[u,1] <- activity
            tidy_data[u,2] <- subject
            for (i in 3:81){
                  tidy_data[u,i] <- mean(as.numeric(subset[,i]))    
            }
      }
#return tidy_data from function
      print("Tidy data set")
      print(Sys.time())
      tidy_data

}
