Satellites contain point-in-time payload data related to their parent hub or link records. 
Each hub or link record may have one or more child satellite records, allowing us to record changes in 
the data as they happen. 

They will usually consist of the following columns:

1. A primary key (or surrogate key) which is usually a hashed representation of the natural key.

2. A hashdiff. This is a concatenation of the payload (below) and the primary key. This
allows us to detect changes in a record. For example, if a customer changes their name, 
the hashdiff will change as a result of the payload changing. 

3. A payload. The payload consists of concrete data for an entity, i.e. a customer record. This could be
a name, a date of birth, nationality, age, gender or more. The payload will contain some or all of the
concrete data for an entity, depending on the purpose of the satellite. 

4. An effectivity date. Usually called `EFFECTIVE_FROM`, this column is the business effective date of a 
satellite record. It records that a record is valid from a specific point in time.
If a customer changes their name, then the record with their 'old' name should no longer be valid, and it will no longer 
have the most recent `EFFECTIVE_FROM` value. 

5. The load date or load date timestamp. This identifies when the record was first loaded into the vault.

6. The source for the record.

!!! note
    `LOADDATE` is the time the record is loaded into the database. `EFFECTIVE_FROM` is different and may hold a 
    different value, especially if there is a batch processing delay between when a business event happens and the 
    record arriving in the database for load. Having both dates allows us to ask the questions 'what did we know when' 
    and 'what happened when' using the `LOADDATE` and `EFFECTIVE_FROM` date accordingly. 

### Setting up satellite models

Create a new dbt model as before. We'll call this one `sat_customer_details`. 

`sat_customer_details.sql`
```sql
{{ dbtvault.sat(var('src_pk'), var('src_hashdiff'), var('src_payload'),
                var('src_eff'), var('src_ldts'), var('src_source'),
                var('source_model'))                                   }}
```

To create a satellite model, we simply copy and paste the above template into a model named after the satellite we
are creating. dbtvault will generate a satellite using metadata provided in the next steps.

Satellites should use the incremental materialization, as we load and add new records to the existing data set. 

We recommend setting the `incremental` materialization on all of your satellites using the `dbt_project.yml` file:

`dbt_project.yml`
```yaml
models:
  my_dbtvault_project:
   satellites:
    materialized: incremental
    tags:
      - sat
    sat_customer_details:
      vars:
        ...
    sat_booking_details:
      vars:
        ...
```
### Adding the metadata

Let's look at the metadata we need to provide to the [sat](../macros.md#sat) macro via the ```dbt_project.yml``` file.

#### Source table

The first piece of metadata we need is the source table. This step is easy, as in this example we created the 
staging layer ourselves.  All we need to do is provide the name of stage table as a string in our metadata 
as follows.

```dbt_project.yml```
```yaml
sat_customer_details:
  vars:
    source_model: 'stg_customer_hashed'
```
    
#### Source columns

Next, we define the columns which we would like to bring from the source.
Using our knowledge of what columns we need in our ```sat_customer_details``` table, we can identify columns in our
staging layer which map to them:

1. The primary key of the parent hub or link table,  which is a hashed natural key. 
The `CUSTOMER_PK` we created earlier in the [staging](tut_staging.md) section will be used for `sat_customer_details`.
2. A hashdiff. We created `CUSTOMER_HASHDIFF` in [staging](tut_staging.md) earlier, which we will use here.
3. Some payload columns: `CUSTOMER_NAME`, `CUSTOMER_DOB`, `CUSTOMER_PHONE` which should be present in the 
raw staging layer via an [stage](../macros.md#stage) macro call.
4. An `EFFECTIVE_FROM` column, also added in staging. 
5. A load date timestamp, which is present in the staging layer as `LOADDATE`. 
6. A `SOURCE` column.

We can now add this metadata to the ```dbt_project```:

```dbt_project.yml```
```yaml hl_lines="4 5 6 7 8 9 10 11 12"
sat_order_customer_details:
  vars:
    source_model: 'stg_customer_hashed'
    src_pk: 'CUSTOMER_PK'
    src_hashdiff: 'CUSTOMER_HASHDIFF'
    src_payload:
      - 'CUSTOMER_NAME'
      - 'CUSTOMER_DOB'
      - 'CUSTOMER_PHONE'
    src_eff: 'EFFECTIVE_FROM'
    src_ldts: 'LOADDATE'
    src_source: 'SOURCE'
```

### Running dbt

With our model complete and our YAML written, we can run dbt to create our `sat_customer_details` satellite.

`dbt run -m +sat_customer_details`
    
And our table will look like this:

| CUSTOMER_PK  | CUSTOMER_HASHDIFF | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOADDATE    | SOURCE |
| ------------ | ------------      | ----------    | ------------ | --------------- | -------------- | ----------- | ------ |
| B8C37E...    | 3C5984...         | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01     | 1993-01-01  | 1      |
| .            | .                 | .             | .            | .               | .              | .           | 1      |
| .            | .                 | .             | .            | .               | .              | .           | 1      |
| FED333...    | D8CB1F...         | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01     | 1993-01-01  | 1      |


### Next steps

We have now created a staging layer and a hub, link and satellite. Next we will look at [transactional links](tut_t_links.md).