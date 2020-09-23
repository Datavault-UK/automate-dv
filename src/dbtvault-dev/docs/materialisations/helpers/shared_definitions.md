{% docs arg__period_materialisation__timestamp_field %}

The field to reference and extract timestamps and dates from. 

This should be the same as the `src_ldts` attribute if using a table macro.

{% enddocs %}


{% docs arg__period_materialisation__offset %}

The period of time to offset the start of the load from. For example, if period is set to `day` and the offset is `1`, then
this will evaluate to `start + 1 day`

{% enddocs %}


{% docs arg__period_materialisation__period %}

The period of time to iterate through. The naming varies per platform, though some common examples are:

- hour
- day
- month
- year

See below for platform specific documentation.

[Snowflake](https://docs.snowflake.com/en/sql-reference/functions-date-time.html#supported-date-and-time-parts)

{% enddocs %}


{% docs arg__period_materialisation__start_timestamp %}

The starting timestamp for the range of records to be loaded. 
Records must have a timestamp greater or equal to this value to be included.

{% enddocs %}


{% docs arg__period_materialisation__stop_timestamp %}

The stopping timestamp for the range of records to be loaded. 
Records must have a timestamp less than this value to be included.

{% enddocs %}