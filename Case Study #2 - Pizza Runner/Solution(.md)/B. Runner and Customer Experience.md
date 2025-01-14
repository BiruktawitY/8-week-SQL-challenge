# Runner and Customer Experience

### 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)?
```sql
SELECT  FLOOR(days_num / 7) + 1 week_number, COUNT(*) runner_signups
FROM(
SELECT *, DATEDIFF(registration_date, '2021-01-01') days_num
FROM runners) as date_diff
GROUP BY week_number;
```
**Output**:\
![Screenshot 2025-01-13 154412](https://github.com/user-attachments/assets/b1194482-71e7-465a-92f7-d4d54af6cce1)

### 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
```sql
SELECT runner_id,ROUND(AVG(TIMESTAMPDIFF(MINUTE, order_time, pickup_time))) avg_min
FROM customer_orders_copy c
JOIN runner_orders_copy r
ON c.order_id = r.order_id
GROUP BY runner_id;
```
**Output**:\
![image](https://github.com/user-attachments/assets/3aaf4960-2d6a-4d9b-a18c-09546dddbc22)

### 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
```sql
WITH t1 AS(
SELECT TIMESTAMPDIFF(MINUTE, order_time, pickup_time) time_diff, COUNT(pizza_id) OVER(PARTITION BY c.order_id) pizza_count
FROM customer_orders_copy c
JOIN runner_orders_copy r
ON c.order_id = r.order_id
)
SELECT pizza_count, ROUND(AVG(time_diff)) avg_min
FROM t1
GROUP BY pizza_count;
```
**Output**:\
![image](https://github.com/user-attachments/assets/14560189-dac4-4977-8199-2baa511931c7)


### 4. What was the average distance travelled for each customer?
```sql
SELECT customer_id, ROUND(AVG(distance), 2) avg_distance_in_km
FROM customer_orders_copy c
JOIN runner_orders_copy r
ON c.order_id = r.order_id
GROUP BY customer_id;
```
**Output**:\
![image](https://github.com/user-attachments/assets/b760fc12-e9f2-49f1-8102-956ecb11a1cd)

### 5. What was the difference between the longest and shortest delivery times for all orders?
```sql
SELECT MIN(duration) shortest_duration, MAX(duration) longest_duration , MAX(duration) - MIN(duration) duration_diff
FROM customer_orders_copy c
JOIN runner_orders_copy r
ON c.order_id = r.order_id;
```
**Output**:\
![image](https://github.com/user-attachments/assets/d74e49be-11ed-4ad8-9803-1a499fd29fa2)

### 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
```sql
SELECT runner_id, c.order_id,ROUND(AVG(distance /(duration / 60) ), 2) `Avg_speed(km/hr)`
FROM customer_orders_copy c
JOIN runner_orders_copy r
ON c.order_id = r.order_id
WHERE cancellation IS NULL
GROUP BY runner_id, c.order_id
ORDER BY runner_id;
```
**Output**:\
![image](https://github.com/user-attachments/assets/15af4441-cb69-4fac-9603-3f1ffe649fa0)


### 7. What is the successful delivery percentage for each runner?
```sql
SELECT runner_id, CONCAT(ROUND(100 * COUNT(pickup_time) / COUNT(*) ,1), '%') success_percentage
FROM runner_orders_copy 
GROUP BY runner_id;
```
**Output**:\
![image](https://github.com/user-attachments/assets/85635a02-29a5-45fa-b5ab-2c679f232d1a)

