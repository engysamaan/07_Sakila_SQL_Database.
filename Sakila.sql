   
    SET SQL_SAFE_UPDATES = 0;

    SELECT *
    FROM sakila.actor;

    -- 1a. Display the first and last names of all actors from the table actor.
    SELECT first_name, last_name
    FROM actor
    
    -- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
    SELECT CONCAT(first_name, '  ', last_name) AS 'Actor Name'
    FROM actor;
 
    -- 2a. find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
    SELECT *    
    FROM actor
    WHERE first_name = 'joe'
    
    -- 2b. Find all actors whose last name contain the letters GEN:
    SELECT  *    
    FROM actor
    WHERE last_name LIKE '%gen%'
  
    -- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
    SELECT last_name , first_name
    FROM actor
    WHERE last_name LIKE '%li%'
        
    -- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
    SELECT  country_id
    FROM country
    WHERE country IN ("Afghanistan", "Bangladesh", "China" )
    
    -- 3a. reate a column in the table actor named description and use the data type BLOB
    ALTER TABLE actor
    ADD description BLOB
    
    -- Delete the description column
    ALTER TABLE actor
    DROP description;
    
    -- 4l 

   
    
    


    
