# -*- coding: utf-8 -*-
"""
Created on Wed Feb 22 00:58:02 2023

@author: YHU
"""


import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.tsa.seasonal import MSTL,seasonal_decompose
import statsmodels.api as sm
import statsmodels.tsa.stattools as ts
from statsmodels.tsa.ar_model import AutoReg
from pmdarima.arima import auto_arima
from statsmodels.tsa.statespace.sarimax import SARIMAX




Timeseries = pd.read_csv('weather/weather8.csv',parse_dates = False, usecols=['ts','TEMPC','Pedestrian'])

#timeseries = Timeseries.iloc[5112:13848]

timeseries = []
for i in range(0,52):
    t = Timeseries.iloc[5112+i*168:5232+i*168]
    timeseries.append(t)
    
timeseries = pd.concat(timeseries)


df = pd.DataFrame(timeseries)
p = df['Pedestrian'].values.tolist()
time = df['ts'].values.tolist()

result = ts.adfuller(p)
print(result)

pdf = pd.DataFrame(data=p, index=time, columns=["y"])



#arima = auto_arima(pdf['y'],start_p =1,d=0,start_q=0,max_p=1,max_d=0,max_q=0,start_P=1,D=1,start_Q=0,max_P=1,max_D=1,max_Q=1,m=24,seasonal=True,error_action='warn',trace=True,supress_warnings= True,stepwise=True,random_state=20,n_fits =50)

#print(arima.summary())


sarima = SARIMAX(pdf['y'],order=(1,0,0),seasonal_order=(7,1,0,24))
sarima = sarima.fit()
print(sarima.summary())
sarima.plot_diagnostics(figsize=(15,12))
plt.show()


#sarima (1,0,0)x(7,1,0,24) has the lowest AIC value which is 74858