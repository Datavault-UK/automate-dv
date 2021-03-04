{%- macro date_timestamp(out_of_sequence) %}

{# {% set date_regex = '^\d{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])$'%} #}
{# {% set datetime_regex = '/^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})$/' %} #}

{%- if 'insert_date' in out_of_sequence.keys() %}

  {%- set insert_date = out_of_sequence['insert_date'] %}

  DATE('{{ insert_date }}')

{%- elif 'insert_timestamp' in out_of_sequence.keys() %}

  {%- set insert_timestamp = out_of_sequence['insert_timestamp']%}

  TO_TIMESTAMP('{{ insert_timestamp }}')

{%- else %}

{# raise error #}

{% endif -%}

{% endmacro -%}