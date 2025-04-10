--1 Create a list of all the different (distinct) replacement costs of the films and find out What's the lowest replacement cost?.
SELECT DISTINCT replacement_cost 
FROM film
ORDER BY 1;
-- answer = 9.99

-- 2  Write a query that gives an overview of how many films have replacements costs in the following cost ranges and tell how many films have a replacement cost in the "low" group? 
SELECT 
CASE 
WHEN replacement_cost BETWEEN 9.99 AND 19.99
THEN 'low'
WHEN replacement_cost BETWEEN 20 AND 24.99
THEN 'medium'
ELSE 'high'
END as cost_range,
COUNT(*)
FROM film
GROUP BY cost_range;
-- answer = 514
-- 3  Create a list of the film titles including their title, length, and category name ordered descendingly by length. Filter the results to only the movies in the category 'Drama' or 'Sports'.In which category is the longest film and how long is it?
SELECT 
title,
name,
length
FROM film f
LEFT JOIN film_category fc
ON f.film_id=fc.film_id
LEFT JOIN category c
ON c.category_id=fc.category_id
WHERE name = 'Sports' OR name = 'Drama'
ORDER BY length DESC;
-- answer = Sports and 184
-- 4 Create an overview of how many movies (titles) there are in each category (name).Which category (name) is the most common among the films?
SELECT
name,
COUNT(title)
FROM film f
INNER JOIN film_category fc
ON f.film_id=fc.film_id
INNER JOIN category c
ON c.category_id=fc.category_id
GROUP BY name
ORDER BY 2 DESC;
-- answer = Sports with 74 titles

-- 5  Create an overview of the actors' first and last names and in how many movies they appear in and Which actor is part of most movies?
SELECT
a.actor_id,
first_name,
last_name,
COUNT(*)
FROM actor a
LEFT JOIN film_actor fa
ON fa.actor_id=a.actor_id
LEFT JOIN film f
ON fa.film_id=f.film_id
GROUP BY a.actor_id,first_name, last_name
ORDER BY COUNT(*) DESC;
-- answer = Gina Degeneres with 42 movies

--6 Create an overview of the addresses that are not associated to any customer.How many addresses are that?
SELECT * FROM address a
LEFT JOIN customer c
ON c.address_id = a.address_id
WHERE c.first_name is null;
-- answer = 4

-- 7 Task: Create the overview of the sales  to determine the from which city (we are interested in the city in which the customer lives, not where the store is) most sales occur.Question: What city is that and how much is the amount?
SELECT 
city,
SUM(amount)
FROM payment p
LEFT JOIN customer c
ON p.customer_id=c.customer_id
LEFT JOIN address a
ON a.address_id=c.address_id
LEFT JOIN city ci
ON ci.city_id=a.city_id
GROUP BY city
ORDER BY city DESC;
--Answer: Cape Coral with a total amount of 221.55

-- 8 Create an overview of the revenue (sum of amount) grouped by a column in the format "country, city".Which country, city has the least sales?
SELECT 
country ||', ' ||city,
SUM(amount)
FROM payment p
LEFT JOIN customer c
ON p.customer_id=c.customer_id
LEFT JOIN address a
ON a.address_id=c.address_id
LEFT JOIN city ci
ON ci.city_id=a.city_id
LEFT JOIN country co
ON co.country_id=ci.country_id
GROUP BY country ||', ' ||city
ORDER BY 2 ASC;
--Answer: United States, Tallahassee with a total amount of 50.85.

--9 Create a list with the average of the sales amount each staff_id has per customer.Which staff_id makes on average more revenue per customer?
SELECT 
staff_id,
ROUND(AVG(total),2) as avg_amount 
FROM (
SELECT SUM(amount) as total,customer_id,staff_id
FROM payment
GROUP BY customer_id, staff_id) a
GROUP BY staff_id;
--Answer: staff_id 2 with an average revenue of 56.64 per customer.

-- 10 Create a list of all the different (distinct) replacement costs of the films.
SELECT 
AVG(total)
FROM 
	(SELECT
	 SUM(amount) as total,
	 DATE(payment_date),
	 EXTRACT(dow from payment_date) as weekday
	 FROM payment
	 WHERE EXTRACT(dow from payment_date)=0
	 GROUP BY DATE(payment_date),weekday) daily;
-- answer = 1388.264285742




