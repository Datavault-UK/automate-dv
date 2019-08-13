{{config(materialized='view', schema='STAR', enabled=True, tags=['static', 'incremental'])}}

select
  TO_DATE(a.dte) as DATE
, DATE_PART(year, a.dte) as YEAR
, DATE_PART(month, a.dte) as MONTH
, MONTHNAME(a.dte) as MONTH_NAME
, DAYOFYEAR(a.dte) as DAY_OF_YEAR
, DAYNAME(a.dte) as DAY_NAME
, DAYOFMONTH(a.dte) as DAY_OF_MONTH
, WEEKOFYEAR(a.dte) as WEEK_OF_YEAR
, DATE_PART(quarter, a.dte) as QUARTER
, DATE_PART(year, DATEADD(month, -4, a.dte)) as FISCAL_YEAR
from (
select
  dateadd(day, '+' || seq4(), {{var("history_date")}}) as dte
from table(generator(rowcount=>730)) as b) as a