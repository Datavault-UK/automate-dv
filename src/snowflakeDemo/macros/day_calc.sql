{% macro day_calc(dte) %}

case
  when DAYOFWEEK(dte) = 0 then 'Sunday'
  when DAYOFWEEK(dte) = 1 then 'Monday'
  when DAYOFWEEK(dte) = 2 then 'Tuesday'
  when DAYOFWEEK(dte) = 3 then 'Wednesday'
  when DAYOFWEEK(dte) = 4 then 'Thursday'
  when DAYOFWEEK(dte) = 5 then 'Friday'
  when DAYOFWEEK(dte) = 6 then 'Saturday'
  end

{% endmacro %}