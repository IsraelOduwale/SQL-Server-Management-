USE emade_dev


CREATE TABLE InterviewNames (
    [Customer ID] varchar(50),
    [name] varchar(50)
)

SELECT * FROM InterviewNames

CREATE TABLE InterviewMedicalExaminations (
    [Customer ID] varchar(50),
    [BMI] varchar(50),
    [HBA1C] varchar(50),
    [Heart Issues] varchar(50),
    [Any Transplants] varchar(50),
    [Cancer history] varchar(50),
    [NumberOfMajorSurgeries] varchar(50),
    [smoker] varchar(50)
)

select * from InterviewMedicalExaminations

CREATE TABLE InterviewHospitalizationDetails (
    [Customer ID] varchar(50),
    [year] varchar(50),
    [month] varchar(50),
    [date] varchar(50),
    [children] varchar(50),
    [charges] varchar(50),
    [Hospital tier] varchar(50),
    [City tier] varchar(50),
    [State ID] varchar(50)
)

select * from InterviewHospitalizationDetails



--Patients with heart problems, avg age of dependent children, avg bmi and avg hospitalization cost

WITH HeartProblemsPatients AS (
    SELECT 
        a.[Customer ID],
        c.children,
        b.BMI,
        c.charges
    FROM InterviewNames a
    JOIN InterviewMedicalExaminations b
        ON a.[Customer ID] = b.[Customer ID]
    JOIN InterviewHospitalizationDetails c
        ON a.[Customer ID] = c.[Customer ID]
    WHERE b.[Heart Issues] = 'Yes'
)
SELECT 
	'Heart Issues' as Condition,
    CAST(ROUND(AVG(CONVERT(DECIMAL(18,2), ISNULL(children, 0))), 2) AS DECIMAL(10,2)) AS Avg_DependentChildren,
    CAST(ROUND(AVG(CONVERT(DECIMAL(18,2), ISNULL(bmi, 0))), 2) AS DECIMAL(10,2)) AS Avg_BMI,
    CAST(ROUND(AVG(CONVERT(DECIMAL(18,2), ISNULL(charges, 0))), 2) AS DECIMAL(10,2)) AS Avg_Hospitalisation_Cost,
	COUNT(*) AS Total_Patients
FROM HeartProblemsPatients



--Find the average hospitalization cost for each hospital tier and each city level.
--BY CITY TIER
SELECT 
    [City Tier],
    CAST(ROUND(AVG(CONVERT(DECIMAL(18,2), ISNULL(charges, 0))), 2) AS DECIMAL(10,2)) AS Avg_Hospitalisation_Cost
FROM InterviewHospitalizationDetails
GROUP BY [City Tier]
order by [City tier];

--BY HOSPITAL TIER
SELECT 
    [Hospital Tier],
    CAST(ROUND(AVG(CONVERT(DECIMAL(18,2), ISNULL(charges, 0))), 2) AS DECIMAL(10,2)) AS Avg_Hospitalisation_Cost
FROM InterviewHospitalizationDetails
GROUP BY [Hospital Tier]
ORDER BY [Hospital tier];


--Determine the number of people who have had major surgery with a history of cancer.
SELECT 
COUNT (*) AS 'CANCER AND MAJOR SURGERY PATIENTS'
FROM InterviewMedicalExaminations 
WHERE [Cancer history] = 'Yes' AND NumberOfMajorSurgeries>= 1

--Determine the number of tier-1 hospitals in each state
SELECT 
[Hospital tier],
[State ID],
COUNT([HOSPITAL TIER]) as HOSPITAL_TIER
FROM InterviewHospitalizationDetails
WHERE [Hospital tier]='tier - 1'
GROUP BY 
[Hospital tier],
[State ID]


select distinct [State id] from InterviewHospitalizationDetails

select distinct [Any Transplants] from InterviewMedicalExaminations

select count([Any Transplants]) from InterviewMedicalExaminations
where [Any Transplants]='yes' and [Heart Issues]='yes'


select [Heart Issues], [Any Transplants] from InterviewMedicalExaminations

SELECT 
    SUM(
        CASE 
            WHEN NumberOfMajorSurgeries = 'No major surgery' THEN 0
            ELSE CAST(NumberOfMajorSurgeries AS INT)
        END
    ) AS TotalSurgeries
FROM InterviewMedicalExaminations;

select distinct year from InterviewHospitalizationDetails

select distinct children from InterviewHospitalizationDetails