-- =============================================
-- Author:		Israel Oduwale
-- Create date: 12-01-2025
-- Description:	This code is to create and run analysis on the tables in EmadeBusiness Project
-- Revise Date: 12-01-2025
-- Version:		v2.0
-- =============================================

use emade_dev


drop table if exists Business
--Create table Business
create table Business
(
ID int not null,
[NAME] varchar (50) null,
AGE int not null,
[ADDRESS] varchar (50) null,
SALARY int not null
)

--Load data
insert into Business
(ID,[NAME],AGE,[ADDRESS],SALARY)
values
(1, 'Ramesh', 32, 'Ahmedabad', 2000),
(2, 'Khilan', 25, 'Delhi', 1500),
(3, 'Kaushik', 23, 'Kota', 2000),
(4, 'Chaitali', 25, 'Mumbai', 6500),
(5, 'Hardik', 27, 'Bhopal', 8500),
(6, 'Komal', 22, 'MP', 4500),
(7, 'Muffy', 24, 'Indore', 10000)

 --display business table
select * from Business

/**1 
if customer age > or = 25 then Senior Developer
if customer age < 25 then Intern
if customer age > and = 25 but also < and = 27 then Associate Engineer
Name field as JobPosition
**/
select 
ID,
NAME,
AGE,
ADDRESS,
SALARY,
CASE
	when age < 25 then 'Intern'
	when age BETWEEN 25 and 27 then 'Associate_Engineer'
	when age > = 25 then 'Senior_Developer'
	Else 'Unknown'
End as JobPosition
from Business


/**2 
If customer age is more than 30 then Gen X
If customer age is 23,24,25 then Gen Z
If customer age is 22 then Gen Alpha
If customer age is 27 then Gen Y
name field as Generation
**/
select 
ID,
NAME,
AGE,
ADDRESS,
SALARY,
CASE
	when age = 22 then 'Gen Alpha'
	when age in (23,24,25) then 'Gen Z'
	when age = 27 then 'Gen Y'
	when age >30 then 'Gen X'
	Else 'Unknown Gen'
End as Generation
from Business