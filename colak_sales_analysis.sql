-- Capstone 1: Sales Territory Analysis
-- Analyst: Burak Colak
-- Territory: Massachusetts (Northeast region)
-- Database: sample_sales

USE sample_sales;

-- ===================================================
-- Q1: Total revenue and date range for Massachusetts
-- ===================================================

SELECT SUM(Sale_Amount) AS total_revenue,
       MIN(Transaction_Date) AS start_date,
       MAX(Transaction_Date) AS end_date
FROM Store_Sales
JOIN store_locations ON store_sales.Store_ID = store_locations.StoreId
WHERE store_locations.State = 'Massachusetts';



