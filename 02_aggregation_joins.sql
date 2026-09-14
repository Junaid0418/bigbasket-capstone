-- 02_aggregation_joins.sql
-- BigBasket Capstone — Part 1, Task 4: Aggregation, Join, and HAVING queries

-- =====================================================================
-- (a) INNER JOIN orders -> products, GROUP BY category, Delivered only
--     HAVING filters to categories whose total_revenue exceeds 10000
-- =====================================================================
SELECT
    p.category,
    COUNT(*) AS order_count,
    SUM(o.amount_inr) AS total_revenue,
    AVG(o.amount_inr) AS avg_revenue
FROM orders o
INNER JOIN products p ON o.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY p.category
HAVING total_revenue > 10000
ORDER BY total_revenue DESC;


-- =====================================================================
-- (b) LEFT JOIN products -> orders, GROUP BY product, counting total
--     orders per product with COUNT(o.order_id) — NOT COUNT(*), since
--     COUNT(*) would wrongly count the unmatched NULL row as 1 instead
--     of 0. Ordered ascending so the least-ordered products (including
--     the genuine zero-order product) surface first.
-- =====================================================================
SELECT
    p.product_name,
    COUNT(o.order_id) AS total_orders
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_orders ASC;
