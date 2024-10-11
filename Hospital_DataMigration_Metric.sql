-- =============================================
-- Author:		Israel Oduwale
-- Create date: 09-08-2024
-- Description:	This code is to migrate data from Hospital database to Prod, Test and Dev databases
--				To run a metric showing the record count for the 4 environments
-- Revise Date: 09-08-2024 
-- Version:		v1.0
-- =============================================




--Data Migration
--Migrating Data from Hospital Database to Prod, Test and Dev databases


--appointment table
select * into Dev.dbo.appointment
from Hospital.dbo.appointment


select * into Test.dbo.appointment
from Hospital.dbo.appointment


select * into Prod.dbo.appointment
from Hospital.dbo.appointment


--nurse table
select * into Test.dbo.nurse
from Hospital.dbo.nurse


select * into Prod.dbo.nurse
from Hospital.dbo.nurse



--physician table
select * into Test.dbo.physician
from Hospital.dbo.physician


select * into Prod.dbo.physician
from Hospital.dbo.physician



--DepartmentHospital table
select * into Dev.dbo.DepartmentHospital
from Hospital.dbo.DepartmentHospital


select * into Test.dbo.DepartmentHospital
from Hospital.dbo.DepartmentHospital


select * into Prod.dbo.DepartmentHospital
from Hospital.dbo.DepartmentHospital


--department table already exists in the databases and so it cannot be moved. 
--I renamed the object name and then was able to migrate it.







--METRIC SHOWING THE RECORD FOR THE 3 ENVIRONMENT (DATABASES)


--appointment Table
select 'Hospital' as source,
'appointment' as TableName,
count (*) as Total
from hospital.dbo.appointment
Union All
select 'Prod' as source,
'appointment' as TableName,
count (*) as Total
from Prod.dbo.appointment
Union All
select 'Test' as source,
'appointment' as TableName,
count (*) as Total
from Test.dbo.appointment
Union All
select 'Dev' as source,
'appointment' as TableName,
count (*) as Total
from Dev.dbo.appointment;



--nurse Table
select 'Hospital' as source,
'nurse' as TableName,
count (*) as Total
from hospital.dbo.nurse
Union All
select 'Prod' as source,
'nurse' as TableName,
count (*) as Total
from Prod.dbo.nurse
Union All
select 'Test' as source,
'nurse' as TableName,
count (*) as Total
from Test.dbo.nurse
Union All
select 'Dev' as source,
'nurse' as TableName,
count (*) as Total
from Dev.dbo.nurse;




--DepartmentHospital Table
select 'Hospital' as source,
'DepartmentHospital' as TableName,
count (*) as Total
from hospital.dbo.DepartmentHospital
Union All
select 'Prod' as source,
'DepartmentHospital' as TableName,
count (*) as Total
from Prod.dbo.DepartmentHospital
Union All
select 'Test' as source,
'DepartmentHospital' as TableName,
count (*) as Total
from Test.dbo.DepartmentHospital
Union All
select 'Dev' as source,
'DepartmentHospital' as TableName,
count (*) as Total
from Dev.dbo.DepartmentHospital;