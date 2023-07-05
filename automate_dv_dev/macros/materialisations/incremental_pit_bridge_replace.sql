/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{% macro incremental_pit_replace(tmp_relation, target_relation, statement_name="main") %}

    {{ adapter.dispatch('incremental_pit_replace', 'automate_dv')(tmp_relation=tmp_relation,
                                                                    target_relation=target_relation,
                                                                    statement_name="main") }}

{%- endmacro -%}

{% macro default__incremental_pit_replace(tmp_relation, target_relation, statement_name="main") %}
    {%- set dest_columns = adapter.get_columns_in_relation(target_relation) -%}
    {%- set dest_cols_csv = dest_columns | map(attribute='quoted') | join(', ') -%}

    TRUNCATE TABLE {{ target_relation }};

    INSERT INTO {{ target_relation }} ({{ dest_cols_csv }})
    (
       SELECT {{ dest_cols_csv }}
       FROM {{ tmp_relation }}
    );
{%- endmacro %}


{% macro databricks__incremental_pit_replace(tmp_relation, target_relation, statement_name="main") %}
    {%- set dest_columns = adapter.get_columns_in_relation(target_relation) -%}
    {%- set dest_cols_csv = dest_columns | map(attribute='quoted') | join(', ') -%}

    INSERT OVERWRITE {{ target_relation }} ({{ dest_cols_csv }})
       SELECT {{ dest_cols_csv }}
       FROM {{ tmp_relation }};

{%- endmacro %}



{% macro incremental_bridge_replace(tmp_relation, target_relation, statement_name="main") %}

    {{ adapter.dispatch('incremental_bridge_replace', 'automate_dv')(tmp_relation=tmp_relation,
                                                                    target_relation=target_relation,
                                                                    statement_name="main") }}

{%- endmacro -%}


{% macro default__incremental_bridge_replace(tmp_relation, target_relation, statement_name="main") %}
    {%- set dest_columns = adapter.get_columns_in_relation(target_relation) -%}
    {%- set dest_cols_csv = dest_columns | map(attribute='quoted') | join(', ') -%}

    TRUNCATE TABLE {{ target_relation }};

    INSERT INTO {{ target_relation }} ({{ dest_cols_csv }})
    (
       SELECT {{ dest_cols_csv }}
       FROM {{ tmp_relation }}
    );
{%- endmacro %}


{% macro databricks__incremental_bridge_replace(tmp_relation, target_relation, statement_name="main") %}
    {%- set dest_columns = adapter.get_columns_in_relation(target_relation) -%}
    {%- set dest_cols_csv = dest_columns | map(attribute='quoted') | join(', ') -%}

    INSERT OVERWRITE {{ target_relation }} ({{ dest_cols_csv }})
       SELECT {{ dest_cols_csv }}
       FROM {{ tmp_relation }}
    ;
{%- endmacro %}



