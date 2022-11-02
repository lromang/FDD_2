#! /usr/bin/env python

import numpy as np
import math
import sys
from datetime import date, timedelta, datetime

value = 1-(float(sys.argv[1])/100) #percentil promedio
fecha_inicial = sys.argv[2]

delta = math.ceil(np.random.exponential(scale=value*10**(1+value), size=1))
fecha_final = datetime.strptime(fecha_inicial,'%Y-%m-%d')+timedelta(days=delta)

print(fecha_final)
print(delta)
