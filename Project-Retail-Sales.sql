CREATE DATABASE RetailSales;
USE RetailSales;

CREATE TABLE retaildata(
	transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customerID INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

SELECT * FROM retaildata;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/retaildata.csv'
INTO TABLE retaildata
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM retailsales.retaildata;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/retaildata.csv'
INTO TABLE retaildata
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

CREATE TABLE retaildata2(
	transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customerID INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

DROP TABLE retaildata2;
SELECT * FROM retaildata2;

ALTER TABLE retaildata2
CHANGE COLUMN `ï»¿transactions_id` `transactions_id` INT PRIMARY KEY;

SELECT * FROM retaildata2;

SELECT COUNT(*) FROM retaildata2;

SELECT * FROM retaildata2
WHERE transactions_id IS NULL
	OR 
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR 
    customerID IS NULL
    OR 
    gender IS NULL
    OR 
    age IS NULL
    OR 
    category IS NULL
    OR 
    quantity IS NULL
    OR 
    price_per_unit IS NULL
    OR 
    cogs IS NULL
    OR 
    total_sale IS NULL;
    
-- Data Exploration : 
-- How many sales we have ?
SELECT COUNT(total_sale) AS totalsales
FROM retaildata2; 

-- How many customers we have ?
SELECT COUNT(DISTINCT customer_ID) 
FROM retaildata2;

-- How many unique category ?
SELECT COUNT(DISTINCT category)
FROM retaildata2;

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * 
FROM retaildata2
WHERE sale_date = "2022-11-05";

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT transactions_id
FROM retaildata2
WHERE category = "Clothing" AND quantiy < 10 AND Year(sale_date) = 2022 AND MONTH(sale_date) = 11 ; 

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,SUM(total_sale) AS total_sales,count(*) AS total_orders
FROM retaildata2
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT AVG(age),category
FROM retaildata2
WHERE category = "Beauty";

-- Q.5  Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT transactions_id,total_sale 
FROM retaildata2
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category,gender,COUNT(transactions_id) AS transactions 
FROM retaildata2
GROUP BY category,gender
ORDER BY category;

-- Q.7  INTERVIEW ASKED QUESTION Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT YEAR(sale_date),MONTH(sale_date),AVG(total_sale)
FROM retaildata2
GROUP BY YEAR(sale_date),MONTH(sale_date)
ORDER BY YEAR(sale_date),AVG(total_sale) DESC;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_ID,SUM(total_sale)
FROM retaildata2
GROUP BY customer_ID
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- Q.9  Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,COUNT(DISTINCT customer_ID)
FROM retaildata2
GROUP BY category;

-- Q.1O Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *, 
	CASE
		WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
        ELSE 'Evening'
	END AS shift
FROM retaildata2
)
SELECT
	shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;