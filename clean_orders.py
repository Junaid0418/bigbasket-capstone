import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# 1. Load the raw data
df = pd.read_csv("orders_raw.csv")
print("Initial shape:", df.shape)

# 2. Remove exact duplicate rows
before = len(df)
df = df.drop_duplicates()
print(f"Removed {before - len(df)} duplicate rows")

# 3. Fix inconsistent casing
df['status'] = df['status'].str.strip().str.title()
df['category'] = df['category'].str.strip().str.title()
df['city'] = df['city'].str.strip().str.title()

# 4. Handle nulls
print("\nNull counts before handling:")
print(df.isnull().sum())

df = df.dropna(subset=['order_id', 'amount_inr'])
df['status'] = df['status'].fillna('Unknown')
df['rating'] = df['rating'].fillna(df['rating'].median())

print("\nNull counts after handling:")
print(df.isnull().sum())

# 5. Outlier detection using IQR on amount_inr
Q1 = df['amount_inr'].quantile(0.25)
Q3 = df['amount_inr'].quantile(0.75)
IQR = Q3 - Q1
lower_bound = Q1 - 1.5 * IQR
upper_bound = Q3 + 1.5 * IQR

outliers = df[(df['amount_inr'] < lower_bound) | (df['amount_inr'] > upper_bound)]
print(f"\nFound {len(outliers)} outliers in amount_inr")
print(f"Bounds: [{lower_bound:.2f}, {upper_bound:.2f}]")

df_clean = df[(df['amount_inr'] >= lower_bound) & (df['amount_inr'] <= upper_bound)]
print("Shape after removing outliers:", df_clean.shape)

# 6. Save cleaned data
df_clean.to_csv("orders_cleaned.csv", index=False)
print("\nSaved orders_cleaned.csv")

# 7. Validation
print("\n--- Validation ---")
print("Status breakdown:")
print(df_clean['status'].value_counts())

delivered_total = df_clean[df_clean['status'] == 'Delivered']['amount_inr'].sum()
print(f"\nTotal Delivered revenue (cleaned): {delivered_total}")
print("Compare this to your Part 1 SQL total (88,282)")

# 8. Charts
plt.figure(figsize=(8, 5))
df_clean['status'].value_counts().plot(kind='bar', color=['green', 'orange', 'red'])
plt.title("Order Status Distribution (Cleaned)")
plt.xlabel("Status")
plt.ylabel("Count")
plt.tight_layout()
plt.savefig("chart_status_distribution.png")
plt.close()

plt.figure(figsize=(8, 5))
df_clean.groupby('category')['amount_inr'].sum().sort_values(ascending=False).plot(kind='bar', color='steelblue')
plt.title("Revenue by Category (Cleaned)")
plt.xlabel("Category")
plt.ylabel("Total Revenue (INR)")
plt.tight_layout()
plt.savefig("chart_revenue_by_category.png")
plt.close()

print("\nSaved chart_status_distribution.png and chart_revenue_by_category.png")