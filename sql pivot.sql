create database pivots;
use pivots;
select * from retail_sales;
SELECT 
    category, quarter, SUM(net_revenue)
FROM
    retail_sales
GROUP BY quarter, category
 order by category, quarter;
 
SELECT *
FROM (
  SELECT category,
         quarter,
         SUM(net_revenue) AS total_revenue
  FROM retail_sales
  GROUP BY category, quarter
) sub
ORDER BY category, quarter;
SELECT *
FROM (
  SELECT category,
         quarter,
         SUM(net_revenue) AS total_revenue
  FROM retail_sales
  GROUP BY category, quarter
) sub
ORDER BY category, quarter;


SELECT 
    category,
    round(sum(total_revenue),2) AS Total_revenue,
    SUM(CASE
        WHEN quarter = 'Q1' THEN total_revenue
        ELSE NULL
    END) AS Q1_revenue,
    SUM(CASE
        WHEN quarter = 'Q2' THEN total_revenue
        ELSE NULL
    END) AS Q2_revenue,
    SUM(CASE
        WHEN quarter = 'Q3' THEN total_revenue
        ELSE NULL
    END) AS Q3_revenue,
    SUM(CASE
        WHEN quarter = 'Q4' THEN total_revenue
        ELSE NULL
    END) AS Q4_revenue
FROM
    (SELECT 
        category, quarter, SUM(net_revenue) AS total_revenue
    FROM
        retail_sales
    GROUP BY category , quarter) sub
GROUP BY category
ORDER BY Total_revenue desc;


#✏️  Practice Problem 1
#Using the same pivot structure from Step 4, write a query that pivots net_revenue by region instead of category. 
#Show total_revenue and each of the 5 regions (North, South, East, West, Central) as separate columns. 
#Order by total_revenue descending.
SELECT 
    quarter,
    SUM(CASE
        WHEN region = 'North' THEN net_revenue
        ELSE NULL
    END) AS North_revenue,
    SUM(CASE
        WHEN region = 'South' THEN net_revenue
        ELSE NULL
    END) AS South_revenue,
    SUM(CASE
        WHEN region = 'East' THEN net_revenue
        ELSE NULL
    END) AS East_revenue,
    SUM(CASE
        WHEN region = 'West' THEN net_revenue
        ELSE NULL
    END) AS West_revenue,
    SUM(CASE
        WHEN region = 'Central' THEN net_revenue
        ELSE NULL
    END) AS Central_revenue
FROM
    retail_sales
GROUP BY quarter
Order by quarter;


Explain analyze SELECT category,
  SUM(CASE WHEN quarter = 'Q1' THEN net_revenue ELSE NULL END) AS q1_revenue,
  SUM(CASE WHEN quarter = 'Q1' THEN profit  ELSE NULL END) AS q1_profit,
  SUM(CASE WHEN quarter = 'Q2' THEN net_revenue ELSE NULL END) AS q2_revenue,
  SUM(CASE WHEN quarter = 'Q2' THEN profit  ELSE NULL END) AS q2_profit,
  SUM(CASE WHEN quarter = 'Q3' THEN net_revenue ELSE NULL END) AS q3_revenue,
  SUM(CASE WHEN quarter = 'Q3' THEN profit  ELSE NULL END) AS q3_profit,
  SUM(CASE WHEN quarter = 'Q4' THEN net_revenue ELSE NULL END) AS q4_revenue,
  SUM(CASE WHEN quarter = 'Q4' THEN profit  ELSE NULL END) AS q4_profit
from retail_sales
group by category;

Explain analyze SELECT category,
  SUM(CASE WHEN quarter = 'Q1' THEN total_revenue ELSE NULL END) AS q1_revenue,
  SUM(CASE WHEN quarter = 'Q1' THEN total_profit  ELSE NULL END) AS q1_profit,
  SUM(CASE WHEN quarter = 'Q2' THEN total_revenue ELSE NULL END) AS q2_revenue,
  SUM(CASE WHEN quarter = 'Q2' THEN total_profit  ELSE NULL END) AS q2_profit,
  SUM(CASE WHEN quarter = 'Q3' THEN total_revenue ELSE NULL END) AS q3_revenue,
  SUM(CASE WHEN quarter = 'Q3' THEN total_profit  ELSE NULL END) AS q3_profit,
  SUM(CASE WHEN quarter = 'Q4' THEN total_revenue ELSE NULL END) AS q4_revenue,
  SUM(CASE WHEN quarter = 'Q4' THEN total_profit  ELSE NULL END) AS q4_profit
