-- 04_dim_cliente.sql
-- DimCliente: deduplicada por customer_unique_id (la llave real de cliente ya que customer_id identifica un pedido, no una persona).
-- Se conserva ciudad/estado de la compra mas reciente por cliente en caso de muda o compra de diferentes ciudades.


USE OlistDW;
GO

CREATE TABLE dw.DimCliente (
    ClienteID           INT IDENTITY(1,1) PRIMARY KEY,
    customer_unique_id  NVARCHAR(50),
    customer_city       NVARCHAR(100),
    customer_state      NVARCHAR(10)
);
GO

WITH Clientes AS (
    SELECT
        c.customer_unique_id,
        c.customer_city,
        c.customer_state,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY TRY_CONVERT(datetime, o.order_purchase_timestamp) DESC
        ) AS rn
    FROM staging.customers c
    JOIN staging.orders o
        ON c.customer_id = o.customer_id
)
INSERT INTO dw.DimCliente (customer_unique_id, customer_city, customer_state)
SELECT
    customer_unique_id,
    customer_city,
    customer_state
FROM Clientes
WHERE rn = 1;
GO

-- Se esperan 96.096 filas (customer_unique_id unicos)
-- SELECT COUNT(*) FROM dw.DimCliente;
