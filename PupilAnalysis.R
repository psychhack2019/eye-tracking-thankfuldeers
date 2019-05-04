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
  select(recording_session_label, trial_index, right_pupil_size, sample_index, study_block, study_image, study_old_num)

#organize for fixation number
df.fixation <- df %>% ungroup() %>% 
  select(recording_session_label, trial_index, right_fix_index, right_pupil_size, sample_index, study_block, study_image, study_old_num)

#get occurence num
testdf.pupil <- df.pupil %>% group_by(recording_session_label, trial_index, study_image) %>% summarise(mean_pupil_size = mean(right_pupil_size)) %>% 
  group_by(recording_session_label) %>% mutate(Occurence_num = ave(study_image==study_image, study_image, FUN=cumsum)) %>% na.omit()


testdf.fixation <- df.fixation %>% group_by(recording_session_label, trial_index, study_image) %>% summarise(mean_pupil_size = mean(right_pupil_size), fixation_num = max(right_fix_index)) %>% 
  group_by(recording_session_label) %>% mutate(Occurence_num = ave(study_image==study_image, study_image, FUN=cumsum)) %>% na.omit()




graphing.pupil <- testdf.pupil %>% group_by(Occurence_num, recording_session_label) %>% summarise(mean_pupil_size = mean(mean_pupil_size)) %>% group_by(recording_session_label) %>%
                  mutate(slopeCheck = case_when(
                                   mean_pupil_size > lead(mean_pupil_size, 1) ~ "reduction",
                                   TRUE ~ "increase"))

graphing.both

pupilAov1 <- aov(mean_pupil_size ~ as.factor(Occurence_num), data=testdf.pupil)
summary(pupilAov1)
model.tables(pupilAov1, "means")

bothAov1 <- aov(as.factor(Occurence_num) ~ mean_pupil_size + fixation_num)

pd <- position_dodge2(0.5)
#linetype = reducing or increasing
pupil.plot <- ggplot(data= graphing.pupil, aes(x=factor(Occurence_num), y=mean_pupil_size, color=factor(Occurence_num), legend=F)) + 
  geom_violin() + 
  geom_point(position=pd, aes(group= recording_session_label), size = 3, shape=1) +
  geom_line(position = pd, aes(group= recording_session_label, colour = slopeCheck), alpha = 0.20, size = 3) + 
  xlab('Occurence Number') + ylab('Pupil size') + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

pupil.plot

graphing.pupil.mean <- graphing.pupil %>% group_by(Occurence_num) %>% summarise(mean_pupil_size = mean(mean_pupil_size), sd = sd(mean_pupil_size))

pupil.plot.mean <- ggplot(data=graphing.pupil.mean, aes(x=factor(Occurence_num), y= mean_pupil_size)) + 
  geom_bar() +
  xlab('Occurence Number') + ylab('Pupil size') + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

pupil.plot.mean
