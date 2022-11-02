import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cm as cm

predicciones=pd.read_csv('datos2.csv',delimiter='|', names=['Cliente','Tiempo_Siguiente'])
predicciones['Tiempo_Siguiente']=predicciones['Tiempo_Siguiente'].apply(lambda x: x/(24*60*60))
plt.scatter(predicciones['Cliente'],predicciones['Tiempo_Siguiente'], c = cm.rainbow(np.linspace(0,1,predicciones.shape[0])) )
plt.xlabel('Percentiles')
plt.ylabel('Tiempo Delta')
plt.title('Tiempo de siguiente compra vs Percentil de Descarga ')
plt.show()
plt.savefig('mygraph.png')
