#! /Users/juanpablogarciavega/miniconda3/envs/fdd2db/bin/python

import pandas as pd
import numpy as np
df= pd.read_csv('/Users/juanpablogarciavega/Documents/pruebinha.csv', header=None, names=["mean_p", "popularity"])
means_to_be_mult= df["mean_p"]
length_for_date=len(means_to_be_mult)
for ind in df.index:try1=np.random.exponential(scale=(df['mean_p'][ind])*10**(1+(df['mean_p'][ind])), size=length_for_date)
try2=np.round(try1)
pd.DataFrame(try2).to_csv('sample3.csv')
