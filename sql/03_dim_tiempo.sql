-- 03_dim_tiempo.sql
-- DimTiempo: generada con CTE recursiva, no desde staging,
-- para tener todos los dias del periodo, asi traer periodos en los que no hubo ventas.

USE OlistDW;
GO

CREATE TABLE dw.DimTiempo (
    DateID          INT IDENTITY(1,1) PRIMARY KEY,
    Fecha           DATE,
    Anio            INT,
    Mes             INT,
    NombreMes       NVARCHAR(20),
    Trimestre       INT,
    DiaSemana       INT,
    NombreDiaSemana NVARCHAR(20)
);
GO

WITH Calendario AS (
    SELECT CAST('2016-01-01' AS DATE) AS Fecha
    UNION ALL
    SELECT DATEADD(DAY, 1, Fecha)
    FROM Calendario
    WHERE Fecha < '2018-12-31'
)
INSERT INTO dw.DimTiempo (Fecha, Anio, Mes, NombreMes, Trimestre, DiaSemana, NombreDiaSemana)
SELECT
    Fecha,
    YEAR(Fecha),
    MONTH(Fecha),
    DATENAME(MONTH, Fecha),
    DATEPART(QUARTER, Fecha),
    DATEPART(WEEKDAY, Fecha),
    DATENAME(WEEKDAY, Fecha)
FROM Calendario
OPTION (MAXRECURSION 0);
GO
