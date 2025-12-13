-- =============================================
-- Author:		Israel Oduwale
-- Create date: 12-12-2025
-- Description:	This code is to create and run analysis on the tables in NetflixBusiness Project
-- Revise Date: 12-12-2025
-- Version:		v2.0
-- =============================================




use emade_dev

select * from Netflix


-- 1. Count the number of Movies vs TV Shows

select 
type,
count (*) as Number_of_Content
from Netflix
group by type


-- 2. Find the most common rating for movies and TV shows
SELECT type, rating, Rating_Count
FROM (
    SELECT 
        type,
        rating,
        COUNT(*) AS Rating_Count,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rnk
    FROM Netflix
    GROUP BY type, rating
)x
WHERE rnk = 1;


-- 3. List all movies released in a specific year 2020
select * from Netflix
where release_year=2020

-- 4. Find the top 5 countries with the most content on NetflixBusiness
Select top 5
country,
count(*) as Content_count
from Netflix
where country is not null
group by country
order by Content_count desc

-- 5. Identify the longest movie
SELECT * FROM Netflix
WHERE type = 'Movie'
  AND duration = (
        SELECT MAX(duration)
        FROM Netflix
        WHERE type = 'Movie'
  )


--SK code 
-- use parsename to normalize date or use charindex SELECT PARSENAME(REPLACE(duration, ' ', 1),1) as duration_normalized, --normalizing the duration fielddurationFROM NetflixWHERE type = 'Movie'order by PARSENAME(REPLACE(duration, ' ', 1),1) desc --normalizing the duration field

-- 6. Find content that was added in the last 5 years
select * from netflix
WHERE date_added >= DATEADD(YEAR, -5, GETDATE());

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'
select * from netflix
where director = 'Rajiv Chilaka'

-- 8. List all TV shows with more than 5 seasons
select * from netflix
where type = 'TV Show' and Duration > '5 seasons'
order by duration desc

--sk code
SELECT *FROM NetflixWHERE TYPE = 'TV Show'--AND PARSENAME(REPLACE(duration, ' ', 1),1)>5AND LEFT(duration, 1)>5;


-- 9. Count the number of content items in each genre
SELECT 
TRIM(value) AS Genre,
COUNT(*) AS Content_Items
FROM Netflix
CROSS APPLY STRING_SPLIT(listed_in, ',')
GROUP BY TRIM(value)
ORDER BY Content_Items DESC;

--sk code
SELECT 	PARSENAME(REPLACE(listed_in, ',', '.'), 1) as genre,	COUNT(*) as total_contentFROM NetflixGROUP BY listed_in;


-- 10. Find each year and the average numbers of content release by India on NetflixBusiness. Return top 5 year with highest avg content release!
select top 5
release_year,
avg(contents) as Average_Contents,
country
from (
	select 
	release_year,
	type,
	country,
	count(*) as Contents
	from netflix
	where country='India'
	group by 
	release_year,
	type,
	country
)x
group by release_year, country
order by Average_Contents desc

-- 11. List all movies that are documentaries
select * from netflix
where listed_in like '%Documentaries%'

-- 12. Find all content without a directors
select * from netflix
where director is null


select distinct country from netflix



-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select
'Salman Khan' as Actor,
SUM(Movie_Appearances) as Movie_Appearances
from(
	Select
	cast,
	release_year,
	count(*) as Movie_Appearances
	from netflix
	where cast like '%Salman Khan%'
	and type = 'Movie'
	and release_year >= YEAR(GETDATE()) - 10
	group by cast, release_year
)x

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT top 10 
TRIM(value) AS Actor,
COUNT(*) AS Movie_Appearances
FROM Netflix
CROSS APPLY STRING_SPLIT(cast, ',')
WHERE type = 'Movie'
AND country = 'India'
AND cast IS NOT NULL
GROUP BY TRIM(value)
ORDER BY Movie_Appearances DESC;

-- 15: Categorize the content based on the presence of the keywords 'kill'and 'violence' in the description field.
--Label content containing these keywords as 'Bad'and all other content as 'Good'.
--Count how many items fall into each category.
select 
type,
Content_Category,
Count(*) as Appearance
from (
	select 
	type,
	title,
	description,
	CASE
	when description like '%Kill%' or description like '%violence%' then 'Bad'
	else 'Good'
	end as Content_Category
	from Netflix
)x
group by Content_category, type

--sk code
SELECT     category,	TYPE,    COUNT(*) AS content_countFROM (    SELECT 		*,        CASE             WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'            ELSE 'Good'        END AS category    FROM Netflix) AS categorized_contentGROUP BY category,TYPEORDER BY TYPE;-- POWERBI QUERIES--because some columns exists where there were multiple values in the rows--so i use trim to include the rows that have multiple values--distinct country count SELECT distinct
TRIM(value) AS Country
FROM Netflix
CROSS APPLY STRING_SPLIT(country, ',')
WHERE TRIM(value) <> ''
order by Country  


--distinct director count SELECT distinct
TRIM(value) AS director
FROM Netflix
CROSS APPLY STRING_SPLIT(director, ',')
WHERE TRIM(value) <> '' 
order by director  

--distinct Category count SELECT distinct
TRIM(value) AS Category
FROM Netflix
CROSS APPLY STRING_SPLIT(listed_in, ',')
WHERE TRIM(value) <> ''
order by Category  

--avg movie duration
select * from Netflix

SELECT AVG(CAST(REPLACE(duration, ' min', '') AS DECIMAL(10,2))) AS avg_duration
FROM Netflix
WHERE type = 'Movie'
  AND duration LIKE '%min'


-- actor movie appearances
SELECT distinct
TRIM(value) AS Actor,
COUNT(*) AS Movie_Appearances
FROM Netflix
CROSS APPLY STRING_SPLIT(cast, ',')
WHERE cast IS NOT NULL
GROUP BY TRIM(value)
ORDER BY Movie_Appearances DESC;

--country productions
SELECT 
TRIM(value) AS Country,
COUNT(*) AS country_prod
FROM Netflix
CROSS APPLY STRING_SPLIT(country, ',')
WHERE country IS NOT NULL
GROUP BY TRIM(value)
ORDER BY country_prod DESC;


-- count of added by year of dateadded
SELECT YEAR(date_added) AS YearAdded ,  count(*) FROM Netflix
group by year(date_added)
ORDER BY YearAdded;


-- category and count
SELECT 
TRIM(value) AS Category,
COUNT(*) AS Category_Count
FROM Netflix
CROSS APPLY STRING_SPLIT(listed_in, ',')
WHERE listed_in IS NOT NULL
GROUP BY TRIM(value)
ORDER BY Category_Count DESC;


select type, count (*) from Netflix
where country = 'India' 
group by type

select * from Netflix
where country = 'India' 

--for