-- =============================================
-- Author:		Israel Oduwale
-- Create date: 07-2-2025
-- Description:	This code is to create and run analysis on the tables in EmadeBrands Project
-- Revise Date: 
-- Version:		v1.0
-- =============================================



Use SQLTraining


CREATE TABLE EmadeBrands(
    [brand_id] int null,
    [brand_name] varchar(50) null
)

select * from EmadeBrands


CREATE TABLE EmadeCategories(
    [category_id] int null,
    [category_name] varchar(50) null
)

select * from EmadeCategories


CREATE TABLE EmadeCustomers(
    [customer_id] int null,
    [first_name] varchar(50) null,
    [last_name] varchar(50) null,
    [phone] varchar(50) null,
    [email] varchar(50) null,
    [street] varchar(50) null,
    [city] varchar(50) null,
    [state] varchar(50) null,
    [zip_code] varchar(50) null
)

select * from EmadeCustomers


CREATE TABLE EmadeOrderItems(
    [order_id] int null,
    [item_id] int null,
    [product_id] int null,
    [quantity] int null,
    [list_price] decimal(10,2) null,
    [discount] decimal(10,2) null
)

select * from EmadeOrderItems


CREATE TABLE EmadeOrders(
    [order_id] int null,
    [customer_id] int null,
    [order_status] int null,
    [order_date] varchar(50) null,
    [required_date] varchar(50) null,
    [shipped_date] varchar(50) null,
    [store_id] int null,
    [staff_id] int null
)

select * from EmadeOrders


CREATE TABLE EmadeProducts(
    [product_id] int null,
    [product_name] varchar(50) null,
    [brand_id] int null,
    [category_id] int null,
    [model_year] varchar(50) null,
    [list_price] decimal(10,2) null
)

select * from EmadeProducts



CREATE TABLE EmadeStaffs(
    [staff_id] int null,
    [first_name] varchar(50) null,
    [last_name] varchar(50) null,
    [email] varchar(50) null,
    [phone] varchar(50) null,
    [active] int null,
    [store_id] int null,
    [manager_id] int null
)

Select * from EmadeStaffs


CREATE TABLE EmadeStocks(
    [store_id] int null,
    [product_id] int null,
    [quantity] int null
)

select * from EmadeStocks


CREATE TABLE EmadeStores(
    [store_id] int null,
    [store_name] varchar(50) null,
    [phone] varchar(50) null,
    [email] varchar(50) null,
    [street] varchar(50) null,
    [city] varchar(50) null,
    [state] varchar(50) null,
    [zip_code] varchar(50) null
)

select * from EmadeStores
select * from EmadeBrands
select * from EmadeCategories
select * from EmadeCustomers
select * from EmadeOrderItems
select * from EmadeOrders
select * from EmadeProducts
select * from EmadeStaffs
select * from EmadeStocks


--Number of products
select count(distinct Product_name) as NumberOfProducts from EmadeProducts 
select Product_name as NumberOfProducts from EmadeProducts 


--1.How many different categories of products are there?
select count(distinct category_id) as NumberOfCategories from EmadeProducts
select COUNT(category_id) as NumberOfCategories from EmadeCategories

--2.List all the customers who are from New York city.
select * from EmadeCustomers
where state='NY'

--3.What are the top 5 products with the highest prices?
select top 5
product_id,
product_name,
list_price
from EmadeProducts
order by list_price desc;

--using dense_rank to include products with same price(tie)
WITH CTE_Products AS (
  SELECT 
  product_name, 
  list_price,
  dense_rank() OVER (ORDER BY list_price DESC) AS rn
  FROM EmadeProducts
)
SELECT product_name, list_price
FROM CTE_Products
WHERE rn <= 5;


--4.What cities are the customers from? Note: show only unique values by removing duplicates in the results.
Select distinct city
from EmadeCustomers

--to show the number of customers from each city
select city, count(*) as Number_Of_Customers
from EmadeCustomers
group by city
order by Number_Of_Customers desc


--5.Find the customer IDs who ordered the first 10 days in October 2018. Hint: Use the table: EmadeOrders
select *
from EmadeOrders
where order_date between '2016-10-01' and '2016-10-10'

--6.Find all the Trek bicycles from 2017 model. Hint: Use the table: EmadeProducts
select *
from EmadeProducts
where product_name like 'Trek%' and model_year=2017

--7.What are the total number of customers in the Customers table? Hint: Use the table: EmadeCustomers
select count(distinct customer_id) as Number_Of_Customers
from EmadeCustomers

--8.What is the total quantity of the products sold? Hint: Use the table: EmadeOrderItems
select sum(quantity) as Total_Quantity_Sold
from EmadeOrderItems

--9.Which product has the highest price? Hint: Use the table: EmadeOrderItems
select * from EmadeOrderItems
select * from EmadeProducts

select 
a.product_id,
b.product_name,
a.list_price
from EmadeOrderItems a
join EmadeProducts b
on a.product_id=b.product_id
where a.list_price=(
	select max(list_price)
	from EmadeOrderItems
	)

