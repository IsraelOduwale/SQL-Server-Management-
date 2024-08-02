use SQLTraining

--ASSIGNMENT 1
create table Movies(
[No] int identity (1,1),
[Name] varchar (50),
[Type] varchar (50),
Rating varchar (15),
Stars varchar (50),
Qty int,
Price decimal (10,2)
)


insert into Movies
values
('Gone with wind', 'Drama', 'G', 'Gable', 4, 39.95),
('Friday the 13th', 'Horror', 'R', 'Jason', 2, 60.95),
('Top Gun', 'Drama', 'PG', 'Cruise', 7, 49.95),
('Splash', 'Comedy', 'PG13', 'Hanks', 3, 29.95),
('Independent Day', 'Drama', 'R', 'Turner', 3, 19.95),
('Risk Business', 'Comedy', 'R', 'Cruise', 2, 44.95),
('Cocoon', 'Sci-fi', 'PG', 'Ameche', 2, 31.95),
('Crocodile', 'Comedy', 'PG13', 'Harris', 2, 69.95),
('101 Dalmatians', 'Comedy', 'G', 'Hoffman', 3, 59.95),
('Tootsie', 'Comedy', 'PG', 'Croft', 1, 29.95)

select * from Movies

--Total number of records available in Drama
select * from Movies 
where Type='Drama'

--Display a list of all movies with price over 20 and sorted by price
select * from Movies
where Price>20 
order by Price 


--Display all movies sorted by QTY
select * from Movies
order by Qty desc 


/**
Display a report listing total by movie type,
current value and replacement value for each movie type . 
Calculate the replacement value for all movies as QTY * Price * 1.15
**/
select
[Type],
sum(Qty) as Total_Qty,
sum(Qty * Price) as Current_Value,
sum(Qty * Price * 1.15) as Replacement_Value
from Movies
group by
Type



--Count the number of movies where Rating is not "G" 
select count(*) as Not_G_Rated from Movies
where Rating not in ('G')


--Insert a new movie in the table and make it Name:Nollywood,:Type should be Super Story; 
--ratings as R; Stars as Regina; Qty as 10 in Movie table where price > 30.

insert into Movies(Name,Type,Rating,Stars, Qty)
select distinct 'Nollywood', 'Super Story', 'R', 'Regina', 10
from Movies
where Price>30









--Assignment 2

create table CarCustomer(
Customer_ID int identity(1,1),
LastName varchar (50),
FirstName varchar (50)
)

insert into CarCustomer
values
('Adams', 'Frank'),
('Smith', 'John'),
('Hamilton', 'Edward'),
('Parks', 'Sara'),
('Zone', 'Nancy'),
('Johnson', 'Mark'),
('Craft', 'Susan'),
('Ford', 'Henry'),
('London', 'Jack'),
('Polansky', 'Shelly')


select * from CarCustomer


create table Car(
CarID int identity(1,1),
Make varchar (50),
Model varchar(50),
Price bigint,
StoreLocation varchar(50),
CustomerID int
)

insert into Car
values
('Ford', 'F150', 13000, 'San Francisco', 1),
('Mercedes Benz', 'E350', 50000, 'San Jose', 2),
('Ford', 'F250', 24000, 'San Francisco', 5),
('Toyota', 'Camry', 30000, 'Oakland', 4),
('Toyota', 'Corolla', 10000, 'Oakland', 2),
('Honda', 'Civic', 9000, 'San Jose', 1),
('Honda', 'CRV', 16000, 'San Francisco', 3),
('Mazda', '3', 3000, 'San Jose', Null),
('Tesla', 'Model 3', 102000, 'San Francisco', Null)


--List all the cars available and their information
select * from Car

--List all the cars with price>10000
select * from Car
where Price>10000

--List all the cars in the san francisco store
select * from Car
where StoreLocation='San Francisco'


--List all the cars that Customer #1 bought
select 
a.Customer_ID,
a.LastName,
a.FirstName,
b.CarID,
b.Make,
b.Model,
b.Price,
b.StoreLocation
from Car b
join CarCustomer a
on a.Customer_ID=b.CustomerID
where Customer_ID=1


--List all the customers whose name ends with Smith
select * from CarCustomer
where LastName='Smith'

select 
a.Customer_ID,
a.LastName,
a.FirstName,
b.CarID,
b.Make,
b.Model,
b.Price,
b.StoreLocation
from Car b
join CarCustomer a
on a.Customer_ID=b.CustomerID
where a.LastName='Smith'


--List the average price of cars
Select avg(Price) as Average_CarsPrice
from Car

--List all the cars whose price ranges from 1000 - 10000
select * from Car
where Price between 1000 and 10000

--List all customers that bought in san francisco
select 
a.Customer_ID,
a.LastName,
a.FirstName,
b.CarID,
b.Make,
b.Model,
b.Price,
b.StoreLocation
from Car b
join CarCustomer a
on a.Customer_ID=b.CustomerID
where StoreLocation = 'San Francisco'



--How many cars does the dealer have in total
Select count(*)as TotalCarsAvailable 
from Car

--How many cars are in each store
Select
StoreLocation,
count(*) as TotalCarsAvailable
from Car
group by StoreLocation 


--What are the minimum and max car prices
select * from Car
where Price =( 
select Min(Price)
from Car
)

select * from Car
where Price =( 
select Max(Price)
from Car
)

