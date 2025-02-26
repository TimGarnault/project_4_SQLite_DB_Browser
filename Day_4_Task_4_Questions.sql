--Questions

-- 4.1 Select the title of all movies.
SELECT Title
FROM Movies

-- 4.2 Show all the distinct ratings in the database.
SELECT DISTINCT Rating
FROM Movies

-- 4.3 Show all unrated movies.
-- from https://www.sqlitetutorial.net/sqlite-is-null/
SELECT Title
FROM Movies
WHERE Rating IS NULL

-- 4.4 Select all movie theaters that are not currently showing a movie.
SELECT Name
FROM MovieTheaters
WHERE Movie IS NULL

-- 4.5 Select all data from all movie theaters and, additionally, the data from the movie that is being shown in the theater (if one is being shown).
SELECT MovieTheaters.*, Movies.*
FROM MovieTheaters
LEFT JOIN Movies
ON MovieTheaters.Movie = Movies.Code

-- 4.6 Select all data from all movies and, if that movie is being shown in a theater, show the data from the theater.
SELECT Movies.*, MovieTheaters.*
FROM Movies
LEFT JOIN MovieTheaters
ON MovieTheaters.Movie = Movies.Code

-- 4.7 Show the titles of movies not currently being shown in any theaters.
SELECT Movies.Title
FROM Movies
LEFT JOIN MovieTheaters
ON MovieTheaters.Movie = Movies.Code
WHERE MovieTheaters.Code IS NULL

-- 4.8 Add the unrated movie "One, Two, Three".
INSERT INTO Movies(Title,Rating) VALUES('One, Two, Three',NULL);

-- 4.9 Set the rating of all unrated movies to "G".
UPDATE Movies
SET Rating = 'G'
WHERE Rating IS NULL

-- 4.10 Remove movie theaters projecting movies rated "NC-17".
DELETE FROM MovieTheaters
WHERE MovieTheaters.Name= (
SELECT MovieTheaters.Name
FROM MovieTheaters
JOIN Movies
ON MovieTheaters.Movie = Movies.Code
Where Rating = 'NC-17')