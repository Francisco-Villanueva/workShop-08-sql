SELECT name FROM movies WHERE year = 1999;

SELECT COUNT(*) FROM movies WHERE year = 1982;

SELECT id, first_name, last_name, gender FROM actors WHERE last_name = 'stack';

SELECT * FROM actors WHERE last_name LIKE 'stack'; // conusltar

SELECT COUNT(*) as aliasDeCount FROM movies WHERE year = 1982 LIMIT 10;
 
SELECT 
first_name, 
COUNT(first_name) as counter
FROM actors
GROUP BY first_name 
ORDER BY counter DESC 
LIMIT 10; 

SELECT 
first_name, 
COUNT(first_name) as counter
FROM actors
ORDER BY counter DESC 
LIMIT 10; 

SELECT CONCAT(first_name, ' ', last_name) AS full_name, COUNT(*) AS total_count
FROM actors
GROUP BY full_name
ORDER BY total_count DESC
LIMIT 10;


SELECT 
first_name || ' ' || last_name AS full_name, 
COUNT(*) AS total_count
FROM actors
GROUP BY first_name || ' ' || last_name
ORDER BY total_count DESC
LIMIT 10;

SELECT 
first_name || ' ' || last_name as full_name, 
FROM actors
LIMIT 10;

SELECT first_name || ' ' || last_name AS full_name, COUNT(first_name || ' ' || last_name) as counter
FROM actors
GROUP BY full_name
ORDER BY counter DESC
LIMIT 10;

SELECT a.id, a.first_name, a.last_name, COUNT(r.role) AS total_roles
FROM actors a
LEFT JOIN roles r ON a.id = r.actor_id
GROUP BY a.id, a.first_name, a.last_name
ORDER BY total_roles DESC
LIMIT 100;

SELECT id, a.first_name, a.last_name, COUNT(r.role) AS total_roles
FROM actors a
LEFT JOIN roles r ON a.id = r.actor_id
GROUP BY a.id, a.first_name, a.last_name
ORDER BY total_roles DESC
LIMIT 100;


SELECT mg.genre, COUNT(m.id) AS total_movies
FROM movies_genres mg
JOIN movies m ON mg.movie_id = m.id
GROUP BY mg.genre
ORDER BY total_movies ;

--Braveheart
SELECT a.first_name, a.last_name
FROM actors a
JOIN roles r ON a.id = r.actor_id
JOIN movies m ON r.movie_id = m.id
WHERE m.name = 'Braveheart' AND m.year = 1995
ORDER BY a.last_name;

--Film noir
SELECT d.first_name || ' ' || d.last_name AS director_name, m.name AS movie_name, m.year
FROM directors d
JOIN movies_directors md ON d.id = md.director_id
JOIN movies m ON md.movie_id = m.id
JOIN movies_genres mg ON m.id = mg.movie_id
WHERE mg.genre = 'Film-Noir' AND m.year % 4 = 0
ORDER BY m.name;

--kevin bacon
SELECT a.first_name, a.last_name, m.name AS movie_name
FROM actors a
JOIN roles r ON a.id = r.actor_id
JOIN movies m ON r.movie_id = m.id
WHERE a.id IN (
  SELECT DISTINCT a2.id
  FROM actors a1
  JOIN roles r1 ON a1.id = r1.actor_id
  JOIN movies m1 ON r1.movie_id = m1.id
  JOIN movies_directors md ON m1.id = md.movie_id
  JOIN directors d ON md.director_id = d.id
  JOIN roles r2 ON d.id = r2.actor_id
  JOIN actors a2 ON r2.actor_id = a2.id
  WHERE a1.first_name = 'Kevin' AND a1.last_name = 'Bacon' AND m1.genre = 'Drama'
)
AND NOT (a.first_name = 'Kevin' AND a.last_name = 'Bacon')
ORDER BY a.last_name, a.first_name;

--kevin bacon  (PLEDU RESOLUCION)
SELECT m.name, a.first_name || " " || a.last_name AS full_name
  FROM actors AS a
  INNER JOIN roles AS r 
    ON r.actor_id = a.id
  INNER JOIN movies AS m 
    ON r.movie_id = m.id
  INNER JOIN movies_genres AS mg 
    ON mg.movie_id = m.id
    AND mg.genre = 'Drama'
  WHERE m.id IN (
    SELECT bacon_m.id
    FROM movies AS bacon_m
    INNER JOIN roles AS bacon_r 
      ON bacon_r.movie_id = bacon_m.id
    INNER JOIN actors AS bacon_a 
      ON bacon_r.actor_id = bacon_a.id
    WHERE bacon_a.first_name = 'Kevin'
      AND bacon_a.last_name = 'Bacon'
    )
    AND full_name != 'Kevin Bacon'
  ORDER BY m.name ASC



--Actores Inmortales
SELECT id, first_name, last_name
FROM actors
WHERE id IN (
  SELECT actor_id
  FROM roles
  WHERE movie_id IN (
    SELECT id
    FROM movies
    WHERE year < 1900
  )
)
INTERSECT
SELECT id, first_name, last_name
FROM actors
WHERE id IN (
  SELECT actor_id
  FROM roles
  WHERE movie_id IN (
    SELECT id
    FROM movies
    WHERE year > 2000
  )
)ORDER BY id;


--Ocupados en Filmación
SELECT a.first_name||' '|| a.last_name  AS full_name,m.year as  "Year", m.name as "Movie",r.role, COUNT(r.role) as roles_counter
FROM actors a
JOIN roles r ON a.id = r.actor_id
JOIN movies m ON r.movie_id = m.id 
WHERE m.year > 1990 
GROUP BY a.id, m.id
HAVING roles_counter >= 5
ORDER BY roles_counter DESC ;



