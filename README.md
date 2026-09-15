# BigBasket Category Performance Diagnostic

A single, connected diagnostic analyzing BigBasket's category performance against monthly revenue targets, built across SQL, spreadsheets, Tableau, and Python — with the same underlying dataset carried through all four parts and cross-validated at each step.

## Project overview

Part 1 builds a deterministic SQLite database and runs SQL queries to diagnose category performance against monthly targets, exporting `monthly_category_revenue.csv`. Part 2 imports that exact CSV into a spreadsheet and reconciles a pivot-table rebuild against Part 1's SQL totals to the rupee. Part 3 turns the same CSV into a published Tableau Public dashboard with a written data story. Part 4 independently cleans a messy raw export of the same underlying orders in Python/Pandas and confirms its findings agree with Part 1's clean SQL diagnostic.

## Repo structure

- `generate_data.py` — deterministic data generator (seed 42); regenerates `bigbasket_capstone.db`, `orders_raw.csv`, `products.csv`
- `bigbasket_capstone.db` — SQLite database (products, customers, orders, category_targets)
- `01_foundations.sql` — SELECT/WHERE, DISTINCT, ORDER BY+LIMIT, Alias, IN, BETWEEN/NOT BETWEEN, IS NULL
- `02_aggregation_joins.sql` — INNER JOIN + HAVING aggregation; LEFT JOIN preserving the zero-order product
- `03_reporting.sql` — CASE WHEN tiering, monthly-by-category report, target variance calculation
- `verify.sql` / `verify_output.txt` — row-count verification against acceptance criteria
- `monthly_category_revenue.csv` — fixed input consumed by Parts 2 and 3 (36 rows, ₹88,282 grand total)
- `bigbasket_capstone.xlsx` — spreadsheet workbook: Monthly Data, Category Targets, Pivot Table, Category Summary (XLOOKUP + variance + conditional formatting)
- `orders_raw.csv`, `products.csv` — messy raw exports used only in Part 4
- `ai_log.md` — AI-assisted prompt log (RCTCF-structured, with verification steps)
- `DATA_STORY.md` — findings and recommendations from the Tableau dashboard

## Live Tableau Public dashboard

**https://public.tableau.com/app/profile/shaik.mohammad.junaid/viz/Bigbasketcapstonedasbord/Dashboard1**

The dashboard includes a monthly revenue time-series, a category revenue bar chart color-coded by target-tier, four KPI cards (Total Revenue, Total Delivered Orders, Average Order Value, Categories Meeting Target), and a category filter that affects every chart at once.

See [DATA_STORY.md](./DATA_STORY.md) for the full write-up of findings and recommendations.

## Regenerating the data

```
python generate_data.py
```

Do not change the `random.seed(42)` line or any fixed lists/weights — every number in this project's acceptance criteria depends on this exact, deterministic output.
