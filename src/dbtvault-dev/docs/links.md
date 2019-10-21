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

#### Source table

The first piece of metadata we need is the source table. This step is easy, as in this example we created the 
new staging layer ourselves. All we need to do is provide a reference to the model we created, and dbt will do the rest for us.
dbt ensures dependencies are honoured when defining the source using a reference in this way.

[Read more about the ref function](https://docs.getdbt.com/docs/ref)

```link_customer_nation.sql```

```sql hl_lines="3"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='link')        -}}

{%- set source = [ref('stg_customer_hashed')]                                               -%} 
```

!!! note
    Make sure you surround the ref call with square brackets, as shown in the snippet
    above.

#### Source columns

Next, we define the columns which we would like to bring from the source.
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
```sql  hl_lines="5 6 7 8"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='link') -}}

{%- set source = [ref('stg_customer_hashed')]                                        -%}

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
provide the metadata it requires:

```link_customer_nation.sql```
```sql hl_lines="10 11 12 13 14 15"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='link') -}}

{%- set source = [ref('stg_customer_hashed')]                                        -%}

{%- set src_pk = 'CUSTOMER_NATION_PK'                                                -%}
{%- set src_fk = ['CUSTOMER_PK', 'NATION_PK']                                        -%}
{%- set src_ldts = 'LOADDATE'                                                        -%}
{%- set src_source = 'SOURCE'                                                        -%}

{%- set tgt_pk = source                                                              -%}
{%- set tgt_fk = [['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_FK'],
                  ['NATION_PK', 'BINARY(16)', 'NATION_FK']]                          -%}

{%- set tgt_ldts = source                                                            -%}
{%- set tgt_source = source                                                          -%}

```      

With these 4 additional lines, we have provided our mapping from source to target:

- Observe that we are renaming the foreign key columns so that they have an ```FK``` suffix.

- For the rest of the ```tgt``` metadata, we do not wish to rename columns or change
any data types, so we are simply using the ```source``` reference as shorthand for keeping the columns the same as
the source.

!!! info
    There is nothing to stop you entering invalid type mappings in this step (i.e. trying to cast an invalid date format to a date),
    so please ensure they are correct.
    You will soon find out, however, as dbt will issue a warning to you. No harm done, but save time by providing 
    the correct metadata!
    
### Invoking the template 

Now we bring it all together and call the [link_template](macros.md#link_template) macro:

```link_customer_nation.sql```
```sql hl_lines="17 18 19"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='link') -}}

{%- set source = [ref('stg_customer_hashed')]                                        -%}

{%- set src_pk = 'CUSTOMER_NATION_PK'                                                -%}
{%- set src_fk = ['CUSTOMER_PK', 'NATION_PK']                                        -%}
{%- set src_ldts = 'LOADDATE'                                                        -%}
{%- set src_source = 'SOURCE'                                                        -%}

{%- set tgt_pk = source                                                              -%}
{%- set tgt_fk = [['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_FK'],
                  ['NATION_PK', 'BINARY(16)', 'NATION_FK']]                          -%}

{%- set tgt_ldts = source                                                            -%}
{%- set tgt_source = source                                                          -%}

{{  dbtvault.link_template(src_pk, src_fk, src_ldts, src_source,
                           tgt_pk, tgt_fk, tgt_ldts, tgt_source,
                           source)                                                    }}

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

### Loading from multiple sources to form a union-based link

In some cases, we may need to create a hub via a union, instead of a single source as we have seen so far.
This may be because:

- Another raw staging table holds some records which our single source does not, and the tables share 
a key. 
- We have multiple source-systems containing different versions or parts of the data which we need to combine. 

We know this data can and should be combined because these records have a shared key. 
We can union the tables on that key, and create a hub containing a complete record set.

We'll need to create a [staging model](staging.md) for each of the sources involved, 
and provide them as a list of references to the source parameter as shown below.

!!! note
    If your primary key and natural key columns have different names across the different
    tables, they will need to be aliased to the same name in the respective staging layers 
    via the [add_columns](macros.md#add_columns) macro.

This procedure only requires additional source references in the source list
metadata of our ```link_customer_nation``` model, and the [link_template](macros.md#link_template) will handle the rest:

```link_customer_nation.sql```
```sql    
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags=['link', 'union']) -}}

{%- set source = [ref('stg_sap_customer_hashed'),                                    
                  ref('stg_crm_customer_hashed'),                                    
                  ref('stg_web_customer_hashed')]                                               -%}

{%- set src_pk = 'CUSTOMER_NATION_PK'                                                           -%}
{%- set src_fk = ['CUSTOMER_PK', 'NATION_PK']                                                   -%}
{%- set src_ldts = 'LOADDATE'                                                                   -%}
{%- set src_source = 'SOURCE'                                                                   -%}
                                                                                                
{%- set tgt_pk = source                                                                         -%}
{%- set tgt_fk = [['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_FK'],                                 
                  ['NATION_PK', 'BINARY(16)', 'NATION_FK']]                                     -%}
                                                                                                
{%- set tgt_ldts = source                                                                       -%}
{%- set tgt_source = source                                                                     -%}
                                                                       
{{ dbtvault.link_template(src_pk, src_fk, src_ldts, src_source,                                 
                          tgt_pk, tgt_fk, tgt_ldts, tgt_source,                                 
                          source)                                                                }}
```

### Next steps

We have now created a staging layer, a hub and a link. Next we will look at satellites. 
These are a little more complicated, but don't worry, the [sat_template](macros.md#sat_template) will handle that for 
us! 
