create database windows_functions;
use windows_functions;
SELECT 
    *
FROM
    sales_transactions;
select
	 sales_rep, 
	 region, 
	 net_revenue, 
	 sum(net_revenue) over (partition by region) as total_revenue, 
	 count(*) over (partition by region) as transaction_count, 
	 avg(net_revenue) over (partition by region) as average_revenue_by_region 
from 
	sales_transactions;
    
    
select 
	sale_date, 
    sales_rep, net_revenue, 
    sum(net_revenue) over (partition by sales_rep order by sale_date) as running_total 
from 
	sales_transactions 
order by 
	sales_rep, sale_date;
    
select category, region, sum(net_revenue) over (partition by region) as cat_total, round(net_revenue/sum(net_revenue) over (partition by region)*100,2) as cat_percentage from sales_transactions;
select transaction_id, sale_date, row_number() over (order by sale_date) as numbering from sales_transactions;
select sale_date, sales_rep, row_number() over (partition by sales_rep order by sale_date) as sales_rep_numbering from sales_transactions order by sales_rep, sale_date;
select * from (select sales_rep,sale_date,product,row_number() over (partition by sales_rep order by sale_date) as rn from sales_transactions) as sub where rn = 1;
select * from sales_transactions;
select * from employee_performance;
select employee_name, department, performance_score, rank() over (partition by department order by performance_score desc) as ranked_rating, dense_rank() over (partition by department order by performance_score desc) as dense_ranked_rating from employee_performance;
SELECT sales_rep, region,
           SUM(net_revenue) AS total_revenue,
           RANK() OVER (ORDER BY SUM(net_revenue) DESC) AS revenue_rank
    FROM sales_transactions
    GROUP BY sales_rep, region
    order by revenue_rank
    limit 3;
    
select employee_name, department, salary, ntile(4) over (partition by department order by salary) from employee_performance;

use windows_functions;
select * from stock_price;
select company, trade_date, close_price, lag(close_price,1) over (partition by company order by trade_date) as previous_month_revenue, round((close_price - lag(close_price,1) over (partition by company order by trade_date)),2) as price_change, round((close_price - lag(close_price,1) over (partition by company order by trade_date))/lag(close_price,1) over (partition by company order by trade_date)* 100,2) as percentage_change from stock_price;
select * from monthly_sales_rep;
select sales_rep, month, total_revenue,target_revenue, lead(target_revenue,1,'unknown') over (partition by sales_rep order by month) as next_month_target from monthly_sales_rep;

#Question 1   [Easy]   Table: sales_transactions
#Write a query that shows each transaction alongside the total number of transactions and total net_revenue
#for the entire sales_transactions table (no partitioning). Add columns: global_txn_count and global_total_revenue.
Select * from sales_transactions;
select
	transaction_id, 
    net_revenue, 
    count(transaction_id) over() as global_txn_count, 
    sum(net_revenue) over() as global_total_revenue 
from 
	sales_transactions;
    
#Question 2   [Easy]   Table: sales_transactions
#For each transaction, show the total net_revenue for that transaction's region as a new column called 
#region_total_revenue, and the region's transaction count as region_txn_count. Keep all individual transaction rows visible.
select 
	transaction_id, 
    region, net_revenue, 
    sum(net_revenue) over (partition by region) as region_total_revenue, 
    count(*) over (partition by region) as region_txt_count 
from 
	sales_transactions;
    
#Question 3   [Medium]   Table: sales_transactions
#Write a query showing each transaction's net_revenue, the running total of net_revenue per sales_rep 
#(ordered by sale_date), and the percentage each transaction contributes to that rep's running total so far.
select * from sales_transactions;
select 
	transaction_id, 
    sales_rep, 
    net_revenue, 
    sum(net_revenue) over(partition by sales_rep order by sale_date) as running_total, 
    round((net_revenue/sum(net_revenue) over (partition by sales_rep) * 100),2) as percentage_contribution 
from 
	sales_transactions; 
    
    
#Question 4   [Medium]   Table: monthly_rep_sales
#From monthly_rep_sales, show each rep's month, total_revenue, a running cumulative revenue per rep ordered by month,
#and a running average deal size per rep. Show only 2023 data.
select * from monthly_sales_rep;
select 
	sales_rep, 
    month, 
    total_revenue, 
    sum(total_revenue) over (partition by sales_rep order by month) as running_total, 
    avg(total_revenue) over (partition by sales_rep order by month) as running_average 
from 
	monthly_sales_rep 
where 
	month like '2023%';
    
    
#Question 5   [Hard]   Table: sales_transactions
#For each category in sales_transactions, calculate: (1) the category total revenue, (2) the category's percentage
#of the grand total revenue, and (3) a running total of category revenue ordered by category total revenue descending. 
#Use a subquery to first aggregate revenue per category, then apply window functions.
select * from sales_transactions;
select 
	sub.category, 
    sub.cat_total, 
    (sub.cat_total/sum(cat_total) over()) as category_percent,
    sum(sub.cat_total) over (order by sub.cat_total desc) as running_total  
from 
	(select 
		category, 
		sum(revenue) as cat_total from sales_transactions 
	group by category) as sub;
    
    
#Question 6   [Easy]   Table: employee_performance
#Assign a row number to every employee in employee_performance,
#ordered by total_comp descending (highest total compensation = row 1). Return all columns plus the row number.
select 
	*, 
    row_number() over (order by total_comp desc) as compensation_ranking 
from e
	mployee_performance;
    






