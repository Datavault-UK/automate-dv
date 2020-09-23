Links are another fundamental component in a Data Vault. 

Links model an association or link, between two business keys. They commonly hold business transactions or structural 
information.

!!! note
    Due to the similarities in the load logic between links and hubs, most of this page will be familiar if you have already read the
    [hubs](tut_hubs.md) page.

Our links will contain:

1. A primary key. For links, we take the natural keys (prior to hashing) represented by the foreign key columns below 
and create a hash on a concatenation of them. 
2. Foreign keys holding the primary key for each hub referenced in the link (2 or more depending on the number of hubs 
referenced) 
3. The load date or load date timestamp.
4. The source for the record

### Setting up link models

Create a new dbt model as before. We'll call this one `link_customer_nation`. 

`link_customer_nation.sql`
```sql
{{ dbtvault.link(var('src_pk'), var('src_fk'), var('src_ldts'),
                 var('src_source'), var('source_model'))        }}
```

To create a link model, we simply copy and paste the above template into a model named after the link we
are creating. dbtvault will generate a link using metadata provided in the next steps.

Links should use the incremental materialization, as we load and add new records to the existing data set. 

We recommend setting the `incremental` materialization on all of your links using the `dbt_project.yml` file:

`dbt_project.yml`
```yaml
models:
  my_dbtvault_project:
   links:
    materialized: incremental
    tags:
      - link
    link_customer_nation:
      vars:
        ...
    link_booking_order:
      vars:
        ...
```

[Read more about incremental models](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/configuring-incremental-models/)

### Adding the metadata

Now we need to provide some metadata to the [link](../macros.md#link) macro.

#### Source table

The first piece of metadata we need is the source table. This step is easy, as we created the 
staging layer ourselves. All we need to do is provide the name of the staging layer in the ```dbt_project.yml``` file 
and dbtvault will do the rest for us.

```dbt_project.yml```

```yaml
link_customer_nation:
  vars:
    source_model: 'stg_customer_hashed'
    ...
```

#### Source columns

Next, we define the columns which we would like to bring from the source.
Using our knowledge of what columns we need in our  `link_customer_nation` table, we can identify columns in our
staging layer which map to them:

1. A primary key, which is a combination of the two natural keys: In this case `CUSTOMER_NATION_PK` 
which we added in our staging layer.
2. `CUSTOMER_KEY` which is one of our natural keys (we'll use the hashed column, `CUSTOMER_PK`).
3. `NATION_KEY` the second natural key (we'll use the hashed column, `NATION_PK`).
4. A load date timestamp, which is present in the staging layer as `LOADDATE` 
5. A `SOURCE` column.

We can now add this metadata to the `dbt_project.yml` file:

```dbt_project.yml```
```yaml  hl_lines="4 5 6 7 8 9"
link_customer_nation:
  vars:
    source_model: 'stg_customer_hashed'
    src_pk: 'LINK_CUSTOMER_NATION_PK'
    src_fk:
      - 'CUSTOMER_PK'
      - 'NATION_PK'
    src_ldts: 'LOADDATE'
    src_source: 'SOURCE'
```

!!! note 
    We are using `src_fk`, a list of the foreign keys. This is instead of the `src_nk` 
    we used when building the hubs. These columns must be given in this list format in the `dbt_project.yml` file
    for the links.

### Running dbt

With our model complete and our YAML written, we can run dbt to create our `link_customer_nation` link.

`dbt run -m +link_customer_nation`

And our table will look like this:

| CUSTOMER_NATION_PK | CUSTOMER_FK  | NATION_FK    | LOADDATE   | SOURCE       |
| ------------------ | ------------ | ------------ | ---------- | ------------ |
| 72A160...          | B8C37E...    | D89F3A...    | 1993-01-01 | 1            |
| .                  | .            | .            | .          | .            |
| .                  | .            | .            | .          | .            |
| 1CE6A9...          | FED333...    | D78382...    | 1993-01-01 | 1            |

### Loading from multiple sources to form a union-based link

In some cases, we may need to create a link via a union, instead of a single source as we have seen so far.
This may be because we have multiple source staging tables, each of which contains a natural key of the link. 
This would require multiple feeds into one table: dbt prefers one feed, 
so we union the different feeds into one source before performing the insert via dbt. 

So, this data can and should be combined because these records have a shared key. 
We can union the tables on that key, and create a link containing a complete record set.

We'll need to have a [staging model](tut_staging.md) for each of the sources involved, 
and provide them as a list of strings in the ```dbt_project.yml``` file as shown below.

!!! note
    If your primary key and natural key columns have different names across the different
    tables, they will need to be aliased to the same name in the respective staging layers 
    via the [stage](../macros.md#stage) macro.

The union link model will look exactly the same as creating a single source link model. To create a union you need to 
provide a list of sources rather than a single source in the metadata, the [link](../macros.md#link) macro 
will handle the rest. 

```dbt_project.yml```
```yaml hl_lines="3 4 5"   
link_nation_region:
  vars:
    source_model:
      - 'stg_customer_hashed'
      - 'v_stg_inventory'
    src_pk: 'NATION_REGION_PK'
    src_fk:
      - 'NATION_PK'
      - 'REGION_PK'
    src_ldts: 'LOADDATE'
    src_source: 'SOURCE'
```

### Next steps

We have now created a staging layer, a hub and a link. Next we will look at [satellites](tut_satellites.md). 
These are a little more complicated, but don't worry, the [sat](../macros.md#sat) macro will handle that for 
us! 
