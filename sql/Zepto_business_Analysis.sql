drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category  VARCHAR (120),
name  VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountpercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice Numeric(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
)

----data exploration---

---count of rows
SELECT COUNT(*) FROM ZEPTO;

---sample data
SELECT * FROM ZEPTO
LIMIT 10;

---NULL VALUES
SELECT * FROM ZEPTO
WHERE Name IS NULL
OR
Category IS NULL
OR
MRP IS NULL
OR
discountPERCENT IS NULL
OR 
DiscountedSellingPrice IS NULL
OR
WeightInGms IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL
OR
availableQuantity IS NULL

--Different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--Products in stock vs out of stock
SELECT outOfStock, COUNT(SKU_ID)
FROM zepto
GROUP BY outOfStock;

--PRODUCT NAMES PRESENT MULTIPLE TIMES
SELECT NAME, COUNT(SKU_ID) AS " Number of SKUs"
FROM zepto
GROUP BY NAME
HAVING COUNT(SKU_ID) > 1
ORDER BY COUNT(SKU_ID) DESC;

--Data Cleaning

--Products with price = 0
SELECT * FROM zepto
WHERE MRP = 0 OR DISCOUNTEDSELLINGPRICE = 0;

DELETE FROM zepto
WHERE MRP = 0;

-- Convert price to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice FROM zepto;

--Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountpercent
FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;

--Q2. What are the products with High MRP but out of Stock.
SELECT DISTINCT name,mrp
FROM zepto
WHERE outOfStock = True and mrp >300
ORDER BY mrp DESC;

--Q3. Calculate estimated revenue for each category
SELECT category,
       SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
WHERE NULLIF(BTRIM(category), '') IS NOT NULL
GROUP BY category
ORDER BY total_revenue DESC;

--Q4. Find all products where MRP is greater than ₹500 and discount is lessthan 10%.
SELECT DISTINCT name,mrp,discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

--Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
       ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto
WHERE NULLIF(BTRIM(category), '') IS NOT NULL
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice / weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGMs > 100
ORDER BY price_per_gram;

--Q7. Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 then 'Low'
     WHEN weightInGms < 5000 then 'MEDIUM'
	 ELSE 'Bulk'
	 END AS weight_category
FROM zepto;

--Q8. What is he Total Inventory Weight per Category
SELECT category,
       SUM(weightInGms * availableQuantity) AS total_weight_gms,
       ROUND(
           SUM(weightInGms * availableQuantity) / 1000.0,
           2
       ) AS total_weight_kg
FROM zepto
WHERE NULLIF(BTRIM(category), '') IS NOT NULL
GROUP BY category
ORDER BY total_weight_gms DESC;

-- Q9. Rank the top 3 discounted products within every category.
WITH ranked_products AS (
    SELECT sku_id, category, name, discountpercent,
           DENSE_RANK() OVER (
               PARTITION BY category
               ORDER BY discountpercent DESC
           ) AS discount_rank
    FROM zepto
    WHERE NULLIF(BTRIM(category), '') IS NOT NULL
)
SELECT category, name, discountpercent, discount_rank
FROM ranked_products
WHERE discount_rank <= 3
ORDER BY category, discount_rank, name;

-- Q10. Stock availability summary and out-of-stock percentage by category.
SELECT category,
       COUNT(*) AS total_product_rows,
       COUNT(*) FILTER (WHERE outofstock IS TRUE) AS out_of_stock_rows,
       COUNT(*) FILTER (WHERE outofstock IS FALSE) AS in_stock_rows,
       ROUND(
           100.0 * COUNT(*) FILTER (WHERE outofstock IS TRUE)
           / NULLIF(COUNT(*), 0), 2
       ) AS out_of_stock_percentage
FROM zepto
WHERE NULLIF(BTRIM(category), '') IS NOT NULL
GROUP BY category
ORDER BY out_of_stock_percentage DESC, total_product_rows DESC;
	 

--Q11. Category contribution to total estimated inventory value.
WITH category_value AS (
    SELECT category,
           SUM(discountedSellingPrice::numeric * availablequantity) AS value_rs
    FROM zepto
    WHERE outofstock IS FALSE
      AND availablequantity > 0
      AND discountedSellingPrice > 0
      AND NULLIF(BTRIM(category), '') IS NOT NULL
    GROUP BY category
)
SELECT category,
       ROUND(value_rs, 2) AS estimated_inventory_value_rupees,
       ROUND(100.0 * value_rs / NULLIF(SUM(value_rs) OVER (), 0), 2)
           AS contribution_percent
FROM category_value
ORDER BY value_rs DESC;

-- Q12. Discount bands: identify how products are distributed by offer level.
SELECT
       CASE
           WHEN discountpercent < 5 THEN 'Low discount (<5%)'
           WHEN discountpercent < 15 THEN 'Moderate discount (5-<15%)'
           ELSE 'High discount (15%+)'
       END AS discount_band,
       COUNT(*) AS product_rows,
       ROUND(AVG(discountpercent)::numeric, 2) AS average_discount_percent
FROM zepto
WHERE discountpercent BETWEEN 0 AND 100
GROUP BY discount_band
ORDER BY average_discount_percent;

-- Q13. Compare each product's discount with its category average.
WITH category_benchmarks AS (
    SELECT category, AVG(discountpercent) AS category_avg_discount
    FROM zepto
    WHERE discountpercent BETWEEN 0 AND 100
      AND NULLIF(BTRIM(category), '') IS NOT NULL
    GROUP BY category
)
SELECT z.category, z.name, z.discountpercent,
       ROUND(b.category_avg_discount::numeric, 2) AS category_avg_discount,
       ROUND((z.discountpercent - b.category_avg_discount)::numeric, 2)
           AS difference_from_category_average
FROM zepto AS z
JOIN category_benchmarks AS b
  ON z.category = b.category
ORDER BY difference_from_category_average DESC, z.name
LIMIT 20;

-- Q14. Find categories with inventory value above the overall category average.
WITH category_value AS (
    SELECT category,
           SUM(discountedSellingPrice::numeric * availablequantity) AS value_rs
    FROM zepto
    WHERE outofstock IS FALSE
      AND availablequantity > 0
      AND discountedSellingPrice > 0
      AND NULLIF(BTRIM(category), '') IS NOT NULL
    GROUP BY category
)
SELECT category, ROUND(value_rs, 2) AS estimated_inventory_value_rupees
FROM category_value
WHERE value_rs > (SELECT AVG(value_rs) FROM category_value)
ORDER BY value_rs DESC;



