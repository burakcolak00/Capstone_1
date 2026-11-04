-- Capstone 1: Sales Territory Analysis
-- Analyst: Burak Colak
-- Territory: Massachusetts (Northeast region)
-- Database: sample_sales

USE sample_sales;

-- ===================================================
-- Q1: Total revenue and date range for Massachusetts
-- ===================================================

SELECT SUM(Sale_Amount) AS total_revenue,
       DATE_FORMAT(MIN(Transaction_Date), '%Y-%m-%d') AS start_date,
       DATE_FORMAT(MAX(Transaction_Date), '%Y-%m-%d') AS end_date
FROM Store_Sales
JOIN store_locations ON store_sales.Store_ID = store_locations.StoreId
WHERE store_locations.State = 'Massachusetts';


-- ================================================
-- Q2: Revenue by year and month for Massachusetts
-- ================================================

SELECT YEAR(Transaction_Date) AS sale_year,
       MONTH(Transaction_Date) AS sale_month,
       SUM(Sale_Amount) AS total_revenue
FROM store_sales
JOIN store_locations ON store_sales.Store_ID = store_locations.StoreId
WHERE store_locations.State = 'Massachusetts'
GROUP BY 1, 2
ORDER BY 1, 2; 

-- ======================================================================
-- Q3: Comparision total revenue for Massachusetts vs. Northeast region
-- ======================================================================

SELECT *
FROM (
    SELECT State,
           total_revenue, 
           SUM(total_revenue) OVER() AS northeast_revenue, 
           ROUND(total_revenue / SUM(total_revenue) OVER() * 100, 2 ) AS state_pct_of_region
    FROM (
        SELECT State, SUM(Sale_Amount) AS total_revenue 
        FROM store_sales JOIN store_locations ON store_sales.Store_ID = store_locations.StoreId
        JOIN management USING(State)
        WHERE Region = 'Northeast'
        GROUP BY 1
        ORDER BY 2 DESC) AS total_rev_by_state_in_northeast
    ) AS pct_of_rev_by_state
WHERE State = 'Massachusetts';  

-- ============================================================================
-- Q4: Num of monthly transactions and average sale by category, Massachusetts
-- ============================================================================

SELECT YEAR(Transaction_Date) AS sale_year,
       MONTH(Transaction_Date) AS sale_month,
       Category,
       COUNT(*) AS num_of_sales,
       ROUND(AVG(Sale_Amount), 2) AS avg_sale_amount 
FROM store_sales
JOIN products ON store_sales.Prod_Num = products.ProdNum
JOIN inventory_categories USING(Categoryid)
JOIN store_locations ON store_sales.Store_ID = store_locations.StoreId
WHERE store_locations.State = 'Massachusetts'
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3;

-- =====================================================================
-- Q5 Ranking of in-store sales performance by store for Massachusetts
-- =====================================================================

SELECT RANK() OVER (ORDER BY SUM(Sale_Amount) DESC) AS store_rank,
       Store_ID,
       store_locations.StoreLocation AS store_location,
       SUM(Sale_Amount) AS total_revenue, 
       COUNT(*) AS number_of_transactions,
       ROUND(AVG(Sale_Amount), 2) AS avg_sale_amount 
FROM Store_Sales
JOIN store_locations ON store_sales.Store_ID = store_locations.StoreId
WHERE store_locations.State = 'Massachusetts'
GROUP BY 2
ORDER BY 4 DESC;

-- ====================================================================================
-- Q6 Recommendation for where to focus sales attention next quarter for Massachusetts
-- ====================================================================================








