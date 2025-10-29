use emade_dev

CREATE TABLE InterviewEmadeStores(
    [store_id] varchar(50),
    [store_name] varchar(50),
    [phone] varchar(50),
    [email] varchar(50),
    [street] varchar(50),
    [city] varchar(50),
    [state] varchar(50),
    [zip_code] varchar(50)
)

select * from InterviewEmadeStores

CREATE TABLE InterviewEmadeStocks (
    [store_id] varchar(50),
    [product_id] varchar(50),
    [quantity] varchar(50)
)

select * from InterviewEmadeStocks

CREATE TABLE InterviewEmadeStaffs (
    [staff_id] varchar(50),
    [first_name] varchar(50),
    [last_name] varchar(50),
    [email] varchar(50),
    [phone] varchar(50),
    [active] varchar(50),
    [store_id] varchar(50),
    [manager_id] varchar(50)
)

Select * from InterviewEmadeStaffs

CREATE TABLE InterviewEmadeProducts (
    [product_id] varchar(50),
    [product_name] varchar(50),
    [brand_id] varchar(50),
    [category_id] varchar(50),
    [model_year] varchar(50),
    [list_price] varchar(50)
)

select * from InterviewEmadeProducts

CREATE TABLE InterviewEmadeOrderItems (
    [order_id] varchar(50),
    [item_id] varchar(50),
    [product_id] varchar(50),
    [quantity] varchar(50),
    [list_price] varchar(50),
    [discount] varchar(50)
)

select * from InterviewEmadeOrderItems

CREATE TABLE InterviewEmadeCustomers (
    [customer_id] varchar(50),
    [first_name] varchar(50),
    [last_name] varchar(50),
    [phone] varchar(50),
    [email] varchar(50),
    [street] varchar(50),
    [city] varchar(50),
    [state] varchar(50),
    [zip_code] varchar(50)
)

select * from InterviewEmadeCustomers

CREATE TABLE InterviewEmadeBrands(
    [brand_id] varchar(50),
    [brand_name] varchar(50)
)

select * from InterviewEmadeBrands

CREATE TABLE InterviewEmadeCategories(
    [category_id] varchar(50),
    [category_name] varchar(50)
)

select * from InterviewEmadeCategories

CREATE TABLE InterviewEmadeOrders(
    [order_id] varchar(50),
    [customer_id] varchar(50),
    [order_status] varchar(50),
    [order_date] varchar(50),
    [required_date] varchar(50),
    [shipped_date] varchar(50),
    [store_id] varchar(50),
    [staff_id] varchar(50)
)

Select * from InterviewEmadeOrders


-- ========================================
-- EmadeStores, EmadeStocks, EmadeStaffs, EmadeProducts,
-- EmadeOrders, EmadeOrderItems, EmadeCustomers,
-- EmadeCategories, EmadeBrands Analysis Queries
-- ========================================

-- 1. List all products with brand names

SELECT 
    a.product_name,
    b.brand_name
FROM InterviewEmadeProducts a
JOIN InterviewEmadeBrands b 
    ON a.Brand_ID = b.brand_id;

-- 2. Find active staff and their store names

SELECT 
    a.staff_id,
    a.First_Name + ' ' + a.last_name AS FullName,
    b.store_name
FROM InterviewEmadeStaffs a
JOIN InterviewEmadeStores b 
    ON a.store_id = b.store_id
WHERE a.active = 1;

select * from InterviewEmadeStaffs
select * from InterviewEmadeStores


-- 3. Customer details

SELECT 
    customer_id,
    first_name + ' ' + last_name AS FullName,
    Email,
    Phone
FROM InterviewEmadeCustomers ;

select count(customer_id) from InterviewEmadeCustomers

select * from InterviewEmadeCustomers


-- 4. Product categories — number of products per category

SELECT 
    b.category_name,
    COUNT(a.product_id) AS ProductCount
FROM InterviewEmadeProducts a
JOIN InterviewEmadeCategories b 
    ON a.category_id = b.category_id
GROUP BY b.category_name;

select * from InterviewEmadeCategories
select * from InterviewEmadeProducts



-- 5. Total sales per product after discount

SELECT 
    b.product_name,
      SUM(
        CONVERT(DECIMAL(18,2), ISNULL(a.Quantity, 0)) *
        CONVERT(DECIMAL(18,2), ISNULL(a.list_price, 0)) *
        (1 - CONVERT(DECIMAL(18,2), ISNULL(a.Discount, 0)))
    ) AS TotalSalesAfterDiscount
		from InterviewEmadeOrderItems a
JOIN InterviewEmadeProducts b 
    ON a.product_id = b.product_id
GROUP BY b.product_name;



select * from InterviewEmadeOrderItems
select * from InterviewEmadeProducts



-- 6. Orders by status

SELECT 
    order_status,
    COUNT(order_id) AS OrderCount
FROM InterviewEmadeOrders 
GROUP BY order_status 
ORDER BY order_status;
select * from InterviewEmadeOrders


-- 7. Customer orders — customers with at least one order

