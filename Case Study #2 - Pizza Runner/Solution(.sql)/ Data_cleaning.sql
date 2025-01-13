-- Data cleaning

-- Cleaning customer_orders table
SELECT * 
FROM pizza_runner.customer_orders;

-- creating a copy of the customer_orders table
CREATE TABLE customer_orders_copy
LIKE customer_orders;

INSERT INTO customer_orders_copy
SELECT *
FROM customer_orders;

-- Ensuring every values is copied to the table
SELECT *
FROM customer_orders_copy;

-- cleaning missing values 
UPDATE customer_orders_copy
SET exclusions = CASE WHEN exclusions IN ('' , 'null') THEN exclusions = null ELSE exclusions END,
	extras = CASE WHEN extras IN ('' , 'null') THEN extras = null ELSE extras END;

-- Cleaning runners table
SELECT *
FROM runner_orders;

CREATE TABLE runner_orders_copy
LIKE runner_orders;

INSERT INTO runner_orders_copy
SELECT *
FROM runner_orders;

SELECT *
FROM runner_orders_copy;

UPDATE runner_orders_copy
SET pickup_time = CASE WHEN pickup_time IN ('' , 'null') THEN pickup_time = null ELSE pickup_time END,
	distance = CASE WHEN distance IN ('' , 'null') THEN distance = null ELSE distance END,
    duration = CASE WHEN duration IN ('' , 'null') THEN duration = null ELSE duration END,
    cancellation = CASE WHEN cancellation IN ('' , 'null') THEN cancellation = null ELSE cancellation END;

UPDATE runner_orders_copy
SET distance = REPLACE(distance, 'km', ''), duration = REPLACE(duration, 'minutes',''), 
	duration = REPLACE(duration, 'mins',''),duration = REPLACE(duration, 'minute','');

SELECT *
FROM runner_orders_copy;
 
