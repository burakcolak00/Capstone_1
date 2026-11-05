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

-- Result: Massachusetts in-store revenue totals $5,733,256.27 for 1 Jan 2022 to 31 Dec 2025 (four full years).
-- Note: DATE_FORMAT is used because my SQL client displayed raw dates one day early (12/31/2021).

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

-- Result: 48 rows (one per month, Jan 2022 to Dec 2025). Monthly revenue sums to $5,733,256.27, matching Q1.
-- Observation: Revenue grew every year, with a big jump in 2025.

-- ======================================================================
-- Q3: Comparison total revenue for Massachusetts vs. Northeast region
-- ======================================================================

SELECT *
FROM (
    SELECT State,
           total_revenue, 
           SUM(total_revenue) OVER() AS northeast_revenue, 
           ROUND(total_revenue / SUM(total_revenue) OVER() * 100, 2 ) AS state_pct_of_region
    FROM (
        SELECT State, 
               SUM(Sale_Amount) AS total_revenue 
        FROM store_sales JOIN store_locations ON store_sales.Store_ID = store_locations.StoreId
        JOIN management USING(State)
        WHERE Region = 'Northeast'
        GROUP BY 1) AS total_rev_by_state_in_northeast
    ) AS pct_of_rev_by_state
WHERE State = 'Massachusetts';  

-- Result: Massachusetts revenue is 23.65% of northeast revenue. 

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

-- Result: one row per month and product category. Transactions sum to 42,010, matching the state total.
-- Observation: Technology & Accessories has highest average sale.

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

-- Result: 18 stores. Worcester ranks first ($602K, about double the transactions of any other store).
-- Lowell ranks last ($267K). Lowest-ranked stores have lower average sales, not fewer transactions.

-- ====================================================================================
-- Q6 Recommendation for where to focus sales attention next quarter for Massachusetts
-- ====================================================================================

-- Revenue by store and year

SELECT store_locations.StoreLocation AS store_location,
       YEAR(Transaction_Date) AS sale_year,
       SUM(Sale_Amount) AS total_revenue
FROM Store_Sales
JOIN store_locations ON store_sales.Store_ID = store_locations.StoreId
WHERE store_locations.State = 'Massachusetts'
GROUP BY 1, 2
ORDER BY 1, 2 ASC;

-- As a result of this table we clearly see that 2025 has a big jump all over the state.
-- Next, let's analyse the reason of the jump

SELECT YEAR(Transaction_Date) AS sale_year,
       SUM(Sale_Amount) AS total_revenue,
       COUNT(*) AS number_of_transactions,
       ROUND(AVG(Sale_Amount), 2) AS avg_sale_amount
FROM Store_Sales
JOIN store_locations ON store_sales.Store_ID = store_locations.StoreId
WHERE store_locations.State = 'Massachusetts'
AND YEAR(Transaction_Date) IN(2024, 2025)
GROUP BY 1
ORDER BY 1;

-- 2025 vs 2024: revenue +55.4%, transactions +74.1%, average sale -10.7%
-- Volume drove the growth: more transactions, at a smaller average sale.

-- Analysing -10.7% on average_sale between 2024 and 2025

SELECT YEAR(Transaction_Date) AS sale_year,
       Category,
       COUNT(*) AS num_of_sales,
       ROUND(AVG(Sale_Amount), 2) AS avg_sale_amount 
FROM store_sales
JOIN products ON store_sales.Prod_Num = products.ProdNum
JOIN inventory_categories USING(Categoryid)
JOIN store_locations ON store_sales.Store_ID = store_locations.StoreId
WHERE store_locations.State = 'Massachusetts'
AND YEAR(Transaction_Date) IN(2024,2025)
GROUP BY 1, 2
ORDER BY 1, 2, 3;

-- Technology & Accessories is the biggest revenue driver.
-- Cheap categories doubled, so the overall average fell. 


SELECT YEAR(Transaction_Date) AS sale_year,
       QUARTER(Transaction_Date) AS sale_quarter,
       Category,
       COUNT(*) AS num_of_sales,
       SUM(Sale_Amount) AS total_revenue
FROM store_sales
JOIN products ON store_sales.Prod_Num = products.ProdNum
JOIN inventory_categories USING(Categoryid)
JOIN store_locations ON store_sales.Store_ID = store_locations.StoreId
WHERE store_locations.State = 'Massachusetts'
AND Category IN('Textbooks', 'Technology & Accessories')
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3;

-- Textbooks and Technology by quarter: Q1 is the weakest textbook quarter every year.

-- =====================================================================
-- RECOMMENDATION: Where to focus sales attention next quarter
-- =====================================================================
-- Focus on Technology & Accessories, and add a textbook promotion for Q1.
--
-- Evidence:
-- 1. Revenue grew 55.4% in 2025 because of transaction volume (+74.1%), not prices.
--    The average sale fell 10.7% because cheap categories (apparel, art supplies,
--    books, stationery) about doubled their transactions.
-- 2. Technology & Accessories is the biggest revenue driver: about $1.56M in 2025
--    (73% of the year's revenue), up 61% from 2024. Its average sale rose from $457 to $485.
-- 3. Technology kept accelerating: Q4 2025 revenue was about 110% higher than Q4 2024.
-- 4. Textbooks lagged: transactions grew only 12% in 2025 while most categories
--    grew 90% or more. Q1 is also the weakest textbook quarter in all four years,
--    and Q1 2025 textbook revenue fell about 19% from Q1 2024.
--
-- Action: Keep technology stock and promotions strong to protect the main revenue driver,
-- and run a textbook promotion in Q1 to lift the weakest category and quarter.
--
-- Store note: Worcester leads all stores in revenue ($602K). The lowest-ranked stores
-- (Lowell, Framingham, Falmouth, Quincy) have normal transaction counts but a lower
-- average sale ($121 to $128 vs. $142 to $148 at the top), so technology promotions
-- could help them most.
