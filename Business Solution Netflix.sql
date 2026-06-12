create table netflix(
show_id	VARCHAR(6),
type	VARCHAR(10),
title	VARCHAR(150),
director	VARCHAR(208),
casts	VARCHAR(1000), 
country	VARCHAR(150),
date_added	VARCHAR(50),
release_year	INT,
rating	VARCHAR(10),
duration	VARCHAR(15),
listed_in	VARCHAR(100),
description VARCHAR(250)
); 

select * from netflix;

SELECT COUNT(*) AS total_content FROM netflix;

SELECT DISTINCT type FROM netflix;

-- 1. Count the number of Movies vs TV Shows

SELECT
 	type, COUNT(*) AS total_content
	FROM netflix
	GROUP BY type;


-- 2. Find the most common rating for movies and TV shows

SELECT
	type, rating
FROM
	(
	SELECT 
	type, rating, count(*), 
	RANK() over(PARTITION BY type ORDER BY count(*)DESC) AS ranking FROM netflix
	GROUP BY type, rating) as t1 
	WHERE ranking=1;

 
-- 3. List all movies released in a specific year (e.g., 2020)

SELECT 
	* 
	FROM netflix
	WHERE release_year= 2020 AND TYPE='Movie';


-- 4. Find the top 5 countries with the most content on Netflix 


SELECT 
	    TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) as new_country,
		  COUNT(show_id) as total_content
    FROM netflix
	GROUP BY new_country
	ORDER BY total_content DESC
	LIMIT 5
	;
    

-- 5. Identify the longest movie

SELECT * FROM netflix
	WHERE type ='Movie'
	AND 
	duration = (select max(duration) from netflix);


-- 6. Find content added in the last 5 years

SELECT *
	FROM netflix
	WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 YEAR';


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * FROM netflix
	WHERE director LIKE '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons

SELECT *
       FROM netflix
	WHERE type = 'TV Show'
	AND 
	SPLIT_PART(duration, ' ', 1):: numeric >5;

-- 9. Count the number of content items in each genre.
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genre, 
	COUNT(show_id) AS total_content
	FROM netflix
	GROUP BY genre;

-- 10.Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg content release!
SELECT 
 	EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) AS year,
	COUNT(*) AS yearly_content,
	ROUND(
	COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100
	, 2) AS Avg_per_year
	FROM netflix
	where country = 'India'
	GROUP BY 1


-- 11. List all movies that are documentaries

SELECT * FROM netflix
	WHERE listed_in ILIKE'%documentaries%'

-- 12. Find all content without a director

SELECT * FROM netflix
	WHERE director IS NULL
	
-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix
	WHERE 
	casts ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
	COUNT(*) AS total_content
	FROM netflix
	WHERE country ILIKE '%India%'
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 10;


  
