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
                                   mean_pupil_size > lead(mean_pupil_size, 1) ~ "reduction", TRUE ~ "increase")) 

graphing.fixation <- testdf.fixation %>% group_by(Occurence_num, recording_session_label) %>% summarise(mean_fixation_num = mean(fixation_num)) %>% group_by(recording_session_label) %>%
  mutate(slopeCheck = case_when(
                              mean_fixation_num > lead(mean_fixation_num, 1) ~ "reduction", TRUE ~ "increase")) 


pupilAov1 <- aov(mean_pupil_size ~ as.factor(Occurence_num), data=testdf.pupil)
summary(pupilAov1)
model.tables(pupilAov1, "means")


bothAov1 <- aov(Occurence_num ~ mean_pupil_size * fixation_num, data=testdf.fixation)
summary(bothAov1)

model.tables(bothAov1)


pd <- position_dodge2(0.25)
#linetype = reducing or increasing
pupil.plot <- ggplot(data= graphing.pupil, aes(x=factor(Occurence_num), y= mean_pupil_size, legend=F)) + 
  geom_violin() + 
  geom_point(position=pd, aes(group= recording_session_label), size = 3, shape=1) +
  geom_line(position = pd, aes(group= recording_session_label, colour = slopeCheck), alpha = 0.20, size = 3) + 
  xlab('Occurence Number') + ylab('Pupil size') + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

pupil.plot


graphing.pupil.mean <- graphing.pupil %>% group_by(Occurence_num) %>% summarise(mean_pupil_size = mean(mean_pupil_size))
graphing.pupil.sd <- graphing.pupil %>% group_by(Occurence_num) %>% summarise(sd = sd(mean_pupil_size))

graphing.pupil.mean$sd <- graphing.pupil.sd$sd


pupil.plot.mean <- ggplot(data= graphing.pupil.mean, aes(numeric(mean_pupil_size))) + 
  geom_bar() 
  
pupil.plot.mean


pd <- position_dodge2(0.25)
fixation.plot <- ggplot(data = graphing.fixation, aes(x=factor(Occurence_num), y=mean_fixation_num)) +
                geom_violin() + 
  geom_point(position=pd, aes(group= recording_session_label), size = 3, shape=1) +
  geom_line(position = pd, aes(group= recording_session_label), alpha = 0.20, size = 3) + 
  xlab('Occurence Number') + ylab('number of fixations') + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

fixation.plot



