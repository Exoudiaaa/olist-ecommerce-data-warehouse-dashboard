-- 08_fact_pagos.sql
-- FactPagos: grano = pago por pedido (distinto al grano de FactVentas).
-- No referencia ProductoID ni VendedorID ya que el pago no ocurre a nivel de producto/vendedor especifico, es consecuencia del diseño del fact constellation.

USE OlistDW;
GO

CREATE TABLE dw.FactPagos (
    FactPagoID          INT IDENTITY(1,1) PRIMARY KEY,
    order_id              NVARCHAR(50),      -- degenerate dimension
    payment_sequential      INT,
    ClienteID             INT NOT NULL,
    DateID                INT NOT NULL,
    PaymentType            NVARCHAR(50),
    PaymentInstallments      INT,
    PaymentValue            DECIMAL(10,2),
    FOREIGN KEY (ClienteID) REFERENCES dw.DimCliente(ClienteID),
    FOREIGN KEY (DateID) REFERENCES dw.DimTiempo(DateID)
);
GO

INSERT INTO dw.FactPagos (order_id, payment_sequential, ClienteID, DateID, PaymentType, PaymentInstallments, PaymentValue)
SELECT
    op.order_id,
    CAST(op.payment_sequential AS INT),
    dc.ClienteID,
    dt.DateID,
    op.payment_type,
    CAST(op.payment_installments AS INT),
    CAST(op.payment_value AS DECIMAL(10,2))
FROM staging.order_payments op
JOIN staging.orders o ON op.order_id = o.order_id
JOIN staging.customers c ON o.customer_id = c.customer_id
JOIN dw.DimCliente dc ON c.customer_unique_id = dc.customer_unique_id
JOIN dw.DimTiempo dt ON dt.Fecha = CAST(TRY_CONVERT(datetime, o.order_purchase_timestamp) AS DATE);
GO

-- Se esperan 103.886 filas (total de order_payments)
-- SELECT COUNT(*) FROM dw.FactPagos;
