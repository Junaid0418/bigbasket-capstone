-- verify.sql
-- Verification queries confirming the generated dataset matches
-- the acceptance criteria: exactly 31 products, 50 customers,
-- 500 orders, 6 category_targets, with orders.status split
-- Delivered 434 / Cancelled 42 / Pending 24.
--
-- Results of running these queries are saved in verify_output.txt.

SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM category_targets;

SELECT status, COUNT(*) FROM orders GROUP BY status;
