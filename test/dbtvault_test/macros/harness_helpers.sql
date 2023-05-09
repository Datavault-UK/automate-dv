{%- macro check_table_exists(model_name) -%}

    {%- set source_relation = adapter.get_relation(database=target.database,
                                                   schema=dbtvault_test.get_schema_name(),
                                                   identifier=model_name) -%}

    {%- if source_relation -%}
        {%- do log("Table '{}' exists.".format(model_name), true) -%}
        {%- do return(True) %}
    {%- else -%}
        {%- do log("Table '{}' does not exist.".format(model_name), true) -%}
        {%- do return(False) %}
    {%- endif -%}

    {%- do return(False) %}

{%- endmacro -%}

{%- macro check_source_exists(source_name, table_name) -%}

    {%- set source = source(source_name, table_name) -%}
    {%- set source_relation = adapter.get_relation(database=source.database,
                                                   schema=source.schema,
                                                   identifier=source.identifier)-%}


    {%- if source_relation.is_table or source_relation.is_view -%}
        {%- do log("Source '{}:{}' exists.".format(source_name, table_name), true) -%}
        {%- do return(True) %}
    {%- else -%}
        {%- do log("Source '{}:{}' does not exist.".format(source_name, table_name), true) -%}
        {%- do return(False) %}
    {%- endif -%}

{%- endmacro -%}


{%- macro recreate_schema(schema_name=None) -%}

    {%- if not schema_name -%}
        {%- set schema_name = dbtvault_test.get_schema_name() %}
    {%- endif -%}

    {%- set schema_relation = api.Relation.create(database=target.database, schema=schema_name) -%}

    {%- do adapter.drop_schema(schema_relation) -%}
    {%- do adapter.create_schema(schema_relation) -%}

{%- endmacro -%}


{%- macro get_hash_length(hash_alg, columns, schema_name, table_name) -%}

    {{- adapter.dispatch('get_hash_length', 'dbtvault_test')(hash_alg=hash_alg, columns=columns, schema_name=schema_name, table_name=table_name) -}}

{%- endmacro -%}


{%- macro postgres__get_hash_length(hash_alg, columns, schema_name, table_name) -%}

    {%- set hash_alg = var('hash', 'MD5') -%}
    {%- if hash_alg == 'MD5' -%}

        WITH CTE AS (
            SELECT DECODE(MD5("{{ columns }}"), 'hex') AS HK
                , "{{ columns }}" AS {{ columns }}
            FROM "{{ schema_name }}".{{ table_name }}
        )
        SELECT
            {{ columns }}
            , length(HK) AS HASH_VALUE_LENGTH
        FROM CTE

    {%- else -%}
        {%- do log('Test is currently only supported for MD5 hashing', info=True) -%}
        {%- do return(False) -%}
    {%- endif -%}


{%- endmacro -%}