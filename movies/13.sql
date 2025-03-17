SELECT DISTINCT p2.name FROM people p1
JOIN stars s1 ON p1.id = s1.person_id
JOIN movies ON s1.movie_id = movies.id
JOIN stars s2 ON movies.id = s2.movie_id
JOIN people p2 ON s2.person_id = p2.id
WHERE p1.name = 'Kevin Bacon'
AND p1.birth = 1958
AND p2.name IS NOT 'Kevin Bacon';

-- This one was tougher to understand, but the JOIN clauses create a thread
-- that links Kevin Bacon to the movies he has starred in, the stars in those movies,
-- and then a second group of stars (s2) as people (p2) in those same movies
-- which Kevin Bacon starred. Then I simply had to include the WHERE clause
-- to ensure it was using the correct Kevin Bacon and then filtering him out of the results
