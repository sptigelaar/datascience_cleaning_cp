Datascience_cleaning_course_project
===================================

Repository for course project 'getting and cleaning data'

This code cleans the test and train data_set and creates 2 data sets general_data has all data on mean and std measures for all subjects and activities tidy_data has only the averages of the mean and std measures per subject-activity-combination.

Function input is the relative or absolute location of the data home dir (/UCI HAR Dataset/).
Function runs in two steps: 
- clean_samsung_data(loc='./') creates a general data set which can then be used with
- samsung_tidy_data(general_data) 


The data in the eventual set is described in the code book 'codebook_tidy_data_samsung.txt'
