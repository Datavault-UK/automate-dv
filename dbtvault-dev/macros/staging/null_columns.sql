{%- macro null_columns(source_relation=none, columns=none) -%}

    {%- set required = columns['REQUIRED'] | indent(4) -%}
    {%- set optional = columns['OPTIONAL'] | indent(4) -%}

    {% if required is not none and required != ''  %}
    {{ required }} AS {{ required }}_ORIGINAL,
    IFNULL({{ required }}, '-1') AS {{ required }}_NEW,
    {% endif  %}

    {% if optional is not none and optional != ''  %}
    {{ optional }} AS {{ optional }}_ORIGINAL,
    IFNULL({{ optional }}, '-1') AS {{ optional }}_NEW,
    {% endif  %}

    CUSTOMER_NAME,
    CUSTOMER_DOB,
    CUSTOMER_PHONE,
    LOAD_DATE,
    md5(CUSTOMER_ID_NEW) AS CUSTOMER_PK,
    '1993-01-01' AS EFFECTIVE_FROM,
    'RAW_STAGE' AS SOURCE,
    '1' AS DBTVAULT_RANK

{%- endmacro -%}