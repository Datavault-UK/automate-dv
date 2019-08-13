{% macro bank_holiday_calc(dte) %}

case
  when DATE_PART(month, dte) = 1 and DATE_PART(day, dte) = 1 then 'New Years Day'
  when then 'Good Friday'

{% endmacro %}