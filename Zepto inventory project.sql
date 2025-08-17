drop table if exists zepto_v2;

create database sqlproject;

USE sqlproject; 

CREATE TABLE zepto_v2 (
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountPercent NUMERIC(5,2),
    availableQuantity INTEGER,
    discountedSellingPrice NUMERIC(8,2),
    weightInGms INTEGER,
    outOfStock BOOLEAN,
    quantity INTEGER
);
select * from zepto_v2;

-- count of rows
select count(name) from zepto_v2;

SELECT COUNT(*) FROM zepto_v2 WHERE name IS NOT NULL;

-- sample data
select * from zepto_v2
limit 10;

DESCRIBE your_zepto;

-- null values
SELECT * FROM sqlproject.zepto_v2
WHERE name IS NULL
OR
Category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

-- different product categories
SELECT DISTINCT Category
FROM sqlproject.zepto_v2
ORDER BY Category;

-- products in stock vs out of stock
SELECT outOfStock, COUNT(quantity)
FROM sqlproject.zepto
GROUP BY outOfStock;

-- product names present multiple times
SELECT name, COUNT(quantity) AS "Number of SKUs"
FROM sqlproject.zepto_v2
GROUP BY name
HAVING count(quantity) > 1
ORDER BY count(quantity) DESC;

-- data cleaning

-- products with price = 0
SELECT * FROM sqlproject.zepto_v2
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM sqlproject.zepto_v2
WHERE mrp = 0;

-- convert paise to rupees
UPDATE sqlproject.zepto_v2
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice FROM sqlproject.zepto_v2;

-- data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM sqlproject.zepto_v2
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2.What are the Products with High MRP but Out of Stock

SELECT DISTINCT name,mrp
FROM sqlproject.zepto_v2
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;

-- Q3.Calculate Estimated Revenue for each category
SELECT Category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM sqlproject.zepto_v2
GROUP BY Category
ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM sqlproject.zepto_v2
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT Category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM sqlproject.zepto_v2
GROUP BY Category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM sqlproject.zepto_v2
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM sqlproject.zepto_v2;

-- Q8.What is the Total Inventory Weight Per Category 
SELECT Category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM sqlproject.zepto_v2
GROUP BY Category
ORDER BY total_weight;


