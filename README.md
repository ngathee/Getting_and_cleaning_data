Getting_and_cleaning_data
=========================
### Prepare the environment
Check to see if a directory named data exists, if not create one.
```r
if(!file.exists("./data")) {
        dir.create("./data")
}
```
### Get the data
Download a zipped file from the source and save it to the specified path. Then, unzip the file an rename it for convenience. 
```r
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/dataset.zip", method="curl")
unzip("./data/dataset.zip", exdir="./data")
file.rename("./data/UCI HAR Dataset", "./data/Dataset")
```
### Read in the data and manupulate it as necessary
#### Read test data
Read all the test data an merge them to make one wide data. 
```r
X_test <- read.table("./data/Dataset/test/X_test.txt")
subject_test <- read.table("./data/Dataset/test/subject_test.txt")
y_test <- read.table("./data/Dataset/test/y_test.txt")
test <- cbind(X_test, subject_test, y_test)
```
#### Read train data
Read all the train data and merge it to create one wide data. 
```r
X_train <- read.table("./data/Dataset/train/X_train.txt")
subject_train <- read.table("./data/Dataset/train/subject_train.txt")
y_train <- read.table("./data/Dataset/train/y_train.txt")
train <- cbind(X_train, subject_train, y_train)
```
#### Combine the test and train data
Merge the test data and train data to create one long data.
```r
test_train <- rbind(test, train)
```
#### Get features names
Read in the data features 
```r
features <- read.table("./data/Dataset/features.txt",  header=FALSE, stringsAsFactors=FALSE)
names(features) <- c("id", "name")
```
#### Add names to our dataset
This will be the column names for the long data we obtained from above. 
```r
names(test_train) <- c(features$name, "Subject", "Activity")
```
#### Get a tidy data
Subset only the required data.  This uses an R search utility and then uses a logical vector to subset the data into a new object.
```r
tidy_data <- test_train[, c(grepl("mean|std",as.character(features$name)), TRUE, TRUE)]
```
#### Make names more descriptive
Remove the unnecessary characters that makes the column names ugly. This uses an R search and replace utility(gsub). 
```r
names(tidy_data) <-  gsub("[,()-]", "", names(tidy_data))
```
#### Clean the environment
We have a lot of large object in memory and we need to remove them. 
```r
rm("features","subject_test","subject_train" ,"test","test_train", "train", "X_test","X_train","y_test", "y_train")
```
#### Perform the necessary computations 
This groups the tidy data by Subject, then by Activity, and then finds the mean of these groups
```r
processed <- aggregate(tidy_data,by=tidy_data[c("Subject","Activity")],FUN=mean)
```
#### Save the tidy as a txt file
Use an R write.table utility to write the tidy data object to a text file. 
```r
write.table(processed, file="tidy_data.txt", row.names = F)
```