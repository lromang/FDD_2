
import pandas as pd
import numpy as np


# pd.select_dtypes
(data
 .pipe(lambda df: df.rename({x: f'col_{x}' for x in df.columns}, axis=1))
 .pipe(lambda df:
       (pd.concat([(df.iloc[:, [i for i, t in enumerate([str(t) for t in df.dtypes]) if t == 'float64']]
                        .pipe(lambda df: (df - df.values.mean(axis=0, keepdims=True)).div(df.values.std(axis=0, keepdims=True)))),
                        df.iloc[:, [i for i, t in enumerate([str(t) for t in df.dtypes]) if t != 'float64']]], axis=1))))


(data
 .pipe(lambda df: df.rename({x: f'col_{x}' for x in df.columns}, axis=1))
 .pipe(lambda df:
       (pd.concat([(df.select_dtypes('number')
                    .pipe(lambda df: (df - df.values.mean(axis=0, keepdims=True)).div(df.values.std(axis=0, keepdims=True)))),
                   df.select_dtypes('object')],
                  axis=1))))

