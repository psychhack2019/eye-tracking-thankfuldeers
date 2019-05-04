# -----Libraries required-----
import pandas
import numpy as py

# -----Global variables-----
FILE_NAME = 'pupil_data.csv.zip'

# -----Code-----
def cleanData(data):
    #Clean the blink trials
    badindex = []
    print("reading")
    
    for index, val in data['right_in_blink'].iteritems():
        if val == 1:
            print("test")
            badindex.extend([index, index-1, index+1])
            
    print("dropping")
    
    dropped = data.drop(badindex)

    cleanData = dropped[dropped['right_in_saccade'] != 1]
    
    return cleanData
    
print("starting")
dat = pandas.read_csv("./" + FILE_NAME, low_memory=False)
print("done reading")
print("beginning cleaning")
cleaned = cleanData(dat)
print("done cleaning")



