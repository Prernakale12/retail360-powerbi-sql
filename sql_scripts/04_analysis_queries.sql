-- 1. Top 10 products by revenue
SELECT TOP 10
    product_name,
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit
FROM clean_orders
GROUP BY product_name
ORDER BY total_revenue DESC;

-- 2. Revenue and profit by region
SELECT
    region,
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) * 100.0 / SUM(sales), 2) AS profit_margin_pct
FROM clean_orders
GROUP BY region
ORDER BY total_revenue DESC;

-- 3. Year-over-year revenue growth
WITH yearly_revenue AS (
    SELECT
        YEAR(order_date) AS sales_year,
        SUM(sales) AS total_revenue
    FROM clean_orders
    GROUP BY YEAR(order_date)
)
SELECT
    sales_year,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY sales_year) AS prev_year_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY sales_year)) * 100.0
        / LAG(total_revenue) OVER (ORDER BY sales_year), 2
    ) AS yoy_growth_pct
FROM yearly_revenue
ORDER BY sales_year;

-- 4. Category and sub-category profitability
SELECT
    category,
    sub_category,
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) * 100.0 / SUM(sales), 2) AS profit_margin_pct
FROM clean_orders
GROUP BY category, sub_category
ORDER BY total_profit ASC;  -- ascending shows loss-making sub-categories first

-- 5. Monthly sales trend by segment
SELECT
    FORMAT(order_date, 'yyyy-MM') AS year_month,
    segment,
    SUM(sales) AS total_revenue
FROM clean_orders
GROUP BY FORMAT(order_date, 'yyyy-MM'), segment
ORDER BY year_month, segment;

-- 6. Top 5 states by revenue
SELECT TOP 5
    state,
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM clean_orders
GROUP BY state
ORDER BY total_revenue DESC;

-- 7. Discount impact on profit
SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.2 THEN 'Low Discount (0-20%)'
        WHEN discount <= 0.5 THEN 'Medium Discount (20-50%)'
        ELSE 'High Discount (50%+)'
    END AS discount_band,
    COUNT(*) AS order_count,
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit,
    ROUND(AVG(profit), 2) AS avg_profit_per_order
FROM clean_orders
GROUP BY
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.2 THEN 'Low Discount (0-20%)'
        WHEN discount <= 0.5 THEN 'Medium Discount (20-50%)'
        ELSE 'High Discount (50%+)'
    END
ORDER BY avg_profit_per_order DESC;

-- 8. Top 10 customers by lifetime value (from RFM view)
SELECT TOP 10
    customer_name,
    segment,
    frequency,
    momentary,
    profit_margin_pct
FROM customer_segments
ORDER BY momentary DESC;

-- 9. Customer segments overview (RFM summary)
SELECT
    segment,
    COUNT(*) AS num_customers,
    ROUND(AVG(frequency), 2) AS avg_frequency,
    ROUND(AVG(momentary), 2) AS avg_monetary,
    ROUND(AVG(profit_margin_pct), 2) AS avg_profit_margin_pct
FROM customer_segments
GROUP BY segment
ORDER BY avg_monetary DESC;

-- 10. Ship mode performance (delivery speed vs profitability)
SELECT
    ship_mode,
    COUNT(*) AS total_orders,
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit,
    ROUND(AVG(DATEDIFF(DAY, order_date, ship_date)), 2) AS avg_days_to_ship
FROM clean_orders
GROUP BY ship_mode
ORDER BY total_revenue DESC;
