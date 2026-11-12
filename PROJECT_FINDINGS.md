# Zepto SQL Project — Findings & Recommendations

## Verified descriptive findings from uploaded CSV

| Metric | Finding |
|---|---:|
| Source records | 3,732 |
| Source columns | 9 |
| Nonblank product categories | 14 |
| Exact duplicate rows | 2 |
| Blank category rows | 1 |
| Rows with MRP = 0 | 1 |
| Rows with selling price = 0 | 1 |
| Rows with weight = 0 | 4 |
| Out-of-stock rows | 453 |
| Maximum discount | 51% |
| Products with MRP > ₹500 and discount < 10% | 82 rows |
| Out-of-stock products with MRP > ₹300 | 8 rows |

## Category findings

| Finding | Result |
|---|---:|
| Highest average discount category | Fruits & Vegetables — 15.46% |
| Second-highest average discount | Meats, Fish & Eggs — 11.03% |
| Highest estimated inventory value | Cooking Essentials — ₹337,369 |
| Equal estimated inventory value | Munchies — ₹337,369 |
| Highest inventory weight | Cooking Essentials — 1,404.65 kg |
| Equal inventory weight | Munchies — 1,404.65 kg |

Estimated inventory value is calculated as discounted selling price × available quantity. Inventory weight is calculated as unit weight × available quantity. Values exclude the blank category and the zero-MRP row, with prices interpreted in rupees after conversion.

# Analysis Notes and Business Recommendations

This document avoids invented numerical results. Use the outputs from your own PostgreSQL run when adding exact figures to a portfolio presentation.

## What the queries help assess

- Discount strategy: distribution of products across low, moderate, and high discount bands.
- Category pricing: categories with the highest average discount.
- Product value: price-per-gram comparisons for products with usable weight and price values.
- Availability: product rows marked out of stock and the out-of-stock percentage by category.
- Inventory exposure: estimated available-stock value by category and categories above the average category value.

## Business recommendations to evaluate against the query outputs

1. Review replenishment needs for high-MRP products that are out of stock.
2. Compare category discount patterns before changing promotional strategy.
3. Investigate products whose discount differs substantially from their category average.
4. Monitor categories with large estimated inventory value to understand stock concentration.
5. Use price-per-gram comparisons to identify products offering stronger quantity value.

## Interpretation caution

Estimated inventory value is calculated as discounted selling price multiplied by available quantity. It is not actual sales revenue.
