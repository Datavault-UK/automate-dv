{% docs macro__get_period_boundaries %}

Get the start and stop timestamp, as well as the number of periods/iterations which need to be made to do the full load.
It is important to note that this materialisation handles the idempotent nature of the materialisation by running a `COALESCE`
on the maximal date found in the target table if it already exists, and the provided `start_date`. 

This also allows the materialisation to handle aborted loads.

{% enddocs %}


{% docs arg__get_period_boundaries__target_schema %}

The schema that the target table is materialised in.

{% enddocs %}


{% docs arg__get_period_boundaries__target_table %}

The name of the materialised target table.

{% enddocs %}


{% docs arg__get_period_boundaries__start_date %}

The date stamp to start loading from. Must be in the format 'YYYY-MM-DD'

{% enddocs %}


{% docs arg__get_period_boundaries__stop_date %}

THe date stamp to stop loading on. Must be in the format 'YYYY-MM-DD'

{% enddocs %}