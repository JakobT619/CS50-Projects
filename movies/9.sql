SELECT name
FROM (
    SELECT DISTINCT people.id, people.name, people.birth
    FROM people
    JOIN stars ON people.id = stars.person_id
    JOIN movies ON stars.movie_id = movies.id
    WHERE movies.year = 2004
) AS subquery
ORDER BY birth;

-- I had to use a subquery to also check people's id, otherwise different actors
-- the same name were not being counted as different people. This subquery ensures
-- that each distinct people.id is being checked as well as people.name. It also
-- includes the birth column in the subquery so that we can use birth in the outer
-- query to ORDER BY birth year. It wouldn't let me ORDER BY birth unless people.birth
-- was SELECTed in the subquery. 
