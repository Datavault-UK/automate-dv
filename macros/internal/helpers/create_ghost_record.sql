{%- macro create_ghost_record(src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

    {{- adapter.dispatch('create_ghost_record', 'dbtvault')(src_pk=src_pk, src_hashdiff=src_hashdiff,
                                                            src_payload=src_payload, src_extra_columns=src_extra_columns,
                                                            src_eff=src_eff, src_ldts=src_ldts,
                                                            src_source=src_source, source_model=source_model) -}}

{%- endmacro -%}

{%- macro default__create_ghost_record(src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

{%- set hash = var('hash', 'MD5') -%}
{%- set source_str = var('system_record_value', 'DBTVAULT_SYSTEM') -%}
{%- set columns = adapter.get_columns_in_relation(ref(source_model)) -%}
{%- set col_definitions = [] -%}

{%- set string_columns = [src_payload] -%}

{%- if src_extra_columns != none -%}
    {%- do string_columns.append(src_extra_columns) -%}
{%- endif -%}

{%- for col in columns -%}

    {%- set col_name = col.column -%}

    {%- if (col_name | lower == src_pk | lower) or (col_name | lower == src_hashdiff | lower) -%}
        {%- set col_sql = dbtvault.binary_ghost(alias=col_name, hash=hash) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif (col_name | lower == src_eff | lower) or (col_name | lower == src_ldts | lower) -%}
        {%- if (col.dtype | lower == 'date') -%}
            {%- set col_sql = dbtvault.cast_date('1900-01-01', as_string=true, datetime=false, alias=col_name)-%}
        {%- else -%}
            {%- set col_sql = dbtvault.cast_date('1900-01-01 00:00:00', as_string=true, datetime=true, alias=col_name)-%}
        {%- endif -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name | lower == src_source | lower -%}
        {%- set col_sql -%}
            CAST('{{ source_str }}' AS {{ col.dtype }}) AS {{ src_source }}
        {%- endset -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif (col_name is in string_columns[0]) or (col_name is in string_columns[1]) -%}
        {% set col_sql = dbtvault.null_ghost(col.dtype, col_name) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- endif -%}

{%- endfor -%}

SELECT
    {% for col in col_definitions -%}
    {{ col }}
    {%- if not loop.last -%},
    {% endif %}
    {%- endfor -%}

{%- endmacro -%}

