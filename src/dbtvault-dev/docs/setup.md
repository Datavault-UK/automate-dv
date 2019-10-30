## Setting up a connection profile

In the dbt project file (```dbt_project.yml```) the expected profile is named ```snowflake-demo```.
In your dbt profiles, you must create a connection with this name and provide the snowflake
account details so that dbt can connect to your Snowflake databases. 

dbt provides their own documentation on how to configure profiles, so we suggest reading that
[here](https://docs.getdbt.com/docs/configure-your-profile).

A sample profile configuration is provided below which will get you started:

```profiles.yml```
```yaml
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

- Your ```DV_PROTOTYPE_WH``` warehouse should be X-Small in size and have a low auto-suspend, as we will
not be coming close to the limits of what Snowflake can process.

- The role can be anything as long as it has full rights to the above schema and database, so we suggest the
default ```SYSADMIN```.

- We have set ```threads``` to 4 here. This setting dictates how 
many models are processed in parallel. In our experience, 4 is a reasonable amount and the full system is created in a 
reasonable time-frame, however, you may run with as many threads as required. 

## The project file

The ```dbt_project.yml``` file provided with the project is mostly standard. The main additions are the
settings for the models and the ```vars```.

```dbt_project.yml```
```yaml
models:
  snowflakeDemo:
    load:
      schema: "VLT"
      enabled: true
      materialized: incremental
      stage:
        schema: "STG"
        enabled: true
        materialized: view
      raw:
        schema: "RAW"
        enabled: true
        materialized: incremental
  vars:
    date: TO_DATE('1992-01-08')
```

#### models

Here we are specifying that models in the ```load``` directory should be loaded in to the ```VLT```
schema, and models in the sub-directories ```stage``` and ```source``` should have their own schemas, 
```STG``` and ```SRC``` respectively. We have also specified that they are all enabled, as well
as their materializations. Many of these attributes are also provided in the files themselves and take
precedence over these settings anyway, this is just a design choice. 

#### vars

To simulate day-feeds, we use a variable we have named ```date``` which is used in the ```SRC``` models to
load for a specific date.

## Install dbtvault

Next, we need to run the command ```dbt deps``` to install dbtvault. 
dbtvault has already been added to the ```packages.yml``` file provided with the example project.