--List the first name and car make, model for all customer who purchased a car from Oakland
select 
a.FirstName,
b.Make,
b.Model,
b.StoreLocation
from Car b
join CarCustomer a
on a.Customer_ID=b.CustomerID
where StoreLocation = 'Oakland'






--Assignment 3

use sqltraining
/**
write the sql statement for creating a table named "Country_Data" contanining VoterId, name, DOB, Age, Height
Address, ContactNo, AnnualEarning whereby VoterId and Name are primary keys of a table named Population data and address
Contact_No are connected with a table named "Contact Data"
**/
Create table Country_Data_one(
Voter_ID_No int,
[Name] varchar(100),
Date_of_birth Date,
Age int,
Height Decimal (5,2),
Address varchar (100),
Contact_number bigint, 
Annual_Earnings Decimal (10,2),
Foreign Key (Voter_ID_No, Name) REFERENCES Population_Data_One(Voter_ID_No, Name),
Foreign Key (Address, Contact_number) REFERENCES Contact_data(Address, Contact_number)
)





Create table Instructor(
ID int,
[Name] varchar(50),
Faculty_Building varchar (50),
[Rank] varchar (20),
Salary bigint
)

insert into Instructor
values
(123, 'A', 'North Welson', 'High', 10000),
(234, 'B', 'South Jackson', 'Mid', 5000),
(345, 'C', 'North Watson', 'High', 12000)

select * from Instructor

/**
make a query statement to find out the names and salary of the instructors in a sequential manner of salary
who are high in rank and sit in a building named similar as jackson

Figured similar like jackson according to this table would mean ends with SON...Hence the LIKE '%son'
and the % indicates that any amount of words(multiple words) can be before 'Son' 
**/
Select 
Name,
Faculty_Building,
[Rank],
Salary
from Instructor
where [Rank]='High' and Faculty_Building like '%son'
order by Salary






Create table Population_Data(
ID int,
[Name] varchar (50),
[Location] varchar(50),
Contact_No bigint,
Age int,
Monthly_Income bigint
)

insert into Population_Data
values
(12, 'A', 'Mirpur', 123454, 34, 10000),
(13, 'B', 'Dhanmondi', 133255, 35, 20000),
(14, 'C', 'Mirpur', 123452, 31, 12000),
(15, 'D', 'Dhanmondi', 123425, 30, 15000)

select * from Population_Data


create table Country_Data(
ID int,
District varchar(50),
Age int
)

insert into Country_Data
values 
(12, 'Dhaka', 35),
(13, 'Dhaka', 36),
(14, 'Dhaka', 32),
(15, 'Dhaka', 30)

select * from Country_Data


/**
write a query to find out the IDs, number of names, number of locations, max age of those people
living in Murpur and Dhanmondi having a monthly salary more than 10000 and age ranges from 30-40 in desc manner of ID
**/

select 
a.ID,
COUNT (a.Name) as Number_Of_Names,
COUNT(a.Location) as Number_of_Locations,
MAX(a.Age) as Maxium_Age
from Population_Data a
join Country_Data b
on a.ID=b.ID
where a.Age between 30 and 40
and monthly_Income>10000
Group by a.ID
order by ID desc


select 
ID,
COUNT(Name) as Number_of_Name,
Count(Location) as Number_of_Location,
MAX(Age) as MaxAge
from Population_Data
where Age between 30 and 40
and Monthly_Income>10000
group by ID
order by ID desc

















--Assignment 4

create database Loans
go

use Loans

create table LoansAccounts(
AccNo int identity(1,1),
Cust_Name varchar(50),
Loan_Amount bigint, 
Installments int,
Int_Rate decimal(10,2),
[Start_Date] date
)

insert into LoansAccounts
values
('R.K. Gupta', 300000, 36, 12.00, '2009-07-19'),
('S.P. Sharma', 500000, 45, 10.00, '2008-03-22'),
('K.P. Jain', 300000, 36, Null, '2007-03-08'),
('M.P. Yadav', 800000, 60, 10.00, '2008-12-06'),
('S.P. Sinha', 200000, 36, 12.50, '2010-01-03'),
('P. Sharma', 700000, 60, 12.50, '2008-06-05'),
('K.S. Dhall', 500000, 48, Null, '2008-03-05')

--Display the details of all the loans
select * from LoansAccounts

--Display the AccNo, Cust_name and Loan_amount of all the Loans
select 
AccNo,
Cust_Name,
Loan_Amount
from LoansAccounts

--Display the details of all the loans with less than 40 installments
Select * from LoansAccounts
where Installments<40

--Display the AccNo and Loan amounts of loans before 2009-04-01
Select 
AccNo,
Loan_Amount,
[Start_Date]
from LoansAccounts
where Start_Date< '2009-04-01'


--Display the int_rate of all the loans started after 2009-04-01
select 
Loan_Amount,
Int_Rate,
[Start_Date]
from LoansAccounts
where Start_Date>'2009-04-01'

--Display the details of all loans whose interest rate is null
Select * from LoansAccounts
where Int_Rate is null

--Display the details of all loans whose interest rate is not null
Select * from LoansAccounts
where Int_Rate is not null


--Display the distinctamounts of various loans from the table. Loan amount should appear only once
select distinct Loan_Amount as Distinct_LoanAmount
from LoansAccounts


--Display the number of installments of various loans. Installment should appear only once 
select distinct count(Installments) as Distinct_NumberOfInstallments
from LoansAccounts