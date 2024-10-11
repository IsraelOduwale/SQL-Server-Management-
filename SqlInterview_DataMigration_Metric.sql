-- =============================================
-- Author:		Israel Oduwale
-- Create date: 09-08-2024
-- Description:	This code is to migrate data from SqlInterview database to Prod, Test and Dev databases
--				To run a metric showing the record count for the 4 environments
-- Revise Date: 09-08-2024 
-- Version:		v1.0
-- =============================================




--Data Migration
--Migrating Data from SqlInterview Database to Prod, Test and Dev databases

select * into Dev.dbo.Customers
from SQLInterview.dbo.Customers


select * into Test.dbo.Customers
from SQLInterview.dbo.Customers


select * into Prod.dbo.Customers
from SQLInterview.dbo.Customers








--METRIC SHOWING THE RECORD FOR THE 3 ENVIRONMENT (DATABASES)


--Customers Table
select 'SQLInterview' as source,
'Customers' as TableName,
count (*) as Total
from SQLInterview.dbo.Customers
Union All
select 'Prod' as source,
'Customers' as TableName,
count (*) as Total
from Prod.dbo.Customers
Union All
select 'Test' as source,
'Customers' as TableName,
count (*) as Total
from Test.dbo.Customers
Union All
select 'Dev' as source,
'Customers' as TableName,
count (*) as Total
from Dev.dbo.Customers;



--JOB Table
select 'SQLInterview' as source,
'JOB' as TableName,
count (*) as Total
from SQLInterview.dbo.JOB
Union All
select 'Prod' as source,
'JOB' as TableName,
count (*) as Total
from Prod.dbo.JOB
Union All
select 'Test' as source,
'JOB' as TableName,
count (*) as Total
from Test.dbo.JOB
Union All
select 'Dev' as source,
'JOB' as TableName,
count (*) as Total
from Dev.dbo.JOB



--orders Table
select 'SQLInterview' as source,
'orders' as TableName,
count (*) as Total
from SQLInterview.dbo.orders
Union All
select 'Prod' as source,
'orders' as TableName,
count (*) as Total
from Prod.dbo.orders
Union All
select 'Test' as source,
'orders' as TableName,
count (*) as Total
from Test.dbo.orders
Union All
select 'Dev' as source,
'orders' as TableName,
count (*) as Total
from Dev.dbo.orders



--Department Table
select 'SQLInterview' as source,
'Department' as TableName,
count (*) as Total
from SQLInterview.dbo.Department
Union All
select 'Prod' as source,
'Department' as TableName,
count (*) as Total
from Prod.dbo.Department
Union All
select 'Test' as source,
'Department' as TableName,
count (*) as Total
from Test.dbo.Department
Union All
select 'Dev' as source,
'Department' as TableName,
count (*) as Total
from Dev.dbo.Department


--Products Table
select 'SQLInterview' as source,
'Products' as TableName,
count (*) as Total
from SQLInterview.dbo.Products
Union All
select 'Prod' as source,
'Products' as TableName,
count (*) as Total
from Prod.dbo.Products
Union All
select 'Test' as source,
'Products' as TableName,
count (*) as Total
from Test.dbo.Products
Union All
select 'Dev' as source,
'Products' as TableName,
count (*) as Total
from Dev.dbo.Products
