Hubs are one of the core building blocks of a Data Vault. 

In general, they consist of 4 columns, but may have more: 

1. A primary key (or surrogate key) which is usually a hashed representation of the natural key (also known as the business key).

2. The natural key. This is usually a formal identification for the record such as a customer ID or 
order number (can be multi-column).

3. The load date or load date timestamp. This identifies when the record was first loaded into the vault.

4. The source for the record, a code identifying where the data comes from. 
(i.e. `1` from the [previous section](tut_staging.md#adding-calculated-and-derived-columns), which is the code for `stg_customer`)

### Setting up hub models

Create a new dbt model as before. We'll call this one `hub_customer`. 

`hub_customer.sql`
```sql
{{ dbtvault.hub(var('src_pk'), var('src_nk'), var('src_ldts'),
                var('src_source'), var('source_model'))        }}
```

To create a hub model, we simply copy and paste the above template into a model named after the hub we
are creating. dbtvault will generate a hub using metadata provided in the next steps.

Hubs should use the incremental materialization, as we load and add new records to the existing data set. 

We recommend setting the `incremental` materialization on all of your hubs using the `dbt_project.yml` file:

`dbt_project.yml`
```yaml
models:
  my_dbtvault_project:
   hubs:
    materialized: incremental
    tags:
      - hub
    hub_customer:
      vars:
        ...
    hub_booking:
      vars:
        ...
```

[Read more about incremental models](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/configuring-incremental-models/)

### Adding the metadata

Let's look at the metadata we need to provide to the [hub](../macros.md#hub) macro.

#### Source model

The first piece of metadata we need is the source model. This step is simple, 
all we need to do is provide the name of the model for the stage table as a string in our metadata as follows:

`dbt_project.yml`
```yaml
hub_customer:
  vars:
    source_model: 'stg_customer_hashed'
    ...
```

#### Source columns

Next, we define the columns which we would like to bring from the source.
Using our knowledge of what columns we need in our  `hub_customer` table, we can identify columns in our
staging layer which we will then use to form our hub:

1. A primary key, which is a hashed natural key. The `CUSTOMER_PK` we created earlier in the [staging](tut_staging.md) 
section will be used for `hub_customer`.
2. The natural key, `CUSTOMER_ID` which we added using the [stage](../macros.md#stage) macro.
3. A load date timestamp, which is present in the staging layer as `LOADDATE`
4. A `SOURCE` column.

We can now add this metadata to the `dbt_project.yml` file:

`dbt_project.yml`
```yaml hl_lines="4 5 6 7"
hub_customer:
  vars:
    source_model: 'stg_customer_hashed'
    src_pk: 'CUSTOMER_PK'
    src_nk: 'CUSTOMER_ID'
    src_ldts: 'LOADDATE'
    src_source: 'SOURCE'
```

### Running dbt

With our model complete and our YAML written, we can run dbt to create our `hub_customer` table.

`dbt run -m +hub_customer`

!!! tip
    Using the '+' in the command above will get dbt to compile and run all parent dependencies for the model we are 
    running, in this case, it will compile and run the staging layer as well as the hub if they don't already exist. 
    
And our table will look like this:

| CUSTOMER_PK  | CUSTOMER_ID  | LOADDATE   | SOURCE       |
| ------------ | ------------ | ---------- | ------------ |
| B8C37E...    | 1001         | 1993-01-01 | 1            |
| .            | .            | .          | .            |
| .            | .            | .          | .            |
| FED333...    | 1004         | 1993-01-01 | 1            |

### Loading hubs from multiple sources

In some cases, we may need to load hubs from multiple sources, instead of a single source as we have seen so far.
This may be because we have multiple source staging tables, each of which contains a natural key for the hub. 
This would require multiple feeds into one table: dbt prefers one feed, 
so we union the separate sources together and load them as one. 

The data can and should be combined because these records have a related key, and are related to the same business concept. 
We can union the tables on that key, and create a hub containing a complete record set.

We'll need to have a [staging model](tut_staging.md) for each of the sources involved, 
and provide them as a list of strings in the `dbt_project.yml` file as shown below.

!!! note
    If your primary key and natural key columns have different names across the different
    tables, they will need to be aliased to the same name in the respective staging layers 
    via the [stage](../macros.md#stage) macro.

The macro needed to create a union hub is identical to a single-source hub, we just provide a 
list of sources rather than a single source in the metadata, the [hub](../macros.md#hub) macro 
will handle the rest. 

`dbt_project.yml`
```yaml hl_lines="3 4 5"
hub_nation:
  vars:
    source_model:
      - 'stg_customer_hashed'
      - 'v_stg_inventory'
    src_pk: 'NATION_PK'
    src_nk: 'NATION_ID'
    src_ldts: 'LOADDATE'
    src_source: 'SOURCE'
```

### Next steps

We have now created a staging layer and a hub. Next we will look at [links](tut_links.md), which are created in a similar way.