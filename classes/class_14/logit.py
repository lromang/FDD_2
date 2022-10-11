#! /Users/luisroman/miniconda3/envs/fdd2/bin/python

import numpy as np
import pandas as pd

class Logit:
      '''
      This class is a logit classifier
      ''' 
      def __init__(self, X, y):
            self.X = X
            self.y = y
            self.theta = np.random.rand(X.shape[1]).reshape(-1, 1)
            print(f'Loading data: X shape [{X.shape}]')
            print(f'Loading data: y shape [{y.shape}]')

      def forward(self):
            '''
            This function implements:
            the logit pass to X. 1/(1 + e-z*theta)
            '''


if __name__ == '__main__':
      mean_1 = np.array([10, 10])
      mean_2 = np.array([5, 5])
      m_cov = np.array([[1, 0], [0, 1]])
      size = 100
      X = np.concatenate([np.random.multivariate_normal(size=size, mean=mean_1, cov=m_cov),
                          np.random.multivariate_normal(size=size, mean=mean_2, cov=m_cov)],
                         axis=0)
      y = np.concatenate([np.ones(size).reshape(-1, 1), np.zeros(size).reshape(-1, 1)])

      log1 = Logit(X=X, y=y)
