-- =============================================
-- Author:		Israel Oduwale
-- Create date: 08-06-2024
-- Description:	This code is to create and Execute Stored Procedures.
-- Revise Date: 08-24-2024 
-- Version:		v1.0
-- =============================================


use SQLTraining

--STored Procedure using World table
create procedure spWorld
as
begin
select * from World
end

exec spWorld

--STored Procedure using Games table
create procedure spGames
as
begin
select * from Games
end

exec spGames


--STored Procedure using ComapnyInfo table
use SQLTrainingCase

create procedure spCompanyInfo
as
begin
select * from CompanyInfo
end

exec spCompanyInfo


--STored Procedure using EmployeeInfo table
create procedure spEmployeeInfo
as
begin
select * from EmployeeInfo
end

exec spEmployeeInfo


--STored Procedure using Business table
create procedure spBusiness
as
begin
select * from Business
end

exec spBusiness


--STored Procedure using Noble table
Create procedure spNoble
as 
begin 
select * from Noble
end

exec spNoble