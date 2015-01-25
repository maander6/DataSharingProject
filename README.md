## Data Cleaning and Sharing Project
repo to contain the project script, the code-book, and a readme.md file
#run_analysis.R Script
=====
This is the read_me file for the run_analysis.R script.  This script takes a 
data set (found at https://d396qusza40orc.cloudfront.net/
getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip),
reads in the relevant text files into data tables, and then creates a single 
data table to follows the tidy data guidelines (H. Wickham, J. Statistical 
Software, 59(10), 2014).  Specifically, the data table that results at after the
script is run has:

*Each column having a single variable

*Each row has a single observation

*The table is a single observational unit

The data that is being processed was collected from a group of 30 volunteers who
wore a Samsung Galaxy S II smart phone at their waist while performing 6 
activities (Walking, walking upstairs, walking downstairs, sitting, standing, 
and laying).  The accelerometer and gyroscope in the phone captured data for the
3-axial linear acceleration and 3-axial angular velocity.  From this data, 
information about body motion and subject exertion with the different activities
were be extracted.  The purpose of this exercise is to take the data and put it 
in a form that can be more easily read and, ultimately, analyzed.  This is 
accomplished by creating a single tidy dataset.  Details about the input files,
the intermediate data tables, and the output tidy data table will be provided
in the accompanying code book

The following presents relevant information for running
the script, and for reading the resulting text file back into an R programming
environment for subsequent manipulation.

###Initial considerations

The data is in a compressed file (getdata-projectfiles-UCI_HAR_dataset.zip).
This file should be decompressed into a directory (./UCI HAR Dataset), and this
directory set as the working directory for the R environment.  The script should
be run from this directory because the script assumes the location of the files
it requires are either in this director or are referenced relative to this 
directory location.

The data.table, the dplyr, and the tidyr packages must be installed on the 
system where the script will be run as the script loads these libraries as one
of the first instructions of the script.  

###Running the script

The script must be run from the directory where the data was extracted into, 
and that is one director up in the tree from the test and train directories.
The output textfile (Samsung_data_tidy.txt) will be written to this directory.

###Reading the output text file back into the R environment

The output text file (Samsung_data_tidy.txt) should be read back into the R
working environment using the following command:

read.table("Samsung_data_tidy.txt", header=TRUE)

### Code Book

Two versions of the code book for the run_analysis script have been uploaded
to Github.com.  One is a text file that does not render well on Github 
because it is displayed without wordwrapping.  A pdf version is also up-
loaded.  This form is much easier to read, and it is suggested that you use 
this version.  After clicking on the pdf version of the code book, you need
to click "view raw" to download the pdf file of the code book.


#Original Source of the Data

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-
Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-
Friendly Support Vector Machine. International Workshop of Ambient Assisted 
Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

#Useful References

This script was written with the help of the following references:

*H. Wickham, "Tidy Data", J. Stat. Software, 59(10), 2014.

*D. Hood, "David's Project FAQ", https://class.courera.org/getdata-010/
  forum/thread?thread_id=49
  
*http://stackoverflow.com/questions/8508482 for code examples for calculating
  the mean values across the entire data table by subject and by activity
