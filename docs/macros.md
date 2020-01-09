## Table templates 
######(macros/tables)

These macros form the core of the package and can be called in your models to build the different types of tables needed
for your Data Vault.

### Metadata notes
#### Using a source reference for the target metadata

In the usage examples for the table template macros in this section, you will see ```source``` provided as the values
for some of the target metadata variables. ```source``` has been declared as a variable at the top of the models, 
and holds a reference to the source table we are loading from. This is shorthand for retaining the name and data types 
of the columns as they are provided in the ```src``` variables. You may wish to alias the columns or change their data 
types in specific circumstances, which is possible by providing an additional parameter as a list of triples: 
``` (source column name, data type to cast to, target column name)```.

Both approaches are shown in the snippet below:

```mysql
{%- set src_pk = 'CUSTOMER_NATION_PK'                           -%}
{%- set src_fk = ['CUSTOMER_PK', 'NATION_PK']                   -%}
{%- ...other src metadata...                                    -%}

{%- set tgt_pk = source                                         -%}
{%- set tgt_fk = [['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_FK'], 
                  ['NATION_PK', 'BINARY(16)', 'NATION_FK']]     -%}
```

Here, we are keeping the ```tgt_pk``` (the target table's primary key) the same as the primary key identified in the
source (```src_pk```).
Behind the scenes, the macro will get the datatype of the column provided in the ```src_pk``` variable and generate a 
mapping for us. If the ```src_pk``` column does not exist, an appropriate exception will be raised.

Alternatively we have provided a manual mapping for the ```tgt_fk``` (the target table's foreign key). 

*For further details and examples on both methods, refer to the usage examples 
and snippets in the table template documentation below (both Single-Source and Union).*

!!! note
    If only aliasing and **not** changing data types, we suggest using the [add_columns](#add_columns) macro. 
    
    This aliasing approach is much simpler and processed in the staging layer instead. 
___

### hub_template

Generates sql to build a hub table using the provided metadata.

```mysql 
dbtvault.hub_template(src_pk, src_nk, src_ldts, src_source,
                      tgt_pk, tgt_nk, tgt_ldts, tgt_source,
                      source)                              
```

#### Parameters

| Parameter     | Description                                         | Type (Single-Source) | Type (Union)    | Required?                                                          |
| ------------- | --------------------------------------------------- | -------------------- | --------------- | ------------------------------------------------------------------ |
| src_pk        | Source primary key column                           | String               | String          | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| src_nk        | Source natural key column                           | String               | String          | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| src_ldts      | Source loaddate timestamp column                    | String               | String          | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| src_source    | Name of the column containing the source ID         | String               | String          | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_pk        | Target primary key column                           | List/Reference       | List/Reference  | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_nk        | Target natural key column                           | List/Reference       | List/Reference  | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_ldts      | Target loaddate timestamp column                    | List/Reference       | List/Reference  | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_source    | Name of the column which will contain the source ID | List/Reference       | List/Reference  | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| source        | Staging model reference or table name               | List                 | List            | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
                                                                                                                    
#### Usage

``` yaml tab="Single-Source"

-- hub_customer.sql:

{{- config(...)                                                -}}
                                                               
{%- set source = [ref('stg_customer_hashed')]                  -%}
                                                                  
{%- set src_pk = 'CUSTOMER_PK'                                 -%}
{%- set src_nk = 'CUSTOMER_ID'                                 -%}
{%- set src_ldts = 'LOADDATE'                                  -%}
{%- set src_source = 'SOURCE'                                  -%}
                                                                  
{%- set tgt_pk = source                                        -%}
{%- set tgt_nk = source                                        -%}
{%- set tgt_ldts = source                                      -%}
{%- set tgt_source = source                                    -%}
                                                                  
{{ dbtvault.hub_template(src_pk, src_nk, src_ldts, src_source,    
                         tgt_pk, tgt_nk, tgt_ldts, tgt_source,    
                         source)                                }}
```

``` yaml tab="Union"

-- hub_parts.sql:

{{- config(...)                                                -}}

{%- set source = [ref('stg_parts_hashed'),                        
                  ref('stg_supplier_hashed'),                     
                  ref('stg_lineitem_hashed')]                  -%}

{%- set src_pk = 'PART_PK'                                     -%}
{%- set src_nk = 'PART_ID'                                     -%}
{%- set src_ldts = 'LOADDATE'                                  -%}
{%- set src_source = 'SOURCE'                                  -%}
                                                               
{%- set tgt_pk = source                                        -%}
{%- set tgt_nk = source                                        -%}
{%- set tgt_ldts = source                                      -%}
{%- set tgt_source = source                                    -%}
                                                                  
{{ dbtvault.hub_template(src_pk, src_nk, src_ldts, src_source,    
                         tgt_pk, tgt_nk, tgt_ldts, tgt_source,    
                         source)                                }}
```


#### Output

```mysql tab="Single-Source"
SELECT DISTINCT 
                    CAST(stg.CUSTOMER_PK AS BINARY(16)) AS CUSTOMER_PK,
                    CAST(stg.CUSTOMER_ID AS VARCHAR(38)) AS CUSTOMER_ID,
                    CAST(stg.LOADDATE AS DATE) AS LOADDATE,
                    CAST(stg.SOURCE AS VARCHAR(15)) AS SOURCE
FROM (
    SELECT a.CUSTOMER_PK, a.CUSTOMER_ID, a.LOADDATE, a.SOURCE
      FROM MYDATABASE.MYSCHEMA.stg_customer_hashed AS a
) AS stg
LEFT JOIN MYDATABASE.MYSCHEMA.hub_customer AS tgt
ON stg.CUSTOMER_PK = tgt.CUSTOMER_PK
WHERE tgt.CUSTOMER_PK IS NULL
```

```mysql tab="Union"
SELECT DISTINCT 
                    CAST(stg.PART_PK AS BINARY(16)) AS PART_PK,
                    CAST(stg.PART_ID AS NUMBER(38,0)) AS PART_ID,
                    CAST(stg.LOADDATE AS DATE) AS LOADDATE,
                    CAST(stg.SOURCE AS VARCHAR(15)) AS SOURCE
FROM (
    SELECT src.PART_PK, src.PART_ID, src.LOADDATE, src.SOURCE,
    LAG(SOURCE, 1)
    OVER(PARTITION by PART_PK
    ORDER BY PART_PK) AS FIRST_SOURCE
    FROM (
      SELECT a.PART_PK, a.PART_ID, a.LOADDATE, a.SOURCE
      FROM MYDATABASE.MYSCHEMA.stg_parts_hashed AS a
      UNION
      SELECT b.PART_PK, b.PART_ID, b.LOADDATE, b.SOURCE
      FROM MYDATABASE.MYSCHEMA.stg_supplier_hashed AS b
      UNION
      SELECT c.PART_PK, c.PART_ID, c.LOADDATE, c.SOURCE
      FROM MYDATABASE.MYSCHEMA.stg_lineitem_hashed AS c
      ) as src
) AS stg
LEFT JOIN MYDATABASE.MYSCHEMA.hub_parts AS tgt
ON stg.PART_PK = tgt.PART_PK
WHERE tgt.PART_PK IS NULL
AND stg.FIRST_SOURCE IS NULL
```

___

### link_template

Generates sql to build a link table using the provided metadata.

```mysql 
dbtvault.link_template(src_pk, src_fk, src_ldts, src_source,
                       tgt_pk, tgt_fk, tgt_ldts, tgt_source,
                       source)                              
```

#### Parameters

| Parameter     | Description                                         | Type (Single-Source) | Type (Union)         | Required?                                                          |
| ------------- | --------------------------------------------------- | ---------------------| ---------------------| ------------------------------------------------------------------ |
| src_pk        | Source primary key column                           | String               | String               | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| src_fk        | Source foreign key column(s)                        | List                 | List                 | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| src_ldts      | Source loaddate timestamp column                    | String               | String               | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| src_source    | Name of the column containing the source ID         | String               | String               | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_pk        | Target primary key column                           | List/Reference       | List/Reference       | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_fk        | Target foreign key column                           | List/Reference       | List/Reference       | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_ldts      | Target loaddate timestamp column                    | List/Reference       | List/Reference       | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_source    | Name of the column which will contain the source ID | List/Reference       | List/Reference       | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| source        | Staging model reference or table name               | List                 | List                 | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |

#### Usage

``` yaml tab="Single-Source"

-- link_customer_nation.sql:
                                                                
{{- config(...)                                                 -}}
                                                                
{%- set source = [ref('stg_crm_customer_hashed')]               -%}
                                                                
{%- set src_pk = 'CUSTOMER_NATION_PK'                           -%}
{%- set src_fk = ['CUSTOMER_PK', 'NATION_PK']                   -%}
{%- set src_ldts = 'LOADDATE'                                   -%}
{%- set src_source = 'SOURCE'                                   -%}
                                                                
{%- set tgt_pk = source                                         -%}
{%- set tgt_fk = [['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_FK'], 
                  ['NATION_PK', 'BINARY(16)', 'NATION_FK']]     -%}
                                                                
{%- set tgt_ldts = source                                       -%}
{%- set tgt_source = source                                     -%}
                                                                
{{ dbtvault.link_template(src_pk, src_fk, src_ldts, src_source, 
                          tgt_pk, tgt_fk, tgt_ldts, tgt_source, 
                          source)                                }}
```                                                             

``` yaml tab="Union"

-- link_customer_nation_union.sql:  

{{- config(...)                                                 -}}

{%- set source = [ref('stg_sap_customer_hashed'),
                  ref('stg_crm_customer_hashed'),
                  ref('stg_web_customer_hashed')]               -%}

{%- set src_pk = 'CUSTOMER_NATION_PK'                           -%}
{%- set src_fk = ['CUSTOMER_PK', 'NATION_PK']                   -%}
{%- set src_ldts = 'LOADDATE'                                   -%}
{%- set src_source = 'SOURCE'                                   -%}

{%- set tgt_pk = source                                         -%}
{%- set tgt_fk = [['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_FK'], 
                  ['NATION_PK', 'BINARY(16)', 'NATION_FK']]     -%}
                                                                
{%- set tgt_ldts = source                                       -%}
{%- set tgt_source = source                                     -%}
                                                                
{{ dbtvault.link_template(src_pk, src_fk, src_ldts, src_source, 
                          tgt_pk, tgt_fk, tgt_ldts, tgt_source, 
                          source)                                }}
```

#### Output

```mysql tab="Single-Source"
SELECT DISTINCT 
                    CAST(stg.CUSTOMER_NATION_PK AS BINARY(16)) AS CUSTOMER_NATION_PK,
                    CAST(stg.CUSTOMER_PK AS BINARY(16)) AS CUSTOMER_FK,
                    CAST(stg.NATION_PK AS BINARY(16)) AS NATION_FK,
                    CAST(stg.LOADDATE AS DATE) AS LOADDATE,
                    CAST(stg.SOURCE AS VARCHAR(15)) AS SOURCE
FROM (
    SELECT a.CUSTOMER_NATION_PK, a.CUSTOMER_PK, a.NATION_PK, a.LOADDATE, a.SOURCE
      FROM MYDATABASE.MYSCHEMA.stg_crm_customer_hashed AS a
) AS stg
LEFT JOIN MYDATABASE.MYSCHEMA.link_customer_nation AS tgt
ON stg.CUSTOMER_NATION_PK = tgt.CUSTOMER_NATION_PK
WHERE tgt.CUSTOMER_NATION_PK IS NULL
```

```mysql tab="Union"
SELECT DISTINCT 
                    CAST(stg.CUSTOMER_NATION_PK AS BINARY(16)) AS CUSTOMER_NATION_PK,
                    CAST(stg.CUSTOMER_PK AS BINARY(16)) AS CUSTOMER_FK,
                    CAST(stg.NATION_PK AS BINARY(16)) AS NATION_FK,
                    CAST(stg.LOADDATE AS DATE) AS LOADDATE,
                    CAST(stg.SOURCE AS VARCHAR(15)) AS SOURCE
FROM (
    SELECT src.CUSTOMER_NATION_PK, src.CUSTOMER_PK, src.NATION_PK, src.LOADDATE, src.SOURCE,
    LAG(SOURCE, 1)
    OVER(PARTITION by CUSTOMER_NATION_PK
    ORDER BY CUSTOMER_NATION_PK) AS FIRST_SOURCE
    FROM (
      SELECT a.CUSTOMER_NATION_PK, a.CUSTOMER_PK, a.NATION_PK, a.LOADDATE, a.SOURCE
      FROM MYDATABASE.MYSCHEMA.stg_sap_customer_hashed AS a
      UNION
      SELECT b.CUSTOMER_NATION_PK, b.CUSTOMER_PK, b.NATION_PK, b.LOADDATE, b.SOURCE
      FROM MYDATABASE.MYSCHEMA.stg_crm_customer_hashed AS b
      UNION
      SELECT c.CUSTOMER_NATION_PK, c.CUSTOMER_PK, c.NATION_PK, c.LOADDATE, c.SOURCE
      FROM MYDATABASE.MYSCHEMA.stg_web_customer_hashed AS c
      ) AS src
) AS stg
LEFT JOIN MYDATABASE.MYSCHEMA.link_customer_nation_union AS tgt
ON stg.CUSTOMER_NATION_PK = tgt.CUSTOMER_NATION_PK
WHERE tgt.CUSTOMER_NATION_PK IS NULL
AND stg.FIRST_SOURCE IS NULL
```

___

### sat_template

Generates sql to build a satellite table using the provided metadata.

```mysql 
dbtvault.sat_template(src_pk, src_hashdiff, src_payload,
                      src_eff, src_ldts, src_source,    
                      tgt_pk, tgt_hashdiff, tgt_payload,
                      tgt_eff, tgt_ldts, tgt_source,    
                      source)                          
```

#### Parameters

| Parameter     | Description                                         | Type           | Required?                                                          |
| ------------- | --------------------------------------------------- | -------------- | ------------------------------------------------------------------ |
| src_pk        | Source primary key column                           | String         | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| src_hashdiff  | Source hashdiff column                              | String         | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| src_payload   | Source payload column(s)                            | List           | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| src_eff       | Source effective from column                        | String         | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| src_ldts      | Source loaddate timestamp column                    | String         | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| src_source    | Name of the column containing the source ID         | String         | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_pk        | Target primary key column                           | List/Reference | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_hashdiff  | Target hashdiff column                              | List/Reference | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_payload   | Target payload column                               | List/Reference | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_eff       | Target effective from column                        | List/Reference | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_ldts      | Target loaddate timestamp column                    | List/Reference | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_source    | Name of the column which will contain the source ID | List/Reference | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| source        | Staging model reference or table name               | List/Reference | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |

#### Usage


``` yaml

-- sat_customer_details.sql:  

{{- config(...)                                                           -}}
                                                                          
{%- set source = [ref('stg_customer_details_hashed')]                     -%}
                                                                          
{%- set src_pk = 'CUSTOMER_PK'                                            -%}
{%- set src_hashdiff = 'CUSTOMER_HASHDIFF'                                -%}
{%- set src_payload = ['CUSTOMER_NAME', 'CUSTOMER_DOB', 'CUSTOMER_PHONE'] -%}
                                                                             
{%- set src_eff = 'EFFECTIVE_FROM'                                        -%}
{%- set src_ldts = 'LOADDATE'                                             -%}
{%- set src_source = 'SOURCE'                                             -%}
                                                                             
{%- set tgt_pk = source                                                   -%}
                                                                          
{%- set tgt_hashdiff = [ src_hashdiff , 'BINARY(16)', 'HASHDIFF']         -%}
                                                                          
{%- set tgt_payload = [[src_payload[0], 'VARCHAR(60)', 'NAME'],             
                       [src_payload[1], 'DATE', 'DOB'],                     
                       [src_payload[2], 'VARCHAR(15)', 'PHONE']]          -%}
                                                                             
{%- set tgt_eff = source                                                  -%}
{%- set tgt_ldts = source                                                 -%}
{%- set tgt_source = source                                               -%}
                                                                             
{{  dbtvault.sat_template(src_pk, src_hashdiff, src_payload,                 
                          src_eff, src_ldts, src_source,                     
                          tgt_pk, tgt_hashdiff, tgt_payload,              
                          tgt_eff, tgt_ldts, tgt_source,                     
                          source)                                          }}
```


#### Output

```mysql 
SELECT DISTINCT 
                    CAST(e.CUSTOMER_HASHDIFF AS BINARY(16)) AS HASHDIFF,
                    CAST(e.CUSTOMER_PK AS BINARY(16)) AS CUSTOMER_PK,
                    CAST(e.CUSTOMER_NAME AS VARCHAR(60)) AS NAME,
                    CAST(e.CUSTOMER_DOB AS DATE) AS DOB,
                    CAST(e.CUSTOMER_PHONE AS VARCHAR(15)) AS PHONE,
                    CAST(e.LOADDATE AS DATE) AS LOADDATE,
                    CAST(e.EFFECTIVE_FROM AS DATE) AS EFFECTIVE_FROM,
                    CAST(e.SOURCE AS VARCHAR(15)) AS SOURCE
FROM MYDATABASE.MYSCHEMA.stg_customer_details_hashed AS e
LEFT JOIN (
    SELECT d.CUSTOMER_PK, d.HASHDIFF, d.NAME, d.DOB, d.PHONE, d.EFFECTIVE_FROM, d.LOADDATE, d.SOURCE
    FROM (
          SELECT c.CUSTOMER_PK, c.HASHDIFF, c.NAME, c.DOB, c.PHONE, c.EFFECTIVE_FROM, c.LOADDATE, c.SOURCE,
          CASE WHEN RANK()
          OVER (PARTITION BY c.CUSTOMER_PK
          ORDER BY c.LOADDATE DESC) = 1
          THEN 'Y' ELSE 'N' END CURR_FLG
          FROM (
            SELECT a.CUSTOMER_PK, a.HASHDIFF, a.NAME, a.DOB, a.PHONE, a.EFFECTIVE_FROM, a.LOADDATE, a.SOURCE
            FROM MYDATABASE.MYSCHEMA.sat_customer_details as a
            JOIN MYDATABASE.MYSCHEMA.stg_customer_details_hashed as b
            ON a.CUSTOMER_PK = b.CUSTOMER_PK
          ) as c
    ) AS d
WHERE d.CURR_FLG = 'Y') AS src
ON src.HASHDIFF = e.CUSTOMER_HASHDIFF
WHERE src.HASHDIFF IS NULL
```

___

### t_link_template

Generates sql to build a transactional link table using the provided metadata.

```mysql 
dbtvault.t_link_template(src_pk, src_fk, src_payload, src_eff, src_ldts, src_source,
                         tgt_pk, tgt_fk, tgt_payload, tgt_eff, tgt_ldts, tgt_source,
                         source)                  
```

#### Parameters

| Parameter     | Description                                         | Type           | Required?                                                          |
| ------------- | --------------------------------------------------- | -------------- | ------------------------------------------------------------------ |
| src_pk        | Source primary key column                           | String         | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| src_fk        | Source foreign key column(s)                        | List           | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| src_payload   | Source payload column(s)                            | List           | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| src_eff       | Source effective from column                        | String         | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| src_ldts      | Source loaddate timestamp column                    | String         | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| src_source    | Name of the column containing the source ID         | String         | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_pk        | Target primary key column                           | List/Reference | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_fk        | Target hashdiff column                              | List/Reference | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_payload   | Target foreign key column(s)                        | List/Reference | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_eff       | Target effective from column                        | List/Reference | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_ldts      | Target loaddate timestamp column                    | List/Reference | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| tgt_source    | Name of the column which will contain the source ID | List/Reference | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |
| source        | Staging model reference or table name               | List/Reference | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |

#### Usage


``` yaml

-- t_link_transactions.sql:  

{{- config(...)                                                                        -}}

{%- set source = [ref('stg_transactions_hashed')]                                      -%}

{%- set src_pk = 'TRANSACTION_PK'                                                      -%}
{%- set src_fk = ['CUSTOMER_FK', 'ORDER_FK']                                           -%}
{%- set src_payload = ['TRANSACTION_NUMBER', 'TRANSACTION_DATE', 'TYPE', 'AMOUNT']     -%}
{%- set src_eff = 'EFFECTIVE_FROM'                                                     -%}
{%- set src_ldts = 'LOADDATE'                                                          -%}
{%- set src_source = 'SOURCE'                                                          -%}

{%- set tgt_pk = source                                                                -%}
{%- set tgt_fk = source                                                                -%}
{%- set tgt_payload = source                                                           -%}
{%- set tgt_eff = source                                                               -%}
{%- set tgt_ldts = source                                                              -%}
{%- set tgt_source = source                                                            -%}

{{ dbtvault.t_link_template(src_pk, src_fk, src_payload, src_eff, src_ldts, src_source,
                            tgt_pk, tgt_fk, tgt_payload, tgt_eff, tgt_ldts, tgt_source,
                            source)                                                     }}
```

#### Output

```mysql 
SELECT DISTINCT 
                    CAST(stg.TRANSACTION_PK AS BINARY) AS TRANSACTION_PK,
                    CAST(stg.CUSTOMER_FK AS BINARY) AS CUSTOMER_FK,
                    CAST(stg.ORDER_FK AS BINARY) AS ORDER_FK,
                    CAST(stg.TRANSACTION_NUMBER AS NUMBER(38,0)) AS TRANSACTION_NUMBER,
                    CAST(stg.TRANSACTION_DATE AS DATE) AS TRANSACTION_DATE,
                    CAST(stg.TYPE AS VARCHAR) AS TYPE,
                    CAST(stg.AMOUNT AS NUMBER(12,2)) AS AMOUNT,
                    CAST(stg.EFFECTIVE_FROM AS DATE) AS EFFECTIVE_FROM,
                    CAST(stg.LOADDATE AS DATE) AS LOADDATE,
                    CAST(stg.SOURCE AS VARCHAR) AS SOURCE
FROM (
      SELECT stg.TRANSACTION_PK, stg.CUSTOMER_FK, stg.ORDER_FK, stg.TRANSACTION_NUMBER, stg.TRANSACTION_DATE, stg.TYPE, stg.AMOUNT, stg.EFFECTIVE_FROM, stg.LOADDATE, stg.SOURCE
      FROM MYDATABASE.MYSCHEMA.stg_transactions_hashed AS stg
) AS stg
LEFT JOIN MYDATABASE.MYSCHEMA.t_link_transactions AS tgt
ON stg.TRANSACTION_PK = tgt.TRANSACTION_PK
WHERE tgt.TRANSACTION_PK IS NULL
```
___

## Staging Macros
######(macros/staging)

These macros are intended for use in the staging layer.
___

### multi_hash

!!! warning
    This macro ***should not be*** used for cryptographic purposes.
    
    The intended use is for creating checksum-like values only, so that we may compare records accurately. 
    
    [Read More](https://www.md5online.org/blog/why-md5-is-not-safe/)
    
!!! seealso "See Also"
    - [hash](#hash)
    - [Hashing best practises and why we hash](bestpractices.md#hashing)
    - With the release of dbtvault 0.4, you may now choose between ```MD5``` and ```SHA-256``` hashing. 
    [Learn how](bestpractices.md#choosing-a-hashing-algorithm-in-dbtvault)
    
This macro will generate SQL hashing sequences for one or more columns as below:

```sql tab='MD5'
CAST(MD5_BINARY(UPPER(TRIM(CAST(column1 AS VARCHAR)))) AS BINARY(16)) AS alias1,
CAST(MD5_BINARY(UPPER(TRIM(CAST(column2 AS VARCHAR)))) AS BINARY(16)) AS alias2
```

```sql tab='SHA'
CAST(SHA2_BINARY(UPPER(TRIM(CAST(column1 AS VARCHAR)))) AS BINARY(32)) AS alias1,
CAST(SHA2_BINARY(UPPER(TRIM(CAST(column2 AS VARCHAR)))) AS BINARY(32)) AS alias2
```

#### Parameters

| Parameter        |  Description                                    | Type     | Required?                                                |
| ---------------- | ----------------------------------------------  | -------- | -------------------------------------------------------- |
| pairs            | (column, alias) pair                            | Tuple    | <i class="md-icon" style="color: green">check_circle</i> |
| pairs: columns   | Single column string or list of columns         | String   | <i class="md-icon" style="color: green">check_circle</i> |
| pairs: alias     | The alias for the column                        | String   | <i class="md-icon" style="color: green">check_circle</i> |
| pairs: sort      | Will alpha sort columns if true, default false. | Boolean  | <i class="md-icon" style="color: red">clear</i>          |


#### Usage

```yaml
{{ dbtvault.multi_hash([('CUSTOMERKEY', 'CUSTOMER_PK'),
                        (['CUSTOMERKEY', 'NAME', 'PHONE', 'DOB'], 
                         'HASHDIFF', true)])                        }}
```

#### Output

```mysql tab='MD5'
CAST(MD5_BINARY(UPPER(TRIM(CAST(CUSTOMERKEY AS VARCHAR)))) AS BINARY(16)) AS CUSTOMER_PK,

CAST(MD5_BINARY(CONCAT(
     IFNULL(UPPER(TRIM(CAST(CUSTOMERKEY AS VARCHAR))), '^^'), '||',
     IFNULL(UPPER(TRIM(CAST(DOB AS VARCHAR))), '^^'), '||',
     IFNULL(UPPER(TRIM(CAST(NAME AS VARCHAR))), '^^'), '||',
     IFNULL(UPPER(TRIM(CAST(PHONE AS VARCHAR))), '^^') )) AS BINARY(16)) AS HASHDIFF
```

```mysql tab='SHA'
CAST(SHA2_BINARY(UPPER(TRIM(CAST(CUSTOMERKEY AS VARCHAR)))) AS BINARY(32)) AS CUSTOMER_PK,

CAST(SHA2_BINARY(CONCAT(
     IFNULL(UPPER(TRIM(CAST(CUSTOMERKEY AS VARCHAR))), '^^'), '||',
     IFNULL(UPPER(TRIM(CAST(DOB AS VARCHAR))), '^^'), '||',
     IFNULL(UPPER(TRIM(CAST(NAME AS VARCHAR))), '^^'), '||',
     IFNULL(UPPER(TRIM(CAST(PHONE AS VARCHAR))), '^^') )) AS BINARY(32)) AS HASHDIFF
```

!!! success "Column sorting"
    If you wish to sort columns in alphabetical order as per [best practices](bestpractices.md#hashing),
    you do not need to worry about doing this manually, just set the 
    ```sort``` flag to true when creating hashdiffs as per the above example.
___

### add_columns

A simple macro for generating sequences of the following SQL:
```mysql 
column AS alias
```

#### Parameters

| Parameter     | Description                         | Type           | Required?                                       |
| ------------- | ----------------------------------- | -------------- | ----------------------------------------------- |
| source_table  | A source reference                  | Source         | <i class="md-icon" style="color: red">clear</i> |
| pairs         | List of (column, alias) pairs       | List of tuples | <i class="md-icon" style="color: red">clear</i> |

!!! note
    At least one of the above parameters must be provided, both may be provided if required.  

#### Usage

```yaml
{{ dbtvault.add_columns(source('MYSOURCE', 'MYTABLE'),
                        [('CURRENT_DATE()', 'EFFECTIVE_FROM'),
                         ('!STG_CUSTOMER', 'SOURCE'),
                         ('OLD_CUSTOMER_PK', 'CUSTOMER_PK'])                }}
```

#### Output

```mysql 
<All columns from MYTABLE>,
CURRENT_DATE() AS EFFECTIVE_FROM,
'STG_CUSTOMER' AS SOURCE,
OLD_CUSTOMER_PK AS CUSTOMER_PK
```

#### Specific usage notes

##### Getting columns from the source
The ```add_columns``` macro will automatically select all columns from the optional  ```source_table``` reference, 
if provided.

##### Overriding source columns

You may wish to override some of the source columns with different values. To replace the  ```SOURCE``` 
or ```LOADDATE``` column value, for example, then you must provide the column name 
that you wish to override as the alias in the pair. 

!!! note
    If a provided column name is the same as a source column name, the provided
    column will take precedence over the source column, and the original source column will not be selected. 

##### Functions

Database functions may be used, for example ```CURRENT_DATE()``` to set the current date as the value of a column, as on
```line 2``` of the usage example. Any function supported by the database is valid, for example ```LPAD()```, which pads
a column with leading zeroes.

##### Adding constants
With the ```add_columns``` macro, you may provide constants. 
These are additional 'calculated' columns created from hard-coded values.
To achieve this, simply provide the constant with a ```!``` in front of the desired constant,
and the macro will do the rest. See ```line 3``` of the usage example above, and the output it gives.

##### Aliasing columns

As of release 0.3, columns should now be aliased in the staging layer prior to loading. This can be achieved by providing the
column name you wish to alias as the first argument in a pair, and providing the alias for that column as the second argument.
This can be observed on ```line 4``` of the usage example above. Aliasing can still be carried out using a 
manual mapping (shown in the [table template](#table-templates) section examples) but this is less concise for aliasing 
purposes.

___

### from

Used in creating source/hashing models to complete a staging layer model.

```mysql 
FROM MYDATABASE.MYSCHEMA.MYTABLE
```

!!! info
    Sources need to be set up in dbt to ensure this works. [Read More](https://docs.getdbt.com/v0.15.0/docs/using-sources)

#### Parameters

| Parameter     | Description                               | Type   | Required?                                                |
| ------------- | ----------------------------------------- | ------ | -------------------------------------------------------- |
| source_table  | A source reference                        | Source | <i class="md-icon" style="color: green">check_circle</i> | 

#### Usage

```yaml
{{ dbtvault.from( source('MYSOURCE', 'MYTABLE') ) }}
```

#### Output

```mysql 
FROM MYDATABASE.MYSCHEMA.MYTABLE
```

___

## Supporting Macros
######(macros/supporting)

Supporting macros are helper functions for use in models. It should not be necessary to call these macros directly, however they 
are used extensively in the [table templates](#table-templates). 

___

### cast

A macro for generating cast sequences:

```mysql
CAST(prefix.column AS type) AS alias
```

#### Parameters

| Parameter        |  Description                  | Required?                                                |
| ---------------- | ----------------------------- | -------------------------------------------------------- |
| columns          |  Triples or strings           | <i class="md-icon" style="color: green">check_circle</i> |
| prefix           |  A string                     | <i class="md-icon" style="color: red">clear</i>          |

#### Usage

!!! note
    As shown in the snippet below, columns must be provided as a list. 
    The collection of items in this list can be any combination of:

    - ```(column, type, alias) ``` 3-tuples 
    - ```[column, type, alias] ``` 3-item lists
    - ```'DOB'``` Single strings.

```yaml

{%- set tgt_pk = ['PART_PK', 'BINARY(16)', 'PART_PK']        -%}

{{ dbtvault.cast([tgt_pk,
                  'DOB',
                  ('PART_PK', 'NUMBER(38,0)', 'PART_ID'),
                  ('LOADDATE', 'DATE', 'LOADDATE'),
                  ('SOURCE', 'VARCHAR(15)', 'SOURCE')], 
                  'stg')                                      }}
```

#### Output

```mysql
CAST(stg.PART_PK AS BINARY(16)) AS PART_PK,
stg.DOB,
CAST(stg.PART_ID AS NUMBER(38,0)) AS PART_ID,
CAST(stg.LOADDATE AS DATE) AS LOADDATE,
CAST(stg.SOURCE AS VARCHAR(15)) AS SOURCE
```

___

### hash

!!! warning
    This macro ***should not be*** used for cryptographic purposes.
    
    The intended use is for creating checksum-like values only, so that we may compare records accurately.
    
    [Read More](https://www.md5online.org/blog/why-md5-is-not-safe/)

!!! seealso "See Also"
    - [multi-hash](#multi_hash)
    - [Hashing best practises and why we hash](bestpractices.md#hashing)
    - With the release of dbtvault 0.4, you may now choose between ```MD5``` and ```SHA-256``` hashing. 
    [Learn how](bestpractices.md#choosing-a-hashing-algorithm-in-dbtvault)
    
A macro for generating hashing SQL for columns:

```sql tab='MD5'
CAST(MD5_BINARY(UPPER(TRIM(CAST(column AS VARCHAR)))) AS BINARY(16)) AS alias
```

```sql tab='SHA'
CAST(SHA2_BINARY(UPPER(TRIM(CAST(column AS VARCHAR)))) AS BINARY(32)) AS alias
```

- Can provide multiple columns as a list to create a concatenated hash
- Columns are sorted alphabetically (by alias) if you set the ```sort``` flag to true.
- Generally, you should alpha sort hashdiffs using the ```sort``` flag.
- Casts a column as ```VARCHAR```, transforms to ```UPPER``` case and trims whitespace
- ```'^^'``` Accounts for null values with a double caret
- ```'||'``` Concatenates with a double pipe 

#### Parameters

| Parameter        |  Description                                     | Type        | Required?                                                |
| ---------------- | -----------------------------------------------  | ----------- | -------------------------------------------------------- |
| columns          |  Columns to hash on                              | String/List | <i class="md-icon" style="color: green">check_circle</i> |
| alias            |  The name to give the hashed column              | String      | <i class="md-icon" style="color: green">check_circle</i> |
| sort             |  Will alpha sort columns if true, default false. | Boolean     | <i class="md-icon" style="color: red">clear</i>          |
                                

#### Usage

```yaml
{{ dbtvault.hash('CUSTOMERKEY', 'CUSTOMER_PK') }},
{{ dbtvault.hash(['CUSTOMERKEY', 'PHONE', 'DOB', 'NAME'], 'HASHDIFF', true) }}
```

!!! tip
    [multi_hash](#multi_hash) may be used to simplify the hashing process and generate multiple hashes with one macro.

#### Output

```mysql tab = 'MD5'
CAST(MD5_BINARY(UPPER(TRIM(CAST(CUSTOMERKEY AS VARCHAR)))) AS BINARY(16)) AS CUSTOMER_PK,
CAST(MD5_BINARY(CONCAT(IFNULL(UPPER(TRIM(CAST(CUSTOMERKEY AS VARCHAR))), '^^'), '||',
                       IFNULL(UPPER(TRIM(CAST(DOB AS VARCHAR))), '^^'), '||',
                       IFNULL(UPPER(TRIM(CAST(NAME AS VARCHAR))), '^^'), '||',
                       IFNULL(UPPER(TRIM(CAST(PHONE AS VARCHAR))), '^^') )) 
                       AS BINARY(16)) AS HASHDIFF
```

```mysql tab='SHA'
CAST(SHA2_BINARY(UPPER(TRIM(CAST(CUSTOMERKEY AS VARCHAR)))) AS BINARY(32)) AS CUSTOMER_PK,
CAST(SHA2_BINARY(CONCAT(IFNULL(UPPER(TRIM(CAST(CUSTOMERKEY AS VARCHAR))), '^^'), '||',
                        IFNULL(UPPER(TRIM(CAST(DOB AS VARCHAR))), '^^'), '||',
                        IFNULL(UPPER(TRIM(CAST(NAME AS VARCHAR))), '^^'), '||',
                        IFNULL(UPPER(TRIM(CAST(PHONE AS VARCHAR))), '^^') )) 
                        AS BINARY(32)) AS HASHDIFF
```

___

### prefix

A macro for quickly prefixing a list of columns with a string:
```mysql
a.column1, a.column2, a.column3, a.column4
```

#### Parameters

| Parameter        |  Description                  | Type   | Required?                                                |
| ---------------- | ----------------------------- | ------ | -------------------------------------------------------- |
| columns          |  A list of column names       | List   | <i class="md-icon" style="color: green">check_circle</i> |
| prefix_str       |  The prefix for the columns   | String | <i class="md-icon" style="color: green">check_circle</i> |

#### Usage

```yaml
{{ dbtvault.prefix(['CUSTOMERKEY', 'DOB', 'NAME', 'PHONE'], 'a') }}
{{ dbtvault.prefix(['CUSTOMERKEY'], 'a') 
```

!!! Note
    Single columns must be provided as a 1-item list, as in the second example above.

#### Output

```mysql
a.CUSTOMERKEY, a.DOB, a.NAME, a.PHONE
a.CUSTOMERKEY
```

___

## Internal
######(macros/internal)

Internal macros support the other macros provided in this package. 
They are used to process provided metadata and should not be called directly. 