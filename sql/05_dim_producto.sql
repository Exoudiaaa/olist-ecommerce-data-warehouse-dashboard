-- 05_dim_producto.sql
-- DimProducto: categoria con fallback en cascada para trabajar productos sin traduccion de nombre de categoria o categoria en portugues.

USE OlistDW;
GO

CREATE TABLE dw.DimProducto (
    ProductoID           INT IDENTITY(1,1) PRIMARY KEY,
    product_id             NVARCHAR(50),   -- llave de negocio
    categoria_pt            NVARCHAR(100),  -- nombre original
    categoria_en             NVARCHAR(100)   -- traducido, con fallback
);
GO

INSERT INTO dw.DimProducto (product_id, categoria_pt, categoria_en)
SELECT
    p.product_id,
    COALESCE(p.product_category_name, 'sem_categoria') AS categoria_pt,
    COALESCE(pcn.product_category_name_english, p.product_category_name, 'sem_categoria') AS categoria_en
FROM staging.products p
LEFT JOIN staging.product_category_name_translation pcn
    ON pcn.product_category_name = p.product_category_name;
GO

-- Se esperan 32.951 filas (product_id unicos)
-- SELECT COUNT(*) FROM dw.DimProducto;
