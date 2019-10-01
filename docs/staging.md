We must create an appropriate staging layer with all of the necessary information for our vault. 

We assume a raw staging layer already exists, all we need to do here is create hashes of these columns 
for our Data Vault.

This is where dbtvault comes in.

### Create the staging model

#### The model header

First we create a new dbt model. If our source table is called 'stg_customer' 
then we should name our additional layer 'stg_customer_hashed', although any sensible naming convention will work if 
kept consistent. In this case, we would create a new file 'stg_customer_hashed.sql' in our models folder.

It is important to note that this additional layer will not necessarily be mapped to only a single table 
in our Data Vault, as it may be required to map one staging table to multiple hubs, links or satellites; just keep this
in mind as we progress.

We have our new model file, what now? Let's add the model header to the file:

```stg_customer_hashed.sql```
```sql

{{- config(materialized='view', schema='my_schema', enabled=true, tags='staging') -}}

```

This is a simple header and you may add tags if necessary, the important parts are the materialization type and 
our schema name:

- The ```materialized``` parameter defines how our table will be materialised in our database. 
Usually we want hashing layers to be views, though they can also be tables depending on our needs.
- The ```schema``` parameter is the name of the schema where this staging table will be created.

#### Providing the metadata

Now we get into the core component of staging: providing metadata. 
This metadata is straightforward and consists of the column names we want to hash, and the alias for our new 
column containing the hash representation.

We need to call the [gen_hashing](/macros/#gen_hashing) macro and provide the appropriate parameters. This macro takes
our provided column names and generates all of the necessary SQL for us. More on how to use this macro is 
provided in the link above.

After adding the macro call, our model will now look something like this:

```stg_customer_hashed.sql```
```sql

{{- config(materialized='view', schema='my_schema', enabled=true, tags='staging') -}}

{{ dbtvault.gen_hashing([('CUSTOMER_ID', 'CUSTOMER_PK')]) -}},

```

!!! note
    Make sure you add the trailing comma after the call.
    
#### Additional columns