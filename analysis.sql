select * from cooker_sales cs  limit 100;
select * from sellers s    limit 100;
select * from fuel_sales fs2  limit 100;


select * from cooker_sales 
where customer_type is null or seller_id is null;


select * from fuel_sales fs2  
where customer_id is null or litres_sold  is null;



-- total cookers sold by different sales channel
select    s."type" , count(*) as total_cookers_sold 
from  cooker_sales cs 
left join sellers s  on s.id = cs.seller_id 
group by s."type" 

--Referrer	970
--CSR	925
--Agent	605


--the count of different seller type
with cte as  ( 
select distinct  s."type" as seller_type , seller_id 
from cooker_sales cs 
left join sellers s  on s.id = cs.seller_id
)
select  seller_type, count(seller_id) as totla_seller_type
from cte
group by seller_type
 
--Referrer	404
--Agent	342
--CSR	50
 

--   koko fuel sold in litres by different sales channel

select  s."type" , count(*) , sum(litres_sold) as total_litres_sold , avg(litres_sold) avg_litres_sold
from  fuel_sales f
left join cooker_sales cs  on cs.customer_id  = f.customer_id 
left join sellers s  on s.id = cs.seller_id 
group by s."type" 

--Referrer	15968	30333.66099999995	1.8996531187374717
--CSR	14529	16690.6229999999	1.1487798884988576
--Agent	10875	23391.11200000012	2.150906850574724



-- total fuel sold by customer type 

select  cs.customer_type  , count(*) , sum(litres_sold), avg(litres_sold)
from  fuel_sales f
left join cooker_sales cs  on cs.customer_id  = f.customer_id 
group by  cs.customer_type

-- household	20779	35334.25999999991	1.7004793300928778
-- restaurant	20593	35081.136000000035	1.7035466420628387


select   customer_type,  s."type" ,  count(customer_id)  
from  cooker_sales cs 
left join sellers s  on s.id = cs.seller_id 
group by customer_type,  s."type" 
order by customer_type, "type"



--sale period for different channels
select s."type" , min(sale_date), max(sale_date)
from cooker_sales cs 
left join sellers s  on s.id = cs.seller_id 
group by s."type" 

--Referrer	2019-01-01	2019-01-31
--CSR	2019-01-01	2019-01-31
--Agent	2019-01-01	2019-01-31

select  s."type" , min(tx_date), max(tx_date)
from  fuel_sales f
left join cooker_sales cs  on cs.customer_id  = f.customer_id 
left join sellers s  on s.id = cs.seller_id 
group by s."type" 

--Referrer	2019-01-01	2019-03-31
--CSR	2019-01-02	2019-03-31
--Agent	2019-01-03	2019-03-31


--how many restaurants and how many households
select  cs.customer_type  ,  count(customer_id) as total_cookers_sold
from  cooker_sales cs 
group by  cs.customer_type  

--household	1245
--restaurant	1255
 
select     s."type" , sale_teritory ,  count(customer_id)  
from  cooker_sales cs 
left join sellers s  on s.id = cs.seller_id 
group by   s."type" , sale_teritory
order by sale_teritory 

select "type", count(*)
from sellers s 
group by "type"


select  s."type"  as seller_type ,   to_char(DATE_TRUNC('month', tx_date::date),  'YYYY-MM') AS months ,  sum(litres_sold) as total_litres_sold 
from  fuel_sales f
left join cooker_sales cs  on cs.customer_id  = f.customer_id 
left join sellers s  on s.id = cs.seller_id 
group by s."type" 		, months
order by months


--per cooker per channel


select  s."type"  as seller_type ,  f.customer_id ,  to_char(DATE_TRUNC('month', tx_date::date),  'YYYY-MM') AS months ,  avg(litres_sold) as total_litres_sold 
from  fuel_sales f
left join cooker_sales cs  on cs.customer_id  = f.customer_id 
left join sellers s  on s.id = cs.seller_id 
group by months, s."type" , f.customer_id
order by months, s."type", f.customer_id

---total FUEL PER CHANNEL
select  s."type"  as seller_type ,   to_char(DATE_TRUNC('month', tx_date::date),  'YYYY-MM') AS months ,  sum(litres_sold) as total_litres_sold 
from  fuel_sales f
left join cooker_sales cs  on cs.customer_id  = f.customer_id 
left join sellers s  on s.id = cs.seller_id 
group by s."type" 		, months
order by months



select  s."type"  as seller_type ,   to_char(DATE_TRUNC('month', tx_date::date),  'YYYY-MM') AS months , 
count(cs.customer_id) 
from  fuel_sales f
left join cooker_sales cs  on cs.customer_id  = f.customer_id 
left join sellers s  on s.id = cs.seller_id 
group by s."type", months


select count(distinct cs.customer_id) ,  to_char(DATE_TRUNC('month', tx_date::date),  'YYYY-MM') AS months 
from  fuel_sales f
left join cooker_sales cs  on cs.customer_id  = f.customer_id  
group by  months

--max and min sale date of cookers
select min(sale_date), max(sale_date)
from cooker_sales cs 
-- 2019-01-01	2019-03-31


select min(tx_date), max(tx_date)
from fuel_sales fs2  
--2019-01-01	2019-03-31
