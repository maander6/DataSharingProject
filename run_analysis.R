## run_analysis.R
##
## This is a script that merges several data files creating a single data
## set.  It assigns descriptive labels to each variable (column of the data
## set).  This script provides a detailed step-by-step procedure for gathering
## and cleaning the data.
##
## Set the working directory so that the data files can be read.
##
## setwd("c:/CleanDataProject/UCI HAR Dataset")
## 
## The data file should be extracted into the CleanDataProject directory.
## If that directory does not exist, it should first be created.
##
## The needed libraries should be loaded.  For this project, we will need
## library(data.table), library(dplyr), and library(tidyr)
##
library(data.table)
library(dplyr)
library(tidyr)
## 
## After these libraries are loaded, then the script reads in the data files.
## These will be read into the console, and then converted to a data.table
##
features <- as.data.table(read.table("features.txt"))
activity_lbl <- as.data.table(read.table("activity_labels.txt"))
X_test <- as.data.table(read.table("./test/X_test.txt"))
Y_test <- as.data.table(read.table("./test/y_test.txt"))
subject_test <- as.data.table(read.table("./test/subject_test.txt"))
X_train <- as.data.table(read.table("./train/X_train.txt"))
Y_train <- as.data.table(read.table("./train/y_train.txt"))
subject_train <- as.data.table(read.table("./train/subject_train.txt"))
##
## The data files (X_test and X_train) do not have descriptive column titles.
## We will use the features data.table (561 observations) to create titles for
## the 561 variables in X_test and X_train data.tables.  
##
## Create a Vector with the names of the features measured
##
feature_names <- as.vector(features$V2)
##
## Set the column names of X_test and X_train to the names in
## feature_names
##
setnames(X_test, old=colnames(X_test), new=feature_names)
setnames(X_train, old=colnames(X_train), new=feature_names)
##
## The Y_test and Y_train files contain data that relates the types of 
## activities (e.g. walking, walking up stairs, walking down stairs, 
## sitting, standing, and laying) being measured to the observations recorded
## in the X_test (2947 observations) and X_train (7352 observations).  These
## are added to column 1 of the X_test and X_train data.table using the
## cbind function.
##
X_test <- cbind(Y_test, X_test)
X_train <- cbind(Y_train, X_train)
##
## Rename the activity number column to a descriptive value, ActivityNum
##
setnames(X_test, old="V1", new="ActivityNum")
setnames(X_train, old="V1", new="ActivityNum")
##
## Bind the subject_test and subject_train data.table to the X_test, and 
## X_train data.table, respectively.  The subject_text and subject_train 
## data.tables relate the observations to specific individual subjects used to
## collect the data.  This action is also conducted with the cbind function.
##
X_test <- cbind(subject_test, X_test)
X_train <- cbind(subject_train, X_train)
##
## Rename the Subject column to a descriptive value, Subject
##
setnames(X_test, old="V1", new="Subject")
setnames(X_train, old="V1", new="Subject")
##
## PART 1: MERGE THE TRAINING and TEST SETS TO CREATE ONE DATA SET
##
## Merge the X_test and the X_train data tables into a single data table
## using the rbind function, and place the combined data into a new
## data table, complete_data
##
complete_data <- rbind(X_test, X_train)
##
## EXTRACT ONLY THE MEASUREMENTS ON THE MEAN AND sTD DEV OF EACH MEASUREMENT
##
## To extract only the measurements on the mean and standard deviation, we
## must identify the columns with names that contain the sub-strings "mean"
## and "std".  This is accomplished by using the grep function on the features 
## data table (column V2) which returns a data table with only those 
## observations that have either "mean" or "std" as a substring.
##
cname_mean <- features[grep("mean", features$V2)]
cname_std <- features[grep("std", features$V2)]
##
## Using the cname_mean and cname_std data tables, extract a vector that gives
## the column number that corresponds to those columns that have either "mean"
## or "std" as a substring in the column name.  Assign these vectors to 
## cnum_mean and cnum_std
##
cnum_mean <- as.vector(cname_mean$V1)
cnum_std <- as.vector(cname_std$V1)
##
## To subset the complete_data data.table using the select() function, we need
## the column numbers associated with columns that have a name with the sub-
## strings "mean" or "std".  Because we added 2 columns for the first 2 columns 
## of the complete_data data.table, we need to add 2 to the cnum_mean and 
## cnum_std vectors to have the correct alignment with the columns in the
## complete_data data.table
##
cnum_mean <- cnum_mean+2
cnum_std <- cnum_std+2
##
## 2. EXTRACT ONLY THE MEASUREMETNS ON THE MEAN AND STD DEV FOR EACH MEASUREMENT
##
## We now use these vectors to subset the columns of the complete_data 
## data.table to yield a new data.tabel, complete_data_sub
##
complete_data_sub <- select(complete_data, Subject, ActivityNum, cnum_mean, cnum_std)
##
## Replace the activity numbers with descriptive activity names.  This is 
## accomplished by merging the activity_lbl data.table and the 
## complete_data_sub data.table, after setting a common key.  First rename the
## variable columns of the activity_lbl data table to ActivityNum and Activity
##
setnames(activity_lbl, old="V1", new="ActivityNum")
setnames(activity_lbl, old="V2", new="Activity")
##
## Next set the key to ActivityNum in both the activity_lbl and the 
## complete_data_sub data.table
##
setkey(activity_lbl, ActivityNum)
setkey(complete_data_sub, ActivityNum)
##
## 3.USES DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA SET
##
## Once these 2 tables have a common key, the 2 data.tables can be merged
## to introduce descriptive activity names to the complete_data_sub
## data.table.
##
complete_data_sub <- merge(activity_lbl, complete_data_sub)
##
## the complete_data_sub file has descriptive variable names (column names) but
## the names include punctuation that will interfere if we try to operate on
## this data.table using the column names (e.g. if we want to summarize the
## data based on activity or subject).  For this reason, we would like to strip
## the punctionation from the variable names.  This is accomplished using the
## gsub function.
##
## Create a vector (col_name) of the names of the variables in the
## complete_data_sub data.table
##
col_name <- as.vector(colnames(complete_data_sub))
##
## Strip out the punctuation from the variable (column) names and save back into
## the col_name vector
##
for(i in 1:length(col_name)){col_name[i]<-gsub("[[:punct:]]","",col_name[i])}
##
## use the setnames() function to rename the variable (column) names
## 
setnames(complete_data_sub, old=colnames(complete_data_sub), new=col_name)
##
## 5. CREATE A SECOND, INDEPENDENT TIDY DATA SET WITH AVG OF EACH VARIABLE
##
## To tidy the data, we need to group the data by Subject and Activity
## This can be accomplished in a single step using the lapply function.
##
complete_data_average <- complete_data_sub[,lapply(.SD, mean), by=list(Subject, Activity)]
complete_data_average <- select(complete_data_average, -ActivityNum)
##
## Write the output using the write.table() function
##
write.table(complete_data_average, file="./Samsung_data_tidy.txt", row.names=FALSE)
##