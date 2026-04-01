create database crime;
use crime;
select * from sfp;
select * from sfp2;
select left(date,10) as just_date from sfp;
select left(date,10) as jsut_date, right(date,17) as just_time from sfp;
select incidnt_num,date, left(date,10), right(date,length(date)-11) from sfp;
select incidnt_num, left(address,20) as short_address from sfp;
select trim(both ' ' from descript) from sfp;

select resolution, instr((upper(resolution)),'ARREST') as arrest_position from sfp;
select * from sfp where instr(resolution, 'ARREST') > 0;
select * from sfp where resolution like '%ARREST%';
select date, substr(date,4,2) from sfp;
select  substr(location, (instr(location,',')+2)) from sfp;
select date, concat(substr(date,1,2), '-', substr(date,7,4)) as month_year  from sfp;
SELECT 
    TRIM(BOTH '(' FROM LEFT(location, 8)) AS lat,
    TRIM(BOTH ')' FROM SUBSTR(location,
            INSTR(location, ',') + 2))
FROM
    sfp;
    
SELECT 
    date,
    CONCAT(SUBSTR(date, 7, 4),
            '-',
            SUBSTR(date, 4, 2),
            '-',
            SUBSTR(date, 1, 2)) AS new_date
FROM
    sfp;
    
#Extract the category column in proper case.
SELECT 
    CONCAT(UPPER(LEFT(category, 1)),
            LOWER(SUBSTR(category, 2)))
FROM
    sfp;

select * from sfp;    
describe sfp;

#Retrieve the date column and one week after
SELECT 
    incidnt_num,
    date,
    STR_TO_DATE(LEFT(date, 10), '%m/%d/%Y') AS proper_date,
    STR_TO_DATE(LEFT(date, 10), '%m/%d/%Y') + INTERVAL 7 DAY AS one_week_plus
FROM
    sfp;

SELECT 
    STR_TO_DATE(CONCAT(LEFT(date, 10), ' ', time),
            '%m/%d/%Y %H:%i') AS full_datetime
FROM
    sfp;
    
describe sfp2;
describe sfp;
select cleaned_date, year(cleaned_date) from sfp2;
select date, year(date) from sfp;
select * from sfp;
select * from sfp2;

SELECT cleaned_date,
       YEAR(cleaned_date)         AS yr,
       MONTH(cleaned_date)        AS mo,
       DAY(cleaned_date)          AS dy,
       HOUR(cleaned_date)         AS hr,
       MINUTE(cleaned_date)       AS mi,
       DAYOFWEEK(cleaned_date)    AS dow,
       WEEK(cleaned_date)         AS week_number
FROM sfp2;

SELECT 
    DATE(DATE_FORMAT(cleaned_date, '%Y-%u-1')) AS first_day,
    COUNT(*) AS num_of_incidents
FROM
    sfp2
GROUP BY first_day;
select * from sfp2;
select * from sfp2 where day_of_week = 'Monday';

SELECT 
    YEAR(cleaned_date) AS cleaned_year,
    MONTH(cleaned_date) AS cleaned_month,
    COUNT(*) AS no_of_incidents
FROM
    sfp2
GROUP BY cleaned_year , cleaned_month;

select * from sfp2;
SELECT 
    incidnt_num,
    cleaned_date,
    COALESCE(resolution, 'no resolution') AS resolution
FROM
    sfp2;
    
SELECT COALESCE(resolution, category, 'Unknown') AS best_label
FROM sfp;

select * from sfp;
#Challenge 1
#Write a single query that returns a full incident report with: a formatted date (YYYY-MM-DD),
# the category in proper case, the address in uppercase, and 'No Info' wherever resolution is NULL.

SELECT 
    incidnt_num,
    STR_TO_DATE(LEFT(date, 10), '%m/%d/%Y') AS formatted_date,
    CONCAT(UPPER(LEFT(category, 1)),
            LOWER(SUBSTR(category, 2))) as proper_category,
    UPPER(address) as address,
    COALESCE(resolution, 'no info') AS resolution
FROM
    sfp;


#Challenge 2
#Using crime_incidents_cleandate, find the day of the week that has the highest number of incidents. 
#Show the day name and incident count.
select * from sfp2;
SELECT 
    day_of_week, COUNT(*) AS num_incidents
FROM
    sfp2
GROUP BY day_of_week
ORDER BY day_of_week DESC
LIMIT 1; 

#Challenge 3
#Write a query that rebuilds the location field from the lat and lon columns and then extracts
# just the latitude back out of the rebuilt string. This tests CONCAT and SUBSTRING_INDEX working together.

#Challenge 4
#Write a query that flags incidents as 'Evening' (hour 18–23), 'Night' (hour 0–5), 'Morning' (hour 6–11),
# or 'Afternoon' (hour 12–17) based on the cleaned_date. Use HOUR() and a CASE expression.

SELECT 
    incidnt_num,
    cleaned_date,
    CASE
        WHEN HOUR(cleaned_date) BETWEEN 0 AND 5 THEN 'night'
        WHEN HOUR(cleaned_date) BETWEEN 6 AND 11 THEN 'morning'
        WHEN HOUR(cleaned_date) BETWEEN 12 AND 17 THEN 'afternoon'
        WHEN HOUR(cleaned_date) BETWEEN 18 AND 23 THEN 'evening'
    END AS time_of_day
FROM
    sfp2;







    