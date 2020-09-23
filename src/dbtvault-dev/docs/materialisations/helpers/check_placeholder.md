{% docs macro__check_placeholder %}

Searches the given SQL string for an expected placeholder, throwing an error if it is not found. 

{% enddocs %}


{% docs arg__check_placeholder__model_sql %}

The SQL string to search.

{% enddocs %}


{% docs arg__check_placeholder__placeholder %}

Optional. Default: `__PERIOD_FILTER__`

The placeholder to search for.

{% enddocs %}