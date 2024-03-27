select * from members order by first_name;

select * from members where region = 'United States';

select member_id, first_name from members where region!='Australia';

select distinct region from members order by region desc;

select region,count(*) as no_of_members from members
group by region
order by no_of_members desc;

select 
(case when region!='United States' then 'Not United States'
else region
end
) region,count(*) as member_count
from members 
group by (case when region!='United States' then 'Not United States'
else region
end
)
order by member_count desc;

select count(*) as total_records from prices;

select ticker,count(*) as no_of_records from prices
group by ticker;

select ticker, min(market_date),max(market_date) from prices
group by ticker;

select extract(month from market_date) as market_month,round(avg(price),2) as avg_price
from prices
where ticker = 'ETH'
group by market_month
order by avg_price;

select market_date,ticker, count(*) as count_extra
from prices
group by market_date,ticker
having count(*)>1;

select count(distinct market_date) as row_count from prices where high>'20000';

select * from prices order by id desc limit 10;

select ticker, count(distinct market_date) as breakout_days_count from prices where price>open
group by ticker;

select ticker, count(distinct market_date) as non_breakout_days_count from prices where price<open
group by ticker;

SELECT
    ticker,
    ROUND(AVG(CASE WHEN price > open THEN 1 ELSE 0 END), 2)*100 AS breakout_day_percent,
    ROUND(AVG(CASE WHEN price < open THEN 1 ELSE 0 END), 2)*100 AS non_breakout_day_percent
FROM
    prices
GROUP BY
    ticker;


select txn_type, count(*) as transaction_count from transactions 
where ticker = 'BTC'
group by txn_type;



with cte as (
select member_id,sum(quantity) as btc_sold_quantity
from transactions
where ticker = 'BTC' and txn_type = 'SELL'
group by member_id
)

select members.*, btc_sold_quantity
from members
inner join cte 
on cte.member_id = members.member_id
where btc_sold_quantity<500
order by btc_sold_quantity desc;
	

select members.*,
sum(case when txn_type = 'BUY' then quantity else 0 end)/sum(case when txn_type = 'SELL' then quantity else 0 end) as buy_to_sell_ratio
from transactions
inner join members
on members.member_id = transactions.member_id
group by members.member_id
order by buy_to_sell_ratio desc;


select members.first_name,
sum(case when txn_type = 'BUY' then transactions.quantity 
	when txn_type = 'SELL' then transactions.quantity end) as total_quantity
from transactions
inner join members
on members.member_id = transactions.member_id
where ticker = 'BTC'
group by members.first_name
order by total_quantity desc;

