# -----Libraries required-----
import pandas
import numpy as py

# -----Global variables-----
FILE_NAME = 'pupil_data.csv.zip'

# -----Code-----
dat = pandas.read_csv("./" + FILE_NAME, low_memory=False)

print(dat)