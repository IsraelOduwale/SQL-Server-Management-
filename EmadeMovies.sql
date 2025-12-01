-- =============================================
-- Author:		Israel Oduwale
-- Create date: 10-28-2025
-- Description:	This code is to create and run analysis on the tables in EmadeMovies Project
-- Revise Date: 12-01-2025
-- Version:		v2.0
-- =============================================

use emade_dev

drop table if exists Emade_Movies

create table Emade_Movies
(No int not null,
Name varchar (50) null,
Type varchar (50) null,
Rating varchar (5) null,
Stars varchar (50) null,
Qty int not null, 
Price dec(10, 2) not null)

insert into Emade_Movies
(No,Name,Type,Rating,Stars,Qty,Price)
values
(1,'Gone With Wind','Drama','G','Gable',4,39.95),
(2,'Friday the 13th','Horror','R','Jason',2,60.95),
(3,'Top Gun','Drama','PG','Cruise',7,49.95),
(4,'Splash','Comedy','PG13','Hanks',3,29.95),
(5,'Independent Day','Drama','R','Turner',3,19.95),
(6,'Risk Business','Comedy','R','Cruise',2,44.95),
(7,'Cocoon','Sci-fi','PG','Ameche',2,31.95),
(8,'Crocodile','Comedy','PG13','Harris',2,69.95),
(9,'101 Dalmatians','Comedy','G','Hoffman',3,59.95),
(10,'Tootsie','Comedy','PG','Croft',1,29.95)

select * from Emade_Movies

--1 Find the total number of records available in the type which is Drama
Select * from Emade_Movies
where Type='Drama'

--gives the total quantity of drama movies available and the count of how many different drama movies title
Select 
Type,
count(*) as NumberOfTitle,
SUM(QTY) as Available
from Emade_Movies
where Type='Drama'
group by Type


--2 Display a list of all movies with price over 20 and sorted by price
select * from Emade_Movies
where Price>20
order by Price 

--3 Display all the movies sorted by QTY in decreasing order
select * from Emade_Movies
order by Qty desc

--4 Display a report listing total by movie type, current value, and replacement value for each movie type.
select 
Type,
SUM(Qty*Price) as Current_Value,
SUM(QTY*Price*1.15) as Replacement_Value
from Emade_Movies
group by
Type


--5 Calculate the replacement value for all movies as QTY*Price*1.15
select 
Name,
Type,
Rating,
Stars,
Qty,
Price,
SUM(Qty*Price) as Current_Value,
SUM(QTY*Price*1.15) as Replacement_Value
from Emade_Movies
group by
name,
type,
Rating,
Stars,
Qty,
Price


--6 Count the number of movies where rating is not "G".
Select count(*) as NumberOfMovies
from Emade_Movies
where Rating != 'G'


--7 Insert a new movie in the table and make it Name:Nollywood, Type should be SuperStory, Ratings as R, Stars as Regina, Qty
--as 10 in Movie table were price > 30
INSERT INTO Emade_Movies 
VALUES 
(11, 'Nollywood', 'SuperStory', 'R', 'Regina', 10, 35)




select * from Emade_Movies
