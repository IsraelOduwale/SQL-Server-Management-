-- =============================================
-- Author:		Israel Oduwale
-- Create date: 10-09-2024
-- Description:	This code is to create the emade consulting TABLES
--				To run further analysis on the records in the TABLES
-- Revise Date: 10-09-2024
-- Version:		v1.0
-- =============================================



use Dev

CREATE TABLE Emadeconsultingcustomers (
    customer_id integer PRIMARY KEY,
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100)
);

INSERT INTO Emadeconsultingcustomers (customer_id, first_name, last_name, email) 
VALUES
(1, 'John', 'Doe', 'johndoe@email.com'),
(2, 'Jane', 'Smith', 'janesmith@email.com'),
(3, 'Bob', 'Johnson', 'bobjohnson@email.com'),
(4, 'Alice', 'Brown', 'alicebrown@email.com'),
(5, 'Charlie', 'Davis', 'charliedavis@email.com'),
(6, 'Eva', 'Fisher', 'evafisher@email.com'),
(7, 'George', 'Harris', 'georgeharris@email.com'),
(8, 'Ivy', 'Jones', 'ivyjones@email.com'),
(9, 'Kevin', 'Miller', 'kevinmiller@email.com'),
(10, 'Lily', 'Nelson', 'lilynelson@email.com'),
(11, 'Oliver', 'Patterson', 'oliverpatterson@email.com'),
(12, 'Quinn', 'Roberts', 'quinnroberts@email.com'),
(13, 'Sophia', 'Thomas', 'sophiathomas@email.com');

select * from Emadeconsultingcustomers;



CREATE TABLE Emadeconsultingproducts (
    product_id integer PRIMARY KEY,
    product_name varchar(100),
    price decimal
);


INSERT INTO Emadeconsultingproducts (product_id, product_name, price)
VALUES
(1, 'Product A', 10.00),
(2, 'Product B', 15.00),
(3, 'Product C', 20.00),
(4, 'Product D', 25.00),
(5, 'Product E', 30.00),
(6, 'Product F', 35.00),
(7, 'Product G', 40.00),
(8, 'Product H', 45.00),
(9, 'Product I', 50.00),
(10, 'Product J', 55.00),
(11, 'Product K', 60.00),
(12, 'Product L', 65.00),
(13, 'Product M', 70.00);


select * from Emadeconsultingproducts;




CREATE TABLE Emadeconsultingorders (
    order_id integer PRIMARY KEY,
    customer_id integer,
    order_date date
);


INSERT INTO Emadeconsultingorders (order_id, customer_id, order_date) 
VALUES
(1, 1, '2023-05-01'),
(2, 2, '2023-05-02'),
(3, 3, '2023-05-03'),
(4, 1, '2023-05-04'),
(5, 2, '2023-05-05'),
(6, 3, '2023-05-06'),
(7, 4, '2023-05-07'),
(8, 5, '2023-05-08'),
(9, 6, '2023-05-09'),
(10, 7, '2023-05-10'),
(11, 8, '2023-05-11'),
(12, 9, '2023-05-12'),
(13, 10, '2023-05-13'),
(14, 11, '2023-05-14'),
(15, 12, '2023-05-15'),
(16, 13, '2023-05-16');

select * from Emadeconsultingorders;


 

CREATE TABLE Emadeconsultingorder_items (
    order_id integer,
    product_id integer,
    quantity integer
);

INSERT INTO Emadeconsultingorder_items (order_id, product_id, quantity)
VALUES
(1, 1, 2),
(1, 2, 1),
(2, 2, 1),
(2, 3, 3),
(3, 1, 1),
(3, 3, 2),
(4, 2, 4),
(4, 3, 1),
(5, 1, 1),
(5, 3, 2),
(6, 2, 3),
(6, 1, 1),
(7, 4, 1),
(7, 5, 2),
(8, 6, 3),
(8, 7, 1),
(9, 8, 2),
(9, 9, 1),
(10, 10, 3),
(10, 11, 2),
(11, 12, 1),
(11, 13, 3),
(12, 4, 2),
(12, 5, 1),
(13, 6, 3),
(13, 7, 2),
(14, 8, 1),
(14, 9, 2),
(15, 10, 3),
(15, 11, 1),
(16, 12, 2),
(16, 13, 3);

select * from Emadeconsultingorder_items


--QUESTION 1 - WHICH PRODUCT HAS THE HIGHEST PRICE? ONLY RETURN A SINGLE ROW
SELECT * FROM Emadeconsultingproducts
WHERE PRICE=(
	SELECT MAX(PRICE) 
	FROM Emadeconsultingproducts
	)



--QUESTION 2 - WHICH CUSTOMER HAS MADE THE MOST ORDERS?

SELECT
A.customer_id, 
A.first_name, 
A.last_name, 
COUNT(B.order_id) AS Order_count
FROM Emadeconsultingcustomers A
LEFT JOIN Emadeconsultingorders B ON A.customer_id = B.customer_id
GROUP BY
A.customer_id, 
A.first_name, 
A.last_name
HAVING COUNT(B.order_id) = (
    SELECT MAX(order_count)
    FROM (
        SELECT COUNT(order_id) AS order_count
        FROM Emadeconsultingorders
        GROUP BY customer_id
    )x
);


