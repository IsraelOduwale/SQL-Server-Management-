-- =============================================
-- Author:		Israel Oduwale
-- Create date: 09-08-2024
-- Description:	This code is to migrate data from SqlTraining database to Prod, Test and Dev databases
--				To run a metric showing the record count for the 4 environments
-- Revise Date: 09-08-2024 
-- Version:		v1.0
-- =============================================




--METRIC SHOWING THE RECORD FOR THE 3 ENVIRONMENT (DATABASES)

--NOBLE TABLE
select 'SQLtraining' as source,
'Noble' as TableName,
count (*) as Total
from SQLtraining.dbo.Noble
Union All
select 'Prod' as source,
'Noble' as TableName,
count (*) as Total
from Prod.dbo.Noble
Union All
select 'Test' as source,
'Noble' as TableName,
count (*) as Total
from Test.dbo.Noble
Union All
select 'Dev' as source,
'Noble' as TableName,
count (*) as Total
from Dev.dbo.Noble



--CAR TABLE
select 'SQLtraining' as Source,
'Car' as TableName,
count (*) as Total
from SQLtraining.dbo.Car
Union All
select 'Prod' as Source,
'Car' as TableName,
count (*) as Total
from Prod.dbo.Car
Union All
select 'Test' as Source,
'Car' as TableName,
count (*) as Total
from Test.dbo.Car
Union All
select 'Dev' as Source,
'Car' as TableName,
count (*) as Total
from Dev.dbo.Car



--CarCustomer TABLE
select 'SQLtraining' as Source,
'CarCustomer' as TableName,
count (*) as Total
from SQLtraining.dbo.CarCustomer
Union All
select 'Prod' as Source,
'CarCustomer' as TableName,
count (*) as Total
from Prod.dbo.CarCustomer
Union All
select 'Test' as Source,
'CarCustomer' as TableName,
count (*) as Total
from Test.dbo.CarCustomer
Union All
select 'Dev' as Source,
'CarCustomer' as TableName,
count (*) as Total
from Dev.dbo.CarCustomer



--Country_Data TABLE
select 'SQLtraining' as Source,
'Country_Data' as TableName,
count (*) as Total
from SQLtraining.dbo.Country_Data
Union All
select 'Prod' as Source,
'Country_Data' as TableName,
count (*) as Total
from Prod.dbo.Country_Data
Union All
select 'Test' as Source,
'Country_Data' as TableName,
count (*) as Total
from Test.dbo.Country_Data
Union All
select 'Dev' as Source,
'Country_Data' as TableName,
count (*) as Total
from Dev.dbo.Country_Data



--Covid_Data TABLE
select 'SQLtraining' as Source,
'Covid_Data' as TableName,
count (*) as Total
from SQLtraining.dbo.Covid_Data
Union All
select 'Prod' as Source,
'Covid_Data' as TableName,
count (*) as Total
from Prod.dbo.Covid_Data
Union All
select 'Test' as Source,
'Covid_Data' as TableName,
count (*) as Total
from Test.dbo.Covid_Data
Union All
select 'Dev' as Source,
'Covid_Data' as TableName,
count (*) as Total
from Dev.dbo.Covid_Data



--Covid_Data_Africa TABLE
select 'SQLtraining' as Source,
'Covid_Data_Africa' as TableName,
count (*) as Total
from SQLtraining.dbo.Covid_Data_Africa
Union All
select 'Prod' as Source,
'Covid_Data_Africa' as TableName,
count (*) as Total
from Prod.dbo.Covid_Data_Africa
Union All
select 'Test' as Source,
'Covid_Data_Africa' as TableName,
count (*) as Total
from Test.dbo.Covid_Data_Africa
Union All
select 'Dev' as Source,
'Covid_Data_Africa' as TableName,
count (*) as Total
from Dev.dbo.Covid_Data_Africa



--DAX_Sales TABLE
select 'SQLtraining' as Source,
'DAX_Sales' as TableName,
count (*) as Total
from SQLtraining.dbo.DAX_Sales
Union All
select 'Prod' as Source,
'DAX_Sales' as TableName,
count (*) as Total
from Prod.dbo.DAX_Sales
Union All
select 'Test' as Source,
'DAX_Sales' as TableName,
count (*) as Total
from Test.dbo.DAX_Sales
Union All
select 'Dev' as Source,
'DAX_Sales' as TableName,
count (*) as Total
from Dev.dbo.DAX_Sales


--Employees TABLE
select 'SQLtraining' as Source,
'Employees' as TableName,
count (*) as Total
from SQLtraining.dbo.Employees
Union All
select 'Prod' as Source,
'Employees' as TableName,
count (*) as Total
from Prod.dbo.Employees
Union All
select 'Test' as Source,
'Employees' as TableName,
count (*) as Total
from Test.dbo.Employees
Union All
select 'Dev' as Source,
'Employees' as TableName,
count (*) as Total
from Dev.dbo.Employees



--Games TABLE
select 'SQLtraining' as Source,
'Games' as TableName,
count (*) as Total
from SQLtraining.dbo.Games
Union All
select 'Prod' as Source,
'Games' as TableName,
count (*) as Total
from Prod.dbo.Games
Union All
select 'Test' as Source,
'Games' as TableName,
count (*) as Total
from Test.dbo.Games
Union All
select 'Dev' as Source,
'Games' as TableName,
count (*) as Total
from Dev.dbo.Games



--NobleBackup TABLE
select 'SQLtraining' as Source,
'NobleBackup' as TableName,
count (*) as Total
from SQLtraining.dbo.NobleBackup
Union All
select 'Prod' as Source,
'NobleBackup' as TableName,
count (*) as Total
from Prod.dbo.NobleBackup
Union All
select 'Test' as Source,
'NobleBackup' as TableName,
count (*) as Total
from Test.dbo.NobleBackup
Union All
select 'Dev' as Source,
'NobleBackup' as TableName,
count (*) as Total
from Dev.dbo.NobleBackup



--PRSN TABLE
select 'SQLtraining' as Source,
'PRSN' as TableName,
count (*) as Total
from SQLtraining.dbo.PRSN
Union All
select 'Prod' as Source,
'PRSN' as TableName,
count (*) as Total
from Prod.dbo.PRSN
Union All
select 'Test' as Source,
'PRSN' as TableName,
count (*) as Total
from Test.dbo.PRSN
Union All
select 'Dev' as Source,
'PRSN' as TableName,
count (*) as Total
from Dev.dbo.PRSN


