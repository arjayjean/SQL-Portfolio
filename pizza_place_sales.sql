use pizza_place_sales;

select * from orders;

-- 1.) Select the total number of orders from 2015
select count(*) as order_count from orders;

-- 2.) Select the total number of orders by month; Sorted by the number of orders in a descending order
select monthname(date) as month_name, count(*) as month_count 
from orders
group by month_name
order by month_count DESC;

-- 3.) Select the total number of orders by day; Sorted by the number of orders in a descending order
select dayname(date) as day_name, count(*) as day_count 
from orders
group by day_name
order by day_count DESC;

-- 4.) Select the peak hours; Sorted by the number of orders in a descending order
select case 
	when hour(time) = 12 then concat(hour(time), ' pm')
    when hour(time) > 12 then concat((hour(time) - 12), ' pm')
    when hour(time) < 12 then concat(hour(time), ' am')
end as peak_hour
from orders
group by peak_hour
order by count(*) DESC;

-- 5.) Select the pizza sales from 2015
select round(sum(pizzas.price*od.quantity), 2) as pizza_sale from order_details as od
left join pizzas
using(pizza_id);

-- 6.) Select the pizza sales for each month
select monthname(orders.date) as month_name, round(sum(pizzas.price*od.quantity), 2) as month_sale from orders
left join order_details as od
using(order_id)
left join pizzas
using(pizza_id)
group by month_name
order by month_sale DESC;


-- 7.) Select the Top 5 pizzas and theifrom 2015
select replace(pt.name, 'The ', '') as pizza_name, round(sum(pizzas.price*od.quantity), 2) as year_sale from pizza_types as pt
left join pizzas
using(pizza_type_id)
left join order_details as od
using(pizza_id)
group by pizza_name
order by year_sale DESC
limit 5;