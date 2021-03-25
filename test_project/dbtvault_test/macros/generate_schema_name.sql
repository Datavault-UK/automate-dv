{% macro generate_schema_name(custom_schema_name, node) -%}
    {{ dbtvault_test.get_schema_name() }}
{%- endmacro %}


{% macro get_schema_name() -%}

    {%- set schema_name -%}
        {{- target.schema -}}_{{ env_var('SNOWFLAKE_DB_USER') }}{{ '_' ~ env_var('CIRCLE_BRANCH', '') | replace('-','_') | replace('.','_') | replace('/','_') if env_var('CIRCLE_BRANCH', '') -}}
        {{- '_' ~ env_var('CIRCLE_JOB', '') if env_var('CIRCLE_JOB', '') -}}
        {{- '_' ~ env_var('CIRCLE_NODE_INDEX', '') if env_var('CIRCLE_NODE_INDEX', '') -}}
    {%- endset -%}

    {% do return(schema_name) %}

{%- endmacro %}