import pandas as pd 
import numpy as np 

#poblacion_1_exp = np.random.exponential(0.5)
#poblacion_2_exp = np.random.exponential(1)
#poblacion_3_exp = np.random.exponential(1.5)

values = {"fecha":[], "id":[], "pop":[]}

#print(pd.Timedelta(days = 1) + pd.to_datetime(pd.date_range(start="2022-09-15", end="2022-09-15", periods=1)))


for i in range(200):
    fecha_inicial = pd.date_range(start="2022-09-15", end="2022-12-1", periods=1)
    values["fecha"].append(fecha_inicial)
    values["id"].append(i)
    values["pop"].append(0)
    ult_fecha = fecha_inicial
    for j in range(10):
        poblacion_1_exp = np.random.exponential(0.5) 
        fecha_inicial = ult_fecha + pd.Timedelta(days = poblacion_1_exp)
        values["fecha"].append(fecha_inicial)
        values["id"].append(i)
        values["pop"].append(0)
        ult_fecha = fecha_inicial

for i in range(200):
    fecha_inicial = pd.date_range(start="2022-09-15", end="2022-12-1", periods=1)
    values["fecha"].append(fecha_inicial)
    values["id"].append(i)
    values["pop"].append(1)
    ult_fecha = fecha_inicial
    for j in range(10): 
        poblacion_2_exp = np.random.exponential(1)
        fecha_inicial = ult_fecha + pd.Timedelta(days = poblacion_2_exp*10)
        values["fecha"].append(fecha_inicial)
        values["id"].append(i)
        values["pop"].append(1)
        ult_fecha = fecha_inicial

for i in range(200):
    fecha_inicial = pd.date_range(start="2022-09-15", end="2022-12-1", periods=1)
    values["fecha"].append(fecha_inicial)
    values["id"].append(i)
    values["pop"].append(2)
    ult_fecha = fecha_inicial
    for j in range(10):
        poblacion_3_exp = np.random.exponential(1.5) 
        fecha_inicial = pd.to_datetime(ult_fecha + pd.Timedelta(days = poblacion_3_exp))
        values["fecha"].append(fecha_inicial)
        values["id"].append(i)
        values["pop"].append(2)
        ult_fecha = fecha_inicial

df = pd.DataFrame(values, columns=["fecha", "id", "pop"])

start = pd.to_datetime("2022-09-15")
end = pd.to_datetime("2022-12-1")

population0 = df[df["pop"] == 0] 
num_population0 = len(population0)

population1 = df[df["pop"] == 1] 
num_population1 = len(population1)

population2 = df[df["pop"] == 2] 
num_population2 = len(population2)

values_percentages_p0 = []
values_percentages_p1 = []
values_percentages_p2 = []


df_percentages = pd.DataFrame(columns=["w1", "w2", "w3", "w4", "w5", "w6", "w7", "w8", "w9", "w10", "w11", "w12"])

while(start <= end): 
    end_week = start + pd.Timedelta(days = 7)
    #print(start, end_week)

    #para p0
    mask = (population0['fecha'] >= start) & (population0['fecha'] <= end_week)
    num_user_returned_p0 = len(population0[mask]["id"].unique()) 
    values_percentages_p0.append(num_user_returned_p0 / 200)


    #para p1
    mask = (population1['fecha'] >= start) & (population1['fecha'] <= end_week)
    num_user_returned_p1 = len(population1[mask]["id"].unique()) 
    values_percentages_p1.append(num_user_returned_p1 / 200)

    #para p2
    mask = (population2['fecha'] >= start) & (population2['fecha'] <= end_week)
    num_user_returned_p2 = len(population2[mask]["id"].unique()) 
    values_percentages_p2.append(num_user_returned_p2 / 200)

    start = end_week


print(values_percentages_p0, values_percentages_p1, values_percentages_p2)

df_percentages_p0 = pd.Series(values_percentages_p0)
df_percentages_p1 = pd.Series(values_percentages_p1)
df_percentages_p2 = pd.Series(values_percentages_p2)

df_percentages = pd.concat([df_percentages_p0, df_percentages_p1, df_percentages_p2], axis=1)

#df_percentages.iloc[0] = values_percentages_p0
#df_percentages.iloc[1] = values_percentages_p1
#df_percentages.iloc[2] = values_percentages_p2



print(df_percentages)
#weeks = pd.date_range(start="2022-09-15", end="2022-12-15", freq="1W")
#print(weeks)








