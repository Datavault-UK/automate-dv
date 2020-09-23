![alt text](../assets/images/staging.png "Staging from a raw table to the raw vault")

The dbtvault package assumes you've already loaded a Snowflake database staging table with raw data 
from a source system or feed (the 'raw staging layer').

### Pre-conditions

There are a few conditions that need to be met for the dbtvault package to work:

- All records are for the same `load_datetime`
- The table is truncated & loaded with data for each load cycle

Instead of truncating and loading, you may also build a view over the table to filter out the right records and load 
from the view.

!!! tip "Good News!"
    **We will shortly be removing this restriction**

### Let's Begin

The raw staging table needs to be prepared with additional columns so that we may load our raw vault.
Specifically, we need to add primary key hashes, hashdiffs, and any implied fixed-value columns (see the diagram).

We also need to ensure column names align with target hub or link table column names.

!!! info
    Hashing of primary keys is optional in Snowflake and natural keys alone can be used in place of hashing. 
    
    We've implemented hashing as the only option for now, though a non-hashed version will be added in future releases, checkout our [roadmap](../roadmap.md).
    
## Creating the stage model

To prepare our raw staging layer, we create a dbt model and call the dbtvault [stage](../macros.md#stage) macro with 
provided metadata. 

### Setting up staging models

First we create a new dbt model. Our example source table is called `raw_orders`, and in this scenario contains data about customers and orders.
We should name our staging model sensibly, for example `stg_orders_hashed.sql`, although any consistent and sensible naming convention will work.

`stg_orders_hashed.sql`
```sql
{{ dbtvault.stage(include_source_columns=var('include_source_columns', none), 
                  source_model=var('source_model', none), 
                  hashed_columns=var('hashed_columns', none), 
                  derived_columns=var('derived_columns', none)) }}
```

To create a staging model, we simply copy and paste the above template into a model named after the staging table/view we
are creating. We provide the metadata to this template, which will use them to generate a staging layer.

Staging models should use the `view` materialization, though it can be a `table` depending on your requirements. 
We recommend setting the `view` materialization on all of your staging models using the `dbt_project.yml` file:

`dbt_project.yml`
```yaml
models:
  my_dbtvault_project:
   staging:
    materialized: view
    tags:
      - stage
    stg_customer_hashed:
      vars:
        ...
    stg_booking_hashed:
      vars:
        ...
```

#### Adding the metadata

Let's look at the metadata we need to provide to the [stage](../macros.md#stage) macro.

#### Source model

The first piece of metadata we need is the source name. This can be in dbt `source` style, or `ref` style.
Generally speaking, our source for staging will be an external raw source of data, so we should set up 
a dbt source and use the `source` style.
We will assume you have opted to use the `source` style for the remainder of the staging tutorial. 

```yaml tab='source'
# schema.yml
version: 2

sources:
  - name: my_source
    database: MY_DATABASE
    schema: MY_SCHEMA
    tables:
      - name: raw_customer

# dbt_project.yml
stg_customer_hashed:
  vars:
    source_model: 
      my_source: "raw_customer"
```

```yaml tab='ref'
# dbt_project.yml
stg_customer_hashed:
  vars:
    source_model: "raw_customer"
```

### Adding hashed columns

We can now specify a mapping of columns to hash, which we will use in our raw vault layer.

`dbt_project.yml`

```yaml hl_lines="5 6 7 8 9 10 11 12 13 14 15 16 17"

stg_customer_hashed:
  vars:
    source_model: 
      my_source: "raw_customer"
    hashed_columns:
      CUSTOMER_PK: "CUSTOMER_ID"
      NATION_PK: "NATION_ID"
      CUSTOMER_NATION_PK:
        - "CUSTOMER_ID"
        - "NATION_ID"
      CUSTOMER_HASHDIFF:
        is_hashdiff: true
        columns:
          - "CUSTOMER_NAME"
          - "CUSTOMER_PHONE"
          - "CUSTOMER_DOB"
```

With this metadata, the [stage](../macros.md#stage) macro will:

- Hash the `CUSTOMER_ID` column, and create a new column called `CUSTOMER_PK` containing the hash value.
- Hash the `NATION_ID` column, and create a new column called `NATION_PK` containing the hash value.
- Concatenate the values in the `CUSTOMER_ID` and ```NATION_ID``` columns and hash them in the order supplied, creating a new
column called `CUSTOMER_NATION_PK` containing the hash of the combination of the values.
- Concatenate the values in the `CUSTOMER_NAME`, `CUSTOMER_PHONE`, `CUSTOMER_DOB` 
columns and hash them, creating a new column called `CUSTOMER_HASHDIFF` containing the hash of the 
combination of the values. The `is_hashdiff: true` flag should be provided so that dbtvault knows to treat this column as a hashdiff.
Treating this column as a hashdiff means dbtvault with automatically sort the columns prior to hashing.

See [Why do we hash?](../best_practices.md#why-do-we-hash) for details on hashing best practises.

### Adding calculated and derived columns

We can also provide a mapping of derived, calculated or constant columns which will be needed for the raw vault 
but which do not already exist in the raw data.

Some of these columns may be 'constants' implied by the context of the staging data.
For example, we could add a source table code value for audit purposes, or a load date which is the result of a function such as `CURRENT_TIMESTAMP()`.
We provide a constant by prepending a `!` to the front of the value in the key/value pair. 
[Read more about constants](../metadata.md#constants)

!!! tip
    For full options, usage examples and syntax, please refer to the [stage](../macros.md#stage) macro documentation.

```yaml hl_lines="18 19 20"

stg_customer_hashed:
  vars:
    source_model: 
      my_source: "raw_customer"
    hashed_columns:
      CUSTOMER_PK: "CUSTOMER_ID"
      NATION_PK: "NATION_ID"
      CUSTOMER_NATION_PK:
        - "CUSTOMER_ID"
        - "NATION_ID"
      CUSTOMER_HASHDIFF:
        is_hashdiff: true
        columns:
          - "CUSTOMER_NAME"
          - "CUSTOMER_ID"
          - "CUSTOMER_PHONE"
          - "CUSTOMER_DOB"
    derived_columns:
      SOURCE: "!1"
      EFFECTIVE_FROM: "BOOKING_DATE"
```

!!! info
    By default, the stage macro will automatically select all columns which exist in the source model, unless
    the `include_source_columns` macro is set to `false`.

In summary this model will:

- Be materialized as a view
- Select all columns from the external data source `raw_customer`
- Generate hashed columns to create primary keys and a hashdiff
- Generate a `SOURCE` column with the constant value `1`
- Generate an `EFFECTIVE_FROM` column derived from the `BOOKING_DATE` column present in the raw data.

### Running dbt

With our model complete and our YAML written, we can run dbt:
                                       
`dbt run -m stg_customer_hashed`

And our table will look like this:

| CUSTOMER_PK  | NATION_PK    | CUSTOMER_NATION_PK  | CUSTOMER_HASHDIFF   | (source table columns) | SOURCE       | EFFECTIVE_FROM |
| ------------ | ------------ | ------------------- | ------------------- | ---------------------- | ------------ | -------------- |
| B8C37E...    | D89F3A...    | 72A160...           | .                   | .                      | 1            | 1993-01-01     |
| .            | .            | .                   | .                   | .                      | .            | .              |
| .            | .            | .                   | .                   | .                      | .            | .              |
| FED333...    | D78382...    | 1CE6A9...           | .                   | .                      | 1            | 1993-01-01     |

### Next steps

Now that we have implemented a new staging layer with all of the required fields and hashes, we can start loading our vault
with hubs, links and satellites.