FROM (
  SELECT category, quarter,
         SUM(net_revenue) AS total_revenue,
         SUM(profit)      AS total_profit
  FROM retail_sales
  GROUP BY category, quarter
) sub
GROUP BY category;

#Both of the queries above would give the same result, the only diference is the optimization as the later
#query is more optimized by the former.

#✏️  Practice Problem 2
#Write a pivot query that shows units_sold AND profit by quarter for each category. 
#The subquery should aggregate both SUM(units_sold) and SUM(profit) grouped by category and quarter. 
#The outer query should produce 8 columns: q1_units, q1_profit, q2_units, q2_profit, q3_units, q3_profit, q4_units, q4_profit.
select * from retail_sales;
SELECT 
    category,
    SUM(CASE
        WHEN quarter = 'Q1' THEN total_units
        ELSE NULL
    END) AS Q1_total_units_sold,
    SUM(CASE
        WHEN quarter = 'Q1' THEN total_profit
        ELSE NULL
    END) AS Q1_total_profit,
    SUM(CASE
        WHEN quarter = 'Q2' THEN total_units
        ELSE NULL
    END) AS Q2_total_units_sold,
    SUM(CASE
        WHEN quarter = 'Q2' THEN total_profit
        ELSE NULL
    END) AS Q2_total_profit,
    SUM(CASE
        WHEN quarter = 'Q3' THEN total_units
        ELSE NULL
    END) AS Q3_total_units_sold,
    SUM(CASE
        WHEN quarter = 'Q3' THEN total_units
        ELSE NULL
    END) AS Q3_total_units_sold,
    SUM(CASE
        WHEN quarter = 'Q3' THEN total_profit
        ELSE NULL
    END) AS Q3_total_profit,
    SUM(CASE
        WHEN quarter = 'Q4' THEN total_units
        ELSE NULL
    END) AS Q4_total_units_sold,
    SUM(CASE
        WHEN quarter = 'Q4' THEN total_profit
        ELSE NULL
    END) AS total_profit
FROM
    (SELECT 
        category,
            quarter,
            SUM(units_sold) total_units,
            SUM(profit) total_profit
    FROM
        retail_sales
    GROUP BY category , quarter) AS sub
GROUP BY category; 

#✏️  Practice Problem 3
#Write a pivot query that shows net_revenue by quarter for the South and East regions only 
#(use WHERE region IN ('South','East') in the subquery). Group by category and order by total revenue descending
SELECT category,
  SUM(total_revenue) AS total_revenue,
  SUM(CASE WHEN quarter='Q1' THEN total_revenue ELSE NULL END) AS q1,
  SUM(CASE WHEN quarter='Q2' THEN total_revenue ELSE NULL END) AS q2,
  SUM(CASE WHEN quarter='Q3' THEN total_revenue ELSE NULL END) AS q3,
  SUM(CASE WHEN quarter='Q4' THEN total_revenue ELSE NULL END) AS q4
FROM (
  SELECT category, quarter,
         SUM(net_revenue) AS total_revenue
  FROM retail_sales
  WHERE region IN ('South','East')
  GROUP BY category, quarter
) sub
GROUP BY category
ORDER BY total_revenue DESC;

select * from retail_sales;


#✏️  Practice Problem 4
#Write a pivot that shows gross_revenue by year (2022, 2023, 2024) for each region. 
#Include a total_revenue column and order by it descending.
SELECT region,
  SUM(total_rev) AS total_revenue,
  SUM(CASE WHEN year=2022 THEN total_rev ELSE NULL END) AS rev_2022,
  SUM(CASE WHEN year=2023 THEN total_rev ELSE NULL END) AS rev_2023,
  SUM(CASE WHEN year=2024 THEN total_rev ELSE NULL END) AS rev_2024
