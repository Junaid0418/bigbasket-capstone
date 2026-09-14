import sqlite3
conn = sqlite3.connect("bigbasket_capstone.db")
cur = conn.cursor()
for t in ["products", "customers", "orders", "category_targets"]:
    print(t, cur.execute(f"SELECT COUNT(*) FROM {t}").fetchone())
print(cur.execute("SELECT status, COUNT(*) FROM orders GROUP BY status").fetchall())