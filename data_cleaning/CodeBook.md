#Codebook.md

The data for the project was downloaded and un-zipped from here: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The following variables were used to read in the text files:
  
  subj_test,x_test,y_test,subj_train,x_train,y_train,features

data_merged was the product of rbind-ing and cbind-ing the above variables, and features was used to name the majority of the columns.I also used features to extract the mean and standard deviation from the data and stored the mean & standard deviation in data_mean_std2. I used gsub and the information in activity_labels.txt to name the variables in the activty column.

I did several data_renames since several of the features variables were not very explicit in their naming. Hadley Wickham, discusses his philosophy of tidy data in his 'Tidy Data' paper
# http://vita.had.co.nz/papers/tidy-data.pdf

tidy_data was the last variable, which holds all my "tidy" data for the project that I then wrote to a text file.