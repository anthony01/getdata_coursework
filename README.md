# getdata_coursework
Refer to CodeBook.md for files & variables description

Reading raw data
================

```{r}
vars        <- read.table("data/features.txt", stringsAsFactors = FALSE)[ , 2]
df.train    <- read.table("data/train/X_train.txt", col.names = vars) # 'Train'-part of the dataframe
df.test     <- read.table("data/test/X_test.txt",  col.names = vars)  # 'Test'-part of the dataframe 

subj.train  <- unlist(read.table("data/train/subject_train.txt"))     # 'Volunteer' marks for each measurement
subj.test   <- unlist(read.table("data/test/subject_test.txt"))

activ.label <- unlist(read.table("data/activity_labels.txt")[ , 2])   # 'Activity' labels
activ.train <- unlist(read.table("data/train/y_train.txt"))           # 'Activity' marks
activ.test  <- unlist(read.table("data/test/y_test.txt"))
activ.train <- activ.label[activ.train]
activ.test  <- activ.label[activ.test]
```

Data Manipulation
=================

1. The training and the test sets are merged and only the data on the mean and standard deviation
were selected for each measurement.

```{r}
library(dplyr)
ind    <- grep("mean\\(|std\\(", vars, value = FALSE)
df.all <- select(rbind(df.train, df.test), ind)
df.all <- mutate(df.all, subject = c(subj.train, subj.test), 
                        activity = c(as.character(activ.train), as.character(activ.test)))
```

2. Second, independent tidy data set ('df') was created with
the average of each variable for each activity and each subject

```{r}
df <- df.all %>% group_by(subject, activity) %>%  summarise_each(funs(mean(., na.rm = TRUE)))
```

3. Output the resulting dataframe to a text file. Can be read back into memory using 'read.csv("data/df2.csv")'.

```{r}
write.table(df, file = "data/df2.csv", sep = ',', row.names = FALSE)
```