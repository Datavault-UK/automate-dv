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
{{- config(materialized='incremental', schema='MYSCHEMA', tags='hub') -}}
```

Hubs are always incremental, as we load and add new records to the existing data set. 

[Read more about incremental models](https://docs.getdbt.com/v0.15.0/docs/configuring-incremental-models)

!!! note "Dont worry!" 
    The [hub](macros.md#hub) deals with the Data Vault
    2.0 standards when loading into the hub from the source. We won't need to worry about unwanted duplicates.
    
### Adding the metadata

Let's look at the metadata we need to provide to the [hub](macros.md#hub) macro.

!!! tip "New in v0.5"
    As of v0.5, metadata must be provided in the ```dbt_project.yml```. Please refer to our [metadata](metadata.md) page.

!!! warning "hub_template deprecated"
    For previous versions prior to 0.5, please use the [hub_template](macros.md#hub_template) macro. 
    

#### Source table

The first piece of metadata we need is the source table. This step is easy, as in this example we created the 
staging layer ourselves. All we need to do is provide the name of stage table as a string in our metadata as follows.

```dbt_project.yml```

```yaml
hub_customer:
          vars:
            source: 'v_stg_orders'
            ...
```

#### Source columns

Next, we define the columns which we would like to bring from the source.
Using our knowledge of what columns we need in our  ```hub_customer``` table, we can identify columns in our
staging layer which we will then use to form our hub:

1. A primary key, which is a hashed natural key. The ```CUSTOMER_PK``` we created earlier in the [staging](staging.md) 
section will be used for ```hub_customer```.
2. The natural key, ```CUSTOMER_KEY``` which we added using the [add_columns](macros.md#add_columns) macro.
3. A load date timestamp, which is present in the staging layer as ```LOADDATE``` 
4. A ```SOURCE``` column.

We can now add this metadata to the model:

```dbt_project.yml```

```yaml hl_lines="4 5 6 7"
hub_customer:
          vars:
            source: 'v_stg_orders'
            src_pk: 'CUSTOMER_PK'
            src_nk: 'CUSTOMER_KEY'
            src_ldts: 'LOADDATE'
            src_source: 'SOURCE'
```

!!! note "New in v0.5"
    Notice something missing? You no longer need to specify target columns in your metadata! All required columns 
    including constants, aliases, and functions must be handled using the [add_columns](macros.md#add_columns) macro
    in the staging layer.  

### Invoking the template 

Now all that is needed is to create your hub:

```hub_customer.sql```                                                                 
```sql hl_lines="3 4"                                                             
{{- config(materialized='incremental', schema='MYSCHEMA', tags='hub') -}}

{{ dbtvault.hub(var('src_pk'), var('src_nk'), var('src_ldts'),
                var('src_source'), var('source'))                      }}
```

Here we have added a call to the [hub](macros.md#hub) macro, referencing our variables declared in the 
```dbt_project.yml```.

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