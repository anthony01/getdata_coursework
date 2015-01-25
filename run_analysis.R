library(dplyr)

vars        <- read.table("data/features.txt", stringsAsFactors = FALSE)[ , 2]
df.train    <- read.table("data/train/X_train.txt", col.names = vars)
df.test     <- read.table("data/test/X_test.txt",  col.names = vars)

subj.train  <- unlist(read.table("data/train/subject_train.txt"))
subj.test   <- unlist(read.table("data/test/subject_test.txt"))

activ.label <- unlist(read.table("data/activity_labels.txt")[ , 2])
activ.train <- unlist(read.table("data/train/y_train.txt"))
activ.test  <- unlist(read.table("data/test/y_test.txt"))
activ.train <- activ.label[activ.train]
activ.test  <- activ.label[activ.test]

# Merging datasets (task#1) and extracts only the measurements on the mean and standard deviation for each measurement (task#2) 
ind    <- grep("mean\\(|std\\(", vars, value = FALSE)
df.all <- select(rbind(df.train, df.test), ind)

# Add 'activities' to dataframe with descriptive variable names (task#4)
df.all <- mutate(df.all, subject = c(subj.train, subj.test), 
                        activity = c(as.character(activ.train), as.character(activ.test)))

# Create a second, independent tidy data set with the average of each variable for each activity and each subject (task#5)
df     <- df.all %>% group_by(subject, activity) %>%  summarise_each(funs(mean(., na.rm = TRUE)))

# Output second dataframe to the file 'data/df2.csv'. Can be read back into memory using 'read.csv("data/df2.csv")'.
write.table(df, file = "data/df2.csv", sep = ',', row.names = FALSE)