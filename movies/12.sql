SELECT title FROM movies
JOIN stars s1 ON movies.id = s1.movie_id
JOIN people p1 ON s1.person_id = p1.id
JOIN stars s2 ON movies.id = s2.movie_id
JOIN people p2 ON s2.person_id = p2.id
WHERE p1.name = 'Bradley Cooper'
AND p2.name = 'Jennifer Lawrence';

-- The key to this one was to join the stars and people tables twice,
-- once for each actor. To do this, I needed to alias each table as s1, s2, p1, p2
-- so they could be uniquely referenced for each actor.

