-- =============================================
-- Author:		Israel Oduwale
-- Create date: 10-09-2024
-- Description:	This code is to create the BEST BUY TABLES
--				To run further analysis on the records in the BEST BUY TABLES
-- Revise Date: 10-09-2024
-- Version:		v1.0
-- =============================================



use SQLTraining

--1:Creating a BEST_BUY CUSTOMERS  table
CREATE TABLE BEST_BUY_CUSTOMERS
( 
  CUSTOMER_ID INT NOT NULL,
 FIRST_NAME VARCHAR(50) NULL,
 LAST_NAME VARCHAR(50) NULL,
 AGE INT NOT NULL,
COUNTRY VARCHAR(50) NULL
);


--2:LOAD DATA TO THE BEST_BUY_CUSTOMERS TABLE
INSERT INTO BEST_BUY_CUSTOMERS
(CUSTOMER_ID, FIRST_NAME, LAST_NAME, AGE, COUNTRY)
VALUES (1, 'John', 'Doe', 31, 'USA'),
(2, 'Robert', 'Luna', 22, 'USA'),
(3, 'David', 'Robinson', 22, 'UK'),
(4, 'John', 'Reinhardt', 25, 'UK'),
(5, 'Betty', 'Doe', 28, 'UAE')

 

 select * from BEST_BUY_CUSTOMERS

--2:Creating an ORDER table

CREATE TABLE BEST_BUY_ORDERS
(
   ORDER_ID INT NOT NULL,
   ITEM VARCHAR(50) NULL,
   AMOUNT MONEY,
   CUSTOMER_ID INT NOT NULL
);


--2:LOAD DATA TO THE ( 1, 'Keyboard', 400,4), TABLE
INSERT INTO BEST_BUY_ORDERS
(ORDER_ID, ITEM, AMOUNT, CUSTOMER_ID)
VALUES 
( 1, 'Keyboard', 400,4),
( 2, 'Mouse', 300,4),
( 3, 'Monitor', 12000,3),
( 4, 'Keyboard', 400,1),
( 5, 'Mousepad', 250,2)


select * from BEST_BUY_ORDERS



--2:Creating a BEST_BUY_PRODUCTS table

CREATE TABLE BEST_BUY_PRODUCTS
(
   PRODUCT_ID INT NOT NULL,
   PRODUCT_NAME VARCHAR(50) NULL,
   AMOUNT MONEY,
   CUSTOMER_ID INT NOT NULL
);


--2:LOAD DATA TO THE ( 1, 'Keyboard', 400,4), TABLE
INSERT INTO BEST_BUY_PRODUCTS
(PRODUCT_ID, PRODUCT_NAME, AMOUNT, CUSTOMER_ID)
VALUES 
( 1, 'Keyboard', 400,5),
( 2, 'Headphone', 300,4),
( 3, 'Laptop', 12000,3),
( 4, 'Pen', 400,1),
( 5, 'Mousepad', 250,2)


select * from BEST_BUY_PRODUCTS



select * from BEST_BUY_CUSTOMERS
select * from BEST_BUY_ORDERS


--1:Write a query that shows customer who bought item Mouse
select 
A.CUSTOMER_ID,
A.FIRST_NAME,
A.LAST_NAME,
A.AGE,
A.COUNTRY,
B.ITEM,
B.AMOUNT
FROM BEST_BUY_CUSTOMERS A
LEFT JOIN BEST_BUY_ORDERS B
ON A.CUSTOMER_ID = B.CUSTOMER_ID
WHERE B.ITEM= 'Mouse';




--2:SHOW ME THE CUSTOMER INFO AND THE ITEM THAT THEY ORDER, THE PRODUCT BUT ONLY SHOW THE PRODUCT FOR PEN
select 
A.CUSTOMER_ID,
A.FIRST_NAME,
A.LAST_NAME,
A.AGE,
A.COUNTRY,
B.ORDER_ID,
B.ITEM,
B.AMOUNT,
C.PRODUCT_ID,
C.PRODUCT_NAME
FROM BEST_BUY_CUSTOMERS A
LEFT JOIN BEST_BUY_ORDERS B
ON A.CUSTOMER_ID = B.CUSTOMER_ID
LEFT JOIN BEST_BUY_PRODUCTS C
ON A.CUSTOMER_ID = C.CUSTOMER_ID
WHERE C.PRODUCT_NAME= 'PEN'
