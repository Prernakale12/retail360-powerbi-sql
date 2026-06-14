-- Segmentation view

CREATE OR ALTER VIEW customer_segments AS
SELECT
	customer_id,
	customer_name,
	segment,
	COUNT(DISTINCT order_id) AS frequency,
	SUM(sales) AS momentary,
	DATEDIFF(DAY, MAX(order_date), '2017-12-31') AS recency_days,
	ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct
FROM clean_orders
GROUP BY customer_id, customer_name, segment;
GO
