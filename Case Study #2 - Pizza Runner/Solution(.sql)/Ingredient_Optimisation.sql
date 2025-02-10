-- Ingredient Optimisation

-- Data preparation

-- creating pizza_recipes_copy 
DROP TABLE IF EXISTS pizza_recipes_copy;

CREATE TABLE pizza_recipes_copy
( pizza_id int, topping_id varchar(4), topping_name text);

INSERT INTO pizza_recipes_copy
SELECT 
    pizza_id, 
    TRIM(t.topping_id), topping_name
FROM (
    SELECT 
        pizza_id, 
        topping_id
    FROM pizza_recipes,
    JSON_TABLE(
        CONCAT('["', REPLACE(toppings, ',', '","'), '"]'),
        "$[*]" COLUMNS(topping_id INT PATH "$")
    ) AS toppings_table
) t
JOIN pizza_toppings p
ON t.topping_id = p.topping_id
ORDER BY pizza_id, t.topping_id;

SELECT *
FROM pizza_recipes_copy;


-- creating an extras_toppings table
DROP TABLE IF EXISTS extras_toppings;
CREATE TABLE extras_toppings (order_id INT, pizza_id INT, extras_id VARCHAR(4), extras_topping_name text);

INSERT INTO extras_toppings
SELECT order_id,pizza_id, TRIM(extras_id), topping_name as extras_topping_name
FROM (
	  SELECT order_id, pizza_id, extras_id
      FROM customer_orders_copy,
      JSON_TABLE(
			CONCAT('["', REPLACE(extras, ',','","'), '"]'),
            "$[*]" COLUMNS(extras_id VARCHAR(4) PATH "$")
	) as extras_separated
) as e
JOIN pizza_toppings p
ON e.extras_id = p.topping_id;

SELECT *
FROM extras_toppings;

-- creating an exclusion table
DROP TABLE IF EXISTS excluded_toppings;
CREATE TABLE excluded_toppings (order_id INT, pizza_id INT, exclusions_id VARCHAR(4), excluded_topping_name text);

INSERT INTO excluded_toppings
SELECT order_id,pizza_id, TRIM(exclusions_id), topping_name excluded_topping_name
FROM (
	  SELECT order_id, pizza_id, exclusions_id
      FROM customer_orders_copy,
      JSON_TABLE(
			CONCAT('["', REPLACE(exclusions, ',','","'), '"]'),
            "$[*]" COLUMNS(exclusions_id VARCHAR(4) PATH "$")
	) as exclusions_separated
) as e
JOIN pizza_toppings p
ON e.exclusions_id = p.topping_id;

SELECT *
FROM excluded_toppings;



-- 1. What are the standard ingredients for each pizza?
SELECT *
FROM pizza_recipes_copy;

-- 2. What was the most commonly added extra?
SELECT extras_id, topping_name, COUNT(*) total_count
FROM extras_toppings e
JOIN pizza_toppings p
ON e.extras_id = p.topping_id
GROUP BY extras_id, topping_name
ORDER BY total_count DESC
LIMIT 1 ;

-- 3. What was the most common exclusion?
SELECT exclusions_id,excluded_topping_name, COUNT(*) total_count
FROM excluded_toppings 
GROUP BY exclusions_id,excluded_topping_name
ORDER BY total_count DESC
LIMIT 1;

/*
Generate an order item for each record in the customers_orders table in the format of one of the following:
		- Meat Lovers
		- Meat Lovers - Exclude Beef
		- Meat Lovers - Extra Bacon
		- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
*/

WITH T1 AS
(
SELECT order_id, pizza_id, group_concat(DISTINCT excluded_topping_name)  excluded
FROM excluded_toppings 
GROUP BY order_id, pizza_id),
t2 AS
(SELECT order_id, pizza_id, group_concat(DISTINCT extras_topping_name)  extras
 from extras_toppings
 GROUP BY order_id, pizza_id)

SELECT c.order_id,customer_id,
	(CASE
		WHEN c.exclusions IS NULL AND c.extras IS NULL THEN pizza_name
        WHEN c.exclusions IS NOT NULL AND c.extras IS NULL THEN CONCAT(pizza_name, ' - Exclude ', t1.excluded)
        WHEN c.extras IS NOT NULL AND c.exclusions IS NULL THEN CONCAT(pizza_name, ' - Include ', t2.extras)
        WHEN c.extras IS NOT NULL AND c.exclusions IS NOT NULL THEN CONCAT(pizza_name, ' - Exclude ', t1.excluded, ' - Include ' , t2.extras)
	  END ) as pizza_order
FROM customer_orders_copy c
LEFT JOIN T1
on c.order_id = t1.order_id and c.pizza_id = t1.pizza_id
LEFT JOIN T2
on c.order_id = t2.order_id and c.pizza_id = t2.pizza_id
JOIN pizza_names p
ON c.pizza_id = p.pizza_id;


