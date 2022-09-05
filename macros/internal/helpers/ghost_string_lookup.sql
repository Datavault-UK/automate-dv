{% macro ghost_string_lookup() %}

    {% set string_lookup = {'STRING':'',
                            'VARCHAR':'',
                            'CHAR':'00000000000000000000000000000000',
                            'INT':'0',
                            'FLOAT':'0.0',
                            'BOOLEAN':'FALSE',
                            'DATETIME':'1900-01-01 00:00:00',
    }}

{% do return(string_lookup) %}