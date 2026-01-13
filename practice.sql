#29-12-2025
-- Query a list of CITY names from STATION for cities that have an even ID number. Print the results in any order, but exclude duplicates from the answer.
SELECT DISTINCT CITY FROM STATION
WHERE ID % 2 = 0;

-- Find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.
SELECT COUNT(CITY) - COUNT(DISTINCT (CITY)) FROM STATION;

-- Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.
(SELECT CITY, LENGTH(CITY) AS CITY_LENGTH FROM STATION
GROUP BY CITY
ORDER BY CITY_LENGTH ASC, CITY ASC
LIMIT 1)
UNION ALL
(SELECT CITY, LENGTH(CITY) AS CITY_LENGTH FROM STATION
GROUP BY CITY
ORDER BY CITY_LENGTH DESC, CITY DESC
LIMIT 1)

-- Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE 'A%' OR CITY LIKE 'E%' OR CITY LIKE 'I%' OR CITY LIKE 'O%' OR CITY LIKE 'U%';
# This checks if the city name begins with 'A', 'E', 'I', 'O', or 'U'. For case-insensitivity, use ILIKE in PostgreSQL or LOWER(CITY) LIKE...(most common) 

SELECT DISTINCT CITY FROM STATION
WHERE CITY REGEXP '^[AEIOU]';
# REGEXP with ^ (start) and [AEIOU] (any vowel) is concise and often case-insensitive by default (check your SQL dialect).

SELECT DISTINCT CITY FROM STATION
WHERE LEFT(CITY, 1) IN ('A', 'E', 'I', 'O', 'U');
# LEFT(CITY, 1) gets the first letter, which is then checked against the list of vowels. 

-- Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. Your result cannot contain duplicates.
SELECT DISTINCT CITY
FROM STATION
WHERE CITY REGEXP '^[aeiouAEIOU].*[aeiouAEIOU]$';
# This uses a regular expression: ^ for start, [aeiouAEIOU] for any vowel, .* for any characters in between, and $ for the end, ensuring both start and end are vowels. 

-- Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.
SELECT DISTINCT CITY FROM STATION
WHERE LEFT(CITY,1) NOT IN ('A','E','I','O','U');

-- Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. Your result cannot contain duplicates.
SELECT DISTINCT CITY FROM STATION 
WHERE CITY NOT REGEXP '^[aeiouAEIOU]' OR CITY NOT REGEXP '[aeiouAEIOU]$';

#30-12-2025
-- Query the Name of any student in STUDENTS who scored higher than  Marks. Order your output by the last three characters of each name. If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.
SELECT NAME FROM STUDENTS
WHERE MARKS > 75
ORDER BY RIGHT(NAME,3), ID ASC;

-- Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in alphabetical order.
SELECT NAME FROM EMPLOYEE
ORDER BY NAME ASC;

#03-01-2026
--Generate the following two result sets:

-- 1.Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed by the first letter of each profession as a parenthetical (i.e.: enclosed in parentheses). For example: AnActorName(A), ADoctorName(D), AProfessorName(P), and ASingerName(S).
-- 2.Query the number of ocurrences of each occupation in OCCUPATIONS. Sort the occurrences in ascending order, and output them in the following format:
--There are a total of [occupation_count] [occupation]s.
--where [occupation_count] is the number of occurrences of an occupation in OCCUPATIONS and [occupation] is the lowercase occupation name. If more than one Occupation has the same [occupation_count], they should be ordered alphabetically.
--Note: There will be at least two entries in the table for each type of occupation.

SELECT CONCAT(Name, '(', LEFT(Occupation, 1), ')')
FROM OCCUPATIONS
ORDER BY Name ASC;
SELECT CONCAT('There are a total of ', COUNT(Occupation), ' ', LOWER(Occupation), 's.')
FROM OCCUPATIONS
GROUP BY Occupation
ORDER BY COUNT(Occupation) ASC, Occupation ASC;

#07-01-2026
-- Query the total population of all cities in CITY where District is California.
SELECT SUM(POPULATION) FROM CITY
WHERE DISTRICT = "CalIfornia";

-- Query the average population for all cities in CITY, rounded down to the nearest integer.
SELECT FLOOR(AVG(POPULATION)) FROM CITY;

-- Query the sum of the populations for all Japanese cities in CITY. The COUNTRYCODE for Japan is JPN.
SELECT SUM(POPULATION) FROM CITY
WHERE COUNTRYCODE = "JPN";

-- Query the difference between the maximum and minimum populations in CITY.
SELECT MAX(POPULATION) - MIN(POPULATION) AS DIFFERENCE FROM CITY;

-- Samantha was tasked with calculating the average monthly salaries for all employees in the EMPLOYEES table, but did not realize her keyboard's 0 key was broken until after completing the calculation. 
-- She wants your help finding the difference between her miscalculation (using salaries with any zeros removed), and the actual average salary.
-- Write a query calculating the amount of error (i.e.: actual - miscalculated average monthly salaries), and round it up to the next integer.
SELECT CEIL(AVG(SALARY)-AVG(REPLACE(SALARY,0,''))) FROM EMPLOYEES;
 --- CEIL(): Rounds the result of each average (actual and miscalculated) up to the next whole number.
 --- NULLIF(SALARY, '0'): Replaces any '0' in the salary with NULL. When AVG() encounters NULL values, it ignores them, effectively removing the zeros from the calculation.

#09-01-2026
-- Given the CITY and COUNTRY tables, query the names of all cities where the CONTINENT is 'Africa'.
-- Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
SELECT City.Name
FROM City
INNER JOIN Country ON City.CountryCode = Country.Code
WHERE Country.Continent = 'Africa';

#10-01-2026
-- Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population) rounded down to the nearest integer.
-- Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
SELECT COUNTRY.Continent, FLOOR(AVG(CITY.Population)) AS Average_Population 
FROM CITY 
INNER JOIN COUNTRY ON CITY.CountryCode = COUNTRY.Code
GROUP BY COUNTRY.Continent;

-- Ketty gives Eve a task to generate a report containing three columns: Name, Grade and Mark. Ketty doesn't want the NAMES of those students who received a grade lower than 8. The report must be in descending order by grade 
-- i.e. higher grades are entered first. If there is more than one student with the same grade (8-10) assigned to them, order those particular students by their name alphabetically. Finally, if the grade is lower than 8, use "NULL" as their name and list them by their grades in descending order. 
-- If there is more than one student with the same grade (1-7) assigned to them, order those particular students by their marks in ascending order.
SELECT
CASE WHEN gr.Grade < 8 THEN NULL
WHEN gr.Grade >= 8 THEN st.Name END,
gr.Grade, st.marks FROM students st JOIN grades gr
WHERE st.marks BETWEEN gr.min_mark AND gr.max_mark
ORDER BY gr.grade DESC, st.name ASC;

-- Julia just finished conducting a coding contest, and she needs your help assembling the leaderboard! 
-- Write a query to print the respective hacker_id and name of hackers who achieved full scores for more than one challenge. Order your output in descending order by the total number of challenges in which the hacker earned a full score. 
-- If more than one hacker received full scores in same number of challenges, then sort them by ascending hacker_id.
SELECT H.hacker_id, H.name
FROM Hackers H
JOIN Submissions S ON H.hacker_id = S.hacker_id
JOIN Challenges C ON S.challenge_id = C.challenge_id
JOIN Difficulty D ON C.difficulty_level = D.difficulty_level
WHERE S.score = D.score
GROUP BY H.hacker_id, H.name
HAVING COUNT(S.challenge_id) > 1
ORDER BY COUNT(S.challenge_id) DESC, H.hacker_id ASC;
