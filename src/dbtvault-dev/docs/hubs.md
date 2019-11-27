Hubs are one of the core building blocks of a Data Vault. 

In general, they consist of 4 columns, but may have more: 

1. A primary key (or surrogate key) which is usually a hashed representation of the natural key (also known as the business key).

2. The natural key. This is usually a formal identification for the record such as a customer ID or 
order number (can be multi-column).

3. The load date or load date timestamp. This identifies when the record was first loaded into the vault.

4. The source for the record, a code identifying where the data comes from. 
(i.e. ```1``` from the [previous section](staging.md#adding-the-footer), which is the code fo stg_customer)

### Creating the model header

Create a new dbt model as before. We'll call this one ```hub_customer```. 

The following header is what we use, but feel free to customise it to your needs:

```hub_customer.sql```
```sql
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='hub') -}}

```

Hubs are always incremental, as we load and add new records to the existing data set. 

[Read more about incremental models](https://docs.getdbt.com/v0.14.0/docs/configuring-incremental-models)

!!! note "Dont worry!" 
    The [hub_template](macros.md#hub_template) deals with the Data Vault
    2.0 standards when loading into the hub from the source. We won't need to worry about unwanted duplicates.
    
### Adding the metadata

Let's look at the metadata we need to provide to the [hub_template](macros.md#hub_template) macro.

#### Source table

The first piece of metadata we need is the source table. This step is easy, as in this example we created the 
staging layer ourselves. All we need to do is provide a reference to the model we created, and dbt will do the rest for us.
dbt ensures dependencies are honoured when defining the source using a reference in this way.

[Read more about the ref function](https://docs.getdbt.com/v0.14.0/docs/ref)

```hub_customer.sql```

```sql hl_lines="3"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='hub') -}}

{%- set source = [ref('stg_customer_hashed')]                                       -%}
```

!!! note
    Make sure you surround the ref call with square brackets, as shown in the snippet
    above.

#### Source columns

Next, we define the columns which we would like to bring from the source.
Using our knowledge of what columns we need in our  ```hub_customer``` table, we can identify columns in our
staging layer which map to them:

1. A primary key, which is a hashed natural key. The ```CUSTOMER_PK``` we created earlier in the [staging](staging.md) 
section will be used for ```hub_customer```.
2. The natural key, ```CUSTOMER_ID``` which we added using the [add_columns](macros.md#add_columns) macro.
3. A load date timestamp, which is present in the staging layer as ```LOADDATE``` 
4. A ```SOURCE``` column.

We can now add this metadata to the model:

```hub_customer.sql```
```sql hl_lines="5 6 7 8"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='hub') -}}

{%- set source = [ref('stg_customer_hashed')]                                       -%}

{%- set src_pk = 'CUSTOMER_PK'                                                      -%}
{%- set src_nk = 'CUSTOMER_ID'                                                      -%}
{%- set src_ldts = 'LOADDATE'                                                       -%}
{%- set src_source = 'SOURCE'                                                       -%}

```

#### Target columns

Now we can define the target column mapping. The [hub_template](macros.md#hub_template) does a lot of work for us if we
provide the metadata it requires.

```hub_customer.sql```
```sql hl_lines="10 11 12 13"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='hub') -}}

{%- set source = [ref('stg_customer_hashed')]                                       -%}

{%- set src_pk = 'CUSTOMER_PK'                                                      -%}
{%- set src_nk = 'CUSTOMER_ID'                                                      -%}
{%- set src_ldts = 'LOADDATE'                                                       -%}
{%- set src_source = 'SOURCE'                                                       -%}
                                                                           
{%- set tgt_pk = source                                                             -%}
{%- set tgt_nk = source                                                             -%}
{%- set tgt_ldts = source                                                           -%}
{%- set tgt_source = source                                                         -%}
```

With these 4 additional lines, we have provided our mapping from source to target. 

In this particular scenario we aren't renaming the columns or changing the data type, 
so we have used the source reference as a shorthand for keeping the 
same name and datatype as the source columns. If you want to rename columns or change their type, 
this can be achieved by providing triples instead of the reference, 
[see the documentation](macros.md#using-a-source-reference-for-the-target-metadata) 
for more details.

### Invoking the template 

Now we bring it all together and call the [hub_template](macros.md#hub_template) macro:

```hub_customer.sql```                                                                 
```sql hl_lines="15 16 17"                                                             
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='hub') -}}

{%- set source = [ref('stg_customer_hashed')]                                       -%}

{%- set src_pk = 'CUSTOMER_PK'                                                      -%}
{%- set src_nk = 'CUSTOMER_ID'                                                      -%}
{%- set src_ldts = 'LOADDATE'                                                       -%}
{%- set src_source = 'SOURCE'                                                       -%}
                                                                           
{%- set tgt_pk = source                                                             -%}
{%- set tgt_nk = source                                                             -%}
{%- set tgt_ldts = source                                                           -%}
{%- set tgt_source = source                                                         -%}
                                                                                       
{{ dbtvault.hub_template(src_pk, src_nk, src_ldts, src_source,                         
                         tgt_pk, tgt_nk, tgt_ldts, tgt_source,               
                         source)                                                     }}
```

### Running dbt

With our model complete, we can run dbt to create our ```hub_customer``` hub.

```dbt run --models +hub_customer```

!!! tip
    Using the '+' in the command above will get dbt to compile and run all parent dependencies for the model we are 
    running, in this case, it will re-create the staging layer from the ```stg_customer_hashed``` model if needed. 
    dbt will also create our hub if it doesn't already exist.
    
And our table will look like this:

| CUSTOMER_PK  | CUSTOMER_ID  | LOADDATE   | SOURCE       |
| ------------ | ------------ | ---------- | ------------ |
| B8C37E...    | 1001         | 1993-01-01 | 1            |
| .            | .            | .          | .            |
| .            | .            | .          | .            |
| FED333...    | 1004         | 1993-01-01 | 1            |

### Loading from multiple sources to form a union-based hub

In some cases, we may need to create a hub via a union, instead of a single source as we have seen so far.
This may be because we have multiple source staging tables, each of which contains a natural key of the hub. 
This would require multiple feeds into one table: dbt prefers one feed, 
so we union the different feeds into one source before performing the insert via dbt. 

So, this data can and should be combined because these records have a shared key. 
We can union the tables on that key, and create a hub containing a complete record set.

We'll need to have a [staging model](staging.md) for each of the sources involved, 
and provide them as a list of references to the source parameter as shown below.

!!! note
    If your primary key and natural key columns have different names across the different
    tables, they will need to be aliased to the same name in the respective staging layers 
    via the [add_columns](macros.md#add_columns) macro.

This procedure only requires additional source references in the source list
metadata of our ```hub_customer``` model, the [hub_template](macros.md#hub_template) will handle the rest:

```hub_customer.sql```
```sql hl_lines="3 4 5"      
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags=['hub', 'union']) -}}

{%- set source = [ref('stg_sap_customer_hashed'),                                              
                  ref('stg_crm_customer_hashed'),                                              
                  ref('stg_web_customer_hashed')]                                              -%}
                                                                                 
{%- set src_pk = 'CUSTOMER_PK'                                                                 -%}
{%- set src_nk = 'CUSTOMER_ID'                                                                 -%}
{%- set src_ldts = 'LOADDATE'                                                                  -%}
{%- set src_source = 'SOURCE'                                                                  -%}
                                                                                               
{%- set tgt_pk = source                                                                        -%}
{%- set tgt_nk = source                                                                        -%}
{%- set tgt_ldts = source                                                                      -%}
{%- set tgt_source = source                                                                    -%}
                                                                                               
{{ dbtvault.hub_template(src_pk, src_fk, src_ldts, src_source,                                 
                         tgt_pk, tgt_fk, tgt_ldts, tgt_source,                                 
                         source)                                                                }}
```

### Next steps

We have now created a staging layer and a hub. Next we will look at Links, which are created in a similar way.