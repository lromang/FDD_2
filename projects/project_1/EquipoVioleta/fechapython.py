#! /usr/bin/env python

import pandas as pd
from datetime import datetime
import random

inicio = datetime(2020, 1, 1)
final =  datetime(2022, 12, 31)

random_date = inicio + (final - inicio) * random.random()

print((random_date).date())

