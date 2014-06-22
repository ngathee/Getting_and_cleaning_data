

### Prepare the environment
if(!file.exists("./data")) {
        dir.create("./data")
}

### Get the data 
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(fileUrl, destfile = "./data/dataset.zip", method="curl")
unzip("./data/dataset.zip", exdir="./data")
file.rename("./data/UCI HAR Dataset", "./data/Dataset")

### Read in the data and manupulate it as necessary
#### Read test data
X_test <- read.table("./data/Dataset/test/X_test.txt")
subject_test <- read.table("./data/Dataset/test/subject_test.txt")
y_test <- read.table("./data/Dataset/test/y_test.txt")
test <- cbind(X_test, subject_test, y_test)

#### Read train data
X_train <- read.table("./data/Dataset/train/X_train.txt")
subject_train <- read.table("./data/Dataset/train/subject_train.txt")
y_train <- read.table("./data/Dataset/train/y_train.txt")
train <- cbind(X_train, subject_train, y_train)

#### Combine the test and train data
test_train <- rbind(test, train)

#### Get features names
features <- read.table("./data/Dataset/features.txt",  header=FALSE, stringsAsFactors=FALSE)
names(features) <- c("id", "name")

#### Add names to our dataset
names(test_train) <- c(features$name, "Subject", "Activity")

#### Get a tidy data
tidy_data <- test_train[, c(grepl("mean|std",as.character(features$name)), TRUE, TRUE)]

#### Make names more descriptive
names(tidy_data) <-  gsub("[,()-]", "", names(tidy_data))

#### Clean the environment
rm("features","subject_test","subject_train" ,"test","test_train", "train", "X_test","X_train","y_test", "y_train")

#### Perform the necessary computataions 
processed <- aggregate(tidy_data,by=tidy_data[c("Subject","Activity")],FUN=mean)

#### Save the tidy as a txt file
write.table(processed, file="tidy_data.txt", row.names = F)
