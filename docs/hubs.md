Hubs are one of the core building blocks of a Data Vault. 

In general, they consist of 4 columns: 

1. A primary key (or surrogate key) which is usually a hashed representation of the natural key (also known as the business key).

2. The natural key itself. This is usually a formal identification for the record such as a customer ID or 
order number (can be multi-column).

3. The load date or load date timestamp. This identifies when the record was first loaded into the vault.

4. The source for the record. (i.e. ```1``` from the [previous section](staging.md#adding-the-footer))

### Creating the model header

Create a new dbt model as before. We'll call this one 'hub_customer'. 

The following header is what we use, but feel free to customise it to your needs:

```hub_customer.sql```
```sql
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='hub') -}}

```

Hubs are always incremental, as we load and add new records to the existing data set.

An incremental materialisation will optimize our load in cases where the target table (in this case, ```hub_customer```)
already exists and already contains data. This is very important for tables containing a lot of data, where every ounce 
of optimisation counts. 

[Read more about incremental models](https://docs.getdbt.com/docs/configuring-incremental-models)

!!! note "Dont worry!" 
    The [hub_template](macros.md#hub_template) will deal with the filtering of records and ensuring all of the Data Vault
    2.0 standards are upheld when loading into the hub from the source. We won't need to worry about unwanted duplicates.
    
### Adding the metadata

Let's look at the metadata we need to provide to the [hub_template](macros.md#hub_template) macro.

#### Source columns

Using our knowledge of what columns we need in our  ```hub_customer``` table, we can identify columns in our
staging layer which map to them:

1. A primary key, which is a hashed natural key. The ```CUSTOMER_PK``` we created earlier in the [staging](staging.md) section 
is a perfect fit.
2. The natural key itself, ```CUSTOMER_ID``` which we added using the [add_columns](macros.md#add_columns) macro.
3. A load date timestamp, which is present in the staging layer as ```LOADDATE``` 
4. A ```SOURCE``` column.

We can now add this metadata to the model:

```hub_customer.sql```
```sql hl_lines="3 4 5 6"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='hub') -}}

{%- set src_pk = 'CUSTOMER_PK'                                                      -%}
{%- set src_nk = 'CUSTOMER_ID'                                                      -%}
{%- set src_ldts = 'LOADDATE'                                                       -%}
{%- set src_source = 'SOURCE'                                                       -%}

```

#### Target columns

Now we can define the target column mapping. The [hub_template](macros.md#hub_template) does a lot of work for us if we
provide the metadata it requires. We can define which source columns map to the required target columns and
define a column type at the same time:

```hub_customer.sql```
```sql hl_lines="8 10 11 12 13"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='hub') -}}

{%- set src_pk = 'CUSTOMER_PK'                                                      -%}
{%- set src_nk = 'CUSTOMER_ID'                                                      -%}
{%- set src_ldts = 'LOADDATE'                                                       -%}
{%- set src_source = 'SOURCE'                                                       -%}

{%- set tgt_cols = [src_pk, src_nk, src_ldts, src_source]                           -%}

{%- set tgt_pk = [src_pk, 'BINARY(16)', src_pk]                                     -%}
{%- set tgt_nk = [src_nk, 'VARCHAR(38)', src_nk]                                    -%}
{%- set tgt_ldts = [src_ldts, 'DATE', src_ldts]                                     -%}
{%- set tgt_source = [src_source, 'VARCHAR(15)', src_source]                        -%}
```

With these 5 additional lines, we have now informed the macro how to transform our source data:

- On line 8, we have written the 4 columns we worked out earlier to define what source columns
we are using and what order we want them in. We have used the variable names to avoid writing the columns again.
- On the remaining lines we have provided our mapping from source to target. In this particular scenario we aren't
renaming the columns, so we have used the source column reference on both sides. If you need to rename the columns 
however, this feature allows you to do so.
- We have provided a type in the mapping so that the type is explicitly defined. For now, this is not optional, but we
will simplify this for scenarios where we want the data type or column name to remain unchanged in future releases.

!!! info
    There is nothing to stop you entering invalid type mappings in this step (i.e. trying to cast an invalid date format to a date),
    so please ensure they are correct.
    You will soon find out, however, as dbt will issue a warning to you. No harm done, but save time by providing 
    accurate metadata!
    

!!! question "Why is ```tgt_cols``` needed?"
    In future releases, we will eliminate the need to duplicate the source columns as shown on line 8. 
    
    For now, this is a necessary evil. 

#### Source table

The last piece of metadata we need is the source table. This step is easy, as in this example we created the 
new staging layer ourselves. All we need to do is provide a reference to the model we created, and dbt will do the rest for us.
dbt ensures dependencies are honoured when defining the source using a reference in this way.

[Read more about the ref function](https://docs.getdbt.com/docs/ref)

```hub_customer.sql```

```sql hl_lines="15"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='hub') -}}
                                                                                    
{%- set src_pk = 'CUSTOMER_PK'                                                      -%}
{%- set src_nk = 'CUSTOMER_ID'                                                      -%}
{%- set src_ldts = 'LOADDATE'                                                       -%}
{%- set src_source = 'SOURCE'                                                       -%}
                                                                                    
{%- set tgt_cols = [src_pk, src_nk, src_ldts, src_source]                           -%}
                                                                                    
{%- set tgt_pk = [src_pk, 'BINARY(16)', src_pk]                                     -%}
{%- set tgt_nk = [src_nk, 'VARCHAR(38)', src_nk]                                    -%}
{%- set tgt_ldts = [src_ldts, 'DATE', src_ldts]                                     -%}
{%- set tgt_source = [src_source, 'VARCHAR(15)', src_source]                        -%}
                                                                                    
{%- set source = [ref('stg_orders_hashed')]                                         -%}
```

### Invoking the template 

Now we bring it all together and call the [hub_template](macros.md#hub_template) macro:

```hub_customer.sql```                                                                 
                                                                                       
```sql hl_lines="17 18 19"                                                                                
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='hub') -}}
                                                                                       
{%- set src_pk = 'CUSTOMER_PK'                                                      -%}
{%- set src_nk = 'CUSTOMER_ID'                                                      -%}
{%- set src_ldts = 'LOADDATE'                                                       -%}
{%- set src_source = 'SOURCE'                                                       -%}
                                                                                       
{%- set tgt_cols = [src_pk, src_nk, src_ldts, src_source]                           -%}
                                                                                       
{%- set tgt_pk = [src_pk, 'BINARY(16)', src_pk]                                     -%}
{%- set tgt_nk = [src_nk, 'VARCHAR(38)', src_nk]                                    -%}
{%- set tgt_ldts = [src_ldts, 'DATE', src_ldts]                                     -%}
{%- set tgt_source = [src_source, 'VARCHAR(15)', src_source]                        -%}
                                                                                       
{%- set source = [ref('stg_customer_hashed')]                                       -%}
                                                                                       
{{ dbtvault.hub_template(src_pk, src_nk, src_ldts, src_source,                         
                         tgt_cols, tgt_pk, tgt_nk, tgt_ldts, tgt_source,               
                         source)                                                     }}
```                                                                                    

### Running dbt

With our model complete, we can run dbt to create our ```hub_customer``` hub.

```dbt run --models +hub_customer```

!!! tip
    The '+' in the command above will cause dbt to also compile and run all parent dependencies for the model we are 
    running, in this case, it will re-create the staging layer from the ```stg_customer_hashed``` model if needed. 
    dbt will also create our hub if it doesn't already exist.
    
And our table will look like this:

| CUSTOMER_PK  | CUSTOMER_ID  | LOADDATE   | SOURCE       |
| ------------ | ------------ | ---------- | ------------ |
| B8C37E...    | 1001         | 1993-01-01 | 1            |
| .            | .            | .          | .            |
| .            | .            | .          | .            |
| FED333...    | 1004         | 1993-01-01 | 1            |


### Next steps

We have now created a staging layer and a hub. Next we will look at Links, which are created in a similar way.