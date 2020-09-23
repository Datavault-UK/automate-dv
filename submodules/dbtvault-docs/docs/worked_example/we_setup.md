## Download the demonstration project

Assuming you already have a python environment installed, the next step is to download the latest 
demonstration project from the repository.

Using the button below, find the latest release and download the zip file, listed under assets.

<a href="https://github.com/Datavault-UK/snowflakeDemo/releases" class="btn">
<i class="fa fa-download"></i> View Downloads
</a>

Once downloaded, unzip the project.

## Installing requirements

Once you have downloaded the project, install all of the requirements from the provided ```requirements.txt``` file.
First make sure the ```requirements.txt``` file is in your current working directory, then run:

```pip install -r requirements.txt```

This will install dbt and all of its dependencies, ready for 
development with dbt.

## Install dbtvault

Next, we need to install dbtvault. 
dbtvault has already been added to the ```packages.yml``` file provided with the example project, so all you need to do 
is run the following command:
 
```dbt deps```

## Setting up dbtvault with Snowflake

In the provided dbt project file (```dbt_project.yml```) the profile is named ```snowflake-demo```.
In your dbt profiles, you must create a connection with this name and provide the snowflake
account details so that dbt can connect to your Snowflake databases. 

dbt provides their own documentation on how to configure profiles, so we suggest reading that
[here](https://docs.getdbt.com/v0.15.0/docs/configure-your-profile).

A sample profile configuration is provided below which will get you started:

```profiles.yml```
```yaml linenums="1"
snowflake-demo:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <bu77777.eu-west-1>

      user: <myusername>
      password: <mypassword>

      role: <SYSADMIN>
      database: DV_PROTOTYPE_DB
      warehouse: DV_PROTOTYPE_WH
      schema: DEMO
      threads: 4
      client_session_keep_alive: False
```

Replace everything in this configuration marked with```<>``` with your own Snowflake account details.

Key points:

- You must also create a ```DV_PROTOTYPE_DB``` database and ```DV_PROTOTYPE_WH``` warehouse.



- Your ```DV_PROTOTYPE_WH``` warehouse should be X-Small in size and have a 5 minute auto-suspend, as we will
not be coming close to the limits of what Snowflake can process.



- The role can be anything as long as it has full rights to the above schema and database, so we suggest the
default ```SYSADMIN```.

- We have set ```threads``` to 4 here. This setting dictates how 
many models are processed in parallel. In our experience, 4 is a reasonable amount and the full system is created in a 
reasonable time-frame, however, you may run with as many threads as required. 

![alt text](../assets/images/database.png "Creating a database in snowflake")
![alt text](../assets/images/warehouse.png "Creating a warehouse in snowflake")

## The project file

As of v0.5, the ```dbt_project.yml``` file is now used as a metadata store. Below is an example file showing the
metadata for a single instance of each of the current table types. 

```dbt_project.yml```
```yaml linenums="1"

models:
  snowflakeDemo:
    raw_stage:
      schema: 'RAW'
      tags:
        - 'raw'
      materialized: view
    stage:
      schema: 'STG'
      tags:
        - 'stage'
      enabled: true
      materialized: view
      v_stg_inventory:
        vars:
          [...]
      v_stg_orders:
        vars:
          [...]
      v_stg_transactions:
        vars:
          source_model: 'raw_transactions'
          hashed_columns:
            TRANSACTION_PK:
              - 'CUSTOMER_ID'
              - 'TRANSACTION_NUMBER'
            CUSTOMER_FK: 'CUSTOMER_ID'
            ORDER_FK: 'ORDER_ID'
          derived_columns:
            SOURCE: '!RAW_TRANSACTIONS'
            LOADDATE: DATEADD(DAY, 1, TRANSACTION_DATE)
            EFFECTIVE_FROM: 'TRANSACTION_DATE'
    raw_vault:
      schema: 'VLT'
      tags:
        - 'raw_vault'
      materialized: incremental
      hubs:
        tags:
          - 'hub'
        hub_customer:
          vars:
            source_model: 'v_stg_orders'
            src_pk: 'CUSTOMER_PK'
            src_nk: 'CUSTOMERKEY'
            src_ldts: 'LOADDATE'
            src_source: 'SOURCE'
        hub_lineitem:
          vars:
            [...]
        hub_nation:
          vars:
            [...]
        hub_order:
          vars:
            [...]
        hub_part:
          vars:
            [...]
        hub_region:
          vars:
            [...]
        hub_supplier:
          vars:
            [...]
      links:
        tags:
          - 'link'
        link_customer_nation:
          vars:
            source_model: 'v_stg_orders'
            src_pk: 'LINK_CUSTOMER_NATION_PK'
            src_fk:
              - 'CUSTOMER_PK'
              - 'NATION_PK'
            src_ldts: 'LOADDATE'
            src_source: 'SOURCE'
        link_customer_order:
          vars:
            [...]
        link_inventory:
          vars:
            [...]
        link_inventory_allocation:
          vars:
            [...]
        link_nation_region:
          vars:
            [...]
        link_order_lineitem:
          vars:
            [...]
        link_supplier_nation:
          vars:
            [...]
      sats:
        tags:
          - 'satellite'
        sat_inv_inventory_details:
          vars:
            source_model: 'v_stg_inventory'
            src_pk: 'INVENTORY_PK'
            src_hashdiff: 'INVENTORY_HASHDIFF'
            src_payload:
              - 'AVAILQTY'
              - 'SUPPLYCOST'
              - 'PART_SUPPLY_COMMENT'
            src_eff: 'EFFECTIVE_FROM'
            src_ldts: 'LOADDATE'
            src_source: 'SOURCE'
        sat_inv_part_details:
          vars:
            [...]
        sat_inv_supp_nation_details:
          vars:
            [...]
        sat_inv_supp_region_details:
          vars:
            [...]
        sat_inv_supplier_details:
          vars:
            [...]
        sat_order_cust_nation_details:
          vars:
            [...]
        sat_order_cust_region_details:
          vars:
            [...]
        sat_order_customer_details:
          vars:
            [...]
        sat_order_lineitem_details:
          vars:
            [...]
        sat_order_order_details:
          vars:
            [...]
      t_links:
        tags:
          - 't_link'
        t_link_transactions:
          vars:
            source_model: 'v_stg_transactions'
            src_pk: 'TRANSACTION_PK'
            src_fk:
              - 'CUSTOMER_FK'
              - 'ORDER_FK'
            src_payload:
              - 'TRANSACTION_NUMBER'
              - 'TRANSACTION_DATE'
              - 'TYPE'
              - 'AMOUNT'
            src_eff: 'EFFECTIVE_FROM'
            src_ldts: 'LOADDATE'
            src_source: 'SOURCE'
  vars:
    load_date: '1992-01-08'
    hash: 'MD5'
```

#### models

Here we are specifying that models in the `raw_vault` directory should be loaded in to the `VLT` schema, 
and models in the directories `stage` and `raw_stage` should have the schemas `STG` and `RAW` respectively.

We have also specified that they are all enabled, as well as their materialization. Many of these attributes 
are also provided in the files themselves and take precedence over these settings anyway, this is just a design choice. 

#### table metadata

The table metadata is now provided, as of v0.5, in the `dbt_project.yml` file as seen in the above example. 
For each of your table models you must specify the metadata using the correct hierarchy.

Take a look at our [metadata reference](../metadata.md) for a full reference and description.

#### global vars

At the end of the file, we have vars that will apply to all models. 
To simulate day-feeds, we use a variable we have named `load_date` which is used in the `RAW` models to
load for a specific date. This is described in more detail in the [Profiling TPC-H](we_tpch_profile.md) section.