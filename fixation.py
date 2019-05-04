# import required libraries
import os
import os.path
import numpy as np
import pandas as pd
pd.set_option('display.max_rows', 400)
pd.set_option('display.max_columns', 400)

dat = pd.read_csv('pupil_data.csv', low_memory = False, dtype = object)

# get the needed value for a specific image and participant
def getfixation(image_num, participantID, no_na_image_df):
   
    numofpresentation = 0
    numoffixation = list()
    prevfix = 1
    for i in range(2, len(no_na_image_df.index)):
        fix = int(no_na_image_df["right_fix_index"].iloc[i])
        if (int(no_na_image_df["recording_session_label"].iloc[i]) == participantID):
            #print(fix, prevfix)
            if (fix < prevfix):
                #print("here")
                numofpresentation += 1
                numoffixation.append(prevfix)
            prevfix = fix
        #if (i == (len(no_na_image_df.index) - 1)):
        #   print("here", prevfix)
    numofpresentation += 1
    numoffixation.append(prevfix)
    
    if (numofpresentation == 1):
        numoffixation.append("NA")
        numoffixation.append("NA")
    elif (numofpresentation == 2):
        numoffixation.append("NA")
    # 0 seen before and remember
    # 1 seen before and know
    # 2 seen before and new
    # 3 not seen before and remember or know
    # 4 not seen before and new
    new_test_result = -1
    df = no_na_image_df.loc[no_na_image_df["recording_session_label"] == str(participantID)]
    if (image_num in df.study_image.values and image_num in df.test_image.values):
        df2 = df.loc[df["test_image"] == image_num]
        test_result = df2["test_response"].iloc[0]
        if (int(test_result) == 106):
            new_test_result = 0
        elif (int(test_result) == 107):
            new_test_result = 1
        elif (int(test_result) == 108):
            new_test_result = 2
    elif (image_num not in df.study_image.values and image_num in df.test_image.values):
        df2 = df.loc[df["test_image"] == image_num]
        test_result = df2["test_response"].iloc[0]
        if (int(test_result) == 106 or int(test_result) == 107):
            new_test_result = 3
        elif (int(test_result) == 108):
            new_test_result = 4
    
    return numofpresentation, numoffixation, new_test_result


test_list = list()
study_list = list()
for test in dat.test_image.unique():
    test_list.append(test)
for study in dat.study_image.unique():
    study_list.append(study)

image_set = set(study_list + test_list)
image_list = list(image_set)

output_df = pd.DataFrame(columns=['recording_session_label', 'image', 'num_of_presentation', 'fixation1', 'fixation2', 'fixation3', 'test_response'])


for image in image_list:
    image_study_df = dat.loc[dat["study_image"] == image]
    image_test_df = dat.loc[dat["test_image"] == image]
    frames = [image_study_df, image_test_df]
    image_df = pd.concat(frames)
    no_na_image_df = image_df.dropna(subset=['right_fix_index'])
    for participant in range(1,49):
        if str(participant) in no_na_image_df["recording_session_label"].unique():
            numofpresentation, numoffixation, test_result = getfixation(image, participant, no_na_image_df)
            output_df = output_df.append(pd.Series([participant, image, numofpresentation, numoffixation[0], numoffixation[1], numoffixation[2], test_result], index=output_df.columns ), ignore_index=True)

export_csv = output_df.to_csv('fixation_analysis.csv')