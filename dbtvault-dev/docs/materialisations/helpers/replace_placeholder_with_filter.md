{% docs macro__replace_placeholder_with_filter %}

Replace the `__PERIOD_FILTER__` string present in the given SQL, with a `WHERE` clause which filters data by a
specific `period` of time, `offset` from the `start_date`.

{% enddocs %}


{% docs arg__replace_placeholder_with_filter__core_sql %}

SQL string containing the `__PERIOD_FILTER__` string.

{% enddocs %}