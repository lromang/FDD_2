#! /Users/juanpablogarciavega/miniconda3/envs/fdd2db/bin/python

import pandas as pd
import matplotlib.pyplot as plt

df= pd.read_csv('/Users/juanpablogarciavega/Documents/scatter_plot.csv', header=None, names=["Average_num_of_days_between_purchases", "Download_Percentile"])
plt.scatter(df["Download_Percentile"], df["Average_num_of_days_between_purchases"])
plt.xlabel("Download percentile")
plt.ylabel("Average num days")
plt.show()


