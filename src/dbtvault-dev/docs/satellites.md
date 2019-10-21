Satellites compliment hubs and links, providing more concrete data and temporal attributes.

They will usually consist of the following columns:

1. A primary key (or surrogate key) which is usually a hashed representation of the natural key.

2. A hashdiff. This is a concatenation of the payload (below) and the primary key. This
allows us to detect changes in a record. For example, if a customer changes their name, 
the hashdiff will change as a result of the payload changing. 

3. A payload. The payload consists of concrete data for an entity, i.e. a customer record. This could be
a name, a date of birth, nationality, age, gender or more. The payload will contain some or all of the
concrete data for an entity, depending on the purpose of the satellite. 

4. An effectivity date. Usually called ```EFFECTIVE_FROM```, this column is the key temporal attribute of a 
satellite record. The main purpose of this column is to record that a record is valid at a specific point in time.
If a customer changes their name, then the record with their 'old' name should no longer be valid, and it will no longer 
have the most recent ```EFFECTIVE_FROM```.

5. The load date or load date timestamp. This identifies when the record was first loaded into the vault.

6. The source for the record.

### Creating the model header

Create a new dbt model as before. We'll call this one ```sat_customer_details```. 

The following header is what we use, but feel free to customise it to your needs:

```sat_customer_details.sql```
```sql
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='sat') -}}
```

Satellites are always incremental, as we load and add new records to the existing data set.

An incremental materialisation will optimize our load in cases where the target table (in this case, ```sat_customer_details```)
already exists and already contains data. This is very important for tables containing a lot of data, where every ounce 
of optimisation counts. 

