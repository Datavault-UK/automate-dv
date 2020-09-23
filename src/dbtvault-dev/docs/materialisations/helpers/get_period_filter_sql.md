{% docs macro__get_period_filter_sql %}

A wrapper around the `replace_placeholder_with_filter` macro which creates a query designed to
build a temporary table, to select the necessary records for the given load cycle. 

{% enddocs %}


{% docs arg__get_period_filter_sql__target_cols_csv %}

A CSV string of the columns to be created in the target table 
(the table the model is creating with this materialisation)

{% enddocs %}


{% docs arg__get_period_filter_sql__base_sql %}

The SQL provided by the model, prior to any manipulation. 

{% enddocs %}