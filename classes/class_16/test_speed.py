'''
Load movies file:
Search for: 'Baby Boom (1987)'
1.- loc (not sorted)
2.- loc (sorted)
3.- loc (unique)
'''

# 1
import time
import pandas as pd
import numpy as np

# Movies
movies = pd.read_csv('movies.csv')

# Regular movies
regular_movies = movies.set_index('title')

# Sort index
sorted_movies = regular_movies.sort_index()

# Drop duplicates
unique_movies = movies.drop_duplicates('title').set_index('title').sort_index()

# Generate values
res_1 = []
res_2 = []
res_3 = []
n_iters = 10000

for r_title in movies.title.iloc[(np.random.rand(n_iters)*movies.shape[0]).astype(int)]:
    # Regular time
    t_0 = time.time()
    regular_movies.loc[r_title]
    t_1 = time.time()
    res_1.append(t_1 - t_0)
    # Sorted time
    t_0 = time.time()
    sorted_movies.loc[r_title]
    t_1 = time.time()
    res_2.append(t_1 - t_0)
    # Unique time
    t_0 = time.time()
    unique_movies.loc[r_title]
    t_1 = time.time()
    res_3.append(t_1 - t_0)

res_data = pd.DataFrame({'regular': res_1, 'sorted': res_2, 'unique': res_3})




