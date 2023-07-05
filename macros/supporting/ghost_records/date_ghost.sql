{%- macro date_ghost(date_type, alias) -%}
    {{ adapter.dispatch('date_ghost', 'automate_dv')(date_type=date_type, alias=alias) }}
{%- endmacro -%}

{%- macro default__date_ghost(date_type, alias=none) -%}

        {%- if date_type == 'date' -%}
            {{ automate_dv.cast_date('1900-01-01', as_string=true, datetime=false, alias=alias) }}
        {%- else -%}
            {{ automate_dv.cast_date('1900-01-01 00:00:00', as_string=true, datetime=true, alias=alias, date_type=date_type) }}
        {%- endif -%}

{%- endmacro -%}