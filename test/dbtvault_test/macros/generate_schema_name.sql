{% macro generate_schema_name(custom_schema_name, node) -%}
    {{ dbtvault_test.get_schema_name() }}
{%- endmacro %}


{% macro get_schema_name() -%}
    {{- adapter.dispatch('get_schema_name', 'dbtvault_test')() -}}
{%- endmacro -%}

{% macro default__get_schema_name() -%}

    {%- set schema_name = "{}_{}{}".format(target.schema, target.user, pipeline_string) -%}

    {% do return(clean_schema_name(schema_name)) %}

{%- endmacro -%}

{%- macro bigquery__get_schema_name() -%}

    {%- set schema_name = "{}_{}{}".format(target.dataset, target.project, pipeline_string)  -%}

    {% do return(clean_schema_name(schema_name)) %}

{%- endmacro %}

{%- macro sqlserver__get_schema_name() -%}

    {%- set schema_name = "{}_{}{}".format(target.schema, target.user, pipeline_string) -%}

    {% do return(clean_schema_name(schema_name)) %}

{%- endmacro %}

{%- macro clean_schema_name(schema_name) -%}

    {%- do return(schema_name | replace('-','_') | replace('.','_') | replace('/','_')) -%}

{%- endmacro -%}


{%- macro append_pipeline_string() -%}

    {%- set pipeline_string -%}
        {{- '_' ~ env_var('CIRCLE_BRANCH', '') | replace('-','_') | replace('.','_') | replace('/','_') if env_var('CIRCLE_BRANCH', '') -}}
        {{- '_' ~ env_var('CIRCLE_JOB', '') if env_var('CIRCLE_JOB', '') -}}
        {{- '_' ~ env_var('CIRCLE_NODE_INDEX', '') if env_var('CIRCLE_NODE_INDEX', '') -}}
    {%- endset -%}

    {% do return(pipeline_string) %}

{%- endmacro -%}