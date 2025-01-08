## Solutions

1. What is the total amount each customer spent at the restaurant
```sql
/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
SELECT s.customer_id, SUM(price)
FROM sales s
JOIN menu m
ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- 2. How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(DISTINCT order_date)
FROM sales
GROUP BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?
SELECT DISTINCT customer_id, product_name
FROM(
SELECT customer_id, RANK() OVER(PARTITION BY customer_id ORDER BY order_date) f_item, s.product_id,product_name
FROM sales s
JOIN menu m
ON s.product_id = m.product_id) ranked 
WHERE f_item = 1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT product_name, count(*) total_num
FROM sales s
JOIN menu m
ON s.product_id = m.product_id
GROUP BY product_name;

-- 5. Which item was the most popular for each customer?
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
WHERE popularity_rank = 1
; 

-- 6. Which item was purchased first by the customer after they became a member?
SELECT customer_id, product_id
FROM(
SELECT s.customer_id, RANK() OVER (PARTITION BY s.customer_id ORDER BY order_date) ranked,product_id
FROM sales s
JOIN members m
ON s.customer_id = m.customer_id
AND order_date - join_date >= 0 ) first_item
WHERE ranked = 1
;

-- 7. Which item was purchased just before the customer became a member?
SELECT customer_id, product_id
FROM(SELECT s.customer_id, RANK() OVER (PARTITION BY s.customer_id ORDER BY order_date desc) ranked,product_id
FROM sales s
JOIN members m
ON s.customer_id = m.customer_id
AND order_date - join_date < 0) last_item
WHERE ranked = 1;

-- 8. What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id, SUM(price) total_spent, COUNT(*) total_item
FROM sales s
JOIN members m
ON s.customer_id = m.customer_id
AND order_date - join_date < 0 
JOIN menu 
ON s.product_id = menu.product_id
GROUP BY s.customer_id;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
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

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
SELECT s.customer_id,
2 * SUM(
  CASE WHEN order_date - join_date <= 7 OR product_name = 'sushi'  THEN 20*price
     ELSE 10 * price
  END ) points
FROM sales s
JOIN members m
ON s.customer_id = m.customer_id
AND join_date <= order_date 
JOIN menu 
 ON s.product_id = menu.product_id
WHERE order_date <= '2021-01-31'
GROUP BY s.customer_id;

-- Bonus Question
-- Join all things
SELECT s.customer_id, order_date, product_name, price,
	CASE WHEN join_date <= order_date THEN 'Y' 
    	 ELSE 'N' END AS members
FROM sales s
JOIN menu 
on s.product_id = menu.product_id
LEFT JOIN members m
ON s.customer_id = m.customer_id
ORDER BY s.customer_id, order_date;

-- Rank all the things
