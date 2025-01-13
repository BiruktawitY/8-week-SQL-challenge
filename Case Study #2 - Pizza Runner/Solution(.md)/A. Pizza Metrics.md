# Pizza Metrics 🍕
### 1. How many pizzas were ordered?
```sql
SELECT COUNT(*) total_orders
FROM customer_orders_copy;
```
**Output**:\
![image](https://github.com/user-attachments/assets/e834f34c-2ac8-4f9c-98b0-36e403cbfdca)


### 2. How many unique customer orders were made?
```sql
SELECT COUNT(DISTINCT order_id) unique_orders
FROM customer_orders_copy;
```

**Output**:\
![image](https://github.com/user-attachments/assets/ed278a9d-3458-48bf-a7dc-964b3f12db36)


### 3. How many successful orders were delivered by each runner?
```sql
SELECT runner_id,COUNT(	order_id) successful_orders
FROM runner_orders_copy
WHERE cancellation IS NULL
GROUP BY runner_id;
```

**Output**:\
![image](https://github.com/user-attachments/assets/21ced7ed-1768-4923-b2eb-d3de119430db)

### 4. How many of each type of pizza was delivered?
```sql
SELECT pizza_name, COUNT(*) total_count 
FROM customer_orders_copy c
JOIN runner_orders_copy  r
ON c.order_id = r.order_id
JOIN pizza_names p
ON c.pizza_id = p.pizza_id
WHERE cancellation IS NULL
GROUP BY pizza_name;
```
**Output**:\
![image](https://github.com/user-attachments/assets/df00fac0-5641-4d54-9cd5-a23f434e8891)

### 5. How many Vegetarian and Meatlovers were ordered by each customer?
```sql
SELECT customer_id,
	SUM(CASE WHEN pizza_id = 1 THEN 1 ELSE 0 END) AS Meatlovers,
    SUM(CASE WHEN pizza_id = 2 THEN 1 ELSE 0 END) AS Vegetarian
FROM customer_orders_copy c
GROUP BY customer_id;
```
**Output**:\
![image](https://github.com/user-attachments/assets/caa6dbb3-3ad3-40d2-b1f6-dd3bc620ac93)

### 6.What was the maximum number of pizzas delivered in a single order?
```sql
SELECT  MAX(pizza_count) max_pizza
FROM (
SELECT c.order_id, COUNT(*) pizza_count
FROM customer_orders_copy c
JOIN runner_orders_copy  r
ON c.order_id = r.order_id
WHERE cancellation IS NULL
GROUP BY c.order_id) counted;
```
**Output**:\
![image](https://github.com/user-attachments/assets/05d8537c-a258-45cc-b9ae-f2c82b3cd94b)


### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
```sql
SELECT customer_id, 
	SUM(CASE WHEN exclusions IS NULL AND extras IS NULL THEN 1 ELSE 0 END) no_change,
    SUM(CASE WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN 1 ELSE 0 END) has_change
FROM customer_orders_copy c
JOIN runner_orders_copy  r
ON c.order_id = r.order_id
WHERE cancellation IS NULL
GROUP BY customer_id;
```
**Output**:\
![image](https://github.com/user-attachments/assets/0a055fde-7fc3-4732-80c3-f7d4d0c8bdc0)

### 8. How many pizzas were delivered that had both exclusions and extras?
```sql
SELECT COUNT(*) both_change
FROM customer_orders_copy c
JOIN runner_orders_copy  r
ON c.order_id = r.order_id
WHERE cancellation IS NULL 
AND exclusions AND extras IS NOT NULL;
```
**Output**:\
![image](https://github.com/user-attachments/assets/e3cdc596-8f6c-427d-80d3-fdd730431d20)

### 9. What was the total volume of pizzas ordered for each hour of the day?
```sql
SELECT HOUR(order_time) hour_of_the_day, COUNT(pizza_id) pizza_volume
FROM customer_orders_copy
GROUP BY HOUR(order_time);
```
**Output**:\
![image](https://github.com/user-attachments/assets/f267b87e-5b28-498a-93a2-3cd363b0c19f)

### 10.  What was the volume of orders for each day of the week?
```sql
SELECT DAYNAME(order_time) day_of_the_week, COUNT(pizza_id) pizza_volume
FROM customer_orders_copy
GROUP BY day_of_the_week;
```
**Output**:\
![image](https://github.com/user-attachments/assets/2b818219-7f93-4c7b-8498-f5cfe00a6a1e)




