 -- =============================================
-- Author:		Israel Oduwale
-- Create date: 05-10-2024
-- Description:	This code is to create database
--				Create multiple tables and insert values
--				Do more analysis on the tables created, including Joins.
-- Revise Date: 08-19-2024 
-- Version:		v1.0
-- =============================================

create database SQLInterview
go

use SQLInterview

create table PRSN
(
PRSN_IK int not null,
[NAME] varchar (50) null,
AGE int null,
MRN_NB bigint null
)

insert into PRSN
values
(1, 'Bob', 35, 111),
(2, 'John', 25, 222),
(3, 'Mary', 21, 333),
(4, 'Bill', 28, 444),
(5, 'Jack', 15, null),
(6, 'Jake', 15, 666),
(7, 'Anne', 25, 777)

select * from prsn

create table PRSN_PHN
(
PRSN_IK int not null,
LNE_NB int null,
USG_TYP varchar (50) null,
PHONE_NBR varchar (50) null
)

insert into PRSN_PHN
values
(1, 1, 'HOME', '915-111-2222'),
(2, 1, 'HOME', '415-222-3333'),
(2, 2, 'WORK', '510-333-4444'),
(4, 1, 'WORK', '650-444-5555'),
(4, 2, NULL, '925-333-4444'),
(5, 1, 'HOME', '509-555-6666'),
(5, 2, NULL, '510-555-6666')

select * from PRSN_PHN


create table PRSN_ADDR
(
PRSN_IK int not null,
LNE_NB int null,
ADDR_TYP varchar (50) null,
ADDR varchar (50) null
)

insert into PRSN_ADDR
values
(1, 1, 'HOME', 'WALNUT CREEK'),
(1, 2, 'WORK', 'SAN FRANCISCO'),
(2, 1, 'HOME', 'OAKLAND'),
(3, 1, 'WORK', 'DUBLIN'),
(3, 2, NULL, 'SAN JOSE')

SELECT * FROM PRSN_ADDR
select * from PRSN_PHN
select * from PRSN_ADDR

SELECT distinct a.*, b.*, c.* FROM PRSN_ADDR a,
PRSN_PHN b,
PRSN c
where a.PRSN_IK = b.PRSN_IK and c.PRSN_IK = a.PRSN_IK
--QUESTION 1:
/**
query that returns all rows from prsn table with its corresponding phone number,
if address or phone number is not available, display n/a, display a comment depending on whether 
they have an address, a phone number or both
**/

/**
coalesce is used to return the first non-null expression in a list of expressions
it handles cases where the phone number or address is null. if the columns contain null
values then it returns 'N/A'
isnull - same as coalesce
**/

Select
p.PRSN_IK,
p.NAME,
p.MRN_NB,
pa.ADDR_TYP as 'TYPE',
COALESCE(pp.PHONE_NBR, 'N/A') as PHONE_NUMBER,
COALESCE(pa.ADDR, 'N/A') as 'ADDR',
case
when pp.PHONE_NBR is not null and pa.ADDR is not null then 'Member has both'
when pp.PHONE_NBR is not null then 'Member has Phone only'
when pa.ADDR is not null then 'Member has Addr only'
else 'Member has none'
end as COMMENT_TX
from PRSN p
left join PRSN_PHN pp 
on p.PRSN_IK = pp.PRSN_IK 
left join PRSN_ADDR pa
on p.PRSN_IK = pa.PRSN_IK


--another way without coalesce
Select
p.PRSN_IK,
p.NAME,
p.MRN_NB,
pp.USG_TYP as 'TYPE',
case
when pp.PHONE_NBR is null then 'N/A' 
else pp.PHONE_NBR 
end as PHONE_NUMBER,
case
when pa.ADDR is null then 'N/A' 
else pa.ADDR 
end as ADDRESS,
case
when pp.PHONE_NBR is not null and pa.ADDR is not null then 'Member has both'
when pp.PHONE_NBR is null and pa.ADDR is not null then 'Member has Address only'
when pp.PHONE_NBR is not null and pa.ADDR is null then 'Member has phone number only'
else 'Member has none'
end as COMMENT_TX
from PRSN p
left join PRSN_PHN pp 
on p.PRSN_IK = pp.PRSN_IK 
left join PRSN_ADDR pa
on p.PRSN_IK = pa.PRSN_IK











select Type
from
(
select
pa.addr_typ as Type
from PRSN_ADDR pa
left join PRSN_PHN pp
on pa.ADDR_TYP = pp.USG_TYP 
)x


--QUESTION 2:
--return the phone number and address of the oldest person from the prsn table
select 
p.NAME as NAME,
pa.ADDR as 'ADDRESS',
pp.PHONE_NBR as Phone_Number
from
PRSN p
left join PRSN_ADDR pa
on p.PRSN_IK = pa.PRSN_IK
left join PRSN_PHN pp
on p.PRSN_IK = pp.PRSN_IK
WHERE
p.AGE = (select max(AGE) from PRSN)



--QUESTION 3:
--phone number of the third youngest person(s) from the prsn table (use analytic function if possible)
select *
from 
(
		select 
		p.Name,
		pp.PHONE_NBR,
		pp.USG_TYP,
		p.AGE,
		dense_rank () over (Order by p.AGE) as 'DRNK' 
		from PRSN p
		left join PRSN_PHN pp
		on p.PRSN_IK = pp.PRSN_IK
)x 
where DRNK = 3



--QUESTION 4:
--query that will return all person that has multiple addr or multiple phone number
--using group by and count
select 
p.PRSN_IK,
p.NAME,
p.AGE,
p.MRN_NB
from
PRSN p
left join PRSN_ADDR pa
on p.PRSN_IK = pa.PRSN_IK
left join PRSN_PHN pp
on p.PRSN_IK = pp.PRSN_IK
Group by
p.PRSN_IK, p.NAME,p.AGE, p.MRN_NB
Having 
count (pa.ADDR) >1 or count(pp.PHONE_NBR) >1;



--another way...you can use group by like this or use distinct 
select 
p.PRSN_IK,
p.NAME,
p.AGE,
p.MRN_NB
from
PRSN p
left join PRSN_ADDR pa
on p.PRSN_IK = pa.PRSN_IK
left join PRSN_PHN pp
on p.PRSN_IK = pp.PRSN_IK
where ADDR is not null or PHONE_NBR is not null
group by
p.PRSN_IK,
p.NAME,
p.AGE,
p.MRN_NB



--third way distinct 
select distinct
p.PRSN_IK,
p.NAME,
p.AGE,
p.MRN_NB
from
PRSN p
left join PRSN_ADDR pa
on p.PRSN_IK = pa.PRSN_IK
left join PRSN_PHN pp
on p.PRSN_IK = pp.PRSN_IK
where ADDR is not null or PHONE_NBR is not null



--fourth way subquery
select 
PRSN_IK,
NAME,
AGE
MRN_NB
from
(
select 
p.PRSN_IK,
p.NAME,
p.AGE,
p.MRN_NB,
count (pp.PHONE_NBR) as PHONE_NBR_total,
count (pa.ADDR) as ADDR_total
from
PRSN p
left join PRSN_ADDR pa
on p.PRSN_IK = pa.PRSN_IK
left join PRSN_PHN pp
on p.PRSN_IK = pp.PRSN_IK
group by
p.PRSN_IK,
p.NAME,
p.AGE,
p.MRN_NB
)x
where ADDR_total>=1 or PHONE_NBR_total>=1


