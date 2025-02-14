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

### 1. Customer 1:
 - Started the `free trial` on August 1st, 2020, and upgraded to `basic monthly` during the trial period.
### 2. Customer 2:   
   - Started the `free trial` on September 20th, 2020,and uprgaded to `pro annual` during the trial period.
### 3. Customer 11:
  - Started the `free trial` on Novemeber 29th, 2020, and canceled the subscriptiong during the trial period.
### 4. Customer 13:
  - Strarted the `free trial` on December 15th, 2020, upgraded to `basic monthly` during the trial period, and then upgraded to `pro monthly` with effective start date of March 29th, 2021.
### 5. Customer 15:
  - Started the `free trial` on March 3rd, 2020, uprgraded to `pro monthly` during the trial period, and canceled the subscription with effective start date of April 29th, 2020.
### 6. Customer 16:
 -  Started the `free trial` on May 31th, 2020, upgraded to `basic monthly` during the trial period, and then to `pro annual` with effective start date of October 21st, 2020.
### 7. Customer 18:
 - Started the `free trial` on July 6th, 2020, and upgraded to `pro monthly` during the trial period.
### 8. Customer 19:
 -  Started the `free trial` on June 22nd, 2020, upgraded to `pro monthly` during the trial period, and then to `pro annual` with effecctive start date of August 29th, 2020.