--QUESTION 3- WHAT IS THE TOTAL REVENUE PER PRODUCT

SELECT 
A.PRODUCT_ID,
A.PRODUCT_NAME,
SUM(B.QUANTITY * A.PRICE) AS TOTAL_REVENUE
FROM Emadeconsultingproducts A
LEFT JOIN Emadeconsultingorder_items B
ON A.product_id=B.product_id
GROUP BY
A.PRODUCT_ID,
A.PRODUCT_NAME
ORDER BY TOTAL_REVENUE



--QUESTION 4 - FIND THE FIRST ORDER (BY DATE) FOR EACH CUSTOMER

SELECT 
A.order_id, 
A.customer_id,
B.first_name,
B.last_name,
A.order_date
FROM Emadeconsultingorders A
JOIN Emadeconsultingcustomers B
ON A.customer_id=B.customer_id
WHERE A.order_date = (
    SELECT MIN(order_date)
    FROM Emadeconsultingorders
    WHERE customer_id = A.customer_id
);


--QUESTION 5 -FIND THE TOP 3 CUSTOMERS WHO HAVE ORDERED THE MOST DISTINCT PRODUCTS

SELECT TOP 3
A.customer_id,
A.first_name,
A.last_name,             
COUNT(DISTINCT C.product_id) AS PRODUCT_COUNT
FROM Emadeconsultingcustomers A
JOIN Emadeconsultingorders B
ON A.customer_id = B.customer_id
JOIN Emadeconsultingorder_items C 
ON B.order_id = C.order_id
JOIN Emadeconsultingproducts D 
ON C.product_id = D.product_id
GROUP BY 
A.customer_id,
A.first_name, 
A.last_name
ORDER BY 
product_count DESC;



--QUESTION 6 - WHICH PRODUCT HAS BEEN BOUGHT THE LEAST IN TERMS OF QUANTITY

SELECT 
A.product_id,
A.product_name,
SUM(B.quantity) AS TOTAL_QUANTITY
FROM Emadeconsultingproducts A
LEFT JOIN Emadeconsultingorder_items B
ON A.product_id=B.product_id
GROUP BY
A.product_id,
A.product_name
HAVING SUM(B.quantity) = (
    SELECT MIN(TOTAL_QUANTITY)
    FROM (
        SELECT SUM(quantity) AS TOTAL_QUANTITY
        FROM Emadeconsultingorder_items
        GROUP BY product_id
    )x
);

/**
SELECT 
A.product_id,
A.product_name,
SUM(B.quantity) AS TOTAL_QUANTITY
FROM Emadeconsultingproducts A
LEFT JOIN Emadeconsultingorder_items B
ON A.product_id=B.product_id
GROUP BY
A.product_id,
A.product_name
ORDER BY TOTAL_QUANTITY 
**/


--QUESTION 7 - WHAT IS THE MEDIAN ORDER TOTAL

SELECT 
AVG(Total_Order_Value) AS avg_order_total
FROM (
    SELECT 
	a.order_id, 
	SUM(b.quantity * c.price) AS Total_Order_Value
    FROM Emadeconsultingorders a
    JOIN Emadeconsultingorder_items b 
	ON a.order_id = b.order_id
    JOIN Emadeconsultingproducts c 
	ON b.product_id = c.product_id
    GROUP BY 
	a.order_id
) AS Order_Totals;




--QUESTION 8 -FOR EACH ORDER, DETERMINE IF IT WAS 'EXPENSIVE' (TOTAL OVER 300)
--AFFORDABLE (TOTAL OVER 100), CHEAP (<100)

SELECT 
B.order_id,
SUM(B.QUANTITY * A.PRICE) AS TOTAL_AMOUNT,
CASE
WHEN SUM(B.QUANTITY * A.PRICE) >300 THEN 'EXPENSIVE'
WHEN SUM(B.QUANTITY * A.PRICE) >100 THEN 'AFFORDABLE'
WHEN SUM(B.QUANTITY * A.PRICE) <100 THEN 'CHEAP'
ELSE 'UNKNOWN'
END AS CATEGORY
FROM Emadeconsultingproducts A
JOIN Emadeconsultingorder_items B
ON A.product_id=B.product_id
JOIN Emadeconsultingorders C
ON C.order_id=B.order_id
GROUP BY
B.order_id
ORDER BY TOTAL_AMOUNT

SELECT * FROM Emadeconsultingproducts
SELECT * FROM Emadeconsultingorders
SELECT * FROM Emadeconsultingorder_items



--QUESTION 9 - FIND CUSTOMERS WHO HAVE ORDERED THE PRODUCT WITH THE HIGHEST PRICE

SELECT 
A.customer_id,
A.first_name,
A.last_name,
A.email
FROM Emadeconsultingcustomers A
JOIN Emadeconsultingorders B
ON A.customer_id = B.customer_id
JOIN Emadeconsultingorder_items C 
ON B.order_id = C.order_id
JOIN Emadeconsultingproducts D 
ON C.product_id = D.product_id
WHERE D.price= (
	SELECT MAX(PRICE)
	FROM Emadeconsultingproducts
);