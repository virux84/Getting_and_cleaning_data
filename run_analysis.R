library("data.table")
library("reshape2")




# Data train and test
Test_x <- read.table("./UCI HAR Dataset/test/X_test.txt")
Test_y <- read.table("./UCI HAR Dataset/test/y_test.txt")
Test_s <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(Test_x) <- read.table("./UCI HAR Dataset/features.txt")[,2]

Train_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
Train_y <- read.table("./UCI HAR Dataset/train/y_train.txt")
Train_s <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(Train_x) <- read.table("./UCI HAR Dataset/features.txt")[,2]

# mu and sd
features <- grepl("mean|std",  read.table("./UCI HAR Dataset/features.txt")[,2])
Test_x = Test_x[,features]
Train_x = Train_x[,features]

#Activity
Label_act <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
Test_y[,2] = Label_act[Test_y[,1]]
names(Test_y) = c("Activity_ID", "Activity_Label")
names(Test_s) = "subject"
Train_y[,2] = Label_act[Train_y[,1]]
names(Train_y) = c("Activity_ID", "Activity_Label")
names(Train_s) = "subject"

#Merge
Data_test <- cbind(as.data.table(Test_s), Test_y, Test_x)
Data_train <- cbind(as.data.table(Train_s), Train_y, Train_x)
data = rbind(Data_test, Data_train)

#Reshaping
Label_id   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), Label_id)
Data_melt    = melt(data, id = Label_id, measure.vars = data_labels)
final_data   = dcast(Data_melt, subject + Activity_Label ~ variable, mean)

write.table(final_data, file = "./tidy_data.txt",row.names = FALSE)