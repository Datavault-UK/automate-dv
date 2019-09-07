
        insert into DV_PROTOTYPE_DB.SRC_VLT.hub_customer (CUSTOMER_PK, CUSTOMERKEY, SOURCE, LOADDATE)
        (
            select CUSTOMER_PK, CUSTOMERKEY, SOURCE, LOADDATE
            from DV_PROTOTYPE_DB.SRC_VLT.hub_customer__dbt_tmp
        );
      
    