/*Arjay Jean 
CGS1540C
A6 - Queries
11/21/2022*/ 

-- SQL 1 - Use sakila database
USE sakila;

-- SQL 2A - Retrieve all the actors
SELECT * FROM actor;

-- SQL 2B - Retrieve actor's first and last name
SELECT first_name, last_name FROM actor;

-- SQL 2C - Retrieve actor's full name
SELECT concat(first_name, ' ', last_name) AS full_name FROM actor;


-- SQL 3A - Retrieve film ID & title that are rated 'PG-13'
SELECT  film_id, title FROM film
	WHERE rating = 'PG-13';

-- SQL 3B - Return the total number of 'PG-13' films
SELECT  COUNT(*) FROM film
	WHERE rating = 'PG-13';

-- SQL 4 - Retrieve all the film IDs, title, description, and category ID
SELECT f.film_id, f.title, f.description, fc.category_id FROM film AS f
	INNER JOIN film_category AS fc
	USING(film_id);
    
-- SQL 5 - Retrieve all the store_id, address, city, postal_code
SELECT s.store_id, a.address, a.address2, ci.city, a.postal_code, co.country 
FROM country AS co
INNER JOIN city AS ci USING(country_id)
INNER JOIN address AS a USING(city_id)
INNER JOIN store AS s USING(address_id)
	WHERE co.country = 'United States';
    
-- SQL 6 - Retrieve all the films title with PG-13 and released in 2006
SELECT title, release_year FROM film
	WHERE release_year = 2006 AND rating = 'PG-13'
    ORDER BY title DESC;
    
-- SQL 7 - Retrieve actors with last name that starts with B
SELECT first_name, last_name FROM actor
	WHERE last_name LIKE 'B%';


-- HOMEWORK 
-- SQL HW1 - Retrieve the number of ratings within the film table
SELECT rating, COUNT(rating) AS rating_count FROM film
	GROUP BY rating;
    
-- SQL HW2 - Retrieve film titles, their length, between 100 and 150 minutes, in the order of the duration, and its rating 
SELECT title, length AS duration, rating 
FROM film
	WHERE length BETWEEN 100 AND 150
    ORDER BY length;
    
    
-- SQL HW3 - Retrieve customer's ID, their full name and their activity level(Active/Inactive)
SELECT customer_id, first_name, last_name, IF(active = 1, 'Active', 'Inactive') AS activity_level FROM customer;    


-- SQL HW4 - Retrieve the customer's ID, full name, and the amount they paid for their 
-- MAX(p.amount) AS expense_pay 
SELECT c.customer_id, c.first_name, c.last_name, p.amount
FROM customer AS c
INNER JOIN payment AS p
	USING(customer_id)
INNER JOIN rental
	USING(rental_id)
INNER JOIN inventory
	USING(inventory_id)
INNER JOIN film AS f
	USING(film_id);


-- SQL HW5 - Retrieve the film titles and all of their special features
SELECT title, SUBSTRING_INDEX(special_features, ',', 1) AS special_features_1, 
				IF(substring_index(SUBSTRING_INDEX(special_features, ',', 2), ',', -1) = SUBSTRING_INDEX(special_features, ',', -1), NULL, substring_index(substring_index(special_features, ',', -2), ',', 1)) AS special_features_2,
                IF(SUBSTRING_INDEX(special_features, ',', -1) != SUBSTRING_INDEX(special_features, ',', 1), SUBSTRING_INDEX(special_features, ',', -1), NULL) AS special_features_3 
			FROM film;

-- SQL HW6 - Retrieve the actors full name and initials
SELECT first_name, last_name, CONCAT(LEFT(first_name, 1), '.', LEFT(last_name, 1), '.') AS initials FROM actor;


-- SQL HW7 - Retrieve customer's ID, full name, and their overall payment for rentals
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS overall_pay FROM customer AS c
	INNER JOIN payment AS p
		USING(customer_id)
	GROUP BY customer_id;
    
    
-- SQL HW8 - Retrieve the customer's name and give them proper capitalization
SELECT 
	INSERT(LOWER(first_name), 1, 1, UPPER(LEFT(first_name, 1))) AS first_name, 
    INSERT(LOWER(last_name), 1, 1, UPPER(LEFT(last_name, 1))) AS last_name
FROM actor;

-- SQL HW9 - Retrieve the rating and give them their description
SELECT rating,
	CASE
		WHEN rating = 'G' THEN 'General Audiences'
        WHEN rating = 'PG' THEN 'Parental Guidance Suggested'
        WHEN rating = 'PG-13' THEN 'Parents Strongly Cautioned'
        WHEN rating = 'R' THEN 'Restricted'
        WHEN rating = 'NC-17' THEN 'Adults Only'
	END rating_description
FROM film
GROUP BY rating;

/*
Functions used in homework:
	1.) GROUP BY
    2.) BETWEEN
    3.) IF
    4.) INNER JOIN
    5.) SUBSTRING_INDEX + NULL
    --	ADDITIONAL	--
    6.) LEFT
    7.) SUM
    8.) INSERT + LOWER + UPPER
    9.) CASE
*/







