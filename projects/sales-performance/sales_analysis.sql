-- Sales Performance Dashboard
-- Source table: dbo.sales_raw

USE SalesAnalytics;
GO

-- 1. Data-quality check
SELECT COUNT(*) AS nombre_lignes
FROM dbo.sales_raw;
GO

-- 2. Sales and profit by region
SELECT
    Region,
    SUM(TRY_CONVERT(decimal(18,2), Sales)) AS ventes_totales,
    SUM(TRY_CONVERT(decimal(18,2), Profit)) AS profit_total
FROM dbo.sales_raw
GROUP BY Region
ORDER BY ventes_totales DESC;
GO

-- 3. Profit margin by region
SELECT
    Region,
    ROUND(
        100.0 * SUM(TRY_CONVERT(decimal(18,2), Profit))
        / NULLIF(SUM(TRY_CONVERT(decimal(18,2), Sales)), 0),
        2
    ) AS marge_pct
FROM dbo.sales_raw
GROUP BY Region
ORDER BY marge_pct DESC;
GO

-- 4. Profit by region and category
SELECT
    Region,
    Category,
    SUM(TRY_CONVERT(decimal(18,2), Profit)) AS profit_total
FROM dbo.sales_raw
GROUP BY Region, Category
ORDER BY profit_total DESC;
GO

-- 5. Best-selling products by quantity
SELECT TOP 10
    Product_Name,
    SUM(TRY_CONVERT(int, Quantity)) AS quantite_vendue
FROM dbo.sales_raw
GROUP BY Product_Name
ORDER BY quantite_vendue DESC;
GO

-- 6. Customer segment performance
SELECT
    Segment,
    SUM(TRY_CONVERT(decimal(18,2), Sales)) AS ventes_totales,
    SUM(TRY_CONVERT(decimal(18,2), Profit)) AS profit_total
FROM dbo.sales_raw
GROUP BY Segment
ORDER BY profit_total DESC;
GO

-- 7. Analytical view used by Power BI
CREATE OR ALTER VIEW dbo.vw_region_performance AS
SELECT
    Region,
    SUM(TRY_CONVERT(decimal(18,2), Sales)) AS ventes_totales,
    SUM(TRY_CONVERT(decimal(18,2), Profit)) AS profit_total,
    SUM(TRY_CONVERT(int, Quantity)) AS quantite_totale
FROM dbo.sales_raw
GROUP BY Region;
GO

-- 8. Validation of the Power BI source
SELECT *
FROM dbo.vw_region_performance;
GO
