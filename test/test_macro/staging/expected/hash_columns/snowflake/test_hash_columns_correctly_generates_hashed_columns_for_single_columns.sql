CAST((MD5_BINARY(NULLIF(UPPER(TRIM(CAST("BOOKING_REF" AS VARCHAR))), ''))) AS BINARY(16)) AS "BOOKING_PK",
CAST((MD5_BINARY(NULLIF(UPPER(TRIM(CAST("CUSTOMER_ID" AS VARCHAR))), ''))) AS BINARY(16)) AS "CUSTOMER_PK"