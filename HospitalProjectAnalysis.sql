-- =============================================
-- Author:		Israel Oduwale
-- Create date: 10-03-2024
-- Description:	This code is to run further analysis on the records in the Hospital Project
-- Revise Date: 10-03-2024
-- Version:		v1.0
-- =============================================



use dev

select * from patients
--Lists out number of patients in descending order
--Does not include Quincy
--Must have at least 2 patients from that city

select distinct
city,
count(Id) as Patient_Count
from patients
where CITY not in ('Quincy')
group by
CITY
having COUNT(Id) >=2
order by
Patient_Count desc


--SK VERSION
SELECT DISTINCT 
	CITY, 
	COUNT(ID) AS P
FROM PATIENTS
WHERE CITY <> 'QUINCY'
GROUP BY CITY
HAVING COUNT(ID) > 1
ORDER BY CITY DESC


--2.To find out the Top 10 patients with the most visits to the hospital 
select TOP 10
a.SSN,
a.BIRTHDATE,
a.PREFIX,
a.FIRST,
coalesce([MIDDLE], 'N/A') as MIDDLE,
a.LAST,
a.Gender,
a.ADDRESS,
a.CITY,
a.STATE,
a.county,
COUNT(b.ENCOUNTERCLASS) as 'Visits'
from patients a
left join Encounters b
on a.id=b.PATIENT
group by 
a.SSN, a.BIRTHDATE, a.PREFIX, a.FIRST, a.MIDDLE, a.LAST, a.Gender, a.ADDRESS,
a.CITY, a.STATE, a.county
order by
Visits desc;


--SK VERSION USING CTE
WITH VISITS AS
		(
	SELECT  
		B.CITY,
		A.PATIENT,
		B.ID,
		COUNT(B.ID) AS NUMBEROFVISITS
	FROM ENCOUNTERS A
		JOIN PATIENTS B 
		ON A.PATIENT=B.ID
	GROUP BY 
		B.CITY,
		A.PATIENT,
		B.ID
		)
SELECT 
	TOP 10 *
FROM VISITS
ORDER BY NUMBEROFVISITS DESC;



--3.To find out the number of times patients from each city visited the hospital.
select distinct
a.CITY,
b.PATIENT,
a.ID,
COUNT(b.ENCOUNTERCLASS) as 'Visits'
from patients a
left join Encounters b
on a.id=b.PATIENT
group by 
a.CITY,
b.PATIENT,
a.ID
order by
Visits desc


--SK VERSION
SELECT DISTINCT
	B.CITY,
	A.PATIENT,
	B.ID,
	COUNT(B.ID) AS NUMBEROFVISITS
FROM ENCOUNTERS A
	JOIN PATIENTS B 
	ON A.PATIENT=B.ID
GROUP BY 
	B.CITY,
	A.PATIENT,
	B.ID
ORDER BY NUMBEROFVISITS DESC;




--4. To find out the cities with up to 50 counts of emergency cases.
select
a.CITY,
b.ENCOUNTERCLASS,
COUNT(b.ENCOUNTERCLASS) as 'Number of Emergency Cases'
from patients a
left join Encounters b
on a.id=b.PATIENT
where b.ENCOUNTERCLASS = 'Emergency'
group by 
a.CITY,
b.ENCOUNTERCLASS
having COUNT(b.ENCOUNTERCLASS) >= 5
order by
[Number of Emergency Cases] desc
--NOTE: NO city had up to 50 counts of emergency cases. Highest was 20 in medford



--SK VERSION
SELECT DISTINCT
	B.CITY,
	A.ENCOUNTERCLASS,
	COUNT(ENCOUNTERCLASS) AS COUNTSOFEMERGENCYCASES
FROM ENCOUNTERS A
	JOIN PATIENTS B 
	ON A.PATIENT=B.ID
WHERE ENCOUNTERCLASS = 'EMERGENCY'
GROUP BY 
B.CITY,
A.ENCOUNTERCLASS
HAVING COUNT(ENCOUNTERCLASS) >= 5
ORDER BY COUNTSOFEMERGENCYCASES DESC;




--5. Now to find out the number of patients from Boston who came in 2020.
--to show their info
select 
a.First,
coalesce([MIDDLE], 'N/A') as MIDDLE,
a.Last,
a.City
from patients a
left join Encounters b
on a.id=b.PATIENT
where a.CITY='Boston' and Year(b.START)=2020
group by
a.First,
a.MIDDLE,
a.Last,
a.city


--basically it is just 7 patients that came multiple times, and that is why i used distinct to know the exact number
--to show just the total number
select 
a.CITY,
COUNT(distinct b.PATIENT) as 'Number of Boston Patients in 2020'
from patients a
left join Encounters b
on a.id=b.PATIENT
where a.CITY='Boston' and Year(b.START)>= 2020 
group by
a.CITY

