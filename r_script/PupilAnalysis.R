library(tidyverse)


setwd(".")
datapath = "../data/cleanedEyeDat.csv"
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


graphing.both <- testdf.fixation %>% group_by(Occurence_num) %>% summarise(mean_fixation_num = mean(fixation_num), mean_pupil_size = mean(mean_pupil_size), sd_pupil_size = sd(mean_pupil_size))
graphing.both$sd_pupil_size <- graphing.pupil %>% group_by(Occurence_num) %>% summarise(sd = sd(mean_pupil_size)) %>% pull(sd)


pupilAov1 <- aov(mean_pupil_size ~ as.factor(Occurence_num), data=testdf.pupil)
summary(pupilAov1)
model.tables(pupilAov1, "means")

bothAov1 <- aov(Occurence_num ~ mean_pupil_size * fixation_num, data=graphing.fixation)
summary(bothAov1)

model.tables(bothAov1)

bothManova <- manova(cbind(mean_pupil_size, fixation_num) ~ Occurence_num, data=testdf.fixation)
summary(bothManova)

summary.aov(bothManova)


#GRAPHING THE PUPIL DATA
png("../static/img/PupilViolin.png")
pd <- position_dodge2(0.25)
pupil.plot <- ggplot(data= graphing.pupil, aes(x=factor(Occurence_num), y= mean_pupil_size, legend=F)) + 
  geom_violin() + 
  geom_point(position=pd, aes(group= recording_session_label), size = 3, shape=1) +
  geom_line(position = pd, aes(group= recording_session_label, colour = slopeCheck), alpha = 0.20, size = 3) + labs(title="Violin Plot of Pupil Size by Occurence") +
  xlab('Occurence Number') + ylab('Pupil size') + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  labs(colour = "Slope") #+ theme(legend.position="None")

pupil.plot

dev.off() 



#graphing.pupil.mean <- graphing.pupil %>% group_by(Occurence_num) %>% summarise(mean_pupil_size = mean(mean_pupil_size))
#graphing.pupil.sd <- graphing.pupil %>% group_by(Occurence_num) %>% summarise(sd = sd(mean_pupil_size))

#graphing.pupil.mean$sd <- graphing.pupil.sd$sd


#pupil.plot.mean <- ggplot(data= graphing.pupil.mean, aes(numeric(mean_pupil_size))) + 
#  geom_bar() 
  
#pupil.plot.mean 


#GRAPHING THE FIXATION DATA
png("../static/img/fixationViolin.png")

pd <- position_dodge2(0.25)
fixation.plot <- ggplot(data = graphing.fixation, aes(x=factor(Occurence_num), y=mean_fixation_num)) +
                geom_violin() + 
  geom_point(position=pd, aes(group= recording_session_label), size = 3, shape=1) +
  geom_line(position = pd, aes(group= recording_session_label, colour = slopeCheck), alpha = 0.20, size = 3) + labs(title="Violin Plot of Number of Fixations by Occurence") +
  xlab('Occurence Number') + ylab('number of fixations') + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
                                                       
fixation.plot

dev.off() 

sd_fixation_num <- sd(mean_fixation_num)

sd_fixation_num

#DOUBLE AXIS
png("../static/img/BothVars.png")
p <- ggplot(graphing.both, aes(x = factor(Occurence_num), group = 1)) 

p <- p + geom_line(aes(y = mean_pupil_size, colour = "Pupil Diameter"), size = 2)
p <- p + geom_point(aes(y = mean_pupil_size, colour = "Pupil Diameter"), shape = 15, size = 4)
p <- p + geom_errorbar(aes(ymin=mean_pupil_size - sd_pupil_size, ymax = mean_pupil_size + sd_pupil_size), width=.2,
              position=position_dodge(.5)) 

label.df <- data.frame(Occurence_num = c(1))

p <- p + geom_text(data = label.df, aes(y = 1800), label = "**")

p <- p + geom_line(aes(y = mean_fixation_num*180, colour = "Fixations"), size = 2)
p <- p + geom_point(aes(y = mean_fixation_num*180, colour = "Fixations"), shape = 16, size = 4)
p <- p + geom_errorbar(aes(ymin=mean_fixation_num*180 - sd_fixation_num*180, ymax = mean_fixation_num*180 + sd_fixation_num*180), width=.2,
                   position=position_dodge2(.5)) 

p <- p + scale_y_continuous(sec.axis = sec_axis(~./180, name = "Number of Fixations"))

p <- p + scale_colour_manual(values = c("blue", "red"))
p <- p + labs(y = "Mean Pupil Size",
              x = "Occurence Number",
              colour = "Paramater")

p <- p + theme(legend.position = c(0.8, 0.9)) + theme(panel.grid = element_blank()) 

p 
dev.off() 

