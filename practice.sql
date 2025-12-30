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