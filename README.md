# Capstone 1: EmporiUm Sales Territory Analysis

**Analyst:** Burak Colak
**Territory:** Massachusetts (Northeast region, in-store sales)
**Tools:** MySQL Workbench, Excel (PivotCharts), Git/GitHub

## Project Description

EmporiUm is a student bookstore chain that also sells tech products, art
supplies, and other merchandise in stores and online. In this project I act as
a data analyst for the Massachusetts sales territory. I use SQL to answer a
sales manager's questions about the territory's performance, build Excel
PivotCharts to illustrate the findings, and make a recommendation for where to
focus sales attention next quarter.

The data covers in-store sales from January 1, 2022 to December 31, 2025.

## Questions Analyzed

1. Total revenue for the territory, plus the start and end dates of the data
2. Revenue by year and month
3. Territory revenue compared to the Northeast region
4. Number of transactions per month and average transaction amount by product category
5. Ranking of in-store sales performance by store
6. Recommendation for where to focus sales attention next quarter

## Files

| File | Description |
|---|---|
| `colak_sales_analysis.sql` | SQL script with queries and comments for each question |
| `colak_territory_chart.xlsx` | Excel workbook containing the PivotCharts |

## Database

The analysis uses the `sample_sales` MySQL database, which includes these tables:
`Store_Sales`, `Online_Sales`, `Products`, `Inventory_Categories`,
`Inventory_Subcategories`, `Store_Locations`, `Management`, and `Shipper_List`.

To recreate it, run the provided `sample_sales` SQL script in MySQL Workbench.

## Video Demo

[Watch the 10-minute project walkthrough](ADD-LINK-HERE)

## Key Findings

- Massachusetts in-store revenue totals **$5,733,256.27** and makes up **23.65%** of the Northeast region.
- Revenue grew every year, with a big jump in 2025 (+55.4% vs. 2024).
- The growth came from volume: transactions rose 74.1% while the average sale fell 10.7%.
- The average sale fell because cheap categories (apparel, art supplies, books, stationery) roughly doubled in transactions, while average prices within each category held steady.
- Technology & Accessories is the biggest revenue driver (about 73% of 2025 revenue), and its average sale increased from $457 to $485.
- Textbooks lagged: transactions grew only 12% in 2025, and Q1 is the weakest textbook quarter in all four years.
- Worcester is the top store ($602K). The lowest-ranked stores have normal transaction counts but a lower average sale.

## Recommendation

Focus on **Technology & Accessories** to protect the main revenue driver, and run a
**textbook promotion in Q1**, which is the weakest quarter for the weakest-growing
category. Because the data ends in December 2025, these trends should be rechecked
against more recent sales before acting.

**Stores:** Worcester leads all stores in revenue ($602K). The lowest-ranked stores
(Lowell, Framingham, Falmouth, Quincy) have normal transaction counts but a lower
average sale ($121 to $128 vs. $142 to $148 at the top), so technology promotions
could help them most.

## Charts

The Excel workbook contains PivotCharts of quarterly revenue by product category
(2022 to 2025) and of total revenue by store.
