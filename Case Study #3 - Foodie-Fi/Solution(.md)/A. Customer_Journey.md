# A. Customer Journey

**Question:**
Based off the 8 sample customers provided in the sample from the `subscriptions` table, write a brief description about each customer’s onboarding journey.
Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

**Solution:**
```sql
SELECT *
FROM subscriptions s
JOIN plans p
ON s.plan_id = p.plan_id
WHERE customer_id IN (1, 2, 11, 13, 15, 16,18,19);
```

**Sample Customers**:\
![image](https://github.com/user-attachments/assets/4d70b6d0-5765-41f8-81dc-8662dbed238c)

