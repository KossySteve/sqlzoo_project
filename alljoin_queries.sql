--How many stops are in the database
SELECT COUNT(name)
FROM stops

--Find the id value for the stop 'Craiglockhart'
SELECT * FROM route
GROUP BY stop

--Give the id and the name for the stops on the '4' 'LRT' service
SELECT id, name FROM stops
JOIN route ON stop= id
WHERE company ='LRT' AND num = 4
GROUP BY name
ORDER BY pos

--The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes
SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) = 2

--Change the query so that it shows the services from Craiglockhart to London Road.
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop = 149

--Change the query so that the services between 'Craiglockhart' and 'London Road' are shown
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'

--Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=115 AND b.stop = 137
GROUP BY num

--Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross
SELECT a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name='Tollcross'

--Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services
SELECT stopb.name, a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'

--List the teachers who have NULL for their department
SELECT name FROM teacher
WHERE DEPT is NULL

--Note the INNER JOIN misses the teachers with no department and the departments with no teacher.
SELECT teacher.name, dept.name
 FROM teacher INNER JOIN dept
           ON (teacher.dept=dept.id)

--Use a different JOIN so that all teachers are listed
SELECT teacher.name, dept.name
 FROM teacher LEFT JOIN dept
           ON (teacher.dept=dept.id)

--Use a different JOIN so that all departments are listed
SELECT teacher.name, dept.name
 FROM teacher RIGHT JOIN dept
           ON (teacher.dept=dept.id)

--Use COALESCE to print the mobile number. Use the number '07986 444 2266' if there is no number given. Show teacher name and mobile number or '07986 444 2266
SELECT name, COALESCE(mobile,'07986 444 2266')
FROM teacher

--Use the COALESCE function and a LEFT JOIN to print the teacher name and department name. Use the string 'None' where there is no department.
SELECT teacher.name, COALESCE(dept.name,  'None' )
 FROM teacher LEFT JOIN dept
           ON (teacher.dept=dept.id)

--Use COUNT to show the number of teachers and the number of mobile phones.
SELECT COUNT(name), COUNT(mobile)
FROM teacher

--Use COUNT and GROUP BY dept.name to show each department and the number of staff. Use a RIGHT JOIN to ensure that the Engineering department is listed.
SELECT dept.name, COUNT(teacher.name)
 FROM teacher RIGHT JOIN dept
           ON (teacher.dept=dept.id)
GROUP BY dept.name

--Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2 and 'Art' otherwise.
SELECT teacher.name,
  CASE WHEN dept = 1
            THEN 'Sci'
            WHEN dept = 2
            THEN 'Sci'
            ELSE 'Art'
       END

--Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2, show 'Art' if the teacher's dept is 3 and 'None' otherwise.
SELECT teacher.name,
  CASE WHEN dept = 1
            THEN 'Sci'
            WHEN dept = 2
            THEN 'Sci'
            WHEN dept = 3
            THEN 'Art'
            ELSE 'None'
       END
FROM teacher

--List the films where the yr is 1962 [Show id, title]
SELECT id, title
  FROM movie
    WHERE yr=1962

 --Give year of 'Citizen Kane'
SELECT yr
  FROM movie
    WHERE title = 'Citizen Kane'

--List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr
  FROM movie
    WHERE title LIKE '%Star Trek%'
      ORDER BY yr

--What id number does the actor 'Glenn Close' have?
SELECT id
  FROM actor
    WHERE name = 'Glenn Close'

--What is the id of the film 'Casablanca'
SELECT id
  FROM movie
    WHERE title = 'Casablanca'

--Obtain the cast list for 'Casablanca'.
--what is a cast list?
--Use movieid=11768, (or whatever value you got from the previous question)
SELECT name
  FROM actor
    JOIN casting ON id = actorid
      WHERE movieid=11768.

--Obtain the cast list for the film 'Alien'
SELECT name
  FROM actor
    JOIN casting ON id = actorid
      WHERE movieid=(SELECT id FROM movie WHERE title ='Alien')

--List the films in which 'Harrison Ford' has appeared
SELECT title FROM movie
  JOIN casting ON movie.id = movieid
    WHERE actorid =
      (SELECT DISTINCT actorid FROM casting JOIN actor ON actor.id = actorid WHERE name ='Harrison Ford')

--List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
SELECT DISTINCT title FROM movie
  JOIN casting ON movie.id = movieid
WHERE actorid =
(SELECT DISTINCT actorid FROM casting JOIN actor ON actor.id = actorid WHERE name ='Harrison Ford') AND ord!=1

--List the films together with the leading star for all 1962 films
SELECT title, name FROM movie
  JOIN casting ON movie.id = movieid
    JOIN actor ON actor.id = actorid
      WHERE ord=1 AND yr = 1962

--Modify it to show the matchid and player name for all goals scored by Germany.
SELECT matchid, player FROM goal
  WHERE teamid = 'GER'

--Show id, stadium, team1, team2 for just game 1012
SELECT id,stadium,team1,team2
  FROM game
    WHERE game.id = 1012

--Modify it to show the player, teamid, stadium and mdate for every German goal.
SELECT player, teamid, stadium, mdate
  FROM game JOIN goal ON (id=matchid)
    WHERE teamid = 'GER'

--Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
SELECT team1, team2, COUNT(player), player
  FROM game JOIN goal ON (id=matchid)
    WHERE player LIKE 'Mario%'
      GROUP BY player

--Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT player, teamid, coach, gtime
  FROM goal JOIN eteam ON (teamid=id)
    WHERE gtime<=10

--List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
SELECT mdate, teamname
  FROM eteam JOIN game ON (team1=eteam.id)
    WHERE coach = 'Fernando Santos'

--List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT player
  FROM goal JOIN game ON (matchid=id)
    WHERE stadium = 'National Stadium, Warsaw'

--Instead show the name of all players who scored a goal against Germany.
SELECT DISTINCT player
  FROM game JOIN goal ON matchid = id
    WHERE (team1='GER' OR team2='GER') AND teamid != 'GER'

--Show teamname and the total number of goals scored
SELECT teamname, COUNT(teamid)
  FROM eteam JOIN goal ON id=teamid
    GROUP BY teamid
      ORDER BY teamname

--Show the stadium and the number of goals scored in each stadium
SELECT stadium, COUNT(teamid)
  FROM game JOIN goal ON id=matchid
    GROUP BY stadium

--For every match involving 'POL', show the matchid, date and the number of goals scored
SELECT matchid,mdate, COUNT(teamid)
  FROM game JOIN goal ON id = matchid
    WHERE (team1 = 'POL' OR team2 = 'POL')
      GROUP BY mdate
        ORDER BY matchid

--For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT matchid, mdate, COUNT(teamid)
  FROM goal JOIN game ON (matchid=id)
    WHERE teamid = 'GER'
      GROUP BY mdate
        ORDER BY matchid
