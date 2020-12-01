{% macro _get_dispatch_lookup_packages() %}
  {% set override_namespaces = var('dbtvault_bq_dispatch_list', []) %}
  {% do return(override_namespaces + ['dbtvault_bq']) %}
{% endmacro %}