#! /home/sammyboy86/anaconda3/envs/fdd2/bin/python

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

carts = pd.read_csv('carts.csv')



carts_avg=carts.groupby('cart_id').mean()

carts_avg=carts.join(carts_avg, on='cart_id', lsuffix='l')

carts_avg=carts_avg[["cart_id","book_idl","purchase_date","percentile"]]

carts_avg['expo'] = carts_avg['percentile']


carts_avg['expo']=carts_avg['expo'].apply(lambda x: np.mean(np.random.exponential(1/((x+.001)*10**(1+x)),size=10)))

#multiply times 100 to get day estimate
carts_avg['days_until_return'] = (carts_avg['expo']*100)

print(carts_avg['percentile'].corr(carts_avg['days_until_return']))
print(carts_avg.describe())


fig= plt.scatter(carts_avg['percentile'], carts_avg['days_until_return'])
plt.xlabel("percentile")
plt.ylabel("estimated_days_until_return")

plt.savefig('percentiles_vs_return_date.png')
