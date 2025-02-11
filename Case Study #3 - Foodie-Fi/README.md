# Case Study #3 - Foodie-Fi
![image](https://github.com/user-attachments/assets/483ca038-2980-4ad6-9e05-976159a04542)
## Table of Contents
- [Introduction](#introduction)
- [Data](#data)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Data Source](#data-source)
- [Case Study Questions](#case-study-questions)
  
## Introduction 
Danny realised that he wanted to create a new streaming service that only had food related contents. He finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world! This case study focuses on using subscription style digital data to answer important business questions.

## Data
Danny has shared 2 datasets for this case study:
- `plans`
- `subscriptions`

### Table 1: `plans`
This table includes the subscription options available at Foodie-Fi. 
- In the Basic plan customers have a limited access and can only stream.
- In pro plan customers have no watch time limits and are able to download videos for offline viewing.
- Customers can sign up to an intial 7 day free trial will automatically continue with the pro montly subscription plan unless they cancel, downgrade to basic or upgrade to and annual pro plan at any point during this trial
- When the customers cancel their Foodie-Fi service - they will have a `churn` plan.
  
![image](https://github.com/user-attachments/assets/102c6684-9c30-4ea6-b4f8-e14b2bcb2303)

### Table 2: `subscriptions`
![image](https://github.com/user-attachments/assets/160169bc-2a83-42c6-a8e4-7f5bd8d6574c)


## Entity Relationship Diagram
![image](https://github.com/user-attachments/assets/90e6e36e-1b5c-46a4-9f55-0783541068f7)


## Data Source
This datasets is part of the [8-Week SQL Challenge](https://8weeksqlchallenge.com/case-study-3/)

## Case Study Questions
This case study is split into an initial data understanding question before diving straight into data analysis questions before finishing with 1 single extension challenge.
- Customer Journey
- Data Analysis Questions
- Challenge Payment Question
- Outside The Box Questions

### A. Customer Journey
Based off the 8 sample customers provided in the sample from the `subscriptions` table, write a brief description about each customer’s onboarding journey.
Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

### B. Data Analysis Question 
1. How many customers has Foodie-Fi ever had?
2. What is the monthly distribution of `trial` plan `start_date` values for our dataset - use the start of the month as the group by value
3. What plan `start_date` values occur after the year 2020 for our dataset? Show the breakdown by count of events for each `plan_name`
4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
6. What is the number and percentage of customer plans after their initial free trial?
7. What is the customer count and percentage breakdown of all 5 `plan_name` values at `2020-12-31`?
8. How many customers have upgraded to an annual plan in 2020?
9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?


### C. Challenge Payment Question
The Foodie-Fi team wants you to create a new `payments` table for the year 2020 that includes amounts paid by each customer in the `subscriptions` table with the following requirements:
- monthly payments always occur on the same day of month as the original `start_date` of any monthly paid plan
- upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
- upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
- once a customer churns they will no longer make payments

### D. Outside The Box Questions
