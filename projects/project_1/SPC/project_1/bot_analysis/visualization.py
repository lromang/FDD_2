#! /usr/bin/python3



import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('percentages.csv', header=None)

print(df.head())
t = df[0]
v = df[1]

# make a plot

fig, ax = plt.subplots(figsize=(6,3))
ax.scatter(t,v)
ax.set_xlabel('Genres',fontsize=14)
ax.set_ylabel('Percentage',fontsize=14)
ax.set_title('users 2 more decile',fontsize=14)

print(rcsetup.all_backends)