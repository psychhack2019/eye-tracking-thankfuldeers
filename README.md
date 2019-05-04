# DeersEyeTrack
Psychhack2019 project on Eyetracking Dataset, by Team ThankfulDeers.

## Development Setup
This project is written in Node.js, R and Python3.7 environment. Please make sure [Node.js](https://nodejs.org/en/download/), [R](https://cran.r-project.org/mirrors.html) and [Python3](https://www.python.org/downloads/) is installed properly.

## Usage
### Clean dataset
There is a sample dataset available in data directory, dataset details are in "Dataset available for UofT PsychHacks2019" section.

User can also use there own dataset as long as it follows the same format as the sample dataset and is in the data directory.

User can follow the following instructions to clean a dataset:

1. Install the required dependencies.
```
$ cd eye-tracking-thankfuldeers/data
$ pip install -r requirements.txt
```

2. Run code. Can replace pupil_data.csv.zip with your own dataset name. If user doesn't provide the name of dataset, the code will default run on sample dataset.
```
$ python cleaner.py pupil_data.csv.zip
```

3. Once cleaner finishes successfully, there should be a file named "cleanedEyeDat.csv" created in data directory, which will be used in the following analysis. 

## Dataset available for UofT PsychHacks2019

pupil_data.csv.zip: Contains sample report extracted from Eyelink (R) 1000 at frequency of 20Hz for 48 participants.

### Study design
Participants view face images for 6 blocks and perform a remember-know-new (RKN) recognition task in the last 3 blocks.

Study blocks 1-2 (60 trials in each block): Exposure-I (60 face images presented twice)<br/>
Study blocks 3-5 (40 trials in each block): Indirect Test (60 face images from Exposure-I presented for the 3rd time and 60 new face images presented once)<br/>
Study block 6 (60 trials): Exposure-II (60 face images that were presented for the first time in Block 3-5, presented once again)<br/>

Test blocks 1-3 (40 trials in each block): Direct Test (60 face images from Exposure-II that were presented twice before and 60 new face images presented once)<br/>

### Variables:<br/>
```
"recording_session_label": subject number
"trial_index": trial number (1:420)
"right_fix_index": fixation index
"right_in_blink": blink (1) or not (0)
"right_in_saccade": saccade (1) or not (0)
"right_pupil_size": pupil size
"right_saccade_index": saccade index
"sample_index": sample number (ms)
"timestamp": timestamp (generated by Eyelink)
"trial_start_time": timestamp when the trial started (generated by Eyelink)
"study_end": end time of study trial (only for study blocks 1-6, i.e., trials 1-300; NA otherwise)
"study_start": start time of study trial (only for study blocks 1-6, i.e., trials 1-300; NA otherwise)
"test_end": end time of test trial (only for test blocks 1-3, i.e., trials 301-420; NA otherwise)
"test_start": start time of test trial (only for test blocks 1-3, i.e., trials 301-420; NA otherwise)
"test_response": response on the test trial -- 106 ("remember"), 107 ("know"), 108 ("new")
"test_rt": response time on the test trial (ms)
"study_block": study block number (1:6)
"study_image": image label of the study trial (JPG)
"study_old_num": whether the image was old or new (only for study blocks 3-5)
"study_trial": trial number within block (1:40 for study blocks 3-5; 1:60 for study blocks 1,2,6)
"test_block": test block number (1:3)
"test_image": image label of the test trial (JPG)
"test_old_num": whether the image was old or new (only for test blocks)
"test_trial": trial number within block (1:40)
"sample_blink_outlier": outlier based on whether the eye is in a fixation (0) or not (1)
"pupil_after": whether the sample index is higher (1) or lower (0) than response time
"pupil_before": whether the sample index is higher (0) or lower (1) than response time
"pupil_mean_after": mean pupil size for sample indices higher than response time
"pupil_mean_before": mean pupil size for sample indices lower than response time
"pupil_last": whether the sample index is in the first 1500 ms (0) or the last 1500 ms (1) (out of the 3000ms trial)
"pupil_first": whether the sample index is in the first 1500 ms (1) or the last 1500 ms (0) (out of the 3000ms trial)
"pupil_mean_last": mean pupil size for sample indices higher than 1500 ms
"pupil_mean_first": mean pupil size for sample indices lower than 1500 ms
```
