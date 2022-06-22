RANK() OVER (PARTITION BY "CUSTOMER_ID" ORDER BY "BOOKING_DATE") AS "DBTVAULT_RANK",
DENSE_RANK() OVER (PARTITION BY "TRANSACTION_ID" ORDER BY "TRANSACTION_DATE") AS "SAT_RANK"