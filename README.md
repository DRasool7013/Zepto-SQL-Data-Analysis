# Zepto SQL Data Analysis Project

A PostgreSQL portfolio project exploring Zepto product pricing, discounts, stock availability, and inventory. The project contains **14 business-analysis questions**, the source CSV, SQL scripts, and available query/output screenshots.

## Tools
- PostgreSQL
- pgAdmin 4
- SQL

## Project contents

```text
Zepto-SQL-Data-Analysis/
├── README.md
├── sql/
│   └── zepto_business_analysis.sql
├── data/
├   ├── Readme.md
│   └── zepto_v1.csv
└── screenshots/
    └── (captured PostgreSQL query and output screenshots)
```

## Dataset

The supplied CSV contains product-level fields:
`Category`, `name`, `mrp`, `discountPercent`, `availableQuantity`,
`discountedSellingPrice`, `weightInGms`, `outOfStock`, and `quantity`.

The table setup script creates a generated `sku_id` primary key and maps the CSV fields to PostgreSQL column names. The analysis SQL uses the lowercase PostgreSQL identifiers created by that table.

## Business questions solved

| No. | Business question |
|---:|---|
| 1 | Find the top 10 best-value products based on discount percentage. |
| 2 | Identify high-MRP products that are out of stock. |
| 3 | Calculate estimated available inventory value by category. |
| 4 | Find products with MRP above ₹500 and discount below 10%. |
| 5 | Identify the top 5 categories by average discount percentage. |
| 6 | Compare product price per gram for products weighing more than 100 g. |
| 7 | Classify products into Low, Medium, and Bulk weight groups. |
| 8 | Calculate total inventory weight per category. |
| 9 | Rank the top 3 discounted products within each category. |
| 10 | Summarize stock availability and out-of-stock percentage by category. |
| 11 | Calculate each category's contribution to estimated inventory value. |
| 12 | Identify how products are distributed across discount bands. |
| 13 | Compare each product's discount with its category average. |
| 14 | Find categories with inventory value above the overall category average. |

## SQL skills demonstrated

- Filtering, sorting, and limiting results (`WHERE`, `ORDER BY`, `LIMIT`)
- Aggregations (`COUNT`, `SUM`, `AVG`)
- Grouped analysis (`GROUP BY`)
- Conditional logic (`CASE WHEN`)
- Common table expressions (CTEs)
- Subqueries
- Window functions (`DENSE_RANK`, windowed aggregate)
- Data-quality checks for duplicates, missing values, and invalid ranges
- Handling blank category values and division by zero safely

## How to run in pgAdmin 4

1. Create a PostgreSQL database and connect to it in pgAdmin.
2. Open `sql/00_create_zepto_table.sql` in Query Tool and execute it. This creates the `zepto` table.
3. In pgAdmin's Object Explorer, right-click `zepto` → **Import/Export Data**.
4. Choose **Import**, select `data/zepto_v1.csv`, set Format to **CSV**, enable **Header**, and import the file.
5. Open `sql/zepto_business_analysis.sql` and execute the statements. You can run the full script or select individual questions.
6. Review each result set and compare it with the screenshots in `screenshots/`.

**Important:** `00_create_zepto_table.sql` contains `DROP TABLE IF EXISTS zepto`. Running it deletes an existing table named `zepto` before recreating it. Back up any important data first. The analysis script is designed for the table created above and does not repeat the original paise-to-rupee conversion.

## Interpreting the analysis

The inventory-value queries calculate an estimate using:

`discountedSellingPrice × availableQuantity`

This is the estimated value of available stock, **not actual sales revenue**. The dataset does not establish that the available quantity was sold. Treat the outputs as descriptive analysis of the supplied snapshot, not live Zepto inventory.

## Screenshots

The `screenshots/` folder contains the screenshots available from the project work. They are kept with their original capture names rather than being assigned to specific question numbers without verification.

## Author

**Dudekula Alla Rasool**  
Aspiring Data Analyst | PostgreSQL | SQL | Power BI | Excel | Python

GitHub: [DRasool7013](https://github.com/DRasool7013)