FROM (
  SELECT region, year,
         SUM(gross_revenue) AS total_rev
  FROM retail_sales
  GROUP BY region, year
) sub
GROUP BY region
ORDER BY total_revenue DESC;
use pivots;
select * from category_q_budget;


#Converting columns to rows (unpivoting)
SELECT 
    b.category,
    q.quarter,
    (CASE q.quarter
        WHEN 'Q1' THEN q1_budget
        WHEN 'Q2' THEN q2_budget
        WHEN 'Q3' THEN q3_budget
        WHEN 'Q4' THEN q4_budget
        ELSE NULL
    END) AS Quarterly_budget
FROM
    category_q_budget AS b
        CROSS JOIN
    (SELECT 'Q1' AS quarter UNION ALL SELECT 'Q2' UNION ALL SELECT 'Q3' UNION ALL SELECT 'Q4') AS q;


#✏️  Practice Problem 5
#Write a complete columns-to-rows pivot for the category_quarterly_budget table. 
#The output should have three columns: category, quarter, and budget_amount. After producing the unpivoted result, 
#wrap it in an outer query that calculates the average budget_amount per quarter (GROUP BY quarter) and orders from 
#highest to lowest average.
SELECT 
    sub.quart AS Quarters,
    AVG(sub.Quarterly_budget) AS average_quarterly_budget
FROM
    (SELECT 
        b.category AS cat,
            q.quarter AS quart,
            (CASE q.quarter
                WHEN 'Q1' THEN q1_budget
                WHEN 'Q2' THEN q2_budget
                WHEN 'Q3' THEN q3_budget
                WHEN 'Q4' THEN q4_budget
                ELSE NULL
            END) AS Quarterly_budget
    FROM
        category_q_budget AS b
    CROSS JOIN (SELECT 'Q1' AS quarter UNION ALL SELECT 'Q2' UNION ALL SELECT 'Q3' UNION ALL SELECT 'Q4') AS q) AS sub
GROUP BY sub.quart;

#Unpivoting the months columns to get the average revenue per month
select * from region_revenue;
SELECT 
    sub.months, AVG(sub.monthly_revenue) AS avg_monthly_revenue
FROM
    (SELECT 
        r.region,
            m.months,
            (CASE m.months
                WHEN 'January' THEN rev_jan
                WHEN 'February' THEN rev_feb
                WHEN 'March' THEN rev_mar
                WHEN 'April' THEN rev_apr
                WHEN 'May' THEN rev_may
                WHEN 'June' THEN rev_jun
                WHEN 'July' THEN rev_jul
                WHEN 'August' THEN rev_aug
                WHEN 'September' THEN rev_sep
                WHEN 'October' THEN rev_oct
                WHEN 'November' THEN rev_Nov
                WHEN 'December' THEN rev_dec
                ELSE NULL
            END) AS monthly_revenue
    FROM
        region_revenue r
    CROSS JOIN (SELECT 'January' AS months
    UNION ALL SELECT 'February' 
    UNION ALL SELECT 'March' 
    UNION ALL SELECT 'April' 
    UNION ALL SELECT 'May' 
    UNION ALL SELECT 'June' 
    UNION ALL SELECT 'July' 
    UNION ALL SELECT 'August' 
    UNION ALL SELECT 'September' 
    UNION ALL SELECT 'October' 
    UNION ALL SELECT 'November' 
    UNION ALL SELECT 'December') AS m) AS sub
GROUP BY sub.months;


#Practice question sessions
#Question 1
#Write a pivot that shows gross_revenue by sales channel (Online, In-Store, Wholesale, Mobile App) for each quarter. 
#Include a total column and order by total descending.
select * from retail_sales;
SELECT 
    sub.channel,
    SUM(total_revenue) AS total_gross,
    SUM(CASE
        WHEN quarter = 'Q1' THEN total_revenue
        ELSE NULL
    END) as Q1_gross,
    SUM(CASE
        WHEN quarter = 'Q2' THEN total_revenue
        ELSE NULL
    END) as Q2_gross,
    SUM(CASE
        WHEN quarter = 'Q3' THEN total_revenue
        ELSE NULL
    END) as Q3_gross,
    SUM(CASE
        WHEN quarter = 'Q4' THEN total_revenue
        ELSE NULL
    END) as Q4_gross
