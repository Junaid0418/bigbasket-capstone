-- 03_reporting.sql
-- BigBasket Capstone — Part 1, Task 5: CASE WHEN tiering, monthly report,
-- and target-variance derived-fields queries

-- =====================================================================
-- (a) Tier every product by its total Delivered revenue:
--     High >= 3000, Medium >= 1000, else Low
-- =====================================================================
SELECT
    p.product_name,
    SUM(o.amount_inr) AS total_revenue,
    CASE
        WHEN SUM(o.amount_inr) >= 3000 THEN 'High'
        WHEN SUM(o.amount_inr) >= 1000 THEN 'Medium'
        ELSE 'Low'
    END AS tier
FROM products p
JOIN orders o ON p.product_id = o.product_id
WHERE o.status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;


-- =====================================================================
-- (b) Monthly-by-category business report (Delivered orders only)
--     This exact result set is what gets exported to
--     monthly_category_revenue.csv — 36 rows, grand total 88282.
-- =====================================================================
SELECT
    p.category,
    strftime('%Y-%m', o.order_date) AS month,
    COUNT(*) AS order_count,
    SUM(o.amount_inr) AS total_revenue,
    AVG(o.amount_inr) AS avg_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY p.category, month
ORDER BY p.category, month;


-- =====================================================================
-- (c) Variance and percentage-variance vs category_targets
--     SQLite integer-division note: total_revenue and target_revenue_inr
--     are both INTEGER columns, so (total_revenue - target_revenue_inr)
--     / target_revenue_inr alone truncates to an integer (almost always 0)
--     BEFORE the *100 ever runs. Multiplying by 100.0 first (a REAL
--     literal) forces floating-point division so the true percentage
--     comes through.
-- =====================================================================
SELECT
    p.category,
    SUM(o.amount_inr) AS total_revenue,
    ct.target_revenue_inr,
    ct.target_revenue_inr - SUM(o.amount_inr) AS variance,
    ((SUM(o.amount_inr) - ct.target_revenue_inr) * 100.0) / ct.target_revenue_inr AS percentage_variance,
    CASE
        WHEN SUM(o.amount_inr) >= ct.target_revenue_inr THEN 'Above Target'
        WHEN SUM(o.amount_inr) >= ct.target_revenue_inr * 0.85 THEN 'Below Target - Watch'
        ELSE 'Below Target - Critical'
    END AS tag
FROM orders o
JOIN products p ON o.product_id = p.product_id
JOIN category_targets ct ON p.category = ct.category
WHERE o.status = 'Delivered'
GROUP BY p.category, ct.target_revenue_inr
ORDER BY percentage_variance DESC;
