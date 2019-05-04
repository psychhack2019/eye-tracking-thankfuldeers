library(car) 
library(ggplot2)
library(lattice)
library(tidyverse)
library(mixtools)
library(flexmix)

setwd("C:/Users/lkdoy/Scripts/GitHub/MA/eye-tracking-thankfuldeers/")
datapath = "./cleanedEyeDat.csv"
#read datafile
df <- read_csv(datapath)

#organize for pupil diameter 
df.pupil <- df %>% ungroup() %>% 
  select(recording_session_label, trial_index, right_pupil_size, sample_index, study_block, study_image, study_old_num, pupil_before, pupil_after, pupil_mean_after, pupil_mean_before, pupil_last, pupil_first, pupil_mean_first, pupil_mean_last)
#organize for fixation number


#factorVar <- c('study_block','study_old_num') #make a factor list  
#df <- lapply(df[factorVar], as.factor)


#get occurence num
testdf.pupil <- df.pupil %>% group_by(recording_session_label, trial_index, study_image) %>% summarise(mean_pupil_size = mean(right_pupil_size)) %>% 
  group_by(recording_session_label) %>% mutate(Occurence_num = ave(study_image==study_image, study_image, FUN=cumsum))


testing <- testdf.pupil %>% group_by(Occurence_num) %>% summarise(meanPupilSize = mean(mean_pupil_size, devPupilSize = sd(mean_pupil_size)))

pupilAov1 <- aov(mean_pupil_size ~ as.factor(Occurence_num), data=testdf.pupil)
summary(pupilAov1)
model.tables(pupilAov1, "means")


ggplot(dat, aes(x=Occurence_num, y=mean_pupil_size))




