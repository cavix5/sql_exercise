/*
Ej. 1
Modify it to show the matchid and player name for all goals scored by Germany. 
To identify German players, check for: teamid = 'GER'
*/

SELECT matchid, player FROM goal 
  WHERE teamid = 'GER';

/*
Ej. 2
From the previous query you can see that Lars Bender's scored a goal in game 1012. 
Now we want to know what teams were playing in that match.
Notice in the that the column matchid in the goal table corresponds to the id column in the game table.
We can look up information about game 1012 by finding that row in the game table.
Show id, stadium, team1, team2 for just game 1012
*/

SELECT id,stadium,team1,team2
  FROM game
WHERE id = 1012;

/*
Ej. 3
Modify it to show the player, teamid, stadium and mdate for every German goal.
*/

SELECT player, teamid, stadium, mdate
  FROM game JOIN goal ON (id=matchid)
WHERE teamid = 'GER';

/*
Ej. 4
Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10.
*/

SELECT player, teamid, coach, gtime
  FROM goal JOIN eteam on teamid=id
 WHERE gtime<=10;

/*
Ej. 5
Show the team1, team2 and player for every goal scored by a player called Mario 
player LIKE 'Mario%'
*/

SELECT  team1, team2, player
  FROM game JOIN goal ON (id=matchid)
WHERE player LIKE 'Mario%';

/*
Ej. 6
Instead show the name of all players who scored a goal against Germany.
*/

SELECT DISTINCT player
  FROM game JOIN goal ON matchid = id 
    WHERE (teamid != 'GER' AND 
(team1 = 'GER' OR team2 = 'GER'));

/*
Ej. 7
Show teamname and the total number of goals scored.
*/

SELECT teamname, COUNT(teamid)
  FROM eteam JOIN goal ON id=teamid
GROUP BY teamname;

/*
Ej. 8
Show the stadium and the number of goals scored in each stadium.
*/

SELECT stadium, COUNT(teamid)
  FROM game JOIN goal ON id=matchid
GROUP BY stadium;

/*
Ej. 9
For every match involving 'POL', show the matchid, 
date and the number of goals scored.
*/

SELECT matchid, mdate, COUNT(teamid)
  FROM game JOIN goal ON matchid = id 
 WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY matchid, mdate;


/*
Ej. 10
For every match where 'GER' scored, show matchid, 
match date and the number of goals scored by 'GER'.
*/

SELECT matchid, mdate, COUNT(teamid)
  FROM game JOIN goal ON matchid = id 
 WHERE teamid = 'GER'
GROUP BY matchid, mdate;

/*
Ej. 11
List every match with the goals scored by each team as shown. 
This will use "CASE WHEN" which has not been explained in any previous exercises.
*/

SELECT
  mdate,
  team1,
  SUM(CASE WHEN teamid = team1 THEN 1 ELSE 0 END) AS score1,
  team2,
  SUM(CASE WHEN teamid = team2 THEN 1 ELSE 0 END) AS score2
FROM game
JOIN goal ON matchid = id
GROUP BY mdate, matchid, team1, team2
ORDER BY mdate, matchid, team1, team2;


/*
Ej. 12
Which were the busiest years for 'Rock Hudson', show the year and the number of 
movies he made each year for any year in which he made more than 2 movies.
*/

SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;

/*
Ej. 13
List the film title and the leading actor for all of the films 'Julie Andrews' played in.
*/

SELECT DISTINCT  title, name
FROM movie JOIN casting ON (movie.id = movieid  AND ord = 1) JOIN actor 
ON actorid = actor.id
WHERE movie.id IN(SELECT movieid FROM casting
WHERE actorid IN (
  SELECT id FROM actor
  WHERE name='Julie Andrews'));

/*
Ej. 14
Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
*/

SELECT name
FROM movie JOIN casting ON (movie.id = movieid  AND ord = 1) JOIN actor 
ON actorid = actor.id
GROUP BY name, ord
HAVING SUM(ord) >= 15 
ORDER BY name;

/*
Ej. 15
List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
*/

SELECT DISTINCT title, COUNT(actorid)
FROM movie JOIN casting ON (movieid = movie.id)
WHERE yr = 1978
GROUP BY title
ORDER BY COUNT(actorid) DESC, title;