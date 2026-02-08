USE sales_dataset;

select *
from orders

-- sum of sales --
select sum(sales)
from orders

-- top 10 customers --
select customer_name , sum(sales) as total_sales
from orders
group by customer_name
order by total_sales desc
limit 10;

-- top 10 products --
select product_name , sum(sales) as total_sales
from orders
group by product_name
order by total_sales desc
limit 10;

-- products above average --
with products_cte as
(
select product_name , sum(sales) as total_sales
from orders
group by product_name
)
select *
from products_cte
where total_sales > (select avg (total_sales) from products_cte)

-- sales by region base on average --
with city_cte as
(
select city , sum(sales) as total_sales
from orders
group by city
)
select *
from city_cte
where total_sales > (select avg (total_sales) from city_cte )
order by total_sales desc


SELECT 
    country,
    city,
    SUM(sales) AS total_sales
FROM orders
GROUP BY country, city
ORDER BY total_sales DESC;

SELECT 
    country,
    city,
    SUM(sales) AS total_sales,
    RANK() OVER (PARTITION BY country ORDER BY SUM(sales) DESC) AS rank_in_country
FROM orders
GROUP BY country, city;

-- monthly sales (time trend) --
select MONTH(STR_TO_DATE(order_date, '%d/%m/%y')) as month_number , sum(sales) as total_sales
from orders
group by month_number
order by month_number;

-- monthly sales (sales trend) --
select MONTH(STR_TO_DATE(order_date, '%d/%m/%y')) as month_number , sum(sales) as total_sales
from orders
group by month_number
order by total_sales desc;

-- most sales year --
select year(STR_TO_DATE(order_date, '%d/%m/%y')) as year_number , sum(sales) as total_sales
from orders
group by year_number
order by total_sales desc
limit 1;

-- calculated average order value -- 
select avg(order_total)
from (
select order_id , sum(sales) as order_total
from orders
group by order_id) x ;


WITH order_totals AS (
    SELECT
        order_id,
        SUM(sales) AS order_total
    FROM orders
    GROUP BY order_id
)
SELECT AVG(order_total)
FROM order_totals;
