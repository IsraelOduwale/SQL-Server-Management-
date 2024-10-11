-- =============================================
-- Author:		Israel Oduwale
-- Create date: 10-09-2024
-- Description:	This code is to create the emade consulting TABLES
--				To run further analysis on the records in the TABLES
-- Revise Date: 10-09-2024
-- Version:		v1.0
-- =============================================




use Dev


CREATE TABLE EmadeconsultingLOCATION
(
LOCATION_ID INT not null,
CITY VARCHAR (20) null,
)

INSERT INTO EmadeconsultingLOCATION
VALUES
(122, 'NEW YORK'),
(123, 'DALLAS'), 
(124, 'CHICAGO'), 
(167, 'BOSTON')

SELECT * FROM EmadeconsultingLOCATION



CREATE TABLE EmadeconsultingDEPARTMENT
(
DEPARTMENT_ID INT not null,
NAME VARCHAR(20) null,
LOCATION_ID INT not null
)

INSERT INTO EmadeconsultingDEPARTMENT
VALUES
(10, 'ACCOUNTING', 122),
(20, 'SALES', 124),
(30, 'RESEARCH', 123),
(40, 'OPERATIONS', 167)

SELECT * FROM EmadeconsultingDEPARTMENT


CREATE TABLE EmadeconsultingJOB
(
JOB_ID INT not null, 
DESIGNATION VARCHAR (20) null
)

INSERT INTO EmadeconsultingJOB 
VALUES
(667, 'Clerk'),
(668, 'Staff'),
(669, 'Analyst'),
(670, 'Sales Person'),
(671, 'Manager'),
(672, 'President')

SELECT * FROM EmadeconsultingJOB



CREATE TABLE EmadeconsultingEMPLOYEEnew
(
EMPLOYEE_ID INT not null,
Last_Name VARCHAR(20) null,
First_Name VARCHAR(20) null,
Middle_Name VARCHAR(20) null,
Job_ID INT not null,
Manager_ID INT not null, 
Hire_Date DATE null,
Salary Money null,
Comm INT null,
Department_ID INT not null
)

INSERT INTO EmadeconsultingEMPLOYEEnew
VALUES
(7369, 'SMITH', 'JOHN', 'Q', 667, 7902, '17-DEC-84', 800, NULL, 20),
(7499, 'ALLEN', 'KEVIN', 'J', 670, 7698, '20-FEB-85', 1600, 300, 30),
(7505, 'DOYLE', 'JEAN', 'K', 671, 7839, '04-APR-85', 2850, NULL, 30),
(7506, 'DENNIS', 'LYNN', 'S', 671, 7839, '15-MAY-85', 2750, NULL, 30),
(7507, 'BAKER', 'LESLIE', 'D', 671, 7839, '10-JUN-85', 2200, NULL, 40),
(7521, 'WARK', 'CYNTHIA', 'D', 670, 7698, '22-FEB-85', 1250, 500, 30)


SELECT * FROM EmadeconsultingLOCATION
SELECT * FROM EmadeconsultingDEPARTMENT
SELECT * FROM EmadeconsultingJOB
SELECT * FROM EmadeconsultingEMPLOYEEnew

--QUESTION 1- DISPLAY THE EMPLOYEE DETAILS WITH SALARY GRADES 
SELECT
A.EMPLOYEE_ID,
A.LAST_NAME,
A.First_Name,
A.Middle_Name,
A.JOB_ID,
B.DESIGNATION,
A.Salary,
CASE
WHEN Salary<1500 THEN 'D'
WHEN Salary<2000 THEN 'C'
WHEN Salary<2500 THEN 'B'
WHEN Salary>2500 THEN 'A'
ELSE 'UNKNOWN'
END AS SALARY_GRADE
FROM EmadeconsultingEMPLOYEEnew A
LEFT JOIN EmadeconsultingJOB B
ON A.Job_ID=B.JOB_ID
ORDER BY
A.Salary DESC;


--QUESTION 2 - LIST OUT ALL THE JOBS IN SALES AND ACCOUNTING DEPARTMENTS
SELECT 
A.JOB_ID,
B.DESIGNATION,
A.SALARY
FROM EmadeconsultingEMPLOYEEnew A
JOIN EmadeconsultingJOB B
ON A.JOB_ID = B.Job_ID
JOIN EmadeconsultingDEPARTMENT C 
ON A.Department_ID = C.DEPARTMENT_ID
WHERE C.NAME IN ('SALES', 'ACCOUNTING');


--QUESTION 3 - DISPLAY THE EMPLOYEES LIST WITH highest SALARY 
SELECT
A.EMPLOYEE_ID,
A.LAST_NAME,
A.First_Name,
A.Middle_Name,
A.JOB_ID,
B.DESIGNATION,
A.Salary
FROM EmadeconsultingEMPLOYEEnew A
JOIN EmadeconsultingJOB B
ON A.Job_ID=B.JOB_ID
WHERE A.SALARY=(
SELECT MAX(SALARY)
FROM EmadeconsultingEMPLOYEEnew
);


--QUESTION 4 - DISPLAY EMPLOYEES WHO ARE WORKING IN SALES DEPARTMENT 
SELECT
A.EMPLOYEE_ID,
A.LAST_NAME,
A.First_Name,
A.Middle_Name,
A.JOB_ID,
B.DESIGNATION,
A.Salary,
A.Department_ID,
C.NAME
FROM EmadeconsultingEMPLOYEEnew A
JOIN EmadeconsultingJOB B
ON A.Job_ID=B.JOB_ID
JOIN EmadeconsultingDEPARTMENT C 
ON A.Department_ID = C.DEPARTMENT_ID
WHERE C.NAME='SALES';


--QUESTION 5 - FIND OUT THE NO. OF EMPLOYEES WORKING IN SALES DEPARTMENT 
SELECT
COUNT(*) AS 'EMPLOYEE COUNT'
FROM EmadeconsultingEMPLOYEEnew A
JOIN EmadeconsultingDEPARTMENT C 
ON A.Department_ID = C.DEPARTMENT_ID
WHERE C.NAME='SALES';


--QUESTION 6 - DISPLAY THE SECOND HIGHEST SALARY DRAWING EMPLOYEE DETAILS

SELECT *
FROM EmadeconsultingEMPLOYEEnew
WHERE Salary = (
    SELECT MAX(Salary)
    FROM EmadeconsultingEMPLOYEEnew
    WHERE Salary < (
		SELECT MAX(Salary) 
		FROM EmadeconsultingEMPLOYEEnew)
);


--QUESTION 7 - LIST OUT EMPLOYEES WHO EARN MORE THAN EVERY EMPLOYEE IN DEPARTMENT 30
SELECT *
FROM EmadeconsultingEMPLOYEEnew
WHERE Salary=(
select MAX(Salary)
FROM EmadeconsultingEMPLOYEEnew
where Department_ID=30
);

/**
SELECT *
FROM EmadeconsultingEMPLOYEEnew
WHERE Salary = (
    SELECT Salary
    FROM EmadeconsultingEMPLOYEEnew
    WHERE Salary > (
		SELECT MAX(Salary) 
		FROM EmadeconsultingEMPLOYEEnew
		where Department_ID=30
	)
)
**/


--QUESTION 8 - FIND OUT THE EMPLOYEES WHO EARN GREATER THAN THE AVERAGE SALARY FOR THEIR DEPARTMENT
SELECT *
FROM EmadeconsultingEMPLOYEEnew a
WHERE Salary > (
    SELECT AVG(Salary)
    FROM EmadeconsultingEMPLOYEEnew
    WHERE Department_ID = a.Department_ID
);
