{% macro ghost_string_lookup() %}

    {% set string_lookup = {'TYPE_STRING': 'NULL',
                            'TYPE_VARCHAR': 'NULL',
                            'TYPE_VARCHAR(50)': 'NULL',
                            'TYPE_CHAR(32)':'00000000000000000000000000000000',
                            'TYPE_INT':'0',
                            'TYPE_FLOAT':'0.0',
                            'TYPE_BOOLEAN':'FALSE',
                            'TYPE_DATETIME':'1900-01-01 00:00:00',
                            'TYPE_DATETIME2':'1900-01-01 00:00:00',
                            'TYPE_DATE':'1900-01-01',
                            'TYPE_BINARY':'00000000000000000000000000000000',
                            'TYPE_bytea':'00000000000000000000000000000000',
                            'TYPE_BINARY(16)':'00000000000000000000000000000000',
                            'TYPE_BINARY(30)':'00000000000000000000000000000000',
                            'TYPE_character varying':'NULL',
                            'TYPE_date':'1900-01-01',
                            'TYPE_character varying(50)':'NULL',
                            'TYPE_varchar':'NULL',
                            'TYPE_binary':'00000000000000000000000000000000'
    } %}

{% do return(string_lookup) %}

{% endmacro %}