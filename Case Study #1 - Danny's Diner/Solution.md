## Solutions

1. What is the total amount each customer spent at the restaurant
```sql
SELECT s.customer_id, SUM(price)
FROM sales s
JOIN menu m
ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;
```
**Output**:\
![image](https://github.com/user-attachments/assets/b9aca37d-a599-4934-819b-cb00f6c992d9) 

2. How many days has each customer visited the restaurant?
```sql
SELECT customer_id, COUNT(DISTINCT order_date)
FROM sales
GROUP BY customer_id;
```

**Output**:\
![image](https://github.com/user-attachments/assets/4973faea-09f7-4ad5-8e07-71d991b8ab68)

3. What was the first item from the menu purchased by each customer?
```sql
SELECT DISTINCT customer_id, product_name
FROM(
SELECT customer_id, RANK() OVER(PARTITION BY customer_id ORDER BY order_date) f_item, s.product_id,product_name
FROM sales s
JOIN menu m
ON s.product_id = m.product_id) ranked 
WHERE f_item = 1;
```

**Output**:\
![image](https://github.com/user-attachments/assets/d75e5c48-0f59-441e-9d63-c77cbff1a3fb)

4. What is the most purchased item on the menu and how many times was it purchased by all customers?
```sql
SELECT product_name, count(*) total_num
FROM sales s
JOIN menu m
ON s.product_id = m.product_id
GROUP BY product_name;
```

**Output**\
![image](https://github.com/user-attachments/assets/0777d4c4-16a2-4c6e-b4a4-475b6dc6fe7b)

5. Which item was the most popular for each customer?
```sql
SELECT customer_id, product_id, product_count
FROM (
    SELECT 
        customer_id, 
        product_id,
        COUNT(*) AS product_count, 
        RANK() OVER (PARTITION BY customer_id ORDER BY COUNT(*) DESC) AS popularity_rank 
    FROM sales
    GROUP BY customer_id, product_id
) AS ranked
WHERE popularity_rank = 1; 
```

**Output**:\
![image](https://github.com/user-attachments/assets/c341b0f3-62c3-41c1-b7a4-ef47f017e74d)

6. Which item was purchased first by the customer after they became a member?
```sql
SELECT customer_id, product_id
FROM(
SELECT s.customer_id, RANK() OVER (PARTITION BY s.customer_id ORDER BY order_date) ranked,product_id
FROM sales s
JOIN members m
ON s.customer_id = m.customer_id
AND order_date - join_date >= 0 ) first_item
WHERE ranked = 1;
```

**Output**:\
![image](https://github.com/user-attachments/assets/bf2bc5e5-9b31-48bc-b10c-1b297176fd14)

7. Which item was purchased just before the customer became a member?
```sql
SELECT customer_id, product_id
FROM(SELECT s.customer_id, RANK() OVER (PARTITION BY s.customer_id ORDER BY order_date desc) ranked,product_id
FROM sales s
JOIN members m
ON s.customer_id = m.customer_id
AND order_date - join_date < 0) last_item
WHERE ranked = 1;
```

**Output**:\
![image](https://github.com/user-attachments/assets/93bcac46-5d82-40f1-8d7c-8856968f7459)

8. What is the total items and amount spent for each member before they became a member?
```sql
SELECT s.customer_id, SUM(price) total_spent, COUNT(*) total_item
FROM sales s
JOIN members m
ON s.customer_id = m.customer_id
AND order_date - join_date < 0 
JOIN menu 
ON s.product_id = menu.product_id
GROUP BY s.customer_id;
```

**Output**:\
![image](https://github.com/user-attachments/assets/22a56d94-4d3a-4199-af2c-0c63fbf391b5)

9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
```sql
SELECT 
    s.customer_id, 
    SUM(
        CASE 
            WHEN m.product_name = 'sushi' THEN price * 20  
            ELSE price * 10  END
    ) AS total_points
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;
```

**Output**:\
![image](https://github.com/user-attachments/assets/5b7320b0-6f4a-48ca-9227-a046189b70c4)

10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
```sql
WITH count_points AS(
  SELECT s.customer_id, order_date, join_date, product_name,price,
  (CASE
   	WHEN product_name = 'sushi' THEN 20
    WHEN order_date BETWEEN join_date AND join_date +6 THEN 20
    ELSE 10
   END) points
  FROM sales s
  JOIN  menu m 
  ON s.product_id = m.product_id
  JOIN members 
  ON s.customer_id = members.customer_id
) 

SELECT customer_id, 
	SUM(points * price) as total_points
FROM count_points
WHERE  order_date <= '2021-01-31'
GROUP BY customer_id;
```

**Output**:\
![image](https://github.com/user-attachments/assets/0995dad9-b6c1-4d0f-89e8-55db53892e43)


## Bonus Question
Join all things:
```sql
SELECT s.customer_id, order_date, product_name, price,
	CASE WHEN join_date <= order_date THEN 'Y' 
    	 ELSE 'N' END AS members
FROM sales s
JOIN menu 
on s.product_id = menu.product_id
LEFT JOIN members m
ON s.customer_id = m.customer_id
ORDER BY s.customer_id, order_date;
```

**Output**:\
![image](https://github.com/user-attachments/assets/72301b70-2aac-4649-a5a4-5245415877b2)

Rank all the things:
```sql
With joined AS
( SELECT s.customer_id, order_date, product_name, price,
	CASE WHEN join_date <= order_date THEN 'Y' 
    	 ELSE 'N' END AS members
FROM sales s
JOIN menu 
on s.product_id = menu.product_id
LEFT JOIN members m
ON s.customer_id = m.customer_id
ORDER BY s.customer_id, order_date)
SELECT *,
 ( CASE WHEN members = 'Y' THEN RANK()OVER(PARTITION BY customer_id,members ORDER BY order_date)  
        ELSE null END) as ranking
FROM joined;
```
**Output**:\
![image](https://github.com/user-attachments/assets/f6e63219-e380-44a1-b238-e0b8878aca35)

