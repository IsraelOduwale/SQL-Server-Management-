-- =============================================
-- Author:		Israel Oduwale
-- Create date: 09-08-2024
-- Description:	This code is to migrate data from CompanyData database to Prod, Test and Dev databases
--				To run a metric showing the record count for the 4 environments
-- Revise Date: 09-08-2024 
-- Version:		v1.0
-- =============================================




--Data Migration
--Migrating Data from CompanyData Database to Prod, Test and Dev databases

select * into Dev.dbo.EmployeeInfoCompany
from CompanyData.dbo.EmployeeInfoCompany


select * into Test.dbo.EmployeeInfoCompany
from CompanyData.dbo.EmployeeInfoCompany


select * into Prod.dbo.EmployeeInfoCompany
from CompanyData.dbo.EmployeeInfoCompany







--METRIC SHOWING THE RECORD FOR THE 3 ENVIRONMENT (DATABASES)


--EmployeeInfoCompany Table
select 'CompanyData' as source,
'EmployeeInfoCompany' as TableName,
count (*) as Total
from CompanyData.dbo.EmployeeInfoCompany
Union All
select 'Prod' as source,
'EmployeeInfoCompany' as TableName,
count (*) as Total
from Prod.dbo.EmployeeInfoCompany
Union All
select 'Test' as source,
'EmployeeInfoCompany' as TableName,
count (*) as Total
from Test.dbo.EmployeeInfoCompany
Union All
select 'Dev' as source,
'EmployeeInfoCompany' as TableName,
count (*) as Total
from Dev.dbo.EmployeeInfoCompany;