
use customer_insights;

select *
from customer;

-- revenue by gender
select gender, sum(purchase_amount) as revenue
from customer
group by gender;



-- which customers used a discount coupon and still spent more than average amount 
select *
from customer;

select customer_id, purchase_amount
from customer
where discount_applied ='Yes' and purchase_amount>=(select avg(purchase_amount) from customer);

-- top 5 products with highest average 

select item_purchased, round(avg(review_rating),2) as avg_rating
from customer
group by item_purchased
order by avg_rating desc
limit 5;

-- compare the average purchase amount between standard and express shipping 

select shipping_type, 
round(avg(purchase_amount),2) as avg_purchase_amount,
round(avg(review_rating),2) as avg_review_rating
from customer
group by shipping_type
having shipping_type in ('Standard', 'Express');


-- do subscribed customers spend more compare on average spend and total revenue

select *
from customer;

select subscription_status, 
count(customer_id),
round(avg(purchase_amount),2) as average_spend,
sum(purchase_amount) as total_revenue
from customer
group by subscription_status;

select item_purchased,
round(100*sum(case when discount_applied = 'Yes' then 1 else 0 end)/count(*),2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;



with customer_type as(
select customer_id, previous_purchases,
case 	
	when previous_purchases=1 then 'New' 
    when previous_purchases between 2 and 10 then 'Returning' 
    else 'Loyal'
    end as customer_segment
    from customer
    )
    
    select customer_segment, count(*) as number_of_customer
    from customer_type
    group by customer_segment;
    
    -- top 3 most purchased product from each category
    select *
    from customer;
    
with item_count as (
select category, item_purchased, count(*) as total_orders, 
row_number()over(partition by category order by count(*)  desc) as item_rank
from customer
group by category, item_purchased)

select item_rank, category, item_purchased, total_orders
from item_count
where item_rank<=3;

-- are the customers who are repeat buyers more likely to subscribe

select *
from customer;

select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases>5
group by subscription_status;


-- revenue by age group 
select age_groups, sum(purchase_amount) as revenue,
row_number() over( order by sum(purchase_amount) desc) as rank_number
from customer
group by age_groups
