-- Row counts: orders should be ~99k
SELECT 'orders' AS t, count(*) FROM raw.orders
UNION ALL SELECT 'order_items', count(*) FROM raw.order_items
UNION ALL SELECT 'customers', count(*) FROM raw.customers;

-- Check DuckDB read the dates as timestamps, not text
DESCRIBE raw.orders;

-- Orders per month
SELECT date_trunc('month', order_purchase_timestamp) AS month, count(*) AS orders
FROM raw.orders
GROUP BY 1 ORDER BY 1;

-- Top 10 categories by revenue, in English
SELECT t.product_category_name_english AS category,
       round(sum(i.price), 0)           AS revenue
FROM raw.order_items i
JOIN raw.products p             USING (product_id)
LEFT JOIN raw.category_translation t USING (product_category_name)
GROUP BY 1 ORDER BY 2 DESC LIMIT 10;