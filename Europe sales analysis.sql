#Analysis done in SQL with by using advanced SQL concepts such as CTEs, ranking functions  and  aggregations for better insights#

SELECT 
    *
FROM
    Parks_and_Recreation.europe;
#Changing the data type of the date columns#    
ALTER TABLE europe ADD COLUMN orderdate DATE;
UPDATE europe 
SET 
    orderdate = STR_TO_DATE(`Order Date`, '%m/%d/%Y');
ALTER TABLE europe DROP COLUMN`Order Date`;
ALTER TABLE europe ADD COLUMN shipdate DATE;
UPDATE europe 
SET 
    shipdate = STR_TO_DATE(`Ship Date`, '%m/%d/%Y');
ALTER TABLE europe DROP COLUMN`Ship Date`;

#Avg profit by orderyear#
SELECT 
    YEAR(orderdate) AS orderyear,
    ROUND(AVG(`Total profit`), 0) AS avgprofit
FROM
    europe
GROUP BY orderyear
ORDER BY orderyear;

#AvgProfit by Channel#
SELECT 
    `Sales Channel`,
    ROUND(AVG(`Total profit`), 0) AS avgprofit
FROM
    europe
GROUP BY `Sales Channel` order by avgprofit desc;

#AvgProfit by Item Type#
SELECT 
    `Item Type`,
    ROUND(AVG(`Total profit`), 0) AS avgprofit
FROM
    europe
GROUP BY `Item Type` order by avgprofit desc;


#Top 3 item type with most profit#
SELECT 
    `Item Type`,
    ROUND(AVG(`Total profit`), 0) AS avgprofit
FROM
    europe
GROUP BY `Item Type` order by avgprofit desc limit 3;

#Bottom 3 item types least profit#
SELECT 
    `Item Type`,
    ROUND(AVG(`Total profit`), 0) AS avgprofit
FROM
    europe
GROUP BY `Item Type` order by avgprofit asc limit 3;


#Countries which  gaave the first 3 orders in each  Item type#

with cte as (select *, dense_rank()over(partition by `Item Type` order by orderdate asc) as drank from europe)
select * from cte where drank<=3;

#Avg profit by Units sold#

SELECT 
    `Units Sold`, ROUND(AVG(`Total Profit`), 0) AS avgprofit
FROM
    europe
GROUP BY `Units Sold`
ORDER BY `Units Sold`;

#Comparing the profits earned in the initial year and current year by Item Type#

with cte3 as(with cte2  as (with cte1 as (with cte as (SELECT 
    `Item Type`,
    YEAR(orderdate) AS orderyear,ROUND(AVG(`Total Profit`), 0) AS avgprofit
FROM
    europe
GROUP BY `Item Type`, orderyear order by `Item Type`)
select * from cte where orderyear=2010 or orderyear=2017)
select *,lead(avgprofit)over(partition by `Item Type` order by orderyear) as finalyearprofit from cte1)
select * from cte2 where orderyear<2017)
select `Item Type`,finalyearprofit as 2017avgprofit,avgprofit as 2010avgprofit from cte3;

#Comparing the profits earned in the initial year and current year by Sales Channel#
with cte3 as(with cte2  as (with cte1 as (with cte as (SELECT 
    `Sales Channel`,
    YEAR(orderdate) AS orderyear,ROUND(AVG(`Total Profit`), 0) AS avgprofit
FROM
    europe
GROUP BY `Sales Channel`, orderyear order by `Sales Channel`)
select * from cte where orderyear=2010 or orderyear=2017)
select *,lead(avgprofit)over(partition by `Sales Channel` order by orderyear) as finalyearprofit from cte1)
select * from cte2 where orderyear<2017)
select `Sales Channel`,finalyearprofit as 2017avgprofit,avgprofit as 2010avgprofit from cte3;

#Avg cost by Sales Channel#
SELECT 
    ROUND(AVG(`Total Cost`), 0) AS avgcost, `Sales Channel`
FROM
    europe
GROUP BY `Sales Channel`;

#Avg profit by country#
SELECT 
    ROUND(AVG(`Total Profit`), 0) AS avgprofit, Country
FROM
    europe
GROUP BY Country
ORDER BY avgprofit ASC
LIMIT 5;


select * from europe;

#Avg revenue by country#
SELECT 
    ROUND(AVG(`Total Revenue`), 0) AS avgrevenue, Country
FROM
    europe
GROUP BY Country
ORDER BY avgrevenue ASC
LIMIT 5;

#Avg profit by item type#

with cte as(SELECT 
    ROUND(AVG(`Total Profit`), 0) AS avgprofit, ROUND(AVG(`Total Cost`), 0) AS avgcost, `Item type`
FROM
    europe
GROUP BY `Item type`)
select * from cte where avgprofit>avgcost;

#Total orders by order type#

with cte as (SELECT * from europe where `Sales Channel`="Online") 
   select `Order priority`, COUNT(*) AS totalonlineorders
FROM
    cte
GROUP BY `Order priority`
ORDER BY totalonlineorders DESC ;

#Aggregations on cost,profit and revenue#
with cte as (select year(orderdate) as orderyear, round(avg(`Total Profit`),0) as avgprofit,round(avg(`Total Revenue`),0) as avgrevenue,round(avg(`Total Cost`),0) as avgcost from europe group by orderyear)
select orderyear,avgprofit from cte;


#Avg profit by ship date#
SELECT 
   shipdate, ROUND(AVG(`Total Profit`), 0) AS avgprofit
FROM
    europe
GROUP BY shipdate
ORDER BY shipdate ASC;
    
    

 









