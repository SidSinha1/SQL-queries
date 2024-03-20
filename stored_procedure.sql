CREATE DEFINER=`root`@`localhost` PROCEDURE `get_monthly_gross_sales_for_customer`(
   c_code int
)
BEGIN
   select
s.date,
sum(round(g.gross_price*sold_quantity,2)) as gross_price_totalo
from fact_sales_monthly s
join fact_gross_price g
on 
   g.product_code=s.product_code and 
   g.fiscal_year=get_fiscal_year(s.date)
   where
   customer_code=c_code
group by s.date;
END