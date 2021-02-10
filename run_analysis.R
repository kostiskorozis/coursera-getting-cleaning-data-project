library(reshape2)

#download and unzip the data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data.zip", method = "curl")
unzip("data.zip")

#labels and activities
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("index", "activity"))
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("index", "feature"))

#feature extraction
feat_index <- grep("(mean|std)", features$feature)
features <- features[feat_index,]
feat_names <- features$feature

#trimming and polishing feature names and activity labels
activity_labels[,2] <- tolower(activity_labels[,2])
activity_labels[,2] <- sub("_", " ", activity_labels[,2])

feat_names <- sub("^t", "[time domain signal] ", feat_names)
feat_names <- sub("^f", "[frequency domain signal] ", feat_names)
feat_names <- sub("[(]+[)]", "", feat_names)
feat_names <- gsub("-", " - ", feat_names)
feat_names <- sub("Acc", " Accelerometer ", feat_names)
feat_names <- sub("Gyro", " Gyroscope ", feat_names)
feat_names <- sub("X$", "X axis", feat_names)
feat_names <- sub("Y$", "Y axis", feat_names)
feat_names <- sub("Z$", "Z axis", feat_names)

#train data
traindata <- read.table("./UCI HAR Dataset/train/X_train.txt")
traindata <- traindata[,feat_index]
traindata <- setNames(traindata, feat_names)

traindata_y <- read.table("./UCI HAR Dataset/train/y_train.txt")
colnames(traindata_y) <- "Activity"

traindata_sub <- read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(traindata_sub) <- "Subject"
traindata <- cbind(traindata, traindata_y, traindata_sub)

#test data
testdata <- read.table("./UCI HAR Dataset/test/X_test.txt")
testdata <- testdata[,feat_index]
testdata <- setNames(testdata, feat_names)

testdata_y <- read.table("./UCI HAR Dataset/test/y_test.txt")
colnames(testdata_y) <- "Activity"

testdata_sub <- read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(testdata_sub) <- "Subject"
testdata <- cbind(testdata, testdata_y, testdata_sub)

#merging test and train
merged_data <- rbind(testdata, traindata)
merged_data[["Activity"]] <- factor(merged_data[, "Activity"],
                                  levels = activity_labels[["index"]],
                                  labels = activity_labels[["activity"]])

#melting and casting into tidy set
melted_data <- melt(merged_data, id = c("Activity", "Subject"), measure.vars = feat_names)
tidy_data <- dcast(melted_data, Subject + Activity ~ variable, mean)

#writing tidy data
write.table(tidy_data, file = "tidyrun.txt", row.names = FALSE)