FROM
    (SELECT 
        channel, quarter, SUM(gross_revenue) AS total_revenue
    FROM
        retail_sales
    GROUP BY channel , quarter) AS sub
GROUP BY sub.channel
ORDER BY total_gross DESC;

#Question 3
#Write a pivot that shows average margin_pct by quarter for each region. 
#Round each average to 1 decimal place. Order by the Q4 average margin descending (highest Q4 margin at the top).
SELECT 
    region,
    ROUND(SUM(CASE
                WHEN quarter = 'Q1' THEN avg_margin
                ELSE NULL
            END),
            1) AS q1_margin,
    ROUND(SUM(CASE
                WHEN quarter = 'Q2' THEN avg_margin
                ELSE NULL
            END),
            1) AS q2_margin,
    ROUND(SUM(CASE
                WHEN quarter = 'Q3' THEN avg_margin
                ELSE NULL
            END),
            1) AS q3_margin,
    ROUND(SUM(CASE
                WHEN quarter = 'Q4' THEN avg_margin
                ELSE NULL
            END),
            1) AS q4_margin
FROM
    (SELECT 
        region, quarter, AVG(margin_pct) AS avg_margin
    FROM
        retail_sales
    GROUP BY region , quarter) sub
GROUP BY region
ORDER BY q4_margin DESC;

#Question 5
#Using the category_quarterly_budget table, write an unpivot query (columns to rows) that produces: category, 
#quarter, budget_amount. Then join this result to the pivoted revenue from retail_sales to produce a comparison table 
#showing budget vs actual net_revenue per category per quarter.
SELECT a.category, a.quarter, a.budget_amount, round(b.actual_revenue,0) as actual_revenue
FROM (
  SELECT bgt.category, q.quarter,
    CASE q.quarter
      WHEN 'Q1' THEN bgt.q1_budget WHEN 'Q2' THEN bgt.q2_budget
      WHEN 'Q3' THEN bgt.q3_budget WHEN 'Q4' THEN bgt.q4_budget
    END AS budget_amount
  FROM category_q_budget AS bgt
  CROSS JOIN (SELECT 'Q1' AS quarter UNION ALL SELECT 'Q2'
              UNION ALL SELECT 'Q3'  UNION ALL SELECT 'Q4') AS q
) a
JOIN (
  SELECT category, quarter, SUM(net_revenue) AS actual_revenue
  FROM retail_sales GROUP BY category, quarter
) b ON a.category = b.category AND a.quarter = b.quarter
ORDER BY a.category, a.quarter;

#Question 7
#Using the region_monthly_revenue table, write an unpivot that produces region, month_name, and monthly_revenue. 
#Then wrap it to find the month with the highest AVERAGE revenue across all regions. Return month_name and avg_monthly_revenue.
select * from region_revenue;

SELECT 
    sub.region, Max(sub.monthly_revenue) AS avg_monthly_revenue
FROM
    (SELECT 
        r.region,
            m.months,
            (CASE m.months
                WHEN 'January' THEN rev_jan
                WHEN 'February' THEN rev_feb
                WHEN 'March' THEN rev_mar
                WHEN 'April' THEN rev_apr
                WHEN 'May' THEN rev_may
                WHEN 'June' THEN rev_jun
                WHEN 'July' THEN rev_jul
                WHEN 'August' THEN rev_aug
                WHEN 'September' THEN rev_sep
                WHEN 'October' THEN rev_oct
                WHEN 'November' THEN rev_Nov
                WHEN 'December' THEN rev_dec
                ELSE NULL
            END) AS monthly_revenue
    FROM
        region_revenue r
    CROSS JOIN (SELECT 'January' AS months
    UNION ALL SELECT 'February' 
    UNION ALL SELECT 'March' 
    UNION ALL SELECT 'April' 
    UNION ALL SELECT 'May' 
    UNION ALL SELECT 'June' 
    UNION ALL SELECT 'July' 
    UNION ALL SELECT 'August' 
    UNION ALL SELECT 'September' 
    UNION ALL SELECT 'October' 
    UNION ALL SELECT 'November' 
    UNION ALL SELECT 'December') AS m) AS sub
