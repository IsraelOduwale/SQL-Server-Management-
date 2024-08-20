-- =============================================
-- Author:		Israel Oduwale
-- Create date: 03-14-2024
-- Description:	This code is to create database, create table 
--				Do more analysis on Table Games
-- Revise Date: 08-19-2024 
-- Version:		v1.0
-- =============================================

create database SQLTraining
go

use SQLTraining

create table Games
(
[Year] int not null,
City varchar (50) not null
);

select * from Games

insert into Games
(
Year,
City
)
values
(2000, 'Sydney'),
(2004, 'Athens'),
(2008, 'Beijing'),
(2012, 'London');

select * from Games
where Year=2004;

select * from Games
where City='London';

select MAX(Year) as 'Latest Year' from Games

insert into Games
values
(2024, 'Paris');

create VIEW vwOldGames
as (select * from Games where Year<2008);

select * from vwOldGames

select count(*) as 'Number of records'
from Games;

select * from Games
where City not in ('London','Athens')

--using case statements and logical expression
select * from Games


/**
Write a Case statement to show the era of the year.
Name the new column "Year_Status"
**/

select
[Year],
City,
Case when [Year]=2000 then 'GenZ'
when [Year]=2004 then 'GenX'
when [Year]=2008 then 'GenY'
else 'Unknown' 
end as 'Year_Status'
from Games;



/**
Write a Case statement to show year range 2000 and 2008, make sure this shows Year_status as "Great".
any record that is 2024 and above, show them as "Super". Any other record show them as "Good".
Name the new column "Year_Status"
**/

select
[Year],
City,
Case when [Year] in (2000, 2004, 2008) then 'Great'
when [Year]>=2024 then 'Super'
else 'Good'
end as 'Year_Status'
from Games;

--another way 

select
[Year],
City,
Case when [Year] between 2000 and 2008 then 'Great'
when [Year]>=2024 then 'Super'
else 'Good'
end as 'Year_Status'
from Games;



--third way 

select
[Year],
City,
Case when [Year]>=2004 and [Year]<=2012 then 'Great'
when [Year]=2000 then 'Okay'
when [Year]>=2024 then 'Super'
else 'Good'
end as 'Year_Status'
from Games;
