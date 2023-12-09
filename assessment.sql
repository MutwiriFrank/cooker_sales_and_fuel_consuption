1• What is the sales productivity for each channel? 
	
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
		
		
		cooker sale to sale channel
		CSR -18.5
		Agent - 1.2
		Referral - 0.097
		
		
		fuel sale to sale channel
		CSR - 333.8
		Agent -46.7
		Referral - 3
	
		--	 to properly answer this question we need data such as cooker price, fuel price, 
		

a) ◦ Which channel is the most productive?

		Direct sales channel is more productive
		
		
	
b)  Is the most productive channel also the most efficient channel? Why or why not? 
	
		--	total_revenue = cooker price * cookers_sold_per channel + fuel_price * fuel_price_per_channel * litres
		--	cost = commision + salaries + other costs
		--	
		--	efficiency = total revenue/ cost
		yes DIRECT SALES by CSRs is may be more  effective. 
		This is due to  high ratio of  cooker sales(18.5 cookers per CSR)  and fuel sales(333 Litres per CSR) 
		to  Direct Sales(CSR) 
		
--		to properly answer this question we need data such as cooker price, fuel price, commisions, 
--		agent set up cost , salaries  
			

(c) What opportunities might exist to increase sales productivity?
		1. Educating prospective customers and referees on benefit of koko fuel over traditional fuel sources such as charcoal, 
		kerosine and wood which impacts the body negatively.
		
		2. Trainings and education materials -  Educate agents, customers   and CSRs  on the products. Provide  
		
		3. Establish a feedback loop which can be used to improve training and processes such as sales process
		
		4. Providing marketing materials to agents, CSRs and Agents
		
		5 Utilize technology and tools like CRM systems, analytics, automation  to enhance your sales performance 


(d) What additional data would you want to better answer the above questions?
		to properly answer (a) cooker price and fuel price are needed  to calculate total revenue 
		which is divided by each channel total to get productivity per sale channel 	
	
		To properly answer (b) and calculate efficiency   data such as cooker price, fuel price, commisions,
		agent set up cost , salaries  and other costs are needed to calculate total revenue and total costs
		
	
2) What is the average monthly fuel consumption per cooker for each channel?

		select f.customer_id ,  to_char(DATE_TRUNC('month', tx_date::date),  'YYYY-MM') AS months , 
		avg(litres_sold) as avg_litres_sold ,  s."type"  as seller_type 
		from  fuel_sales f
		left join cooker_sales cs  on cs.customer_id  = f.customer_id 
		left join sellers s  on s.id = cs.seller_id 
		group by months,  f.customer_id, s."type"
		order by months,  f.customer_id ,s."type"


		
	with total_cookers_cte as (
		select  s."type" as seller_type , 
			count(customer_id)  as total_cookers
		from  cooker_sales cs  
		left join sellers s  on s.id = cs.seller_id 
		group by s."type"
	)

	select  s."type"  as seller_type ,   to_char(DATE_TRUNC('month', tx_date::date),  'YYYY-MM') AS months , 
		sum(litres_sold) as total_litres_sold   , count(distinct cs.customer_id) as total_unique_cookers, tcc.total_cookers ,
		(sum(litres_sold)  /  tcc.total_cookers ) as average
	from  fuel_sales f
	left join cooker_sales cs  on cs.customer_id  = f.customer_id 
	left join sellers s  on s.id = cs.seller_id 
	left join total_cookers_cte tcc on tcc.seller_type = s."type" 
	group by s."type" , months,  tcc.total_cookers
	order by s."type" , months;


a) Which channel produces the most satisfied customers?

		Agent sale channel produced the most satisfied customers. The customers have a higher average  fuel  consuption per cooker per month .
		The fuel consuption also grew month after month
		jan - 8.44
		feb - 14.62
		march - 15.60

b)Why might fuel consumption differ by sales channel?
	 Customer Demographics of different clients  may differ. for instance customers approached by CSRs may have other fuel alternatives 
	
	 Sales Approach and incetives structure of different channels may differ. Therefore CSRs may focus on selling cooker while agents may focus on selling fuel.
	
	 regional differences  - for example Many CSRs may be in a place where people prefer other fuel sources
	 
	 Customer Preferences
	

c)What opportunities might exist to increase fuel consumption?

		Educating customers  on benefit of koko fuel over traditional fuel sources such as charcoal, 
		kerosine and wood which impacts the body negatively.
		
		Increasing the number of agent to make it very easy for customers to buy Koko fuel.
		
		leverage technology such as crm and data analytics
		
		introduce incetives where customers can get loyalty points after every refill. The points can be redeemed to buy more fuel or airtime.
		
		Establish a feedback loop which can be used  to learn more about the customers and changes to be made 

d)	What additional data would you want to better answer the above questions?
		 Cooker sold on February and March 
