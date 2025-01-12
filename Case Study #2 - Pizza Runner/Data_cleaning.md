# Data Cleaning 🧹
## Cleaning the ` customer_orders ` Table
The  `customer_orders` table contained missing and invalid values. These issues were cleaned as follows:
### Steps:
1. **Create a Copy of the table**:\
   Creating a copy of the original table helps to keep the data integerity,and allows testing of cleaning method without risking data loss.
```sql

CREATE TABLE customer_orders_copy
LIKE customer_orders;

INSERT INTO customer_orders_copy
SELECT *
FROM customer_orders;
```
2. **Replacing Missing or Invalid Values**:
```sql
-- cleaning missing values 
UPDATE customer_orders_copy
SET exclusions = CASE WHEN exclusions IN ('' , 'null') THEN exclusions = null ELSE exclusions END,
	extras = CASE WHEN extras IN ('' , 'null') THEN extras = null ELSE extras END;
```
3. **Verfying the Results**:
```sql
SELECT *
FROM customer_orders_copy;
```
### Results
**Before**: \
![image](https://github.com/user-attachments/assets/277313ed-475e-40f6-be76-ecaae7c438c6)

**After**: \
All the invalid and missing values were replaced by `NULL` values.\
![image](https://github.com/user-attachments/assets/5b5130c5-fd63-4b61-a9b9-4d8901c5d989)

## Cleaning the `runner_orders` table
The `runner_orders` table had missing values, inconsistent formats, redundant units in columns like `distance` and `duration`.
### Steps:
1. **Create a Copy of the Table**:\
To maintain data integrity, we create a copy of the table:
```sql
CREATE TABLE runner_orders_copy
LIKE runner_orders;

INSERT INTO runner_orders_copy
SELECT *
FROM runner_orders;
```

2. **Replace Missing or Invalid Values**:
```sql
UPDATE runner_orders_copy
SET pickup_time = CASE WHEN pickup_time IN ('' , 'null') THEN pickup_time = null ELSE pickup_time END,
	distance = CASE WHEN distance IN ('' , 'null') THEN distance = null ELSE distance END,
    duration = CASE WHEN duration IN ('' , 'null') THEN duration = null ELSE duration END,
    cancellation = CASE WHEN cancellation IN ('' , 'null') THEN cancellation = null ELSE cancellation END;
```
3. **Standardize Formats:**\
Units like `km`, `minutes`,`mins`, and `minute` were remmoved to standardize the `distance` and `duration` columns:
```sql
UPDATE runner_orders_copy
SET distance = REPLACE(distance, 'km', ''), duration = REPLACE(duration, 'minutes',''), 
	duration = REPLACE(duration, 'mins',''),duration = REPLACE(duration, 'minute','');
```
4. **Verify the Results**:
```sql
SELECT *
FROM runner_orders_copy;
```
### Results:
Before: \
![image](https://github.com/user-attachments/assets/47a7c3c0-ceff-40b4-b411-3e7dfc556889)

After: 
  - All invalid and missing values were replaced with `NULL` vaues.
  - Units were removed, data was standardized for consistency.\
![image](https://github.com/user-attachments/assets/13a0da66-3084-4d57-af6c-ec95e07b06c5)



