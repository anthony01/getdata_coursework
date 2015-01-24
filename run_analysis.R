library(dplyr)

activ.label <- unlist(read.table("data/activity_labels.txt")[ , 2])
vars        <- read.table("data/features.txt", stringsAsFactors = FALSE)[ , 2]
df.train    <- read.table("data/train/X_train.txt", col.names = vars)
df.test     <- read.table("data/test/X_test.txt",  col.names = vars)

subj.train  <- unlist(read.table("data/train/subject_train.txt"))
subj.test   <- unlist(read.table("data/test/subject_test.txt"))
activ.train <- unlist(read.table("data/train/y_train.txt"))
activ.test  <- unlist(read.table("data/test/y_test.txt"))

activ.train <- activ.label[activ.train]
activ.test  <- activ.label[activ.test]

ind    <- grep("mean\\(|std\\(", vars, value = FALSE)
df.all <- select(rbind(df.train, df.test), ind)
df.all <- mutate(df.all, subject = c(subj.train, subj.test), 
                        activity = c(as.character(activ.train), as.character(activ.test)))
df     <- df.all %>% group_by(subject, activity) %>%  summarise_each(funs(mean(., na.rm = TRUE)))
