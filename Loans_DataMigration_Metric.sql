-- =============================================
-- Author:		Israel Oduwale
-- Create date: 09-08-2024
-- Description:	This code is to migrate data from Loans database to Prod, Test and Dev databases
--				To run a metric showing the record count for the 4 environments
-- Revise Date: 09-08-2024 
-- Version:		v1.0
-- =============================================




--Data Migration
--Migrating Data from Loans Database to Prod, Test and Dev databases

select * into Dev.dbo.LoansAccounts
from Loans.dbo.LoansAccounts


select * into Test.dbo.LoansAccounts
from Loans.dbo.LoansAccounts


select * into Prod.dbo.LoansAccounts
from Loans.dbo.LoansAccounts







--METRIC SHOWING THE RECORD FOR THE 3 ENVIRONMENT (DATABASES)


--Loans Table
select 'Loans' as source,
'LoansAccounts' as TableName,
count (*) as Total
from Loans.dbo.LoansAccounts
Union All
select 'Prod' as source,
'LoansAccounts' as TableName,
count (*) as Total
from Prod.dbo.LoansAccounts
Union All
select 'Test' as source,
'LoansAccounts' as TableName,
count (*) as Total
from Test.dbo.LoansAccounts
Union All
select 'Dev' as source,
'LoansAccounts' as TableName,
count (*) as Total
from Dev.dbo.LoansAccounts;