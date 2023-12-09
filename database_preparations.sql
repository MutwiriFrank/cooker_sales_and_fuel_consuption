--DDL

drop table if exists Sellers CASCADE;
create table Sellers(
	id int primary key,
	type varchar(100)
);


drop table if exists Cooker_Sales;

create table Cooker_Sales(
	customer_id bigint primary key ,
	customer_type varchar(100),
	sale_date date,
	sale_teritory varchar(100),
	seller_id integer references Sellers (id)
);


drop table if exists Fuel_Sales;

create table Fuel_Sales(
	customer_id bigint references Cooker_Sales(customer_id) ,
	tx_date date,
	litres_sold float
);

\COPY Sellers  FROM F:\koko\data\Sellers.csv DELIMITERS ',' CSV HEADER;

\COPY cooker_sales  FROM F:\koko\data\Cooker_Sales.csv DELIMITERS ',' CSV HEADER;

\COPY fuel_sales  FROM F:\koko\data\Fuel_Sales.csv DELIMITERS ',' CSV HEADER;



CREATE MATERIALIZED VIEW sales_productivity_view
AS
	with total_seller_cte as  ( 
				select    "type" as   seller_type , count(*) as total_seller_type
				from sellers s 
				group by "type"
			),
			total_cookers_cte as (
				select    s."type" as seller_type , count(*) as total_cookers_sold 
				from  cooker_sales cs 
				left join sellers s  on s.id = cs.seller_id 
				group by s."type" 
			), 
			total_fuel_cte as (
				select  s."type"  as seller_type ,   sum(litres_sold) as total_litres_sold 
				from  fuel_sales f
				left join cooker_sales cs  on cs.customer_id  = f.customer_id 
				left join sellers s  on s.id = cs.seller_id 
				group by s."type" 		
	)
					
	select tc.seller_type, total_seller_type, total_cookers_sold, total_litres_sold,  
	(total_cookers_sold::decimal/total_seller_type) as cooker_sales_ratio, (total_litres_sold::decimal/total_seller_type) as fuel_sales_ratio 
	from total_cookers_cte tc
	left join total_seller_cte ts on tc.seller_type = ts.seller_type
	left join total_fuel_cte tf on   tc.seller_type = tf.seller_type
WITH NO DATA;


REFRESH MATERIALIZED VIEW sales_productivity_view;

select * from sales_productivity_view;

drop materialized  view fuel_sales_view;

create  MATERIALIZED VIEW fuel_sales_view
AS
with total_cookers_cte as (
		select  s."type" as seller_type , 
			count(customer_id)  as total_cookers
		from  cooker_sales cs  
		left join sellers s  on s.id = cs.seller_id 
		group by s."type"
	)

	select  s."type"  as seller_type ,   to_char(DATE_TRUNC('month', tx_date::date),  'YYYY-MM') AS months , 
		sum(litres_sold) as total_litres_sold   , count(distinct cs.customer_id) as total_unique_cookers_per_month, tcc.total_cookers ,
		(sum(litres_sold)  /  tcc.total_cookers ) as average
	from  fuel_sales f
	left join cooker_sales cs  on cs.customer_id  = f.customer_id 
	left join sellers s  on s.id = cs.seller_id 
	left join total_cookers_cte tcc on tcc.seller_type = s."type" 
	group by s."type" , months,  tcc.total_cookers
	order by s."type" , months
WITH NO DATA;


REFRESH MATERIALIZED VIEW fuel_sales_view;

select * from fuel_sales_view;






