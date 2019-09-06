{{config(materialized='incremental', schema='test_vlt', enabled=true, tags='feature')}}

SELECT
                CAST(CUSTOMER_PK AS BINARY(16)) AS CUSTOMER_PK,
                CAST(CUSTOMERKEY AS NUMBER(38,0)) AS CUSTOMERKEY,
                CAST(SOURCE AS VARCHAR(4)) AS SOURCE,
                CAST(LOADDATE AS DATE) AS LOADDATE
 FROM (
    SELECT DISTINCT CUSTOMER_PK, CUSTOMERKEY, SOURCE, LOADDATE,
           lag(SOURCE, 1)
           over(partition by CUSTOMER_PK
           order by CUSTOMER_PK) as FIRST_SOURCE
    FROM (SELECT DISTINCT a.CUSTOMER_PK, a.CUSTOMERKEY, a.SOURCE, a.LOADDATE
        FROM DV_PROTOTYPE_DB.SRC_TEST_STG.STG_CUSTOMER AS a
        LEFT JOIN {{ this }} AS c
        ON a.CUSTOMER_PK = c.CUSTOMER_PK
        AND c.CUSTOMER_PK IS NULL
        )
 AS b)
AS stg
WHERE FIRST_SOURCE IS NULL