--10.What's the total price after discount for the 5 largest orders? Use the table: EmadeOrderItems
--If by largest, meaning MOST QUANTITIES
WITH OrderQuantities AS (
    SELECT 
    order_id,
    SUM(quantity) AS total_quantity
    FROM EmadeOrderItems
    GROUP BY order_id
),
Top5Orders AS (
    SELECT order_id, total_quantity,
     RANK() OVER (ORDER BY total_quantity DESC) AS rnk
    FROM OrderQuantities
)
SELECT 
	a.order_id,
    SUM(a.quantity * a.list_price * (1 - a.discount)) AS Total_Price_After_Discount,
	b.total_quantity
FROM EmadeOrderItems a
JOIN Top5Orders b 
ON a.order_id =b.order_id
WHERE rnk <= 5
group by a.order_id, b.total_quantity
order by Total_Price_After_Discount desc


--without CTE
SELECT order_id, total_price_after_discount, total_quantity
from(
	SELECT 
        order_id,
        SUM(quantity * list_price * (1 - discount)) AS total_price_after_discount,
		SUM(quantity) AS total_quantity,
		RANK() OVER (ORDER BY SUM(quantity) desc) AS rnk
    FROM EmadeOrderItems
    GROUP BY order_id
	)x
where rnk<=5



--10.What's the total price after discount for the 5 largest orders? Use the table: EmadeOrderItems
--if largest means BY TOTAL PRICE AFTER DISCOUNT(with CTE)
WITH OrderTotals AS (
    SELECT 
        order_id,
        SUM(quantity * list_price * (1 - discount)) AS total_price_after_discount
    FROM EmadeOrderItems
    GROUP BY order_id
),
Top5Orders AS (
    SELECT order_id, total_price_after_discount,
           RANK() OVER (ORDER BY total_price_after_discount DESC) AS rnk
    FROM OrderTotals
)
SELECT 
	a.order_id,
    total_price_after_discount
FROM EmadeOrderItems a
JOIN Top5Orders b 
ON a.order_id =b.order_id
WHERE rnk <= 5
group by 
a.order_id, 
total_price_after_discount
order by 
Total_Price_After_Discount desc

--Without CTE
SELECT order_id, total_price_after_discount
from(
	SELECT 
        order_id,
        SUM(quantity * list_price * (1 - discount)) AS total_price_after_discount,
		RANK() OVER (ORDER BY SUM(quantity * list_price * (1 - discount)) DESC) AS rnk
    FROM EmadeOrderItems
    GROUP BY order_id
	)x
where rnk<=5;


--11.What is the price difference between the most expensive and the least expensive item? Hint: Use the table: EmadeProducts
SELECT * FROM EmadeProducts

SELECT
MAX(LIST_PRICE) AS MOST_EXPENSIVE_PRICE,
MIN(LIST_PRICE) AS LEAST_EXPENSIVE_PRICE,
MAX(LIST_PRICE)-MIN(LIST_PRICE) AS PRICE_DIFFERENCE
FROM EmadeProducts;


--shwoing the name of the products and the price as well as the difference(Using CROSS JOIN)
SELECT 
    most.product_name AS Most_expensive_product,
    most.list_price AS Highest_price,
    least.product_name AS Least_expensive_product,
    least.list_price AS Lowest_price,
    most.list_price - least.list_price AS Price_difference
FROM 
    (SELECT TOP 1 
	 product_name, list_price 
     FROM EmadeProducts 
     WHERE list_price = (
		SELECT MAX(list_price) 
		FROM EmadeProducts
		)
     ) AS most
CROSS JOIN 
    (SELECT TOP 1
	 product_name, list_price 
     FROM EmadeProducts 
     WHERE list_price = (
		SELECT MIN(list_price) 
		FROM EmadeProducts
		)
     ) AS least;


--12.Which are the top 10 cities with the highest number of customers? Hint: Use the table: EmadeCustomers
--Using rank to show multiple cities with the same number of customers
select
City,
Number_Of_Customers,
RNK
from(
	select 
	city, 
	count(*) as Number_Of_Customers,
	rank () over(order by count(*) desc) as RNK
	from EmadeCustomers
	group by city
	)x
where rnk<=10;


--using top to showing just the first highest 10
select top 10
city, count(*) as Number_Of_Customers
from EmadeCustomers
group by city
order by Number_Of_Customers desc


--13.Find all the products with more than 150 total orders. Use the table: EmadeOrderItems
--no order totals greater than 150
SELECT
a.product_id, 
b.product_name,
COUNT(*) AS Total_orders
FROM EmadeOrderItems a
join EmadeProducts b
on a.product_id=b.product_id
GROUP BY 
a.product_id, b.product_name
HAVING COUNT(*) > 150
order by Total_orders desc;


--14.List the products with their category names. Use the tables: EmadeProducts and EmadeCategories
select 
a.product_id,
a.product_name,
a.brand_id,
b.category_name,
a.model_year,
a.list_price
from EmadeProducts a
join EmadeCategories b
on a.category_id=b.category_id;

