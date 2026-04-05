create database subqueries;
use subqueries;
select * from incidents;
select * from investment;

#Example 1 — Filter Friday incidents, then filter again by resolution
#Scenario: From your crime_incidents table, get all Friday incidents that were not resolved.
select * from incidents where category = 'ROBBERY';
SELECT 
    *
FROM
    incidents
WHERE
    day_of_week = 'Friday'
        AND resolution = 'NONE'; #running the code directly using the where clause
SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        incidents
    WHERE
        day_of_week = 'Friday') AS sub
WHERE
    resolution = 'NONE'; # solving the same query using subsqueries
    
#Practice Question 1
#Write a query that selects all ROBBERY incidents from crime_incidents using a subquery 
#in the FROM clause, then filter the outer query to only show incidents where resolution = 'ARREST, BOOKED'.
SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        incidents
    WHERE
        category = 'ROBBERY') AS sub
WHERE
    resolution = 'ARREST, BOOKED';

SELECT 
    investment_type, AVG(raised_amount_usd)
FROM
    investment
GROUP BY investment_type;


#Practice Question 4
#Write a query that shows the average number of incidents per day for each day of the week.
#Inner query: count incidents per date+day. Outer query: average those counts by day.
select * from incidents;
SELECT 
    sub.day_of_week, AVG(sub.incident_no)
FROM
    (SELECT 
        day_of_week, date, COUNT(incident_id) AS incident_no
    FROM
        incidents
    GROUP BY day_of_week , date) sub
GROUP BY sub.day_of_week;

#Practice Question 5
#From the investments table, find the average number of investments
#received per quarter for each company. Show company_id and avg_investments_per_quarter.
select *from investment;
SELECT 
    sub.company_id, AVG(sub.investment_count)
FROM
    (SELECT 
        company_id,
            funded_quarter,
            COUNT(investment_id) investment_count
    FROM
        investment
    GROUP BY company_id , funded_quarter) AS sub
GROUP BY sub.company_id;


#Practice Question 6
#From crime_incidents, find the total incidents per category per month in the inner query,
#then in the outer query return only categories where the monthly average exceeds 3.
select * from incidents;
SELECT 
    sub.category,
    AVG(sub.incident_count) AS average_incident_per_month_per_category
FROM
    (SELECT 
        category, month, COUNT(incident_id) incident_count
    FROM
        incidents
    GROUP BY month , category) AS sub
GROUP BY sub.category
HAVING average_incident_per_month_per_category > 3;


SELECT *
FROM companies
WHERE company_id IN (
    SELECT DISTINCT company_id
    FROM investment
    WHERE investment_type = 'series-a'
);

select * from companies;
select * from investment;
select * from incidents;

#Practice Question 7
#Select all crime incidents that occurred on the most common day of the week.
#Use a subquery to find which day has the most incidents.
SELECT 
    *
FROM
    incidents
WHERE
    day_of_week = (SELECT 
            day_of_week
        FROM
            incidents
        GROUP BY day_of_week
        ORDER BY COUNT(incident_id) DESC
        LIMIT 1);
        

#Practice Question 8
#Select all companies whose total_funding_usd is greater than the average total_funding_usd across all companies.
SELECT 
    *
FROM
    companies
WHERE
    total_funding_usd > (SELECT 
            AVG(total_funding_usd)
        FROM
            companies);
            
#Practice Question 9
#Select all investments where the company_id belongs to a company that was acquired
#(status = 'acquired' in the companies table).
SELECT 
    *
FROM
    investment
WHERE
    company_id IN (SELECT 
            company_id
        FROM
            companies
        WHERE
            status = 'acquired');
            
#Practice Question 10
#Find all crime incidents in districts that had at least one ROBBERY.
#Use NOT IN to also write a version that excludes those districts.
select * from incidents;
SELECT 
    *
FROM
    incidents
WHERE
    district IN (SELECT 
            district
        FROM
            incidents
        WHERE
            category = 'ROBBERY');
            
select * from companies;
select * from investment;

SELECT 
    c.*, i.total_investment, i.company_no
