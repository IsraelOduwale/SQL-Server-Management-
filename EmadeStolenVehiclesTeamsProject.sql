use emade_dev

CREATE TABLE EmadeStolenVehiclesTeams(
    [ReportID] float,
    [DateStolen] datetime,
    [Make] nvarchar(255),
    [Model] nvarchar(255),
    [Year] float,
    [Color] nvarchar(255),
    [City] nvarchar(255),
    [Latitude] float,
    [Longitude] float,
    [Recovered] nvarchar(255),
    [RecoveryDate] datetime
)

select * from EmadeStolenVehiclesTeams


--1. Identify theft hotspots by city.
select 
city,
count(*) as Theft_Count
from EmadeStolenVehiclesTeams
group by city
order by Theft_Count


--2. Determine which vehicle makes and models are most frequently stolen.
select top 5
Make,
model,
count(*) as Theft_Count
from EmadeStolenVehiclesTeams
group by make, Model
order by Theft_Count desc

select 
Make,
model,
count(*) as Theft_Count
from EmadeStolenVehiclesTeams
group by make, Model
order by Theft_Count desc


-- 3. How many vehicles were stolen each year or month?
select
FORMAT(DateStolen, 'yyyy-MMMM') AS THEFT_MONTH,
count(*) as THEFT_COUNT
from EmadeStolenVehiclesTeams
group by 
FORMAT(DateStolen, 'yyyy-MMMM'), 
YEAR(DateStolen),
MONTH(DateStolen)
order by YEAR(DateStolen), MONTH(DateStolen)

--recovered
select
FORMAT(DateStolen, 'yyyy-MMMM') AS THEFT_MONTH,
count(*) as THEFT_COUNT
from EmadeStolenVehiclesTeams
where Recovered='Yes'
group by 
FORMAT(DateStolen, 'yyyy-MMMM'), 
YEAR(DateStolen),
MONTH(DateStolen)
order by YEAR(DateStolen), MONTH(DateStolen)



-- 4. Which cities have the highest theft rates?
select TOP 3
city,
count(*) as Theft_Count
from EmadeStolenVehiclesTeams
group by city
order by Theft_Count DESC


-- 5. What are the top 10 most stolen vehicle makes and models?
select TOP 10
Make,
model,
count(*) as Theft_Count
from EmadeStolenVehiclesTeams
group by make, Model
order by Theft_Count desc


-- 6. What percentage of vehicles are recovered?
SELECT
COUNT(*) AS RECOVERED_VEHICLES,
cast(
ROUND(100.00 * COUNT(*) / (SELECT COUNT(*) FROM EmadeStolenVehiclesTeams), 1
) as Decimal(10,2)) AS PERCENTAGE
FROM EmadeStolenVehiclesTeams
WHERE Recovered='Yes'


-- 7. How long does it take, on average, to recover a vehicle?
select * from EmadeStolenVehiclesTeams

SELECT 
    AVG(DATEDIFF(day, DateStolen, RecoveryDate)) AS Avg_Days_To_Recover
FROM EmadeStolenVehiclesTeams
WHERE RecoveryDate IS NOT NULL;



select distinct model from EmadeStolenVehiclesTeams;

WITH VehicleCounts AS (
    SELECT 
        City,
        make,
        COUNT(*) AS StolenCount,
        ROW_NUMBER() OVER ( PARTITION BY City ORDER BY COUNT(*) DESC) AS rn
    FROM EmadeStolenVehiclesTeams
    GROUP BY City, Make
)
SELECT 
    City,
    make AS MostStolenVehicle,
    StolenCount
FROM VehicleCounts
WHERE rn = 1
ORDER BY City;

select distinct city from EmadeStolenVehiclesTeams