--15.List all the staffs and the stores they are working in. Use the table: EmadeStaffs
select 
a.staff_id,
a.first_name,
a.last_name,
a.email,
a.phone,
b.store_name,
b.phone,
b.street,
b.city,
b.state,
b.zip_code
from EmadeStaffs a
join EmadeStores b
on a.store_id=b.store_id;




--16. Categorize customers based on their total spending to identify high-value, regular, and low-value customers. 
--If total spending more than 2000, show as Big Spender, If the range is 5000 to 20,000, 
--show as Regular Spender but any other spending should be Low Spender. Show column result as spender_category
--Use the tables: EmadeOrders and EmadeOrderItems (join key is Order_ID)
select
a.customer_id,
c.first_name,
c.last_name,
SUM(b.quantity * b.list_price * (1 - b.discount)) as Total_Spent,
case
	when SUM(b.quantity * b.list_price * (1 - b.discount))>20000 then 'Big Spender'
	when SUM(b.quantity * b.list_price * (1 - b.discount)) between 5000 and 20000 then 'Regular Spender'
	else 'Low Spender'
	end as Customer_Category
from EmadeOrders a
join EmadeOrderItems b
on a.order_id=b.order_id
join EmadeCustomers c
on a.customer_id=c.customer_id
group by a.customer_id,c.first_name,c.last_name
order by a.customer_id


--17.List contacts (Email and Phoner Number) of all the staffs and customers. Use the table: EmadeStaffs and EmadeCustomers (Apply your UNION CLAUSE)
select first_name, last_name, email, phone from EmadeStaffs
union
select first_name, last_name, email, phone from EmadeCustomers


--18.What is the total quantity of each product sold versus the quantity currently in stock? 
--Use the tables: EmadeProducts and EmadeStocks(join key is Product_ID (Apply your UNION ALL , SUM, GROUP BY CLAUSE)
SELECT 
    a.product_id,
    a.product_name,
    SUM(b.quantity) AS quantity,
    'Sold' AS Type
FROM EmadeProducts a
JOIN EmadeOrderItems b ON a.product_id = b.product_id
GROUP BY a.product_id, a.product_name
UNION ALL
SELECT 
    a.product_id,
    a.product_name,
    SUM(b.quantity) AS quantity,
    'In Stock' AS Type
FROM EmadeProducts a
JOIN EmadeStocks b ON a.product_id = b.product_id
GROUP BY a.product_id, a.product_name;


--19. What customers have an average order amount that is greater than the overall average)” when the overall average is unknown! 
--Use the tables: EmadeOrderItems and EmadeOrders(join key is Order_ID)
--Hint: Will need Subquery, having Clause, Group By Clause, SUM. Join Key: Order_ID

SELECT
    customer_id,
    AVG(order_total) AS avg_order_amount
FROM (
    SELECT 
        b.customer_id,
        SUM(a.quantity * a.list_price * (1 - a.discount)) AS order_total
    FROM EmadeOrderItems a
    JOIN EmadeOrders b ON a.order_id = b.order_id
    GROUP BY b.customer_id
) AS customer_orders
GROUP BY customer_id
HAVING AVG(order_total) > (
    SELECT AVG(order_total) 
    FROM (
        SELECT 
            b.order_id,
            SUM(a.quantity * a.list_price * (1 - a.discount)) AS order_total
        FROM EmadeOrderItems a
        JOIN EmadeOrders b ON a.order_id = b.order_id
        GROUP BY b.order_id
    ) AS all_orders
)
order by customer_id 


--20. List the top 10 products with the highest sales revenue and rank them. Hint: USE RANK analytical function. 
--Use the tables: EmadeOrderItems and EmadeProducts(join key is Product_ID)
select
product_id,
product_name,
Revenue
from(
	select
	a.product_id,
	b.product_name,
	sum(a.quantity * a.list_price * (1 - a.Discount)) as Revenue,
	rank() over(order by sum(a.quantity * a.list_price * (1 - a.Discount)) desc) as rnk
	from EmadeOrderItems a 
	join EmadeProducts b
	on a.product_id=b.product_id
	group by a.product_id,b.product_name
)x
where rnk<=10;


--21. What are the total number of orders and total sales amount generated by each store, ranked from highest to lowest sales? Hint: USE CTEs
with StoreOrderSales as (
	select
	a.store_id,
	b.Store_name,
	count(distinct a.order_id) as Total_Orders,
	sum(c.quantity * c.list_price * (1 - c.Discount)) as Total_Sales,
	rank() over(order by sum(c.quantity * c.list_price * (1 - c.Discount)) desc) as Store_Rank
	from EmadeOrders a
	join EmadeStores b
	on a.store_id=b.store_id
	join EmadeOrderItems c
	on a.order_id=c.order_id
	group by
	a.store_id,
	b.Store_name
)
select * from StoreOrderSales
order by Store_Rank;