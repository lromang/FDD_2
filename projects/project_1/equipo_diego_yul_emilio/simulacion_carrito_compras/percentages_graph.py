import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('c:/Users/Diego Arellano/Desktop/ITAM/Fuentes de datos/percentages.csv', header=None, names=["num", "percentage"])

plt.scatter(df["num"], df["percentage"])
plt.xlabel("Número de repetidos")
plt.ylabel("Porcentaje")

plt.show()