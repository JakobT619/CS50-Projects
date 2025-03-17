In 9.sql, write a SQL query to list the names of all people who starred in a movie released in 2004, ordered by birth year.
Your query should output a table with a single column for the name of each person.
People with the same birth year may be listed in any order.
No need to worry about people who have no birth year listed, so long as those who do have a birth year are listed in order.
If a person appeared in more than one movie in 2004, they should only appear in your results once.

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
