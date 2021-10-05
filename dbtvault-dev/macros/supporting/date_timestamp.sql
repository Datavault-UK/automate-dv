{%- macro date_timestamp(out_of_sequence) -%}

    {{- adapter.dispatch('date_timestamp', 'dbtvault')(out_of_sequence=out_of_sequence) -}}

{%- endmacro %}

{%- macro default__date_timestamp(out_of_sequence) %}

{%- if 'insert_date' in out_of_sequence.keys() %}

  {%- set insert_date = out_of_sequence['insert_date'] %}

  DATE('{{ insert_date }}')

{%- elif 'insert_timestamp' in out_of_sequence.keys() %}

  {%- set insert_timestamp = out_of_sequence['insert_timestamp']%}

  TO_TIMESTAMP('{{ insert_timestamp }}')

{%- else %}

  {{- exceptions.raise_compiler_error("ERROR: Missing parameter either insert_date or insert_timestamp.") -}}

{% endif -%}

{% endmacro -%}