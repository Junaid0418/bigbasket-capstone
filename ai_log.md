# AI-Assisted Prompting Log

## Prompt #1 (Part 1 — SQL: LEFT JOIN zero-order query)

**Role:** You are an experienced SQLite analyst helping me debug a
GROUP BY / JOIN query for a retail analytics project.

**Context:** I have a `products` table (31 rows, including one product,
"Premium Face Cream 50g", that has never been ordered) and an `orders`
table (500 rows) linked by `product_id`. I need a query that lists every
product together with its total number of orders, and the zero-order
product must still appear in the result with a count of 0, not be
dropped from the output.

**Task:** Write a SQL query using a LEFT JOIN from `products` to `orders`,
grouped by product, that counts orders per product and correctly shows 0
for products with no matching orders.

**Constraints:** Must use LEFT JOIN (not INNER JOIN), must not use
`COUNT(*)` for the count column (since that counts the unmatched NULL
row as 1 instead of 0), and must GROUP BY the product's primary key and
name together.

**Format:** A single runnable SQLite SELECT statement, ordered ascending
by order count so the zero-order product surfaces first.

**Verification performed:** I ran the AI-suggested query against
`bigbasket_capstone.db` using Python's `sqlite3` module and manually
checked the first row of output — it returned `('Premium Face Cream 50g', 0)`
as the very first row, confirming the LEFT JOIN with `COUNT(o.order_id)`
(rather than `COUNT(*)`) correctly preserved the zero-order product
instead of silently dropping it.
