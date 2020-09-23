dbtvault is metadata driven. YAML variables are provided to macros via the `dbt_project.yml` file instead of being specified in
the models themselves. This keeps the metadata all in one place and simplifies the use of dbtvault.

For further detail about how to use the macros in this section, see [table templates](macros.md#table-templates).

!!! warning 
    In dbtvault v0.6.1, if you are using dbt v0.17.0 you must use `config-version: 1`. 
    This is a temporary workaround due to removal of model-level variable scoping in dbt core functionality.
    We hope to have a permanent fix for this in future.
    
    Read more:
    
    - [Our suggestion to dbt](https://github.com/fishtown-analytics/dbt/issues/2377) (closed in favour of [2401](https://github.com/fishtown-analytics/dbt/issues/2401))
    - [dbt documentation on the change](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-0-17-0/#better-variable-scoping-semantics)
    

### Staging

Only the source metadata is needed to build a hub, as column types and names are inferred from the source in the target 
table. The parameters that the [stage](macros.md#stage) macro accepts are:

| Parameter     | Description                                               | 
| ------------- | --------------------------------------------------------- | 
| source_model | The name of the staging model that feeds the hub.         | 
| src_pk        | The column to use for the primary key (should be hashed)  |
| src_nk        | The natural key column that the primary key is based on.  | 
| src_ldts      | The loaddate timestamp column of the record.              |
| src_source    | The source column of the record.                          |
                                                                           
An example of the metadata structure for a stage model is:

```yaml tab='All variables' linenums="1"
models:
  my_dbtvault_project:
    staging:
      my_staging_model:
        vars:
          source_model: "raw_source"
          hashed_columns:
            CUSTOMER_PK: "CUSTOMER_ID"
            CUST_CUSTOMER_HASHDIFF:
              is_hashdiff: true
              columns:
                - "CUSTOMER_DOB"
                - "CUSTOMER_ID"
                - "CUSTOMER_NAME"
                - "!9999-12-31"
            CUSTOMER_HASHDIFF:
              is_hashdiff: true
              columns:
                - "CUSTOMER_ID"
                - "NATIONALITY"
                - "PHONE"
          derived_columns:
            SOURCE: "!STG_BOOKING"
            EFFECTIVE_FROM: "BOOKING_DATE"
```

```yaml tab="Only source" linenums="1"
models:
  my_dbtvault_project:
    staging:
      my_staging_model:
        vars:
          source_model: "raw_source"
```

```yaml tab='Only hashing' linenums="1"
models:
  my_dbtvault_project:
    staging:
      my_staging_model:
        vars:
          include_source_columns: false
          source_model: "raw_source"
          hashed_columns:
            CUSTOMER_PK: "CUSTOMER_ID"
            CUST_CUSTOMER_HASHDIFF:
              is_hashdiff: true
              columns:
                - "CUSTOMER_DOB"
                - "CUSTOMER_ID"
                - "CUSTOMER_NAME"
                - "!9999-12-31"
            CUSTOMER_HASHDIFF:
              is_hashdiff: true
              columns:
                - "CUSTOMER_ID"
                - "NATIONALITY"
                - "PHONE"
```

```yaml tab="Only derived" linenums="1"
models:
  my_dbtvault_project:
    staging:
      my_staging_model:
        vars:   
          include_source_columns: false
          source_model: "raw_source"
          derived_columns:
            SOURCE: "!STG_BOOKING"
            EFFECTIVE_FROM: "BOOKING_DATE"
```

#### Constants

In the above examples, there are strings prefixed with `!`. This is syntactical sugar provided in dbtvault which 
makes it easier and cleaner to specify constant values when creating a staging layer. 
These constants can be provided as values of columns specified under `derived_columns` 
and `hashed_columns` as showcased in the provided examples.


### Hubs

Only the source metadata is needed to build a hub, as column types and names are inferred from the source in the target 
table. The parameters that the [hub](macros.md#hub) macro accepts are:

| Parameter     | Description                                               | 
| ------------- | --------------------------------------------------------- | 
| source_model | The name of the staging model that feeds the hub.         | 
| src_pk        | The column to use for the primary key (should be hashed)  |
| src_nk        | The natural key column that the primary key is based on.  | 
| src_ldts      | The loaddate timestamp column of the record.              |
| src_source    | The source column of the record.                          |
                                                                           
An example of the metadata structure for a hub is:

`dbt_project.yml`
```yaml linenums="1"
hub_customer:
  vars:
    source_model: 'stg_customer_hashed'
    src_pk: 'CUSTOMER_PK'
    src_nk: 'CUSTOMER_KEY'
    src_ldts: 'LOADDATE'
    src_source: 'SOURCE'
``` 

### Links

The link metadata is very similar to the hub metadata. The parameters that the [link](macros.md#link) macro accept are:

| Parameter     | Description                                              | 
| ------------- | ---------------------------------------------------------| 
| source_model | The staging table that feeds the link. This can be single source or a union. | 
| src_pk        | The column to use for the primary key (should be hashed) |
| src_fk        | The foreign key columns that the make up the primary link key. This must be entered as a list of strings. | 
| src_ldts      | The loaddate timestamp column of the record.             |
| src_source    | The source column of the record.                         |

An example of the metadata structure for a link is:

`dbt_project.yml`
```yaml linenums="1"
link_customer_nation:
  vars:
    source_model: 'v_stg_orders'
    src_pk: 'LINK_CUSTOMER_NATION_PK'
    src_fk:
      - 'CUSTOMER_PK'
      - 'NATION_PK'
    src_ldts: 'LOADDATE'
    src_source: 'SOURCE'
```

### Satellites

The metadata for satellites are different from that of links and hubs. The parameters the [sat](macros.md#sat) macro 
accepts is:

| Parameter     | Description                                                         | 
| ------------- | ------------------------------------------------------------------- | 
| source_model | The staging table that feeds the satellite (only single sources are used for satellites). |               | 
| src_pk        | The primary key column of the table the satellite hangs off.        | 
| src_hashdiff  | The hashdiff column of the satellite's payload.                     |
| src_payload   | The columns that make up the payload of the satellite and are used in the hashdiff. The columns must be entered as a list of strings. |
| src_eff       | The effective from date column.                                          |
| src_ldts      | The loaddate timestamp column of the record.                        |
| src_source    | The source column of the record.                                     |

An example of the metadata structure for a satellite is:


```yaml tab='Standard' linenums="1"
# dbt_project.yml
sat_order_customer_details:
  vars:
    source_model: 'v_stg_orders'
    src_pk: 'CUSTOMER_PK'
    src_hashdiff: 'CUSTOMER_HASHDIFF'
    src_payload:
      - 'NAME'
      - 'ADDRESS'
      - 'PHONE'
      - 'ACCBAL'
      - 'MKTSEGMENT'
      - 'COMMENT'
    src_eff: 'EFFECTIVE_FROM'
    src_ldts: 'LOADDATE'
    src_source: 'SOURCE'
```

```yaml tab='Hashdiff Aliasing' linenums="1"
# dbt_project.yml
sat_order_customer_details:
  vars:
    source_model: 'v_stg_orders'
    src_pk: 'CUSTOMER_PK'
    src_hashdiff: 
      source_column: "CUSTOMER_HASHDIFF"
      alias: "HASHDIFF"
    src_payload:
      - 'NAME'
      - 'ADDRESS'
      - 'PHONE'
      - 'ACCBAL'
      - 'MKTSEGMENT'
      - 'COMMENT'
    src_eff: 'EFFECTIVE_FROM'
    src_ldts: 'LOADDATE'
    src_source: 'SOURCE'
```

Hashdiff aliasing allows you to set an alias for the `HASHDIFF` column.
[Read more](migration_guides/migrating_v0.5_v0.6.md#hashdiff-aliasing)

### Transactional links (non-historised links)

The [t_link](macros.md#t_link) macro accepts the following parameters:

| Parameter     | Description                                                         | 
| ------------- | ------------------------------------------------------------------- | 
| source_model | The staging table that feeds the transactional link (only single sources are used for transactional links). |   
| src_pk        | The primary key column of the transactional link.                   | 
| src_fk        | The foreign key columns that the make up the primary link key. This must be enter as a list of strings |
| src_payload   | The columns that make up and payload of the transactional link. The columns must be entered as a list of strings. |
| src_eff       | The effective from date column.                                     |
| src_ldts      | The loaddate timestamp column of the record.                        |
| src_source    | The source column of the record.                                    |

`dbt_project.yml`
```yaml linenums="1"
t_link_transactions:
  vars:
    source_model: 'v_stg_transactions'
    src_pk: 'TRANSACTION_PK'
    src_fk:
      - 'CUSTOMER_FK'
      - 'ORDER_FK'
    src_payload:
      - 'TRANSACTION_NUMBER'
      - 'TRANSACTION_DATE'
      - 'TYPE'
      - 'AMOUNT'
    src_eff: 'EFFECTIVE_FROM'
    src_ldts: 'LOADDATE'
    src_source: 'SOURCE'
```
___

### The problem with metadata

As metadata is stored in the `dbt_project.yml`, you can probably foresee the file getting very large for bigger 
projects. To help manage large amounts of metadata, we recommend the use of external licence-based tools such as WhereScape, 
Matillion, and erwin Data Modeller. We have future plans to improve metadata handling but in the meantime 
any feedback or ideas are welcome.    