FROM
    companies c
        JOIN
    (SELECT 
        company_id,
            SUM(raised_amount_usd) AS total_investment,
            COUNT(company_id) AS company_no
    FROM
        investment
    GROUP BY company_id) i ON c.company_id = i.company_id;
    


use subqueries;
#Practice Question 11
#Join crime_incidents with a subquery that counts total incidents per district.
#Show each incident plus the total_district_incidents column.
select * from incidents;
SELECT 
    i.*, d.incident_per_district
FROM
    incidents i
        JOIN
    (SELECT 
        district, COUNT(incident_id) AS incident_per_district
        FROM
        incidents
    GROUP BY district) d ON i.district = d.district;
    
    #Practice Question 12
#Join companies to a subquery that returns the most recent investment year per company.
#Show company_name, category, and latest_investment_year.
select * from companies;
select * from investment;
select * from aquisitions;
SELECT 
    c.company_name, c.category, i.most_recent_investment_year
FROM
    companies c
        JOIN
    (SELECT 
        company_id, MAX(funded_year) most_recent_investment_year
    FROM
        investment
    GROUP BY company_id) i ON c.company_id = i.company_id;
    
#Practice Question 13
#Using a joined subquery, display each acquisition alongside the total amount
#Google has spent on acquisitions (as a separate column).
select * from aquisitions;
SELECT 
    a.*, aq.Google_aquisition_sum
FROM
    aquisitions a
        JOIN
    (SELECT 
        acquiring_company, SUM(price_usd) AS Google_aquisition_sum
    FROM
        aquisitions
   
    GROUP BY acquiring_company having acquiring_company = 'Google') aq ON a.acquiring_company = aq.acquiring_company;

    
select * from companies c join investment i on c.company_id = i.company_id;
select * from investment i join companies c on i.company_id = c.company_id;
select * from investment;
select * from aquisitions;

SELECT 
    COUNT(*)
FROM
    (SELECT 
        investment_id
    FROM
        investment UNION ALL SELECT 
        acquisition_id
    FROM
        aquisitions) AS combined;
        
#Practice Question 16
#Find all companies that have BOTH an investment record AND an acquisition record. Use subqueries with IN.
select * from investment;
select * from aquisitions;
SELECT 
    *
FROM
    investment
WHERE
    company_id IN (SELECT 
            acquired_company_id
        FROM
            aquisitions);
            
#Practice Question 17
#Find all crime_incidents categories that have MORE incidents than the average category count. 
#Use a subquery in the HAVING clause.
select * from incidents;

SELECT 
    category, COUNT(incident_id) AS incident_num
FROM
    incidents
GROUP BY category
HAVING incident_num > (SELECT 
        AVG(sub.incident_occurence)
    FROM
        (SELECT 
            category, COUNT(incident_id) AS incident_occurence
        FROM
            incidents
        GROUP BY category) AS sub);

#Practice Question 18
#Using a subquery in FROM, show each investor_name alongside their rank by total amount invested
# (use RANK() if available in your MySQL version, or ORDER BY + variable).
select * from investment;
SELECT 
    investor_name, SUM(raised_amount_usd) total_raised
FROM
    investment
GROUP BY investor_name
ORDER BY total_raised DESC;
select investor_name, total_investment as total_raised,RANK() OVER (ORDER BY sub.total_investment DESC) AS investor_rank from (select investor_name, sum(raised_amount_usd) as total_investment from investment group by investor_name) as sub;

#Practice Question 19
#From the companies table, show all companies founded in a year that also had at least one acquisition.
# Use a subquery with IN against the acquisitions table.
select * from companies;
select * from aquisitions;
SELECT 
    *
FROM
    companies
WHERE
    founded_year IN (SELECT 
            acquired_year
        FROM
            aquisitions);
            
#Practice Question 20
#Write a query that shows the top 3 districts by incident count, then use that result in a subquery
#to pull all Friday incidents from only those top 3 districts.
select * from incidents;
SELECT 
    *
FROM
    incidents
WHERE
    district IN (SELECT 
            sub.district
        FROM
            (SELECT 
                district, COUNT(incident_id) AS incident_occurence
            FROM
                incidents
            GROUP BY district
            ORDER BY incident_occurence DESC
            LIMIT 3) sub) and day_of_week = "Friday";



