import pandas as pd
import os

carpeta = "data/raw/"

for archivo in os.listdir(carpeta):
    if archivo.endswith(".csv"):
        print(f"\n{'='*50}\n{archivo}\n{'='*50}")
        df = pd.read_csv(os.path.join(carpeta, archivo))
        print(df.shape)
        print(df.dtypes)
        print(df.isnull().sum())
        print(df.duplicated())
        print(df.nunique())