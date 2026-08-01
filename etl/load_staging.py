"""
load_staging.py
Cargo los 9 CSV de Olist a las tablas staging.* en SQL Server.
Requiere: pandas, sqlalchemy, pyodbc, ODBC Driver 18 for SQL Server.
Las tablas de staging deben existir previamente (ver sql/01_staging_schema.sql).
"""

import os
import pandas as pd
from sqlalchemy import create_engine

server = "localhost"
database = "OlistDW"

engine = create_engine(
    f"mssql+pyodbc://@{server}/{database}"
    "?driver=ODBC+Driver+18+for+SQL+Server"
    "&trusted_connection=yes"
    "&TrustServerCertificate=yes"
)

carpeta = "data/raw/"

# Mapeo tabla en sql server por nombre de su csv.
archivo_tabla = {
    "olist_customers_dataset.csv": "customers",
    "olist_geolocation_dataset.csv": "geolocation",
    "olist_orders_dataset.csv": "orders",
    "olist_order_items_dataset.csv": "order_items",
    "olist_order_payments_dataset.csv": "order_payments",
    "olist_order_reviews_dataset.csv": "order_reviews",
    "olist_products_dataset.csv": "products",
    "olist_sellers_dataset.csv": "sellers",
    "product_category_name_translation.csv": "product_category_name_translation",
}

for archivo, tabla in archivo_tabla.items():
    ruta = os.path.join(carpeta, archivo)
    print(f"Cargando {archivo} -> staging.{tabla} ...")
    df = pd.read_csv(ruta, dtype=str)  # todo como texto para que se inserten bien en tablas staging que estan con sus atributos en NVARCHAR
    df.to_sql(
        tabla,
        engine,
        schema="staging",
        if_exists="append",
        index=False,
        chunksize=1000        # gelocation tiene muchas filas
    )
    print(f"  {len(df)} filas cargadas")

print("Carga completa")
