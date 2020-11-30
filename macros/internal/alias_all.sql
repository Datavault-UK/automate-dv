{# BQ Change: Had to call BQ alias cause it has an incompatible prefix macro #}
{%- macro alias_all(columns=none, prefix=none) -%}

    {{- adapter.dispatch('alias_all', packages = ['dbtvault_bq'])(columns=columns, prefix=prefix) -}}

{%- endmacro %}

{%- macro default__alias_all(columns, prefix) -%}

{%- if columns is iterable and columns is not string -%}

    {%- for column in columns -%}
        {{ dbtvault_bq.alias(alias_config=column, prefix=prefix) }}
        {%- if not loop.last -%} , {% endif -%}
    {%- endfor -%}

{%- elif columns is string -%}

{{ dbtvault_bq.alias(alias_config=columns, prefix=prefix) }}

{%- endif -%}

{%- endmacro -%}