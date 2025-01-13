-- Pizza Metrics
-- 1. How many pizzas were ordered?
SELECT COUNT(*) total_orders
FROM customer_orders_copy;

-- 2.  How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) unique_orders
FROM customer_orders_copy;

-- 3. How many successful orders were delivered by each runner?
SELECT runner_id,COUNT(	order_id) successful_orders
FROM runner_orders_copy
WHERE cancellation IS NULL
GROUP BY runner_id;

-- 4. How many of each type of pizza was delivered?
SELECT pizza_name, COUNT(*) total_count 
FROM customer_orders_copy c
JOIN runner_orders_copy  r
ON c.order_id = r.order_id
JOIN pizza_names p
ON c.pizza_id = p.pizza_id
WHERE cancellation IS NULL
GROUP BY pizza_name;

-- 5.How many Vegetarian and Meatlovers were ordered by each customer?
SELECT customer_id,
	SUM(CASE WHEN pizza_id = 1 THEN 1 ELSE 0 END) AS Meatlovers,
    SUM(CASE WHEN pizza_id = 2 THEN 1 ELSE 0 END) AS Vegetarian
FROM customer_orders_copy c
GROUP BY customer_id;

-- 6.What was the maximum number of pizzas delivered in a single order?
SELECT  MAX(pizza_count) max_pizza
FROM (
SELECT c.order_id, COUNT(*) pizza_count
FROM customer_orders_copy c
JOIN runner_orders_copy  r
ON c.order_id = r.order_id
WHERE cancellation IS NULL
GROUP BY c.order_id) counted;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT customer_id, 
	SUM(CASE WHEN exclusions IS NULL AND extras IS NULL THEN 1 ELSE 0 END) no_change,
    SUM(CASE WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN 1 ELSE 0 END) has_change
FROM customer_orders_copy c
JOIN runner_orders_copy  r
ON c.order_id = r.order_id
WHERE cancellation IS NULL
GROUP BY customer_id;

-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(*) both_change
FROM customer_orders_copy c
JOIN runner_orders_copy  r
ON c.order_id = r.order_id
WHERE cancellation IS NULL 
AND exclusions AND extras IS NOT NULL;

-- 9.What was the total volume of pizzas ordered for each hour of the day?
SELECT HOUR(order_time) hour_of_the_day, COUNT(pizza_id) pizza_volume
FROM customer_orders_copy
GROUP BY HOUR(order_time);

-- 10. What was the volume of orders for each day of the week?
SELECT DAYNAME(order_time) day_of_the_week, COUNT(pizza_id) pizza_volume
FROM customer_orders_copy
GROUP BY day_of_the_week;
