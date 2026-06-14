-- Find Duplicate order IDs

SELECT [Order_ID], COUNT(*) AS cnt
FROM dbo.raw_orders
GROUP BY [Order_ID]
HAVING COUNT(*) > 1
ORDER BY cnt DESC;

-- Checks for Nulls in Key columns

SELECT
	SUM(CASE WHEN [Order_ID] IS NULL THEN 1 ELSE 0 END) AS null_order_id,
	SUM(CASE WHEN [Customer_ID] IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
	SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
	SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS null_profit
FROM dbo.raw_orders;
GO
