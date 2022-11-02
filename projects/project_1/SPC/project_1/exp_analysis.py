#! /home/sammyboy86/anaconda3/envs/fdd2/bin/python

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

carts = pd.read_csv('carts.csv')



carts_avg=carts.groupby('cart_id').mean()

carts_avg=carts.join(carts_avg, on='cart_id', lsuffix='l')

carts_avg=carts_avg[["cart_id","book_idl","purchase_date","percentile"]]

carts_avg=carts_avg.groupby("book_idl").mean()

carts_avg['expo'] = carts_avg['percentile']


carts_avg['expo']=carts_avg['expo'].apply(lambda x: np.mean(np.random.exponential((x+.001)*10**(1+x),size=100)))

#multiply times 100 to get day estimate
carts_avg['estimated_days_until_return'] = (carts_avg['expo']*10)

#unix timestamp play
carts_avg['estimated_return_date'] = carts_avg['purchase_date']+(carts_avg['estimated_days_until_return']*36400)

#get estimated return date
carts_avg['estimated_return_date']=pd.to_datetime(carts_avg['estimated_return_date'],unit='s')

carts = carts.rename(columns={'book_id': 'book_idl'})

carts = carts.groupby("book_idl").mean()

carts_avg=carts.join(carts_avg, on='book_idl', lsuffix='_l')

print(carts_avg.describe())
print(carts_avg['percentile_l'].corr(carts_avg['estimated_days_until_return']))


#print(carts_avg.head(10))

fig= plt.scatter(carts_avg['estimated_days_until_return'], carts_avg['percentile'])
plt.ylabel("percentile")
plt.xlabel("estimated_days_until_return")

plt.savefig('percentiles_vs_return_date.png')
