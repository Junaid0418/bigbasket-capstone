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

## Prompt #2 (Part 4 — Pandas: data cleaning & validation notebook)

**Role:** Acting as a data analyst cleaning a raw orders export.

**Context:** `orders_raw.csv` (500+ rows) contains duplicates, inconsistent casing in `city`/`category`, missing `amount_inr` and `rating` values, and unbounded outliers in `amount_inr`. Part 1's SQL analysis already established the ground-truth top category (Household Essentials) and grand total revenue.

**Task:** Asked the AI assistant to write a Jupyter notebook that deduplicates the raw export down to exactly 500 rows, standardizes `city`/`category` casing, documents (rather than blindly fills) missing values, computes IQR bounds only on Delivered non-null amounts and caps outliers via `.clip()` instead of dropping them, merges with `products.csv` to find the top category and top supplier by revenue, and produces 3 matplotlib charts plus 3 What/Why/Next-step insights grounded in the notebook's own computed numbers.

**Constraints:** Must not drop outlier rows (cap only); missing ratings on Cancelled/Pending orders must be left unfilled with a stated reason; insights must reference actual computed values, not placeholder text.

**Format:** A runnable `.ipynb` notebook with markdown explanations between code cells.

**Verification performed:** Ran every cell in VS Code's Jupyter interface end-to-end. Confirmed the assertions in the notebook passed (exactly 500 rows after dedup, exactly 4 cities and 6 categories after cleaning). Manually checked the printed "Revenue by category" and "Revenue by supplier" outputs and confirmed both the top category (Household Essentials) and top supplier (HomeEssentials Traders) matched Part 1's SQL findings, printed as `True`/`True` in the notebook's own validation cell.
