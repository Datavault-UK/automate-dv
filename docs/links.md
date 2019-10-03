Links are another fundamental components in a Data Vault. 

Links model an association or link, between two business keys. 

They are similar to [hubs](hubs.md) in structure but contain one additional column, which is simply an additional business key.

!!! note
    Due to the similarities between links and hubs, most of this page will be familiar if you have already read the
    [hubs](hubs.md) page.

Our links will contain:

1. A primary key. This is a concatenation of the two foreign keys below, hashed.
2. A foreign key holding the business key for one source table.
3. Another foreign key holding they business key from an associated source table. 
4. The load date or load date timestamp.
5. The source for the record

### Creating the model header

Create another dbt model. We'll call this one 'link_customer_nation'. 

The following header will be appropriate, but feel free to customise it to your needs:

```link_customer_nation.sql```
```sql
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='link') -}}

```

### Getting required columns

In the [staging](staging.md) walk-through, we added all the columns we needed for creating our hub.
To create our link, we will now need to add some additional columns to our staging layer. 

An individual source table should contain all of the necessary columns to create links, as raw staging
tables often contain multiple associations between keys (that's why we're creating links!).

Because of this, we can simply add some additional pairs to the [add_columns](macros.md#add_columns) macro call. 

In this scenario we will be creating a link to model the association between a customer and their nation, so we 
add the following lines if ```stg_customer``` contains a ```NATION_ID``` column:

```stg_customer_hashed.sql```
```sql hl_lines="4 5 7"

{{- config(materialized='view', schema='MYSCHEMA', enabled=true, tags='staging') -}}
                                                                                 
{{ dbtvault.multi_hash([('CUSTOMER_ID', 'CUSTOMER_PK'),
                         (['CUSTOMER_ID', 'NATION_ID'], 'CUSTOMER_NATION_PK'),
                         ('NATION_ID', 'NATION_PK')])                            -}},
                                                                                 
{{ dbtvault.add_columns([('CUSTOMER_ID', 'CUSTOMER_ID'), 
                         ('NATION_ID', 'NATION_ID'),                        
                         ('CUSTOMER_DOB', 'CUSTOMER_DOB'),                       
                         ('CUSTOMER_NAME', 'CUSTOMER_NAME'),                     
                         ('LOADDATE', 'LOADDATE'),                               
                         ('LOADDATE', 'EFFECTIVE_FROM')])                         }}
                                                                                 
{{- dbtvault.staging_footer(source="STG_CUSTOMER",                               
                            source_table='MYDATABASE.MYSCHEMA.stg_customer')      }} 

``` 

!!! note
    We can rename the staging layer to ```stg_customer_nation_hashed.sql``` if we want to keep
    consistent naming standards, just make sure the reference is updated wherever it is used.

### Adding the metadata

Now we need to provide some metadata to the [link_template](macros.md#link_template) macro.

#### Source columns

Using our knowledge of what columns we need in our  ```hub_customer``` table, we can identify which columns in our
staging layer we will need:

1. A primary key, which is a combination of the two foreign keys: ```CUSTOMER_NATION_PK``` from our modified staging layer.
2. ```CUSTOMER_ID``` which is one of our foreign keys
3. ```NATION_ID``` the second foreign key.
3. A load date timestamp, which is in the staging layer as ```LOADDATE``` 
4. A ```SOURCE``` column.

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
    We are using ```src_fk```, a list of the foreign keys. This is instead of ```src_nk``` when building the hubs.

#### Target columns

Now we can define the target column mapping. The [link_template](macros.md#link_template) does a lot of work for us if we
provide the metadata it requires. We can define which source columns map to the required target columns and also 
define a column type at the same time:

```link_customer_nation.sql```
```sql hl_lines="8 10 11 12 14 15"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='link')        -}}
                                                                                               
{%- set src_pk = 'CUSTOMER_NATION_PK'                                                       -%}
{%- set src_fk = ['CUSTOMER_PK', 'NATION_PK']                                               -%}
{%- set src_ldts = 'LOADDATE'                                                               -%}
{%- set src_source = 'SOURCE'                                                               -%}

{%- set tgt_cols = ['CUSTOMER_NATION_PK', 'CUSTOMER_PK', 'NATION_PK', src_ldts, src_source] -%}

{%- set tgt_pk = [src_pk, 'BINARY(16)', src_pk]                                             -%}
{%- set tgt_fk = [['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_FK'],
                  ['NATION_PK', 'BINARY(16)', 'NATION_FK']]                                 -%}

{%- set tgt_ldts = [src_ldts, 'DATE', src_ldts]                                             -%}
{%- set tgt_source = [src_source, 'VARCHAR(15)', src_source]                                -%}

```        

!!! note
    The column name strings on lines 8 and 11 could easily be replaced with references to 
    the ```src_pk``` and ```src_fk``` variables, these are just written in full for clarity. 
     

#### Source table

The last piece of metadata we need is the source table. As we did with the hubs, we can reference
the staging layer model we made earlier:

```link_customer_nation.sql```

```sql hl_lines="17"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='link')        -}}
                                                                                               
{%- set src_pk = 'CUSTOMER_NATION_PK'                                                       -%}
{%- set src_fk = ['CUSTOMER_PK', 'NATION_PK']                                               -%}
{%- set src_ldts = 'LOADDATE'                                                               -%}
{%- set src_source = 'SOURCE'                                                               -%}

{%- set tgt_cols = ['CUSTOMER_NATION_PK', 'CUSTOMER_PK', 'NATION_PK', src_ldts, src_source] -%}

{%- set tgt_pk = [src_pk, 'BINARY(16)', src_pk]                                             -%}
{%- set tgt_fk = [['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_FK'],
                  ['NATION_PK', 'BINARY(16)', 'NATION_FK']]                                 -%}

{%- set tgt_ldts = [src_ldts, 'DATE', src_ldts]                                             -%}
{%- set tgt_source = [src_source, 'VARCHAR(15)', src_source]                                -%}
                                                                                    
{%- set source = [ref('stg_customer_nation_hashed')]                                        -%}
```

### Invoking the template 

Now we bring it all together and call the [link_template](macros.md#link_template) macro:

```link_customer_nation.sql```
```sql hl_lines="19 20 21"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='link')        -}}
                                                                                               
{%- set src_pk = 'CUSTOMER_NATION_PK'                                                       -%}
{%- set src_fk = ['CUSTOMER_PK', 'NATION_PK']                                               -%}
{%- set src_ldts = 'LOADDATE'                                                               -%}
{%- set src_source = 'SOURCE'                                                               -%}

{%- set tgt_cols = ['CUSTOMER_NATION_PK', 'CUSTOMER_PK', 'NATION_PK', src_ldts, src_source] -%}

{%- set tgt_pk = [src_pk, 'BINARY(16)', src_pk]                                             -%}
{%- set tgt_fk = [['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_FK'],
                  ['NATION_PK', 'BINARY(16)', 'NATION_FK']]                                 -%}

{%- set tgt_ldts = [src_ldts, 'DATE', src_ldts]                                             -%}
{%- set tgt_source = [src_source, 'VARCHAR(15)', src_source]                                -%}
                                                                                    
{%- set source = [ref('stg_customer_nation_hashed')]                                        -%}

{{  dbtvault.link_template(src_pk, src_fk, src_ldts, src_source,
                           tgt_cols, tgt_pk, tgt_fk, tgt_ldts, tgt_source,
                           source)                                                           }}

```

### Running dbt

With our model complete, we can run dbt to create our ```link_customer_nation``` link.

```dbt run --models +link_customer_nation```

And our table will look like this:

| CUSTOMER_NATION_PK               | CUSTOMER_ID  | NATION_ID    | LOADDATE   | SOURCE       |
| -------------------------------- | ------------ | ------------ | ---------- | ------------ |
| 72A160C6CDBF0EDC9D4B4398796C9B42 | 1001         | 10001        | 1993-01-01 | STG_CUSTOMER |
|               .                  | .            | .            | .          | .            |
|               .                  | .            | .            | .          | .            |
| 1CE6A9D2688B0DB0893E46BEDECBF1E3 | 1004         | 10004        | 1993-01-01 | STG_CUSTOMER |


### Next steps

We have now created a staging layer, a hub and a link. Next we will look at satellites. 
These are a little more complicated, but don't worry, the [sat_template](macros.md#sat_template) will handle that for 
us! 
