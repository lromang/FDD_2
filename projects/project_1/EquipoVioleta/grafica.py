#! /usr/bin/env python

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# read text file into pandas DataFrame
df2 = pd.read_csv("datos_grafica", header=None)
df2.rename(columns={0:"delta_avg", 1:"percentile"}, inplace=True)

df2['percentile'] = 100-df2['percentile']
df2.plot.scatter(x='percentile', y='delta_avg', figsize=(8,8))

plt.show()
