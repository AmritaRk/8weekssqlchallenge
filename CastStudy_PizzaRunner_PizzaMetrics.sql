/* Pizza Metrics */

-- How many pizzas were ordered?

SELECT COUNT(PIZZA_ID) FROM CUSTOMER_ORDERS;

-- How many unique customer orders were made?
SELECT COUNT(CUSTOMER_ID) FROM CUSTOMER_ORDERS;

-- How many successful orders were delivered by each runner?
SELECT RUNNER_ID, COUNT(ORDER_ID)
FROM RUNNER_ORDERS
WHERE CANCELLATION IS NULL OR UPPER(CANCELLATION) = 'NULL'
OR LENGTH(CANCELLATION) = 0
GROUP BY RUNNER_ID;

-- How many of each type of pizza was delivered?

SELECT PIZZA_ID, COUNT(R.ORDER_ID)
FROM RUNNER_ORDERS R
JOIN CUSTOMER_ORDERS C
ON R.ORDER_ID = C.ORDER_ID
WHERE CANCELLATION IS NULL OR UPPER(CANCELLATION) = 'NULL'
OR LENGTH(CANCELLATION) = 0
GROUP BY PIZZA_ID;

-- How many Vegetarian and Meatlovers were ordered by each customer?

SELECT CUSTOMER_ID, PIZZA_NAME, COUNT(ORDER_ID)
FROM CUSTOMER_ORDERS C
JOIN PIZZA_NAMES P
ON P.PIZZA_ID = C.PIZZA_ID
GROUP BY CUSTOMER_ID, PIZZA_NAME 
ORDER BY 1,2;

-- What was the maximum number of pizzas delivered in a single order?

WITH COUNT_PIZZA AS(
SELECT R.ORDER_ID,
  COUNT(C.PIZZA_ID), 
  RANK() OVER(ORDER BY COUNT(C.PIZZA_ID) DESC) AS RNK
FROM RUNNER_ORDERS R
JOIN CUSTOMER_ORDERS C
ON R.ORDER_ID = C.ORDER_ID
WHERE CANCELLATION IS NULL OR UPPER(CANCELLATION) = 'NULL'
OR LENGTH(CANCELLATION) = 0
GROUP BY R.ORDER_ID)
SELECT * FROM COUNT_PIZZA
WHERE RNK = 1;

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT CUSTOMER_ID
CASE WHEN 
(EXCLUSIONS IS NULL OR UPPER(EXCLUSIONS) = NULL
OR LENGTH(EXCLUSIONS) = 0) AND ((EXTRAS IS NULL OR UPPER(EXTRAS) = 'NULL' OR LENGTH(EXTRAS) = 0)) THEN 'NO CHANGE' 
ELSE 'CHANGES'
END AS LABEL,
COUNT(ORDER_ID)
FROM CUSTOMER_ORDERS
GROUP BY 1,2 
ORDER BY 1,2;

-- How many pizzas were delivered that had both exclusions and extras?

SELECT count(pizza_id)
from runner_orders r
  join customer_orders c
  on r.order_id = c.order_id
where 
exclusions ~ '[0-9]' and extras ~ '[0-9]'; 

--What was the total volume of pizzas ordered for each hour of the day?

select EXTRACT(HOUR from order_time), count(order_id)
from customer_orders
group by 1;


--What was the volume of orders for each day of the week? 

select to_char(order_time,'DAY'), count(order_id)
from customer_orders
group by 1;


