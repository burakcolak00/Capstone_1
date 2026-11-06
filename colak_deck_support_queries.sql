-- Capstone 1: extra queries for the presentation visuals
-- Analyst: Burak Colak | Territory: Massachusetts (Northeast region)

USE sample_sales;

-- =====================================================================
-- 1. Whole database: transactions and revenue by channel
-- =====================================================================

SELECT 'In-store' AS channel,
       COUNT(*) AS transactions,
       ROUND(SUM(Sale_Amount), 2) AS revenue
FROM Store_Sales
UNION ALL
SELECT 'Online',
       COUNT(*),
       ROUND(SUM(SalesTotal), 2)
FROM Online_Sales;

-- =====================================================================
-- 2. Whole database: size of the business
-- =====================================================================
SELECT (SELECT COUNT(*) FROM Store_Locations) AS stores,
       (SELECT COUNT(DISTINCT State) FROM Store_Locations) AS store_states,
       (SELECT COUNT(DISTINCT ShiptoState) FROM Online_Sales) AS online_ship_states,
       (SELECT COUNT(*) FROM Products) AS products,
       (SELECT COUNT(*) FROM Inventory_Categories) AS categories;

-- =====================================================================
-- 3. Whole database: revenue by year and channel
-- =====================================================================
SELECT YEAR(Transaction_Date) AS sale_year,
       'In-store' AS channel,
       ROUND(SUM(Sale_Amount), 2) AS revenue
FROM Store_Sales
GROUP BY 1
UNION ALL
SELECT YEAR(`Date`),
       'Online',
       ROUND(SUM(SalesTotal), 2)
FROM Online_Sales
GROUP BY 1
ORDER BY 1, 2;

-- =====================================================================
-- 4. Massachusetts: transactions, stores, average sale
-- =====================================================================
SELECT COUNT(*) AS transactions,
       COUNT(DISTINCT Store_ID) AS stores,
       ROUND(AVG(Sale_Amount), 2) AS avg_sale,
       ROUND(SUM(Sale_Amount), 2) AS revenue
FROM Store_Sales
JOIN store_locations ON store_sales.Store_ID = store_locations.StoreId
WHERE store_locations.State = 'Massachusetts';

-- =====================================================================
-- 5. Massachusetts: share of transactions by category group, 2024 vs 2025
-- =====================================================================
SELECT YEAR(Transaction_Date) AS sale_year,
       ROUND(100 * SUM(Category = 'Technology & Accessories') / COUNT(*), 1) AS pct_technology,
       ROUND(100 * SUM(Category = 'Textbooks') / COUNT(*), 1) AS pct_textbooks,
       ROUND(100 * SUM(Category NOT IN ('Technology & Accessories', 'Textbooks')) / COUNT(*), 1) AS pct_low_ticket
FROM store_sales
JOIN products ON store_sales.Prod_Num = products.ProdNum
JOIN inventory_categories USING(Categoryid)
JOIN store_locations ON store_sales.Store_ID = store_locations.StoreId
WHERE store_locations.State = 'Massachusetts'
  AND YEAR(Transaction_Date) IN (2024, 2025)
GROUP BY 1
ORDER BY 1;

-- ========================================
-- 6. Average sale vs tech% for each store
-- For relational analysis
-- ========================================

SELECT
    StoreLocation AS store_location,
    ROUND(AVG(Sale_Amount), 2) AS avg_sale,
    ROUND(100 * SUM(Category = 'Technology & Accessories') / COUNT(*),1) AS tech_pct_of_transactions
FROM store_sales
JOIN products
    ON store_sales.Prod_Num = products.ProdNum
JOIN inventory_categories
    USING (CategoryId)
JOIN store_locations
    ON store_sales.Store_ID = store_locations.StoreId
WHERE State = 'Massachusetts'
GROUP BY StoreLocation
ORDER BY avg_sale DESC;