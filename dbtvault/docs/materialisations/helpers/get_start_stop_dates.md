{% docs macro__get_start_stop_dates %}

A helper macro to fetch the start and stop dates to load with. It will either infer the date range from the min and max 
dates present in the tables in `date_source_models` list, or alternatively use the `start_date` and `stop_date` 
config options. The config options take precedence if both are provided. A suitable error is raised if neither is provided.

{% enddocs %}


{% docs arg__get_start_stop_dates__date_source_models %}

A list of models to union together and extract min and max dates from, which will be used as the range to load records with. 

{% enddocs %}