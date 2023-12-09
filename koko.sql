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

\COPY Sellers  FROM /home/mutwiri/koko/data/Sellers.csv DELIMITERS ',' CSV HEADER;

\COPY cooker_sales  FROM /home/mutwiri/koko/data/Cooker_Sales.csv DELIMITERS ',' CSV HEADER;

\COPY fuel_sales  FROM /home/mutwiri/koko/data/Fuel_Sales.csv DELIMITERS ',' CSV HEADER;



