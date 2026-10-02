-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows
SELECT types,
COUNT (*) as total_content
FROM netflix
GROUP BY types;

-- 2. Find the most common rating for movies and TV shows

SELECT types, rating
FROM (
    SELECT 
        types,
        rating,
        COUNT(*) AS total,
        RANK() OVER (
            PARTITION BY types 
            ORDER BY COUNT(*) DESC
        ) AS ranking
    FROM netflix
    GROUP BY types, rating
) AS T1
WHERE ranking = 1;


-- 3. List all movies released in a specific year

SELECT * FROM netflix 
   WHERE 
     types = 'Movie'
   AND 
     release_year = 2021;

-- 4. Find the top 6 countries with the most content on Netflix

SELECT 
         UNNEST(STRING_TO_ARRAY(country , ',')) as total_country,
		 COUNT (show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 6;


-- 5. Identify the longest movie

SELECT * FROM netflix
WHERE 
    types = 'Movie'
	AND
	duration = (SELECT MAX (duration) FROM netflix);
	
-- 6. Find content added in the last 6 years

SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY')
      >= CURRENT_DATE - INTERVAL '6 years';

-- 7. Find all the movies/TV shows by director 'Kirsten Johnson'!
SELECT * FROM netflix
     WHERE director = 'Kirsten Johnson';
	
-- 8. List all TV shows with more than 5 seasons

SELECT *,
       CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) AS seasons
FROM netflix
WHERE types = 'TV Show'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 5;
		   
-- 9. Count the number of content items in each genre

SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1;

-- 10.Find each year and the average numbers of content release in Pakistan on netflix.return top 5 year with highest avg content release!

SELECT  
     EXTRACT(YEAR FROM TO_DATE (date_added , 'Month DD , YYYY')) AS year,
	 COUNT(*) 
FROM netflix 
WHERE
   country = 'Pakistan'
GROUP BY 1;
   
-- 11. List all movies that are documentaries

SELECT *
FROM netflix
     WHERE types = 'Movie'
     AND 
	 listed_in LIKE '%Documentaries%';


   
-- 12. Find all content without a director

SELECT * FROM netflix
    WHERE 
	 director IS NULL;
	 
--13. Find how many movies actor 'Liam Mitchell' appeared in last 10 years!

SELECT * FROM netflix
    WHERE
	 casts ILIKE '%Liam Mitchell%'
	 AND
	 release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
 

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in Pakistan.

SELECT
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS cast_number,
	COUNT(*) AS total_content

FROM netflix
	
  WHERE 
  country = 'Pakistan' AND types = 'Movie'

GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

WITH checking AS(
SELECT * ,
   CASE WHEN
    description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'VIOLATING'
	ELSE 'BETTTER'
	END category
FROM netflix)

SELECT category , COUNT (*) AS total_count FROM checking
     GROUP BY 1;