# Ingredient Optimisation

## Data preparation 
**1. Created a `pizza_recipes_copy` table**\
To handle multiple toppings per pizza more efficiently, I created a copy of the `pizza_recipes` table with each topping split into its own row.
```sql
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
ORDER BY pizza_id;

SELECT *
FROM pizza_recipes_copy;
```
**Output:**\
![image](https://github.com/user-attachments/assets/f375f03e-e32b-4eb6-9767-bd42d67c1a7f)

**2. `extras_topping` table**\
To track which toppings customers commonly add beyond the standard ingredient, I created the `extras_topping` table using the data from the `customer_orders_copy` table.
```sql
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
```
**Output:**\
![image](https://github.com/user-attachments/assets/1369f117-9eb4-436c-9ee4-59266b99a01e)

**3. `excluded_toppings` table**\
This table helps us see which toppings customers often choose to exclude, based on the data from the `customer_orders_copy` table.
```sql
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
```
**Output:**\
![image](https://github.com/user-attachments/assets/5a0360ac-2a41-46ed-8e37-236dac7cbf07)

## Analysis Queries and Outputs

### 1. What are the standard ingredients for each pizza?
```sql
SELECT *
FROM pizza_recipes_copy;
```
**Output:**\
![image](https://github.com/user-attachments/assets/b33d359e-7b09-4cc7-bca6-e9cb15c85060)

### 2. What was the most commonly added extra?
```sql
SELECT extras_id, topping_name, COUNT(*) total_count
FROM extras_toppings e
JOIN pizza_toppings p
ON e.extras_id = p.topping_id
GROUP BY extras_id, topping_name
ORDER BY total_count DESC
LIMIT 1 ;
```
**Output:**\
![image](https://github.com/user-attachments/assets/cfde65a8-10ce-4326-b13b-2451ada37351)

### 3. What was the most common exclusion?
```sql
SELECT exclusions_id,excluded_topping_name, COUNT(*) total_count
FROM excluded_toppings 
GROUP BY exclusions_id,excluded_topping_name
ORDER BY total_count DESC
LIMIT 1;
```
**Output:**\
![image](https://github.com/user-attachments/assets/9c458621-81b5-4bd0-8ad9-12ec4bfbef5e)

### 4. Generate an order item for each record in the `customers_orders` table in the format of one of the following:
   - `Meat Lovers`
   - `Meat Lovers - Exclude Beef`
   - `Meat Lovers - Extra Bacon`
   - `Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers`
```sql
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
```
**Output:**\
![image](https://github.com/user-attachments/assets/56c32041-ff9a-44e3-b6cc-e8001b5d95a0)