SELECT 
    a.first_name + ' ' + a.Last_Name AS FullName,
    COUNT(b.order_id) AS TotalOrders
FROM InterviewEmadeCustomers a
JOIN InterviewEmadeOrders b 
    ON a.customer_id = b.customer_id
GROUP BY 
a.first_name, 
a.last_name
HAVING COUNT(b.order_id) > 0;

select * from InterviewEmadeOrders
select * from InterviewEmadeCustomers

-- 8. Stock availability — total quantity per product

SELECT 
    b.product_name,
    SUM(CONVERT(INT, ISNULL(a.quantity, 0))) AS total_quantity
FROM InterviewEmadeStocks a
JOIN InterviewEmadeProducts b 
    ON a.product_id = b.product_id
GROUP BY b.product_name;


-- 9. Revenue by store

SELECT 
    c.store_name,
    SUM(
        CONVERT(DECIMAL(18,2), ISNULL(a.quantity, 0)) *
        CONVERT(DECIMAL(18,2), ISNULL(a.list_price, 0)) *
        (1 - CONVERT(DECIMAL(18,2), ISNULL(a.discount, 0)))
    ) AS total_revenue
FROM InterviewEmadeOrderItems a
JOIN InterviewEmadeOrders b 
    ON a.order_id = b.order_id
JOIN InterviewEmadeStores c 
    ON b.store_id = c.store_id
GROUP BY c.store_name;

select * from InterviewEmadeStores


-- 10. Monthly sales analysis

SELECT 
    FORMAT(CONVERT(DATETIME, b.order_date, 101), 'yyyy-MM') AS sales_month,
    SUM(
        CONVERT(DECIMAL(18,2), ISNULL(a.quantity, 0)) *
        CONVERT(DECIMAL(18,2), ISNULL(a.list_price, 0)) *
        (1 - CONVERT(DECIMAL(18,2), ISNULL(a.discount, 0)))
    ) AS monthly_sales
FROM InterviewEmadeOrderItems a
JOIN InterviewEmadeOrders b 
    ON a.order_id = b.order_id
WHERE ISDATE(b.order_date) = 1
GROUP BY FORMAT(CONVERT(DATETIME, b.order_date, 101), 'yyyy-MM')
ORDER BY sales_month;

select * from InterviewEmadeOrders

-- 11. Top 5 customers who spent the most

SELECT TOP 5
    a.first_name + ' ' + a.last_name AS full_name,
    SUM(
        CONVERT(DECIMAL(18,2), ISNULL(c.quantity, 0)) *
        CONVERT(DECIMAL(18,2), ISNULL(c.list_price, 0)) *
        (1 - CONVERT(DECIMAL(18,2), ISNULL(c.discount, 0)))
    ) AS total_spent
FROM InterviewEmadeCustomers a
JOIN InterviewEmadeOrders b 
    ON a.customer_id = b.customer_id
JOIN InterviewEmadeOrderItems c 
    ON b.order_id = c.order_id
GROUP BY a.first_name, a.last_name
ORDER BY total_spent DESC;

-- 12. Employee hierarchy

SELECT 
    a.staff_id,
    a.first_name + ' ' + a.last_name AS staff_name,
    b.first_name + ' ' + b.last_name AS manager_name
FROM InterviewEmadeStaffs a
LEFT JOIN InterviewEmadeStaffs b 
    ON a.manager_id = b.staff_id;

	select * from InterviewEmadeStaffs

-- 13. Product performance — highest sales volume this year
WITH HighestSalesVolume AS (
    SELECT 
		YEAR(CONVERT(DATETIME, c.order_date, 101)) as sales_year,
		b.product_name,
        SUM(
            CONVERT(DECIMAL(18,2), ISNULL(a.quantity, 0)) *
            CONVERT(DECIMAL(18,2), ISNULL(a.list_price, 0)) *
            (1 - CONVERT(DECIMAL(18,2), ISNULL(a.discount, 0)))
        ) AS total_sales
    FROM InterviewEmadeOrderItems a
    JOIN InterviewEmadeOrders c 
        ON a.order_id = c.order_id
    JOIN InterviewEmadeProducts b 
        ON a.product_id = b.product_id
    WHERE ISDATE(c.order_date) = 1
      AND YEAR(CONVERT(DATETIME, c.order_date, 101)) = (
          SELECT MAX(YEAR(CONVERT(DATETIME, order_date, 101)))
          FROM InterviewEmadeOrders
          WHERE ISDATE(order_date) = 1
      )
    GROUP BY b.product_name, c.order_date
)
SELECT TOP 10 
sales_year,
    product_name,
    total_sales
FROM HighestSalesVolume
ORDER BY total_sales DESC;


select * from InterviewEmadeOrders

-- 14. Customer location analysis

SELECT 
    city,
    state,
    COUNT(customer_id) AS customer_count
FROM InterviewEmadeCustomers 
GROUP BY 
city, 
state
order by customer_count desc


select distinct count(product_name) from InterviewEmadeProducts