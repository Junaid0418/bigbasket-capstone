-- 01_foundations.sql
-- BigBasket Capstone — Part 1, Task 3: Foundational SQL queries
-- Each query below is labelled and stands alone.

-- =====================================================================
-- 1) SELECT / WHERE — orders placed by customers in a specific city
--    (joins to customers since city lives there, not on orders directly)
-- =====================================================================
SELECT o.order_id, c.name, c.city, o.order_date, o.amount_inr, o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.city = 'Bengaluru';


-- =====================================================================
-- 2) DISTINCT — list every distinct category
-- =====================================================================
SELECT DISTINCT category
FROM products;


-- =====================================================================
-- 3) ORDER BY + LIMIT — the 5 highest-value orders by amount_inr
-- =====================================================================
SELECT order_id, customer_id, product_id, amount_inr, status
FROM orders
ORDER BY amount_inr DESC
LIMIT 5;


-- =====================================================================
-- 4) Alias (AS) — rename an aggregate/column in the output
-- =====================================================================
SELECT COUNT(*) AS total_orders
FROM orders;


-- =====================================================================
-- 5) IN — orders whose payment_mode is in a 2-mode list
-- =====================================================================
SELECT order_id, payment_mode, amount_inr
FROM orders
WHERE payment_mode IN ('UPI', 'Credit Card');


-- =====================================================================
-- 6) BETWEEN — orders with amount_inr in a stated range
-- =====================================================================
SELECT order_id, amount_inr
FROM orders
WHERE amount_inr BETWEEN 100 AND 500;


-- =====================================================================
-- 6b) NOT BETWEEN — orders with amount_inr outside that same range
-- =====================================================================
SELECT order_id, amount_inr
FROM orders
WHERE amount_inr NOT BETWEEN 100 AND 500;


-- =====================================================================
-- 7) IS NULL — orders with no rating recorded
--    (these are exactly the Cancelled / Pending orders, which never
--     receive a rating — Delivered orders always have one)
-- =====================================================================
SELECT order_id, status, rating
FROM orders
WHERE rating IS NULL;
