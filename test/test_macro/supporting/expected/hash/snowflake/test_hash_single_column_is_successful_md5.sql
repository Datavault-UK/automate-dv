CAST((MD5_BINARY(NULLIF(UPPER(TRIM(CAST("CUSTOMER_ID" AS VARCHAR))), ''))) AS BINARY(16)) AS "CUSTOMER_PK"