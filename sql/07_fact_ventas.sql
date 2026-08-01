-- 07_fact_ventas.sql
-- FactVentas: grano = order_item. Incluye todos los order_status no solo "delivered" para permitir analisis de cancelacion o perdida.

USE OlistDW;
GO

CREATE TABLE dw.FactVentas (
    FactVentaID     INT IDENTITY(1,1) PRIMARY KEY,
    order_id          NVARCHAR(50),      -- degenerate dimension
    order_item_id      INT,
    ClienteID         INT NOT NULL,
    ProductoID        INT NOT NULL,
    VendedorID        INT NOT NULL,
    DateID            INT NOT NULL,
    OrderStatus        NVARCHAR(50),
    Price              DECIMAL(10,2),
    FreightValue        DECIMAL(10,2),
    FOREIGN KEY (ClienteID) REFERENCES dw.DimCliente(ClienteID),
    FOREIGN KEY (ProductoID) REFERENCES dw.DimProducto(ProductoID),
    FOREIGN KEY (VendedorID) REFERENCES dw.DimVendedor(VendedorID),
    FOREIGN KEY (DateID) REFERENCES dw.DimTiempo(DateID)
);
GO

INSERT INTO dw.FactVentas (order_id, order_item_id, ClienteID, ProductoID, VendedorID, DateID, OrderStatus, Price, FreightValue)
SELECT
    oi.order_id,
    oi.order_item_id,
    dc.ClienteID,
    dp.ProductoID,
    dv.VendedorID,
    dt.DateID,
    o.order_status,
    CAST(oi.price AS DECIMAL(10,2)),
    CAST(oi.freight_value AS DECIMAL(10,2))
FROM staging.order_items oi
JOIN staging.orders o
    ON oi.order_id = o.order_id
JOIN staging.customers c
    ON c.customer_id = o.customer_id
JOIN dw.DimCliente dc
    ON dc.customer_unique_id = c.customer_unique_id
JOIN dw.DimProducto dp
    ON dp.product_id = oi.product_id
JOIN dw.DimVendedor dv
    ON dv.seller_id = oi.seller_id
JOIN dw.DimTiempo dt
    ON dt.Fecha = CAST(TRY_CONVERT(datetime, o.order_purchase_timestamp) AS DATE);
GO

-- Se esperan 112.650 filas (total de order_items)
-- SELECT COUNT(*) FROM dw.FactVentas;