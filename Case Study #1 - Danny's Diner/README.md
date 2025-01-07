# CASE STUDY #1- Danny's Diner
![image](https://github.com/user-attachments/assets/d6e0568c-411b-41a5-ae72-ea836f30556c)

## Introduction 
Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.
Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.

## Data
Danny has shared 3 key datasets for this case study:
- `sales`
- `menu`
- `members`

### Table 1: `sales`
The `sales` table captures all `customer_id` level purchases with an corresponding `order_data` and `product_id` information for when and what menu items were ordered.\
![image](https://github.com/user-attachments/assets/53ed3894-33b7-4c66-b835-db1bdc9cb86f)

### Table 2: `menu`
The `menu` table maps the `product_id` to the actual `product_name` and `price` of each menu item.\
![image](https://github.com/user-attachments/assets/f87745f5-52e2-4d2a-85f1-c451158517e5)

### Table 3:`members`
The `members` table captures the `join_date` when a `customer_id` joined the beta version of the Danny's Diner loyalty program.\
![image](https://github.com/user-attachments/assets/cc2e4c18-5d4a-4aa0-bc29-504085aed986)

## Data source: 
 [click here](https://8weeksqlchallenge.com/case-study-1/)

## Task Question
1. What is the total amount each customer spent at the restaurant?\
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

## Bonus Questions
### Join All the Things
The following questions are related creating basic data tables that Danny and his team can use to quickly derive insights without needing to join the underlying tables using SQL.

Recreate the following table output using the available data:
![image](https://github.com/user-attachments/assets/16bac1cd-f733-4b82-8b27-8691a1569802)

### Rank All the Things 
Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.
![image](https://github.com/user-attachments/assets/475b3918-193b-43fb-82bb-e9ee7ca285d3)

##Solution 
[click here](