GROUP BY sub.region;

#Question 9
#Write a rows-to-columns pivot AND a columns-to-rows unpivot in one script. 
#First: pivot retail_sales to show net_revenue by quarter for each category. Second: immediately unpivot 
#your result back to tall format using a subquery. The final output should be category, quarter, 
#net_revenue — identical to the base aggregation query.

SELECT 
    category,
    quarters,
    quarterly_revenue from
    (select category, q.quarters , (CASE q.quarters
        WHEN 'Q1' THEN Q1_revenue
        WHEN 'Q2' THEN Q2_revenue
        WHEN 'Q3' THEN Q3_revenue
        WHEN 'Q4' THEN Q4_revenue
        ELSE NULL
    END) AS quarterly_revenue
FROM
    (SELECT 
        category,
            SUM(CASE
                WHEN quarter = 'Q1' THEN total_revenue
                ELSE NULL
            END) AS Q1_revenue,
            SUM(CASE
                WHEN quarter = 'Q2' THEN total_revenue
                ELSE NULL
            END) AS Q2_revenue,
            SUM(CASE
                WHEN quarter = 'Q3' THEN total_revenue
                ELSE NULL
            END) AS Q3_revenue,
            SUM(CASE
                WHEN quarter = 'Q4' THEN total_revenue
                ELSE NULL
            END) AS Q4_revenue
    FROM
        (SELECT 
        category, quarter, SUM(net_revenue) AS total_revenue
    FROM
        retail_sales
    GROUP BY category , quarter) sub
    GROUP BY category) c
        CROSS JOIN
    (SELECT 'Q1' AS quarters UNION ALL SELECT 'Q2' UNION ALL SELECT 'Q3' UNION ALL SELECT 'Q4') q) a;
    
    select * from retail_sales;
    
  #  Question 10
#CHALLENGE: Write a complete pivot that shows net_revenue by quarter for each category, but only for the year 2023. 
#Then add two extra columns: pct_q1 and pct_q4, showing Q1 and Q4 revenue as a percentage of the category's total 2023 revenue.
# Round to 1 decimal.

SELECT 
    category,
    SUM(total_rev) AS total_2023_revenue,
    SUM(CASE
        WHEN quarter = 'Q1' THEN total_rev
        ELSE NULL
    END) AS q1,
    SUM(CASE
        WHEN quarter = 'Q2' THEN total_rev
        ELSE NULL
    END) AS q2,
    SUM(CASE
        WHEN quarter = 'Q3' THEN total_rev
        ELSE NULL
    END) AS q3,
    SUM(CASE
        WHEN quarter = 'Q4' THEN total_rev
        ELSE NULL
    END) AS q4,
    ROUND(100.0 * SUM(CASE
                WHEN quarter = 'Q1' THEN total_rev
                ELSE NULL
            END) / SUM(total_rev),
            1) AS pct_q1,
    ROUND(100.0 * SUM(CASE
                WHEN quarter = 'Q4' THEN total_rev
                ELSE NULL
            END) / SUM(total_rev),
            1) AS pct_q4
FROM
    (SELECT 
        category, quarter, SUM(net_revenue) AS total_rev
    FROM
        retail_sales
    WHERE
        year = 2023
    GROUP BY category , quarter) sub
GROUP BY category
ORDER BY total_2023_revenue DESC;
#🔍 The filter year=2023 in the subquery restricts data before pivoting. The pct_q1 and pct_q4 columns divide the specific quarter CASE expression by SUM(total_rev) — which covers all four quarters for that category row. This is a common pattern in financial pivot reports: show absolute values AND the percentage contribution of key periods.








