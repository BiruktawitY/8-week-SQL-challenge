# Case Study #2 - Pizza Runner 🍕🍕
![image](https://github.com/user-attachments/assets/044621bb-c3dc-4287-ba04-69ba01218f02)

## Table Of Contents
 - [Introduction](#introduction)
 - [Data Cleaning](#data-cleaning)
 - [Skills applied](#skills-applied)
 - [Data](#data)
 - [Entity Relationship Diagram](#entity-relationship-diagram)
 - [Case Study Questions](#case-study-questions)
 - [Solutions](#solutions)


## Introduction
Danny was scrolling through his Instagram feed when something really caught his eye - "80s Retro Styling and Pizza Is the Future!". \
Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it, he was going to *Uberize* it, and so Pizza Runner was launche!\
Danny started by recruitng "runners" to deliver fresh pizza from Pizza Runner Headquarters(otherwise known as Danny's house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

## Data Cleaning
For detailed steps on how I prepared and cleaned some of the tables used our analysis, please click [here](https://github.com/BiruktawitY/8-week-SQL-challenge/blob/main/Case%20Study%20%232%20-%20Pizza%20Runner/Solution(.md)/Data_cleaning.md)

## Skills applied
The topics relevant to this case study are:
- CTE's(Common Table Expressions)
- Group by aggregates
- Table Joins
- String transformations
- Dealing with null values
- Regular expressions

## Data 
Danny has shared 6 datasets for this case study:
- `runners`
- `customer_orders`
- `runner_orders`
- `pizza_names`
- `pizza_recipes`
- `pizza_toppings`

## Entity Relationship Diagram 
![image](https://github.com/user-attachments/assets/a0b8b08e-ef84-47b4-af05-2ad1a8443db6)

## Data Source
This datasets is part of the [8-Week SQL Challenge](https://8weeksqlchallenge.com/case-study-2/)

## Case Study Questions
This case study is broken up by areas of foucses including:
- Pizza Metrics
- Runner and Customer Experience
- Ingredient Optimisation
- Pricing and Ratings
- Bonus Data Manipulation language Challenges

### A. Pizza Metrics 
1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?
    
 [View my solution here for Pizza Metrics](https://github.com/BiruktawitY/8-week-SQL-challenge/blob/main/Case%20Study%20%232%20-%20Pizza%20Runner/Solution(.md)/A.%20Pizza%20Metrics.md)

 ### B. Runner and Customer Experience
 1. How many runners signed up for each 1 week period? (i.e. week starts `2021-01-01`)
 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
 4. What was the average distance travelled for each customer?
 5. What was the difference between the longest and shortest delivery times for all orders?
 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
 7. What is the successful delivery percentage for each runner?

  [View my solution here for Runner and Customer Experience](https://github.com/BiruktawitY/8-week-SQL-challenge/blob/main/Case%20Study%20%232%20-%20Pizza%20Runner/Solution(.md)/B.%20Runner%20and%20Customer%20Experience.md)

  ### C. Ingredient Optimisation
  1. What are the standard ingredients for each pizza?
  2. What was the most commonly added extra?
  3. What was the most common exclusion?
  4. Generate an order item for each record in the `customers_orders` table in the format of one of the following:\
         - `Meat Lovers`\
         - `Meat Lovers - Exclude Beef`\
         - `Meat Lovers - Extra Bacon`\
         - `Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers`
  5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the `customer_orders` table and add a `2x` in front of any relevant 
     ingredients
    - For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

 [View my solution here for Ingredient Optimisation](https://github.com/BiruktawitY/8-week-SQL-challenge/blob/main/Case%20Study%20%232%20-%20Pizza%20Runner/Solution(.md)/C.%20Ingredient_Optimisation.md)
 
### D. Pricing and Ratings
1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
2. What if there was an additional $1 charge for any pizza extras?
     - Add cheese is $1 extra
3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
     - `customer_id`
     - `order_id`
     - `runner_id`
     - `rating`
     - `order_time`
     - `pickup_time`
     - Time between order and pickup
     - Delivery duration
     - Average speed
     - Total number of pizzas
5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
   
 [View my solution here for Pricing and Ratings](https://github.com/BiruktawitY/8-week-SQL-challenge/blob/main/Case%20Study%20%232%20-%20Pizza%20Runner/Solution(.md)/D.%20Pricing%20and%20Ratings.md)

 ## Solutions 
 - View the full syntax [here](https://github.com/BiruktawitY/8-week-SQL-challenge/tree/main/Case%20Study%20%232%20-%20Pizza%20Runner/Solution(.sql))
 - View the full explanation and results [here](https://github.com/BiruktawitY/8-week-SQL-challenge/tree/main/Case%20Study%20%232%20-%20Pizza%20Runner/Solution(.md))









