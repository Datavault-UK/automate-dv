{%- macro null_columns(source_relation=none, columns=none) -%}

    {%- set required = columns['REQUIRED'] | indent(4) -%}
    {%- set optional = columns['OPTIONAL'] | indent(4) -%}

    SELECT
        {{ null_columns['REQUIRED'] }}
        CUSTOMER_ID AS CUSTOMER_ID_ORIGINAL,
        IFNULL(CUSTOMER_ID, '-1') AS CUSTOMER_ID_NEW,
        CUSTOMER_NAME,
        CUSTOMER_DOB,
        CUSTOMER_PHONE,
        LOAD_DATE,
        md5(CUSTOMER_ID_NEW) AS CUSTOMER_PK,
        '1993-01-01' AS EFFECTIVE_FROM,
        'RAW_STAGE' AS SOURCE,
        '1' AS DBTVAULT_RANK
    FROM "DBTVAULT_DEV"."TEST_SIOBHAN_STRANGE"."RAW_STAGE_SEED"

{%- endmacro -%}