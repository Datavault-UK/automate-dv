{{- config(materialized='table', schema='STG', tags=['static', 'incremental'], enabled=true) -}}

{%- set source_table = source('stage', 'orders_hashed')                                      -%}

{{ dbtvault.multi_hash([('ORDERKEY', 'ORDER_PK'),
                        ('PARTKEY', 'PART_PK'),
                        ('SUPPLIERKEY', 'SUPPLIER_PK'),
                        ('LINENUMBER', 'LINEITEM_PK'),
                        ('CUSTOMERKEY', 'CUSTOMER_PK'),
                        ('CUSTOMER_NATIONKEY', 'CUSTOMER_NATION_PK'),
                        ('CUSTOMER_REGIONKEY', 'CUSTOMER_REGION_PK'),
                        (['PARTKEY', 'SUPPLIERKEY'], 'INVENTORY_PK'),
                        (['LINENUMBER', 'PARTKEY', 'SUPPLIERKEY'], 'INVENTORY_ALLOCATION_PK'),
                        (['COMMITDATE', 'DISCOUNT', 'EXTENDEDPRICE', 'LINESTATUS', 'LINE_COMMENT', 'QUANTITY', 'RECEIPTDATE', 'RETURNFLAG', 'SHIPDATE', 'SHIPINSTRUCT', 'SHIPMODE', 'TAX'], 'LINEITEM_HASHDIFF'),
                        (['LINENUMBER', 'ORDERKEY'], 'LINEITEM_ORDER_PK'),
                        (['CLERK', 'ORDERDATE', 'ORDERPRIORITY', 'ORDERSTATUS', 'ORDER_COMMENT', 'SHIPPRIORITY', 'TOTALPRICE'], 'ORDER_HASHDIFF'),
                        (['CUSTOMERKEY', 'ORDERKEY'], 'ORDER_CUSTOMER_PK'),
                        (['CUSTOMERKEY', 'CUSTOMER_NATIONKEY'], 'LINK_CUSTOMER_NATION_PK'),
                        (['CUSTOMER_ACCBAL', 'CUSTOMER_ADDRESS', 'CUSTOMER_COMMENT', 'CUSTOMER_MKTSEGMENT', 'CUSTOMER_NAME', 'CUSTOMER_PHONE'], 'CUSTOMER_HASHDIFF'),
                        (['CUSTOMER_NATION_COMMENT', 'CUSTOMER_NATION_NAME'], 'CUSTOMER_NATION_HASHDIFF'),
                        (['CUSTOMER_NATIONKEY', 'CUSTOMER_REGIONKEY'], 'CUSTOMER_NATION_REGION_PK'),
                        (['CUSTOMER_REGION_COMMENT', 'CUSTOMER_REGION_NAME'], 'CUSTOMER_REGION_HASHDIFF')]) -}},

{{ dbtvault.add_columns(source_table,
                         [('!TCPH' , 'SOURCE'),
                          ('CURRENT_DATE()', 'LOADDATE')])      }}

{{ dbtvault.from(source_table)                                  }}


