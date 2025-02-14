# B. Data analysis Questions
### 1. How many customers has Foodie-Fi ever had?
```sql
SELECT count(DISTINCT customer_id) customer_count
FROM subscriptions;
```
**Output:**\
![image](https://github.com/user-attachments/assets/dee48520-ee8f-43d1-a0e3-136e8f53dcfc)

### 2. What is the monthly distribution of `trial` plan `start_date` values for our dataset - use the start of the month as the group by value
```sql
SELECT monthname(start_date) `month`, count(*) trial_count
FROM subscriptions s
JOIN plans p
ON s.plan_id = p.plan_id
WHERE plan_name = 'trial'
GROUP BY MONTH(start_date), MONTHNAME(start_date)
ORDER BY MONTH(start_date);
```
**Output:**\
![image](https://github.com/user-attachments/assets/0894d0f4-3da4-4942-bbc1-f28f94823215)

### 3. What plan `start_date` values occur after the year 2020 for our dataset? Show the breakdown by count of events for each `plan_name`
```sql
SELECT s.plan_id,plan_name, COUNT(*) total_count
FROM subscriptions s
JOIN plans p
ON s.plan_id = p.plan_id
WHERE YEAR(start_date) > 2020
GROUP BY s.plan_id, plan_name
ORDER BY s.plan_id;
```
**Output:**\
![image](https://github.com/user-attachments/assets/9954145e-86b5-4794-94ea-4597e8e3ee62)

### 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
```sql
SELECT plan_name, COUNT(*) churned_count ,
	concat(round(100 * COUNT(*) / (select COUNT(DISTINCT customer_id) FROM subscriptions) ,1) , '%') churn_percentage
FROM subscriptions s1
JOIN plans p
ON s1.plan_id = p.plan_id
WHERE plan_name = 'churn';
```
**Output:**\
![image](https://github.com/user-attachments/assets/7c345a87-4214-4b06-b5c1-f72443904c24)

### 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
```sql
SELECT COUNT(*) churned_count, 
	CONCAT(ROUND(100 *  COUNT(*) / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions)), '%') churned_percentage
FROM (
	SELECT s.plan_id,plan_name, ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY start_date) rownum
	FROM subscriptions s
	JOIN plans p
	ON s.plan_id = p.plan_id
) as row_num
WHERE rownum = 2 AND plan_id = 4;
```
**Output:**\
![image](https://github.com/user-attachments/assets/4ac0de65-77fc-42d1-9b53-74ada8a3f2be)

### 6. What is the number and percentage of customer plans after their initial free trial?
```sql
SELECT plan_id, plan_name, COUNT(*) plan_count,
	CONCAT(ROUND(100 *  COUNT(*) / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 1), '%') plan_percentage
FROM (
	SELECT s.plan_id,plan_name, ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY start_date) rownum
	FROM subscriptions s
	JOIN plans p
	ON s.plan_id = p.plan_id
) as s
WHERE rownum =2
GROUP BY plan_id,plan_name
ORDER BY plan_id;
```
**Output:**\
![image](https://github.com/user-attachments/assets/5d98aade-d4e6-4c8c-88cb-8795e7088f2a)

### 7. What is the customer count and percentage breakdown of all 5 `plan_name` values at `2020-12-31`?
```sql
SELECT plan_id, 
plan_name,CONCAT(ROUND(100 * COUNT(*)/ (SELECT COUNT(DISTINCT customer_id) FROM subscriptions) , 1) , '%') plan_perc
FROM (SELECT s.plan_id,customer_id, start_date,plan_name,price, ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY start_date DESC) rownum
FROM subscriptions s
JOIN plans p
ON s.plan_id = p.plan_id
WHERE start_date <= '2020-12-31') temp
WHERE rownum =1
GROUP BY plan_id, plan_name;
```
**Output:**\
![image](https://github.com/user-attachments/assets/a8820a4e-8ecb-4301-a1f6-a210c69c886b)

### 8. How many customers have upgraded to an annual plan in 2020?
```sql
SELECT COUNT(DISTINCT customer_id) annual_plan_count
FROM subscriptions s
JOIN plans p
ON s.plan_id = p.plan_id
WHERE YEAR(start_date) = 2020 AND s.plan_id = 3;
```
**Output:**\
![image](https://github.com/user-attachments/assets/8cadbd48-4809-41f3-afa7-98fd7ac18dee)

### 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
```sql
WITH t1 AS
(
	SELECT  DATEDIFF(start_date, LAG(start_date) OVER (PARTITION BY customer_id)) date_diff
	FROM subscriptions s
	JOIN plans p
	ON s.plan_id = p.plan_id
	WHERE s.plan_id in (0,3)
	ORDER BY customer_id,s.plan_id,start_date
)
SELECT ROUND(AVG(date_diff)) avg_date
FROM t1;
```
**Output:**\
![image](https://github.com/user-attachments/assets/6d2a48b8-8afd-4780-a705-9120c2c0edd4)

### 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
```sql
WITH t1 AS 
(
	SELECT  s.plan_id,customer_id,DATEDIFF(start_date, LAG(start_date) OVER (PARTITION BY customer_id)) date_diff
	FROM subscriptions s
	JOIN plans p
	ON s.plan_id = p.plan_id
	WHERE s.plan_id in (0,3)
	ORDER BY customer_id,s.plan_id,start_date
), t2 AS
(
SELECT *,
	CASE WHEN date_diff BETWEEN 0 AND 30 THEN '0-30 days' 
		 WHEN date_diff BETWEEN 31 AND 60 THEN '31-60 days'
         WHEN date_diff BETWEEN 61 AND 90 THEN '61-90 days'
         WHEN date_diff BETWEEN 91 AND 120 THEN  '91-120 days'
         WHEN date_diff BETWEEN 121 AND 150 THEN '121-150 days'
         WHEN date_diff BETWEEN 151 AND 180 THEN '151-180 days'
		 WHEN date_diff BETWEEN 181 AND 210 THEN '181-210 days'
		 WHEN date_diff BETWEEN 211 AND 240 THEN '211-240 days'
		 WHEN date_diff BETWEEN 241 AND 270 THEN '241-270 days'
		 WHEN date_diff BETWEEN 271 AND 300 THEN '271-300 days'
		 WHEN date_diff BETWEEN 301 AND 330 THEN '301-330 days'
		 WHEN date_diff BETWEEN 331 AND 360 THEN '331-360 days'
	END AS date_breakdown
FROM t1)

SELECT TRIM(date_breakdown) date_breakdown, ROUND(AVG(date_diff)) avg_date_diff,
		COUNT(DISTINCT customer_id) customer_count
FROM t2
WHERE date_breakdown IS NOT NULL
GROUP BY date_breakdown
ORDER BY CAST(SUBSTRING_INDEX(date_breakdown, '-', 1) AS UNSIGNED);
```
**Output:**\
![image](https://github.com/user-attachments/assets/11e0f920-7ef2-401f-b694-3acc230fca06)

### 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
```sql
SELECT COUNT(*) downgrade_count
FROM subscriptions s1
JOIN subscriptions s2
ON s1.customer_id = s2.customer_id 
WHERE YEAR(s2.start_date) = 2020 
   AND s1.plan_id = 2
   AND s2.plan_id = 1
   AND s1.start_date < s2.start_date;
```
**Output:**\
![image](https://github.com/user-attachments/assets/f4e1f34c-2b1d-4e1d-bd1d-baebd91ae159)









