-- This one didn't need to be aliased (AS clause) because the result of the
-- inner query is not being referenced outside of the inner query

SELECT name
FROM (
    SELECT DISTINCT people.id, people.name FROM people
    JOIN directors ON people.id = directors.person_id
    JOIN movies ON directors.movie_id = movies.id
    JOIN ratings ON movies.id = ratings.movie_id
    WHERE ratings.rating >= 9.0
);
