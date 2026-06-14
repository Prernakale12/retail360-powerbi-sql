-- Creating clean data

CREATE OR ALTER VIEW clean_orders AS
WITH deduped AS 
(
	SELECT *,
		ROW_NUMBER() OVER
		(
			PARTITION BY [Order_ID], [Product_ID]
			ORDER BY [Order_Date] DESC
		) AS rn
	FROM dbo.raw_orders
	WHERE [Order_ID] IS NOT NULL 
		AND Sales IS NOT NULL 
		AND Profit IS NOT NULL
)
SELECT
	[Order_ID] AS order_id,
	CAST([Order_Date] AS DATE) AS order_date,
	CAST([Ship_Date] AS DATE) AS ship_date,
	[Ship_Mode] AS ship_mode,
	[Customer_ID] AS customer_id,
	[Customer_Name] AS customer_name,
	UPPER(TRIM(Segment)) AS segment,
	[Country] AS country,
	[City] AS city,
	[State] AS state,
	[Region] AS region,
	[Product_ID] AS product_id,
	UPPER(TRIM(Category)) AS category,
	[Sub_Category] AS sub_category,
	[Product_Name] AS product_name,
	CAST(Sales AS DECIMAL(10,2)) AS sales,
	CAST(Quantity AS INT) AS quantity,
	CAST(Discount AS DECIMAL(5,2)) AS discount,
	CAST(Profit AS DECIMAL(10,2)) AS profit
FROM deduped
WHERE rn = 1;
GO
