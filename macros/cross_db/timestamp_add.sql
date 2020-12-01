{% macro timestamp_add(datepart, interval, from_date_or_timestamp) %}
  {{ adapter.dispatch('timestamp_add', packages = dbtvault_bq._get_dispatch_lookup_packages()
    )(datepart, interval, from_date_or_timestamp) }}
{% endmacro %}


{% macro default__timestamp_add(datepart, interval, from_date_or_timestamp) %}
  dateadd(
      {{ datepart }},
      {{ interval }},
      {{ from_date_or_timestamp }}
  )

{% endmacro %}


{% macro bigquery__timestamp_add(datepart, interval, from_date_or_timestamp) %}
  TIMESTAMP_ADD(
      SAFE_CAST( {{ from_date_or_timestamp }} AS TIMESTAMP),
      INTERVAL {{ interval }} {{ datepart }}
  )
{% endmacro %}
