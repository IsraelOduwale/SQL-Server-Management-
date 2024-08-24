-- =============================================
-- Author:		Israel Oduwale
-- Create date: 03-14-2024
-- Description:	This code is to create database, use database and create tables,
--				To run other analysis on the tables
-- Revise Date: 08-24-2024 
-- Version:		v1.0
-- =============================================

create database hospital
go

use hospital

create table nurse
(
EmployeeID bigint not null,
[Name] varchar (50) not null,
Position varchar (50) not null,
Registered varchar (50) not null,
SSN bigint not null
);

insert into nurse
(
EmployeeID,
[Name],
Position,
Registered,
SSN
)
values
(101, 'Carla Espinosa', 'Head Nurse', 'True',111111110),
(102, 'Laverne Roberts', 'Nurse', 'True',222222220),
(103, 'Paul Flowers', 'Nurse', 'False',333333330);

select * from nurse
where Registered='False';

select [Name] as 'Name', Position as 'Position'
from nurse
where Position='Head Nurse';

select * from nurse






create table physician
(
EmployeeID int not null,
PhysicianName varchar (50) not null,
Position varchar (50) not null,
SSN bigint not null
);

insert into physician
values
(1, 'John Dorian', 'Staff Internist', 111111111),
(2, 'Elliot Reid', 'Attending Physician', 222222222),
(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333),
(4, 'Percival Cox', 'Senior Attending Physician', 444444444),
(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555),
(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666),
(7, 'John Wen', 'Surgical Attending Physician', 777777777),
(8, 'Keith Dudemeister', 'MD Resident', 888888888),
(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

select * from physician

create table department
(
DepartmentID int not null,
[Department Name] varchar (50) not null,
[Department Head] int not null
);

insert into department
values
(1, 'General Medicine', 4),
(2, 'Surgery', 7),
(3, 'Psychiatry', 9);

select [Department Name] as 'Department', PhysicianName as 'Physician'
from department
join physician ON [Department Head]=EmployeeID




create table appointment
(
AppointmentID bigint not null,
Patient bigint not null,
PrepNurse bigint null,
Physician int not null,
Start_dt_time datetime not null,
End_dt_time datetime not null,
[Examination Room] varchar (50) not null
);

insert into appointment
values
(13216584, 100000001, 101, 1, '2008-04-24 10:00:00', '2008-04-24 11:00:00','A'),
(26548913, 100000002, 101, 2, '2008-04-24 10:00:00', '2008-04-24 11:00:00','B'),
(36549879, 100000001, 102, 1, '2008-04-25 10:00:00', '2008-04-25 11:00:00','A'),
(46846589, 100000004, 103, 4, '2008-04-25 10:00:00', '2008-04-25 11:00:00','B'),
(59871321, 100000004, null, 4, '2008-04-26 10:00:00', '2008-04-26 11:00:00','C'),
(69879231, 100000003, 103, 2, '2008-04-26 11:00:00', '2008-04-26 12:00:00','C'),
(76983231, 100000001, null, 3, '2008-04-26 12:00:00', '2008-04-26 13:00:00','C'),
(86213939, 100000004, 102, 9, '2008-04-27 10:00:00', '2008-04-27 11:00:00','A'),
(93216548, 100000002, 101, 2, '2008-04-27 10:00:00', '2008-04-27 11:00:00','B');

select * from appointment


--Eliminating duplicates
--First method
select patient, count (*) as 'Number of patients taken atleast one appointment'
from appointment
group by Patient 

--Second Method
select patient, count (*) as 'Number of patients taken atleast two or more appointment'
from appointment
group by Patient
having count (*) >=2

--Third Method
select distinct Patient from appointment 

