As of v0.5, metadata is provided to the models through the ```dbt_project.yml``` file instead of being specified in
the models themselves. This keeps the metadata all in one place and simplifies the use of dbtvault.

For further detail of the below table templates, see: [table templates](macros.md#table-templates).

!!! note
    In v0.5, only source column metadata is necessary, we have removed target column metadata.  

#### Declaring sources (in the metadata)

Since v0.5, there is no longer the need to state the source using the ```ref``` macro, the new [macros](macros.md) do this all for
you. For single source models, just state the name of the source as a string. 
For the case of union models, just state the sources as a list of strings. Examples of both of these can be seen below:

```yaml tab="Single Source"
hub_customer:
    vars:
      source: 'v_stg_orders'
```

```yaml tab="Union"
hub_nation:
    vars:
      source:
        - 'v_stg_orders'
        - 'v_stg_inventory'
```

#### Hubs

Only the source metadata is needed to build a hub, as column types and names are retained are retained in the target 
table. The parameters that the [hub](macros.md#hub) macro accept are:

| Parameter    | Description                                              | 
| -------------| ---------------------------------------------------------| 
| source       | The staging table that feeds the hub. This can be a single source or a union.  | 
| src_pk       | The column to use for the primary key (should be hashed) |
| src_nk       | The natural key column that the primary key is based on. | 
| src_ldts     | The loaddate timestamp column of the record.             |
| src_source   | The source column of the record.                         |

An example of the metadata structure for a hub is:

```dbt_project.yml```
```yaml
hub_customer:
          vars:
            source: 'stg_customer_hashed'
            src_pk: 'CUSTOMER_PK'
            src_nk: 'CUSTOMER_KEY'
            src_ldts: 'LOADDATE'
            src_source: 'SOURCE'
``` 

#### Links

The link metadata is very similar to the hub metadata. The parameters that the [link](macros.md#link) macro accept are:

| Parameter    | Description                                              | 
| -------------| ---------------------------------------------------------| 
| source       | The staging table that feeds the link. This can be single source or a union. | 
| src_pk       | The column to use for the primary key (should be hashed) |
| src_fk       | The foreign key columns that the make up the primary link key. This must be entered as a list of strings. | 
| src_ldts     | The loaddate timestamp column of the record.             |
| src_source   | The source column of the record.                         |

An example of the metadata structure for a link is:

```dbt_project.yml```
```yaml
link_customer_nation:
          vars:
            source: 'v_stg_orders'
            src_pk: 'LINK_CUSTOMER_NATION_PK'
            src_fk:
              - 'CUSTOMER_PK'
              - 'NATION_PK'
            src_ldts: 'LOADDATE'
            src_source: 'SOURCE'
```

#### Satellites

The metadata for satellites are different from that of links and hubs. The parameters the [sat](macros.md#sat) macro 
accepts is:

| Parameter    | Description                                                         | 
| -------------| ------------------------------------------------------------------- | 
| source       | The staging table that feeds the satellite (only single sources are used for satellites). |               | 
| src_pk       | The primary key column of the table the satellite hangs off.        | 
| src_hashdiff | The hashdiff column of the satellite's payload.                     |
| src_payload  | The columns that make up the payload of the satellite and are used in the hashdiff. The columns must be entered as a list of strings. |
| src_eff      | The effective from date column.                                          |
| src_ldts     | The loaddate timestamp column of the record.                        |
| src_source   | The source column of the record.                                     |

An example of the metadata structure for a satellite is:

```dbt_project.yml```
```yaml
sat_order_customer_details:
          vars:
            source: 'v_stg_orders'
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

#### Transactional links (non-historized links)

The [t_link](macros.md#t_link) macro accepts the following parameters:

| Parameter    | Description                                                         | 
| -------------| ------------------------------------------------------------------- | 
| source       | The staging table that feeds the transactional link (only single sources are used for transactional links). |   
| src_pk       | The primary key column of the transactional link.                   | 
| src_fk       | The foreign key columns that the make up the primary link key. This must be enter as a list of strings |
| src_payload  | The columns that make up and payload of the transactional link. The columns must be entered as a list of strings. |
| src_eff      | The effective from date column.                                          |
| src_ldts     | The loaddate timestamp column of the record.                        |
| src_source   | The source column of the record.                                     |

```dbt_project.yml```
```yaml
t_link_transactions:
          vars:
            source: 'v_stg_transactions'
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

#### Effectivity satellites

Documentation coming soon. Please refer to [eff_sat](macros.md#eff_sat) in the meantime.

#### The problem with metadata

As metadata is stored in the ```dbt_project.yml```, you can probably foresee the file getting very large for bigger 
projects. To help manage large amounts of metadata, we recommend the use of external licence-based tools such as WhereScape, 
Matillion, and erwin Data Modeller. We have future plans to improve metadata handling but in the meantime 
any feedback or ideas are welcome.    
___