/**
select * from Encounters e, patients p
where p.Id = e.PATIENT
and p.CITY= 'Boston' and YEAR(e.START)= 2020
**/
--SK VERSION
SELECT 
	B.CITY,
	COUNT(A.PATIENT) AS NUMBEROFPATIENTS
FROM ENCOUNTERS A
	JOIN PATIENTS B 
	ON A.PATIENT=B.ID
WHERE B.CITY = 'BOSTON' 
	AND START LIKE '2020%'
GROUP BY 
B.CITY;



--6.To find out the top recurring conditions.
select top 5
a.DESCRIPTION,
count(*) as Recurring_Count
from Conditions a
left join patients b
on a.PATIENT=b.Id
group by
a.description
order by
Recurring_Count desc;



--SK VERSION
WITH RECCURRINGCONDITIONS AS
	(
	SELECT DISTINCT 
		A.DESCRIPTION,
		COUNT(*) AS NUMBEROFRECURRENCE
	FROM CONDITIONS A
		JOIN PATIENTS B 
		ON A.PATIENT=B.ID
	GROUP BY A.DESCRIPTION
	)
SELECT 
	TOP 5 DESCRIPTION,
	NUMBEROFRECURRENCE
FROM RECCURRINGCONDITIONS
ORDER BY NUMBEROFRECURRENCE DESC;




--7. To find out the month with the highest number of ambulatory cases since 2010.
select top 1
ENCOUNTERCLASS,
DATENAME(Month, START) as 'Month of Cases',
DATENAME(YEAR, START) as 'Year of Cases',
COUNT(ENCOUNTERCLASS) as 'Number of Cases'
from Encounters
where ENCOUNTERCLASS = 'Ambulatory' and YEAR(Start)>=2010
group by 
ENCOUNTERCLASS,
DATENAME(Month, START),
DATENAME(YEAR, START) 
order by 
[Number of Cases] desc;



--SK VERSION
SELECT 
	TOP 1 NUMBEROFAMBULATORYCASES,
	YEAR,
	MONTH
FROM
	(
	SELECT DISTINCT
		DATEPART(YEAR, A.START) AS YEAR,
		DATEPART(MONTH, A.START) AS MONTH,
		COUNT(A.ENCOUNTERCLASS) AS NUMBEROFAMBULATORYCASES
	FROM ENCOUNTERS A
		JOIN PATIENTS B 
		ON A.PATIENT=B.ID
	WHERE ENCOUNTERCLASS = 'AMBULATORY'
	GROUP BY 
		DATEPART(YEAR, A.START), 
		DATEPART(MONTH, A.START)
	HAVING DATEPART(YEAR, A.START) >= 2010
	) X
 ORDER BY NUMBEROFAMBULATORYCASES DESC




--8.To find out the month with the highest number of emergency cases since 2010.
select top 1
ENCOUNTERCLASS,
DATENAME(Month, START) as 'Month of Cases',
DATENAME(YEAR, START) as 'Year of Cases',
COUNT(ENCOUNTERCLASS) as 'Number of Cases'
from Encounters
where ENCOUNTERCLASS = 'Emergency' and YEAR(Start)>=2010
group by 
ENCOUNTERCLASS,
DATENAME(Month, START),
DATENAME(YEAR, START) 
order by 
[Number of Cases] desc 



--SK VERSION
SELECT 
	TOP 1 NUMBEROFEMERGENCYCASES,
	YEAR,
	MONTH
FROM
	(
	SELECT DISTINCT
		DATEPART(YEAR, A.START) AS YEAR,
		DATEPART(MONTH, A.START) AS MONTH,
		COUNT(A.ENCOUNTERCLASS) AS NUMBEROFEMERGENCYCASES
	FROM ENCOUNTERS A
		JOIN PATIENTS B 
		ON A.PATIENT=B.ID
	WHERE ENCOUNTERCLASS = 'EMERGENCY'
	GROUP BY 
		DATEPART(YEAR, A.START), 
		DATEPART(MONTH, A.START)
	HAVING DATEPART(YEAR, A.START) >= 2010
	) X
ORDER BY NUMBEROFEMERGENCYCASES DESC



--9. Now to find out the Top 15 years with the most immunizations.
SELECT top 15
YEAR([Date]) AS 'Immunization Year', 
COUNT(*) AS 'Total immunizations'
FROM immunizations
GROUP BY
YEAR([Date])
ORDER BY 
[Total immunizations] DESC



--SK VERSION
SELECT 
	TOP 15 NUMBEROFIMMUNIZATIONS,
	YEAR
FROM
	(
	SELECT DISTINCT
		DATEPART(YEAR, A.DATE) AS YEAR,
		COUNT(A.ENCOUNTER) AS NUMBEROFIMMUNIZATIONS
	FROM IMMUNIZATIONS A
		JOIN PATIENTS B 
		ON A.PATIENT=B.ID
	GROUP BY 
		DATEPART(YEAR, A.DATE) )X
ORDER BY NUMBEROFIMMUNIZATIONS DESC;