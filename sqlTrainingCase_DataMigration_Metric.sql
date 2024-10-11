-- =============================================
-- Author:		Israel Oduwale
-- Create date: 09-08-2024
-- Description:	This code is to migrate data from SqlTrainingCase database to Prod, Test and Dev databases
--				To run a metric showing the record count for the 4 environments
-- Revise Date: 09-08-2024 
-- Version:		v1.0
-- =============================================




--Data Migration
--Migrating Data from SqlTrainingCase Database to Prod, Test and Dev databases

select * into Dev.dbo.Business
from SqlTrainingCase.dbo.Business


select * into Test.dbo.Business
from SqlTrainingCase.dbo.Business


select * into Prod.dbo.Business
from SqlTrainingCase.dbo.Business







--METRIC SHOWING THE RECORD FOR THE 3 ENVIRONMENT (DATABASES)


--Business Table
select 'SqlTrainingCase' as source,
'Business' as TableName,
count (*) as Total
from SqlTrainingCase.dbo.Business
Union All
select 'Prod' as source,
'Business' as TableName,
count (*) as Total
from Prod.dbo.Business
Union All
select 'Test' as source,
'Business' as TableName,
count (*) as Total
from Test.dbo.Business
Union All
select 'Dev' as source,
'Business' as TableName,
count (*) as Total
from Dev.dbo.Business;



--CustomerInfo Table
select 'SqlTrainingCase' as source,
'CustomerInfo' as TableName,
count (*) as Total
from SqlTrainingCase.dbo.CustomerInfo
Union All
select 'Prod' as source,
'CustomerInfo' as TableName,
count (*) as Total
from Prod.dbo.CustomerInfo
Union All
select 'Test' as source,
'CustomerInfo' as TableName,
count (*) as Total
from Test.dbo.CustomerInfo
Union All
select 'Dev' as source,
'CustomerInfo' as TableName,
count (*) as Total
from Dev.dbo.CustomerInfo;




--CompanyInfo Table
select 'SqlTrainingCase' as source,
'CompanyInfo' as TableName,
count (*) as Total
from SqlTrainingCase.dbo.CompanyInfo
Union All
select 'Prod' as source,
'CompanyInfo' as TableName,
count (*) as Total
from Prod.dbo.CompanyInfo
Union All
select 'Test' as source,
'CompanyInfo' as TableName,
count (*) as Total
from Test.dbo.CompanyInfo
Union All
select 'Dev' as source,
'CompanyInfo' as TableName,
count (*) as Total
from Dev.dbo.CompanyInfo;


