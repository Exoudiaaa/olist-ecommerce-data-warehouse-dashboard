-- 06_dim_vendedor.sql
-- DimVendedor: seller_id ya es único en origen, no requiere mas trabajo como DimCliente.

USE OlistDW;
GO

CREATE TABLE dw.DimVendedor (
    VendedorID       INT IDENTITY(1,1) PRIMARY KEY,
    seller_id          NVARCHAR(100),
    seller_city          NVARCHAR(50),
    seller_state           NVARCHAR(50)
);
GO

INSERT INTO dw.DimVendedor (seller_id, seller_city, seller_state)
SELECT seller_id, seller_city, seller_state
FROM staging.sellers;
GO

-- Se esperan 3.095 filas (seller_id unicos)
-- SELECT COUNT(*) FROM dw.DimVendedor;
