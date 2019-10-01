We must create an appropriate staging layer with all of the necessary information for our vault. 

We assume a raw staging layer already exists, all we need to do here is create hashes of these columns 
for our Data Vault.

This is where dbtvault comes in.

### Create the staging model

First we create a new dbt model. If our source table is called 'stg_customer' 
then we should name our additional layer 'stg_customer_hashed', although any sensible naming convention will work if 
kept consistent. In this case, we would create a new file 'stg_customer_hashed.sql' in our models folder.

It is important to note that this additional layer will not necessarily be mapped to only a single table 
in our Data Vault, as it may be required to map one staging table to multiple hubs, links or satellites; just keep this
in mind as we progress.

We have our new model, what now? Let's add the model header to the file:

```stg_customer_hashed.sql```
```sql

{{- config(materialized='view', schema='my_schema', enabled=true, tags='staging') -}}

```

This is a simple header and you may add tags if necessary, the important parts are the materialization type and 
our schema name:

- The ```materialized``` parameter defines how our table will be materialised in our database. 
Usually we want hashing layers to be views, though they can also be tables depending on our needs.
- The ```schema``` parameter is the name of the schema where this staging table will be created.