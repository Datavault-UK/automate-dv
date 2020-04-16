# Effectivity satellites

Effectivity satellites are used on links to provide data on which links are currently active and those that are not.

Effectivity satellites contain the following columns:

1. A primary key, which is also the primary key of the [link](macros.md#link). This is the natural keys (prior to hashing) represented by the foreign key columns
and create a hash on a concatenation of them.

2. Effective From date or date timestamp. This is the date that the record is effective from.

3. Start date or date timestamp. This is the date from which the link record is currently the latest/active link.

4. End date or date timestamp. This is the date that a link is made inactive. If it is an active link, a record will 
contain a max date of ```9999-12-31```.  

5. The load date or load date timestamp.

6. The source for the record.

### Creating the model header

Create another empty dbt model. We'll call this one ```eff_sat_customer_order.sql```

The following header is what we use, but feel free to customise it to your needs:

```eff_sat_customer_order.sql```
```sql
{{- config(materialized='incremental', schema='MYSCHEMA', tags='eff_sat') -}}

```

### Adding the metadata

Now we need to provide some metadata to the [eff_sat](macros.md#eff_sat) macro.

#### Source table

The first pieces of metadata we need is the source table and the link table the effectivity satellite is hanging off. 
This step is easy, as we created the staging layer ourselves. All we need to do is provide the name of the staging 
layer in the ```dbt_project.yml``` file under ```source``` and the link table name under ```link``` 
and dbtvault will do the rest for us.

```dbt_project.yml```

```yaml
eff_sat_customer_order:
          vars:
            source: 'stg_customer_order_hashed'
            link: 'link_customer_order'
            ...          
```

#### Source columns

Next, we define the columns which we would like to bring from the source.
Using our knowledge of what columns we need in our  ```eff_sat_customer_order``` table and the columns required help
compute the effectivity satellite logic (all required columns can be found in the [eff_sat](macros.md#eff_sat)). We can 
identify columns in our staging layer which we will then use to form our effectivity satellite:

1. A primary key, which is a combination of the two natural keys: In this case ```CUSTOMER_ORDER_PK``` 
which we added in our staging layer.
2. ```CUSTOMER_FK``` which is one of the foreign keys in the link. This is the foreign key that is going to be used as the
driving foreign key. 
3. ```ORDER_FK``` which is the other foreign key in the link. This is the foreign key that is going to be used as the 
secondary foreign key.
4. ```EFFECTIVE_FROM``` which is the date in the staging table that states when a record becomes effective.
5. ```START_DATETIME``` which is the column in the effectivity satellite whose date defines when a link record begins its
activity.
6. ```END_DATETIME``` which is the column in the effectivity satellite whose date defines when a link record ends its
activity and becomes inactive. Active link records will have a date equal to the max date ```9999-12-31```.
7. A load date timestamp, which is present in the staging layer as ```LOADDATE``` 
8. A ```SOURCE``` column. 

We can now add this metadata to the ```dbt_project.yml``` file:

```dbt_project.yml```
```yaml  hl_lines="5 6 7 8 9 10 11 12"
eff_sat_customer_order:
          vars:
            source: 'stg_customer_order_hashed'
            link: 'link_customer_order'
            src_pk: 'CUSTOMER_ORDER_PK'
            src_dfk: 'CUSTOMER_FK'
            src_sfk: 'ORDER_FK'
            src_eff_from: 'EFFECTIVE_FROM'
            src_start_date: 'START_DATETIME'
            src_end_date: 'END_DATETIME'
            src_ldts: 'LOADDATE'
            src_source: 'SOURCE'
```

!!! note
    Links can often contain more than two foreign keys. For cases where a link contains more than two foreign keys, 
    please see the multi-part key section below.

### Invoking the template

Now we bring it all together and call the [eff_sat](macros.md#eff_sat) macro:

```eff_sat_customer_order.sql```
``` sql hl_lines="2 3 4 5"
{{- config(materialized='incremental', schema='MYSCHEMA', tags='eff_sat')           -}}
-- depends_on: {{ ref(var('link')) }}
{{ dbtvault.eff_sat(var('src_pk'), var('src_dfk'), var('src_sfk'), var('src_ldts'),
                    var('src_eff_from'), var('src_start_date'), var('src_end_date'),
                    var('src_source'), var('link'), var('source'))                   }}
``` 

!!! note
    Unlike the other macros, line 2 of this example is required only for the effectivity satellite. For more info on 
    this please see the [eff_sat](macros.md#eff_sat) macro documentation. 

### Running dbt

With our model complete, we can run dbt to create our ```eff_sat_customer_order``` effectivity satellite.

```dbt run --models +eff_sat_customer_order```

And our table will look like this:

| CUSTOMER_ORDER_PK | EFFECTIVE_FROM | START_DATETIME | END_DATETIME | LOADDATE   | SOURCE       |
| ----------------- | -------------- | -------------- | ------------ | ---------- | ------------ |
| 72A160...         | 1993-01-01     | 1993-01-01     | 9999-12-31   | 1993-01-01 | 1            |
| .                 | .              | .              | .            | .          | .            |
| .                 | .              | .              | .            | .          | .            |
| 1CE6A9...         | 1993-01-01     | 1993-01-01     | 9999-12-31   | 1993-01-01 | 1            |


### Multi-part foreign keys

In some cases, a link may contain more than two foreign keys. The [eff_sat](macros.md#eff_sat) macro accounts for this 
by accepting a multi-part driving foreign key and a multi-part secondary foreign key. To supply this metadata to the 
macro, the driving foreign keys and secondary foreign keys column names must be supplied as a list. An example of this 
can be seen below:

```dbt_project.yml```
```yaml hl_lines="6 7 8 9 10 11 12"
eff_sat_customer_order:
          vars:
            source: 'stg_customer_order_hashed'
            link: 'link_customer_order'
            src_pk: 'CUSTOMER_ORDER_PK'
            src_dfk:
              - 'CUSTOMER_FK'
              - 'NATION_FK'
            src_sfk:
              - 'ORDER_FK'
              - 'PRODUCT_FK'
              - 'ORGANISATION_FK'
            src_eff_from: 'EFFECTIVE_FROM'
            src_start_date: 'START_DATETIME'
            src_end_date: 'END_DATETIME'
            src_ldts: 'LOADDATE'
            src_source: 'SOURCE'
```
