CREATE PROCEDURE `get_forecast_accuracy` (
    in_fiscal_year int
)
BEGIN
with forecast_err_table as (select
     s.customer_code,
     sum(s.sold_quantity) as total_sold_qty,
     sum(s.forecast_quantity) as total_forecast_qty,
     sum((forecast_quantity-sold_quantity)) as net_err,
     sum((forecast_quantity-sold_quantity))*100/sum(forecast_quantity),
     sum(abs(forecast_quantity-sold_quantity)) as abs_err,
     sum(abs(forecast_quantity-sold_quantity))*100/sum(forecast_quantity)
from gdb0041.fact_act_est s
where s.fiscal_year=2021
group by customer_code)
select
   e.*,
   c.customer,
   c.market,
   if (abs_err_pct>100, 0, 100-abs_err_pct) as forecast_accuracy
from forecast_err_table e
join dim_customer c
using (customer_code)
order by forecast_accuracy desc;   
END
