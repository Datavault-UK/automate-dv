{%- macro sat_template(src_pk, src_hashdiff, src_payload,
                       src_eff, src_ldts, src_source,
                       tgt_pk, tgt_hashdiff, tgt_payload,
                       tgt_eff, tgt_ldts, tgt_source,
                       src_table, hash_model) -%}

SELECT e.CUSTOMER_PK, e.CUST_CUSTOMER_HASHDIFF AS HASHDIFF, e.CUSTOMER_NAME AS NAME, e.CUSTOMER_DOB AS DOB, e.EFFECTIVE_FROM, e.LOADDATE, e.SOURCE
FROM DV_PROTOTYPE_DB.SRC_TEST_VLT.TEST_STG_CUSTOMER_HASHED AS e
LEFT JOIN (
    SELECT d.CUSTOMER_PK, d.HASHDIFF, d.NAME, d.DOB, d.EFFECTIVE_FROM, d.LOADDATE, d.SOURCE
    FROM (
          SELECT c.CUSTOMER_PK, c.HASHDIFF, c.NAME, c.DOB, c.EFFECTIVE_FROM, c.LOADDATE, c.SOURCE,
          CASE WHEN RANK() OVER (PARTITION BY c.CUSTOMER_PK ORDER BY c.LOADDATE DESC) = 1 THEN 'Y' ELSE 'N' END CURR_FLG
          FROM (
            SELECT a.CUSTOMER_PK, a.HASHDIFF, a.NAME, a.DOB, a.EFFECTIVE_FROM, a.LOADDATE, a.SOURCE
            FROM DV_PROTOTYPE_DB.SRC_TEST_VLT.TEST_SAT_CUST_CUSTOMER_DETAILS as a
            JOIN DV_PROTOTYPE_DB.SRC_TEST_VLT.TEST_STG_CUSTOMER_HASHED as b
            ON a.CUSTOMER_PK = b.CUSTOMER_PK
          ) as c
    ) AS d
WHERE d.CURR_FLG = 'Y') AS src
ON src.HASHDIFF = e.CUST_CUSTOMER_HASHDIFF
WHERE src.HASHDIFF IS NULL

{% endmacro %}