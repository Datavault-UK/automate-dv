Links are another fundamental component in a Data Vault. 

Links model an association or link, between two business keys. They commonly hold business transactions or structural 
information.

!!! note
    Due to the similarities between links and hubs, most of this page will be familiar if you have already read the
    [hubs](hubs.md) page.

Our links will contain:

1. A primary key. For links, we take the natural keys (prior to hashing) represented by the foreign key columns below 
and create a hash on a concatenation of them. 
2. Foreign keys holding the primary key for each hub referenced in the link (2 or more depending on the number of hubs 
referenced) 
3. The load date or load date timestamp.
4. The source for the record

### Creating the model header

Create another empty dbt model. We'll call this one ```link_customer_nation```. 

The following header is what we use, but feel free to customise it to your needs:

```link_customer_nation.sql```
```sql
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='link') -}}

```

### Adding the metadata

Now we need to provide some metadata to the [link_template](macros.md#link_template) macro.

#### Source columns

Using our knowledge of what columns we need in our  ```link_customer_nation``` table, we can identify columns in our
staging layer which map to them:

1. A primary key, which is a combination of the two natural keys: In this case ```CUSTOMER_NATION_PK``` 
which we added in our staging layer.
2. ```CUSTOMER_ID``` which is one of our natural keys (We'll use the hashed column, ```CUSTOMER_PK```).
3. ```NATION_ID``` the second natural key (We'll use the hashed column, ```NATION_PK```).
4. A load date timestamp, which is present in the staging layer as ```LOADDATE``` 
5. A ```SOURCE``` column.

We can now add this metadata to the model:

```link_customer_nation.sql```
```sql  hl_lines="3 4 5 6"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='link') -}}

{%- set src_pk = 'CUSTOMER_NATION_PK'                                                -%}
{%- set src_fk = ['CUSTOMER_PK', 'NATION_PK']                                        -%}
{%- set src_ldts = 'LOADDATE'                                                        -%}
{%- set src_source = 'SOURCE'                                                        -%}

```

!!! note 
    We are using ```src_fk```, a list of the foreign keys. This is instead of the ```src_nk``` 
    we used when building the hubs. We must use square brackets when defining a list.

#### Target columns

Now we can define the target column mapping. The [link_template](macros.md#link_template) does a lot of work for us if we
provide the metadata it requires. We can define which source columns map to the required target columns and also 
define a column type at the same time:

```link_customer_nation.sql```
```sql hl_lines="8 9 10 11 12 13"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='link')        -}}
                                                                                               
{%- set src_pk = 'CUSTOMER_NATION_PK'                                                       -%}
{%- set src_fk = ['CUSTOMER_PK', 'NATION_PK']                                               -%}
{%- set src_ldts = 'LOADDATE'                                                               -%}
{%- set src_source = 'SOURCE'                                                               -%}

{%- set tgt_pk = [src_pk, 'BINARY(16)', src_pk]                                             -%}
{%- set tgt_fk = [['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_FK'],
                  ['NATION_PK', 'BINARY(16)', 'NATION_FK']]                                 -%}

{%- set tgt_ldts = [src_ldts, 'DATE', src_ldts]                                             -%}
{%- set tgt_source = [src_source, 'VARCHAR(15)', src_source]                                -%}

```      

With these 4 additional lines, we have now informed the macro how to transform our source data:

- We have provided our mapping from source to target. Observe that we are
renaming the foreign key column so that they have an ```FK``` suffix.

- We have provided a type in the mapping so that the type is explicitly defined. For now, this is not optional, but we
will simplify this for scenarios where we want the data type or column name to remain unchanged in future releases.

!!! info
    There is nothing to stop you entering invalid type mappings in this step (i.e. trying to cast an invalid date format to a date),
    so please ensure they are correct.
    You will soon find out, however, as dbt will issue a warning to you. No harm done, but save time by providing 
    accurate metadata!

#### Source table

The last piece of metadata we need is the source table. As we did with the hubs, we can reference
the staging layer model we made earlier, as this contains all the columns we need for the link:

```link_customer_nation.sql```

```sql hl_lines="15"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='link')        -}}
                                                                                               
{%- set src_pk = 'CUSTOMER_NATION_PK'                                                       -%}
{%- set src_fk = ['CUSTOMER_PK', 'NATION_PK']                                               -%}
{%- set src_ldts = 'LOADDATE'                                                               -%}
{%- set src_source = 'SOURCE'                                                               -%}

{%- set tgt_pk = [src_pk, 'BINARY(16)', src_pk]                                             -%}
{%- set tgt_fk = [['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_FK'],
                  ['NATION_PK', 'BINARY(16)', 'NATION_FK']]                                 -%}

{%- set tgt_ldts = [src_ldts, 'DATE', src_ldts]                                             -%}
{%- set tgt_source = [src_source, 'VARCHAR(15)', src_source]                                -%}
                                                                                    
{%- set source = [ref('stg_orders_hashed')]                                                 -%}
```

!!! note
    Make sure you surround the ref call with square brackets, as shown in the snippet
    above.

### Invoking the template 

Now we bring it all together and call the [link_template](macros.md#link_template) macro:

```link_customer_nation.sql```
```sql hl_lines="17 18 19"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='link')        -}}
                                                                                               
{%- set src_pk = 'CUSTOMER_NATION_PK'                                                       -%}
{%- set src_fk = ['CUSTOMER_PK', 'NATION_PK']                                               -%}
{%- set src_ldts = 'LOADDATE'                                                               -%}
{%- set src_source = 'SOURCE'                                                               -%}

{%- set tgt_pk = [src_pk, 'BINARY(16)', src_pk]                                             -%}
{%- set tgt_fk = [['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_FK'],
                  ['NATION_PK', 'BINARY(16)', 'NATION_FK']]                                 -%}

{%- set tgt_ldts = [src_ldts, 'DATE', src_ldts]                                             -%}
{%- set tgt_source = [src_source, 'VARCHAR(15)', src_source]                                -%}
                                                                                    
{%- set source = [ref('stg_orders_hashed')]                                                 -%}

{{  dbtvault.link_template(src_pk, src_fk, src_ldts, src_source,
                           tgt_pk, tgt_fk, tgt_ldts, tgt_source,
                           source)                                                           }}

```

### Running dbt

With our model complete, we can run dbt to create our ```link_customer_nation``` link.

```dbt run --models +link_customer_nation```

And our table will look like this:

| CUSTOMER_NATION_PK | CUSTOMER_FK  | NATION_FK    | LOADDATE   | SOURCE       |
| ------------------ | ------------ | ------------ | ---------- | ------------ |
| 72A160...          | B8C37E...    | D89F3A...    | 1993-01-01 | 1            |
| .                  | .            | .            | .          | .            |
| .                  | .            | .            | .          | .            |
| 1CE6A9...          | FED333...    | D78382...    | 1993-01-01 | 1            |


### Next steps

We have now created a staging layer, a hub and a link. Next we will look at satellites. 
These are a little more complicated, but don't worry, the [sat_template](macros.md#sat_template) will handle that for 
us! 
