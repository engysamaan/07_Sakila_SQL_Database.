   
    SET SQL_SAFE_UPDATES = 0;

    SELECT *
    FROM sakila.actor;

    -- 1a. Display the first and last names of all actors from the table actor.
    SELECT first_name, last_name
    FROM actor;
    
    -- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
    SELECT CONCAT(first_name, '  ', last_name) AS 'Actor Name'
    FROM actor;
 
    -- 2a. find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
    SELECT *    
    FROM actor
    WHERE first_name = 'joe';
    
    -- 2b. Find all actors whose last name contain the letters GEN:
    SELECT  *    
    FROM actor
    WHERE last_name LIKE '%gen%';
  
    -- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
    SELECT last_name , first_name
    FROM actor
    WHERE last_name LIKE '%li%'
    ORDER BY last_name ASC;
        
    -- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
    SELECT  country_id
    FROM country
    WHERE country IN ("Afghanistan", "Bangladesh", "China" );
    
    -- 3a. reate a column in the table actor named description and use the data type BLOB
    ALTER TABLE actor
    ADD description BLOB;
    
    -- 3b  Delete the description column
    ALTER TABLE actor
    DROP description;
    
    --  4a. List the last names of actors, as well as how many actors have that last name.
    SELECT last_name
    FROM actor;
    
    SELECT count(last_name), last_name
    FROM actor
    GROUP BY last_name;
    
    -- OR 
    /*     SELECT DISTINCT(Last_name), count(last_name)
    FROM actor
    GROUP BY Last_name;*/
    
    -- 4b. List last names of actors and the number of actors who have that last name, 
    -- but only for names that are shared by at least two actors
    SELECT count(last_name), last_name
    FROM actor
    GROUP BY last_name
    HAVING count(last_name) >= 2;
    
    -- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as 
    -- GROUCHO WILLIAMS. Write a query to fix the record.
    UPDATE actor
    SET first_name = 'HARPO'
    WHERE ACTOR_ID = 172;

    /* 4d. Perhaps we were too hasty in changing GROUCHO to HARPO.
    It turns out that GROUCHO was the correct name after all! In a single query,
    if the first name of the actor is currently HARPO, change it to GROUCHO */
    UPDATE actor
    SET first_name = 'GROUCHO'
    WHERE first_name = 'HARPO';
    
    -- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
    SELECT * 
    FROM address;
    
    SHOW CREATE TABLE address;
    
    /*6a. Use JOIN to display the first and last names, as well as the address,
    of each staff member. Use the tables staff and address:*/
    SELECT s.first_name, s.last_name, a.address
    FROM staff s
    JOIN address a ON s.address_id = a.address_id;
    
    /*6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
    Use tables staff and payment.*/    
    SELECT s.last_name , sum(p.amount)
    FROM staff s
    JOIN  payment p ON s.staff_id = p.staff_id
    WHERE p.payment_date BETWEEN '2005-08-01' and '2005-08-31'
    Group by s.staff_id;


   /*6c. List each film and the number of actors who are listed for that film.
    Use tables film_actor and film. Use inner join.*/
    SELECT  f.film_id, f.title, count(fa.actor_id) as 'number of actors'
    FROM film f
    INNER JOIN film_actor fa  on f.film_id = fa.film_id
    GROUP BY fa.film_id;
    

    -- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
    
    SELECT  count(film_id)
    FROM  inventory
    WHERE film_id IN 
    ( 
        SELECT film_id
        From film
        WHERE title = 'HUNCHBACK IMPOSSIBLE'
    );
    
 /*-- 6e. Using the tables payment and customer and the JOIN command, 
 list the total paid by each customer. List the customers alphabetically by last name:*/    
    SELECT  c.first_name, c.last_name, sum(p.amount)
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY p.customer_id, c.customer_id
    ORDER BY c.last_name ASC;
    
/*7a.Use subqueries to display the titles of movies starting with the letters 
K and Q whose language is English*/
    SELECT title
    FROM  film
    WHERE language_id IN 
    ( 
        SELECT language_id
        From language
        WHERE name = 'English'
        And title like 'K%' 
        OR title like 'Q%'
    );
    
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.    
    SELECT actor_id, first_name, last_name
    FROM  actor
    WHERE actor_id IN 
    ( 
        SELECT actor_id
        From film_actor
        WHERE film_id IN
        (
            SELECT film_id
            FROM film
            WHERE title = 'ALONE TRIP'
        )
    );

/*7c. You want to run an email marketing campaign in Canada, 
for which you will need the names and email addresses of all Canadian customers. 
Use joins to retrieve this information.*/
    SELECT customer_id, first_name, last_name, email
    FROM  customer
    WHERE address_id 
    IN ( 
    
        SELECT address_id
        From address
        WHERE city_id 
        IN (
        
            SELECT city_id
            FROM city
            WHERE country_id 
            IN (
            
                SELECT country_id
                FROM country
                WHERE country = 'Canada'
            )
        )
    );

/*7d. Sales have been lagging among young families, 
and you wish to target all family movies for a promotion. 
Identify all movies categorized as family films.*/

    SELECT film_id, title
    FROM  film
    WHERE film_id IN 
    ( 
        SELECT film_id
        From film_category
        WHERE category_id IN
        (
            SELECT category_id
            FROM category
            WHERE name = 'Family'
        )
    );
    
-- 7e. Display the most frequently rented movies in descending order.    
    SELECT f.title as "Movies", COUNT(r.rental_id) as "Number of rentals"
    FROM film f 
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id 
    GROUP BY 1
    ORDER BY 2 DESC;


 -- 7f. Write a query to display how much business, in dollars, each store brought in.
    select * from rental
    SELECT s.store_id, SUM(p.amount) 
    FROM store s
    JOIN staff st ON s.store_id = st.store_id
    JOIN rental r ON st.staff_id = r.staff_id
    JOIN payment p ON r.rental_id = p.rental_id
    GROUP BY 1 ;
    
-- 7g. Write a query to display for each store its store ID, city, and country.
 /*   SELECT store_id
    FROM  store
    WHERE address_id IN
    (
        SELECT address_id
        From address a
        WHERE city_id IN
        (
            SELECT city_id
            FROM city c
            WHERE country_id IN
            (
                SELECT country_id
                FROM country
            )
        )
    );*/

    SELECT s.store_id, c.city, co.country
    FROM store s 
    JOIN address a ON s.address_id = a.address_id
    JOIN city c ON a.city_id = c.city_id
    JOIN country co ON c.country_id = co.country_id;

/*7h. List the top five genres in gross revenue in descending order. 
(Hint: you may need to use the following tables: 
category, film_category, inventory, payment, and rental.)*/
    SELECT  c.name as GENERS, sum( p.amount )
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN inventory i ON fc.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    JOIN payment p ON r.rental_id = p.rental_id  
    GROUP BY GENERS
    ORDER BY 2 DESC
    LIMIT 5;
    
/*8a. In your new role as an executive, 
you would like to have an easy way of viewing the Top five genres by gross revenue. 
Use the solution from the problem above to create a view. 
If you haven't solved 7h, you can substitute another query to create a view.*/
    
    CREATE VIEW  Top_Five_Genres as 
    SELECT   c.name as GENERS, sum( p.amount )
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN inventory i ON fc.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    JOIN payment p ON r.rental_id = p.rental_id  
    GROUP BY GENERS
    ORDER BY 2 DESC
    LIMIT 5;
    
-- 8b. How would you display the view that you created in 8a?
    SELECT *
    FROM Top_Five_Genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
    DROP VIEW Top_Five_Genres;

       
