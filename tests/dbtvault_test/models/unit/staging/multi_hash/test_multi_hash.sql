{{ dbtvault.multi_hash([('CUSTOMER_ID', 'CUSTOMER_PK'),
                         (['CUSTOMER_ID', 'CUSTOMER_NAME', 'CUSTOMER_DOB'],
                         'CUST_CUSTOMER_HASHDIFF', true),
                         (['CUSTOMER_ID', 'CUSTOMER_NAME', 'CUSTOMER_DOB'],
                         'CUSTOMER_HASHDIFF', true)])                       -}}