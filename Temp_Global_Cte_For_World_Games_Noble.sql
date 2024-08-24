-- =============================================
-- Author:		Israel Oduwale
-- Create date: 08-24-2024
-- Description:	This code is to create Temp and Global tables,
--				As well as create CTE for World, Games and Noble.
-- Revise Date: 08-24-2024 
-- Version:		v1.0
-- =============================================




use SQLTraining

--FOR WORLD TABLE
--Create Temp Table for World table
SELECT TOP (1000) [Country_Name]
      ,[Continent]
      ,[Area]
      ,[Population]
      ,[GDP]
	into #World
  FROM [SQLTraining].[dbo].[World]

select * from #World

--Create Global Table for World table
SELECT TOP (1000) [Country_Name]
      ,[Continent]
      ,[Area]
      ,[Population]
      ,[GDP]
	into ##World
  FROM [SQLTraining].[dbo].[World]

select * from ##World;

--Create CTE for World table
with WorldCTE as
	(
	SELECT TOP (1000) [Country_Name]
      ,[Continent]
      ,[Area]
      ,[Population]
      ,[GDP]
	FROM [SQLTraining].[dbo].[World]
	)
select * from WorldCTE






--FOR NOBLE TABLE
--Create Temp Table for Noble table
SELECT TOP (1000) [Year]
      ,[Subject]
      ,[Winner]
	  into #Noble
  FROM [SQLTraining].[dbo].[Noble]

select * from #Noble;

--Create Global Table for Noble table
SELECT TOP (1000) [Year]
      ,[Subject]
      ,[Winner]
	  into ##Noble
  FROM [SQLTraining].[dbo].[Noble]

select * from ##Noble;

--Create CTE for Noble table
with NobleCte as
	(
	SELECT 
		[Year],
		[Subject],
		Winner
	FROM Noble
	)
select * from NobleCte







--FOR GAMES TABLE
--Create Temp Table for Games table
SELECT TOP (1000) [Year]
      ,[City]
	  into #Games
  FROM [SQLTraining].[dbo].[Games]


select * from #Games;

--Create Global Table for World table
SELECT TOP (1000) [Year]
      ,[City]
	  into ##Games
  FROM [SQLTraining].[dbo].[Games]


select * from ##Games;

--Create CTE for World table
with GamesCTE as
	(
	SELECT TOP (1000) [Year]
      ,[City]
  FROM [SQLTraining].[dbo].[Games]
	)
select * from GamesCTE