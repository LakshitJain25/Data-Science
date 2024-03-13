-- Rank functions ==========================================================================================

-- partition rank
SELECT * , rank() over(order by age desc) age_rank from students s;


-- dense_rank
SELECT * , dense_rank() over(order by age desc) age_dense_rank from students s;


-- row_number
SELECT * , row_number() over(order by age desc) age_row_number from students s;


-- Partition on the basis of section =======================================================================

-- partition rank
SELECT * , rank() over(partition by section order by age desc) age_rank from students s;


-- partition dense_rank
SELECT * , dense_rank() over(partition by section order by age desc) age_dense_rank from students s;


-- partition row_number
SELECT * , row_number() over(partition by section order by age desc) age_row_number from students s;

-- Rows between ===============================================================================================

-- for defined number of rows
SELECT * , sum(sales) over(order by date rows between 1 preceding and 2 following) sales_sum from sales_table;


-- for unbounded number of rows
SELECT * , sum(sales) over(order by date rows between unbounded preceding and unbounded following) sales_sum from sales_table;

-- Running sum ===================================================================================================

SELECT * , sum(sales) over(order by date rows between unbounded preceding and current row) running_sum from sales_table;

-- with partition by

SELECT * , sum(sales) over(partition by state order by date rows between unbounded preceding and current row) running_sum from sales_table;

-- First Value , LAST VALUE ===================================================================================================

SELECT * , 
first_value(sales) over(partition by state order by date) first_day_sales,
last_value(sales) over(partition by state order by date rows between unbounded preceding and unbounded following) last_day sales,
nth_value(sales,6) over(partition by state order by date ) sixth_day_sales
from sales_table;

-- MOVING AVERAGE =============================================================================================================

SELECT * , avg(sales) over(order by date rows between 2 preceding and current row);


---- LEAD / LAG ===============================================================================================

SELECT * , 
lead(sales) over(partition by customer_id order by dates),
lag(sales) over(partition by customer_id order by dates)
from sales_table; 


