# D. Pricing and Rating
### 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
```sql
SELECT 
	CONCAT('$', SUM(CASE WHEN pizza_name = 'Meatlovers' THEN 12 ELSE 10 END)) as total_pay
FROM runner_orders_copy r
JOIN customer_orders_copy c
ON r.order_id = c.order_id
JOIN pizza_names p
ON c.pizza_id = p.pizza_id
WHERE cancellation IS NULL;
```
**Output:**\
![image](https://github.com/user-attachments/assets/671d7f61-9ea9-4450-9fe5-81983e40345d)

### 2. What if there was an additional $1 charge for any pizza extras?
  - Add cheese is $1 extra
```sql
WITH t1 AS
(
SELECT  LENGTH(extras) - LENGTH(REPLACE(extras,',','')) + 1 as extras_count,
		CASE WHEN pizza_name = 'Meatlovers' THEN 12 ELSE 10 END total_amount
FROM runner_orders_copy r
JOIN customer_orders_copy c
ON r.order_id = c.order_id
JOIN pizza_names p
ON c.pizza_id = p.pizza_id
WHERE cancellation IS NULL
)
 SELECT CONCAT('$', SUM(CASE WHEN extras_count IS NOT NULL THEN ( 1 * extras_count) + total_amount ELSE total_amount END)) total
 FROM t1;
```
**Output:**\
![image](https://github.com/user-attachments/assets/a50bae1d-0b9e-4004-bb03-ecb1c7982377)

### 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
```sql
SELECT *
FROM runner_orders_copy;

DROP TABLE IF EXISTS customers_ratings ;
CREATE TABLE customers_ratings (order_id INT, rating INT);

INSERT INTO customers_ratings
VALUES 
	(1, 4) , (2, 3), (3, 2), (4,5), (5,3), (7,4), (8,3), (10, 5);
    
SELECT *
FROM customers_ratings;
```
**Output:**\
![image](https://github.com/user-attachments/assets/0cf68415-b853-4890-8969-2a993f583ec1)

### 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
- `customer_id`, `order_id`, `runner_id`, `rating`, `order_time`, `pickup_time`, Time between order and pickup, Delivery duration, Average speed, Total number of pizzas
```sql
SELECT customer_id, c1.order_id,runner_id,rating, order_time, pickup_time,  
	TIMESTAMPDIFF(MINUTE, order_time, pickup_time) timediff_in_min, ROUND(AVG(distance /(duration / 60) ), 2) `Avg_speed(km/hr)`,  COUNT(pizza_id) pizza_count
FROM customer_orders_copy c1
JOIN runner_orders_copy  r
ON c1.order_id = r.order_id
JOIN customers_ratings c2
ON c1.order_id = c2.order_id
GROUP BY customer_id, c1.order_id,runner_id,rating, order_time, pickup_time
ORDER BY customer_id;
```
**Output:**\
![image](https://github.com/user-attachments/assets/c51597b5-f174-4a60-a75f-6df3810b298f)

### 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
```sql
WITH t1 AS(
SELECT *,
	 CASE WHEN pizza_name = 'Meatlovers' THEN 12 ELSE 10 END as total_cost
FROM customer_orders_copy c
JOIN pizza_names p
ON c.pizza_id = p.pizza_id
ORDER BY c.order_id)

SELECT CONCAT('$',(SUM(total_cost) - SUM(0.3 * distance))) profit
FROM runner_orders_copy r
JOIN (
		SELECT c.order_id,
			SUM( CASE WHEN pizza_name = 'Meatlovers' THEN 12 ELSE 10 END) as total_cost
		FROM customer_orders_copy c
		JOIN pizza_names p
		ON c.pizza_id = p.pizza_id
		GROUP BY c.order_id) t1
ON r.order_id = t1.order_id
WHERE cancellation IS NULL ;
```
**Output:**\
![image](https://github.com/user-attachments/assets/ae721743-bad6-45fd-8138-136332b5af64)

