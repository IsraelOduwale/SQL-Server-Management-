-- =============================================
-- Author:		Israel Oduwale
-- Create date: 04-25-2024
-- Description:	This code is to create pivot on data in Table Company Info
--				Do more analysis on Table Company Info
-- Revise Date: 04-19-2024
-- Version:		v1.0
-- =============================================


use SQLTrainingCase

--QUESTION 1 PIVOT ASSIGNMENT 
--CREATE A PIVOT TO SHOW THE USA, UK AND CANADA COLUMN FROM THE TABLE COMPANY INFO
select * from CompanyInfo


select *
from
(
select FIRST_NAME, LAST_NAME, COUNTRY
from CompanyInfo
group by 
FIRST_NAME, LAST_NAME, COUNTRY
)x
pivot(count([Country])
for Country in ([USA], [UK], [CANADA]))as Country_Pivot;







--QUESTION 2
--CREATE A PIVOT TO SHOW THE EMPLOYEES AS COLUMNS SUCH AS 55,4,23,10,15,1

insert into EmployeeInfo
values
('Michael', 'James', 1);


select * from EmployeeInfo

select *
from
(
select FIRST_NAME, LAST_NAME, EmployeeId
from EmployeeInfo
group by 
FIRST_NAME, LAST_NAME, EmployeeId
)x
pivot(count([EmployeeId])
for EmployeeId in ([55], [4], [23], [10], [15], [1]))as Employee_Pivot;







--QUESTION 3
--CREATE A PIVOT TO SHOW THE VALUES OF YEAR AS COLUMNS

use SQLTraining

SELECT * from Games

select *
from
(
select Year, City
from Games
group by 
Year, City
)x
pivot(count([Year])
for Year in ([2000], [2004], [2008], [2012], [2024]))as Year_Pivot 







--QUESTION 4
--CREATE A PIVOT TO SHOW THE VALUES OF YEAR AS COLUMNS

use SQLTraining

select * from Noble

select *
from
(
select Year, Subject, Winner
from Noble
group by
Year, Subject, Winner 
)x
pivot(count([Year])
for Year in ([1960], [1961], [1962], [1963], [2024], [2025], [2026], [2027], [2028], [2029], [2030])) as Year_Pivot

/**
select
Winner,
coalesce([Chemistry],'0') 'Chemistry',
coalesce([Literature],'0') 'Literature',
coalesce([Medicine],'0') 'Medicine',
coalesce([Economics],'0') 'Economics'
from
(
select *
from
(
select Year, Subject, Winner
from Noble
group by
Year, Subject, Winner 
)x
pivot(sum([Year])
for Subject in ([Chemistry], [Literature], [Medicine], [Economics])) as Subject_Pivot
)b
**/




--QUESTION 5
--CREATE A PIVOT TO SHOW THE job titles for the case statement in the question

use SQLTrainingCase

select * from Business
select * from vwJobPosition


select * 
from
(
Select
ID,
[NAME],
AGE,
[ADDRESS],
SALARY,
case
when Age<25 then 'Intern'
when Age>=25 and Age<=27 then 'Associate Engineer'
when Age>=25 then 'Senior_Developer'
else 'Unknown'
end as 'Job_Position'
from Business
group by
ID, [NAME], AGE, [ADDRESS], SALARY
)x
pivot (count([Job_Position])
for Job_Position in ([Senior_Developer],[Associate Engineer],[Intern])) as JobPosition_pivot





--QUESTION 6
--CREATE A PIVOT TO SHOW GEN X, GEN Y, GEN Z, GEN ALPHA

select * from Business
select * from vwGeneration

select *
from
(
Select
ID,
[NAME],
AGE,
[ADDRESS],
SALARY,
case
when Age=22 then 'Gen_Alpha'
when Age in (23,24,25) then 'GenZ'
when Age=27 then 'GenY'
when Age>30 then 'GenX'
else 'Unknown'
end as 'Generation'
from Business
group by
ID, [NAME], AGE, [ADDRESS], SALARY
)x
pivot(count([Generation])
for Generation in ([GenX], [GenY], [GenZ], [Gen_Alpha])) as Generation_Pivot


--creating stored procedure for this 
create procedure spGeneration as 
Begin

select * 
from
(
select * from vwGeneration
)x
pivot(count([Generation])
for Generation in ([GenX], [GenY], [GenZ], [Gen_Alpha])) as Generation_Pivot
end

exec spGeneration