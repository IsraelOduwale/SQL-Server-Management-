-- =============================================
-- Author:		Israel Oduwale
-- Create date: 07-12-2024
-- Description:	This code is to extract data from sql 
--				Do more analysis on Table Customers
-- Revise Date: 08-19-2024 
-- Version:		v1.0
-- =============================================

use SQLTraining



select * from [dbo].[Covid_Data]

select * into Covid_Data_Europe from Covid_Data
where WHO_Region in ('Europe')

select * into Covid_Data_Africa from Covid_Data
where WHO_Region in ('Africa')

select * into Covid_Data_Americas from Covid_Data
where WHO_Region in ('Americas')

select * into Covid_Data_SouthEastAsia from Covid_Data
where WHO_Region in ('South-East Asia')

select * from Covid_Data_Africa
select * from Covid_Data_Europe
select * from Covid_Data_Americas
select * from Covid_Data_SouthEastAsia





--roll back and commit
--roll back, the table still comes when you SELECT it
begin tran
delete from Covid_Data_Africa
rollback

--commit, the table is deleted fully
begin tran
delete from Covid_Data_Africa
commit

--cant rollback truncate