[Read more about incremental models](https://docs.getdbt.com/docs/configuring-incremental-models)

### Adding the metadata

Let's look at the metadata we need to provide to the [sat_template](macros.md#sat_template) macro.

#### Source table

The first piece of metadata we need is the source table. This step is easy, as in this example we created the 
new staging layer ourselves. All we need to do is provide a reference to the model we created, and dbt will do the rest for us.
dbt ensures dependencies are honoured when defining the source using a reference in this way.

[Read more about the ref function](https://docs.getdbt.com/docs/ref)f)

```sat_customer_details.sql```
```sql hl_lines="3"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='sat') -}}

{%- set source = [ref('stg_customer_hashed')]                                       -%}
```

!!! note
    Make sure you surround the ref call with square brackets, as shown in the snippet
    above.
    

#### Source columns

Next, we define the columns which we would like to bring from the source.
Using our knowledge of what columns we need in our ```sat_customer_details``` table, we can identify columns in our
staging layer which map to them:

1. A primary key, which is a hashed natural key. The ```CUSTOMER_PK``` we created earlier in the [staging](staging.md) section 
is a perfect fit.
2. A hashdiff. We created ```CUSTOMER_HASHDIFF``` in [staging](staging.md) earlier, which we will use here.
3. Some payload columns: ```CUSTOMER_NAME```, ```CUSTOMER_DOB```, ```CUSTOMER_PHONE``` which should be present in the 
raw staging layer via an [add_columns](macros.md#add_columns) macro call.
4. An ```EFFECTIVE_FROM``` column, also added in staging. 
5. A load date timestamp, which is present in the staging layer as ```LOADDATE```. 
6. A ```SOURCE``` column.

We can now add this metadata to the model:

```sat_customer_details.sql```
```sql hl_lines="5 6 7 9 10 11"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='sat') -}}

{%- set source = [ref('stg_customer_hashed')]                                       -%}

{%- set src_pk = 'CUSTOMER_PK'                                                      -%}
{%- set src_hashdiff = 'CUSTOMER_HASHDIFF'                                          -%}
{%- set src_payload = ['CUSTOMER_NAME', 'CUSTOMER_DOB', 'CUSTOMER_PHONE']           -%}

{%- set src_eff = 'EFFECTIVE_FROM'                                                  -%}
{%- set src_ldts = 'LOADDATE'                                                       -%}
{%- set src_source = 'SOURCE'                                                       -%}
```

#### Target columns

Now we can define the target column mapping. The [sat_template](macros.md#sat_template) does a lot of work for us if we
provide the metadata it requires. We can define which source columns map to the required target columns and
define a column type at the same time:

```sat_customer_details.sql```
```sql hl_lines="13 14 15 16 17 19 20 21"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='sat') -}}

{%- set source = [ref('stg_customer_hashed')]                                       -%}

{%- set src_pk = 'CUSTOMER_PK'                                                      -%}
{%- set src_hashdiff = 'CUSTOMER_HASHDIFF'                                          -%}
{%- set src_payload = ['CUSTOMER_NAME', 'CUSTOMER_DOB', 'CUSTOMER_PHONE']           -%}

{%- set src_eff = 'EFFECTIVE_FROM'                                                  -%}
{%- set src_ldts = 'LOADDATE'                                                       -%}
{%- set src_source = 'SOURCE'                                                       -%}

{%- set tgt_pk = source                                                             -%}
{%- set tgt_hashdiff = [ src_hashdiff , 'BINARY(16)', 'HASHDIFF']                   -%}
{%- set tgt_payload = [[ src_payload[0], 'VARCHAR(60)', 'NAME'],
                       [ src_payload[1], 'DATE', 'DOB'],
                       [ src_payload[2], 'VARCHAR(15)', 'PHONE']]                   -%}

{%- set tgt_eff = source                                                            -%}
{%- set tgt_ldts = source                                                           -%}
{%- set tgt_source =  source                                                        -%}
```

With these 6 additional lines, we have now informed the macro how to transform our source data:

- We have provided our mapping from source to target. We're renaming the payload columns and the hashdiff here.
We are removing the ```CUSTOMER``` prefix, as this satellite is specifically for customer details and it's
superfluous. Renaming will always depend on your specific project and context, however.

- For the rest of the ```tgt``` metadata, we do not wish to rename columns or change
any data types, so we are simply using the ```source``` reference as shorthand for keeping the columns the same as
the source.

!!! info
    There is nothing to stop you entering invalid type mappings in this step (i.e. trying to cast an invalid date format to a date),
    so please ensure they are correct.
    You will soon find out, however, as dbt will issue a warning to you. No harm done, but save time by providing 
    accurate metadata!

### Invoking the template 

Now we bring it all together and call the [sat_template](macros.md#sat_template) macro:

```sat_customer_details.sql```
```sql hl_lines="23 24 25 26 27"
{{- config(materialized='incremental', schema='MYSCHEMA', enabled=true, tags='sat') -}}

{%- set source = [ref('stg_customer_hashed')]                                       -%}

{%- set src_pk = 'CUSTOMER_PK'                                                      -%}
{%- set src_hashdiff = 'CUSTOMER_HASHDIFF'                                          -%}
{%- set src_payload = ['CUSTOMER_NAME', 'CUSTOMER_DOB', 'CUSTOMER_PHONE']           -%}

{%- set src_eff = 'EFFECTIVE_FROM'                                                  -%}
{%- set src_ldts = 'LOADDATE'                                                       -%}
{%- set src_source = 'SOURCE'                                                       -%}

{%- set tgt_pk = source                                                             -%}
{%- set tgt_hashdiff = [ src_hashdiff , 'BINARY(16)', 'HASHDIFF']                   -%}
{%- set tgt_payload = [[ src_payload[0], 'VARCHAR(60)', 'NAME'],
                       [ src_payload[1], 'DATE', 'DOB'],
                       [ src_payload[2], 'VARCHAR(15)', 'PHONE']]                   -%}

{%- set tgt_eff = source                                                            -%}
{%- set tgt_ldts = source                                                           -%}
{%- set tgt_source =  source                                                        -%}

{{  dbtvault.sat_template(src_pk, src_hashdiff, src_payload,
                          src_eff, src_ldts, src_source,
                          tgt_pk, tgt_hashdiff, tgt_payload,
                          tgt_eff, tgt_ldts, tgt_source,
                          source)                                                    }}

```

### Running dbt

With our model complete, we can run dbt to create our ```sat_customer_details``` satellite.

```dbt run --models +sat_customer_details```
    
And our table will look like this:

| CUSTOMER_PK  | HASHDIFF     | NAME       | DOB          | PHONE           | EFFECTIVE_FROM | LOADDATE    | SOURCE |
| ------------ | ------------ | ---------- | ------------ | --------------- | -------------- | ----------- | ------ |
| B8C37E...    | 3C5984...    | Alice      | 1997-04-24   | 17-214-233-1214 | 1993-01-01     | 1993-01-01  | 1      |
| .            | .            | .          | .            | .               | .              | .           | 1      |
| .            | .            | .          | .            | .               | .              | .           | 1      |
| FED333...    | D8CB1F...    | Dom        | 2018-04-13   | 17-214-233-1217 | 1993-01-01     | 1993-01-01  | 1      |


### Next steps

We have now created a staging layer and a hub, link and satellite. We'll be bringing new
table structures in future releases. We'll also be releasing material which demonstrates these examples in a live 
environment soon!