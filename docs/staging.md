
We must create an appropriate staging layer with all of the necessary information for our vault. 

We assume a raw staging layer already exists, all we need to do here is create hashes of these columns 
for our Data Vault.

This is where dbtvault comes in.


### The model header

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

### Providing the metadata for hashing

Now we get into the core component of staging: providing metadata. 
This metadata is straightforward and consists of the column names we want to hash, and the alias for our new 
column containing the hash representation.

We need to call the [gen_hashing](macros.md#gen_hashing) macro and provide the appropriate parameters. This macro takes
our provided column names and generates all of the necessary SQL for us. More on how to use this macro is 
provided in the link above.

After adding the macro call, our model will now look something like this:

```stg_customer_hashed.sql```
```sql

{{- config(materialized='view', schema='MYSCHEMA', enabled=true, tags='staging') -}} 
                                                                                     
{{ dbtvault.gen_hashing([('CUSTOMER_ID', 'CUSTOMER_PK')])                        -}},

```

!!! note
    Make sure you add the trailing comma after the call.
    
### Additional columns

Our Data Vault will not just consist of hashes, so we will need to add some additional columns to our new staging layer, 
containing concrete data.

With the [add_columns](macros.md#add_columns) macro, we can provide a list of columns and any corresponding aliases for 
those columns.


```stg_customer_hashed.sql```
```sql

{{- config(materialized='view', schema='MYSCHEMA', enabled=true, tags='staging') -}} 
                                                                                     
{{ dbtvault.gen_hashing([('CUSTOMER_ID', 'CUSTOMER_PK')])                        -}},
                                                                                     
{{ dbtvault.add_columns([('CUSTOMER_ID', 'CUSTOMER_ID'),                             
                         ('CUSTOMER_DOB', 'CUSTOMER_DOB'),                           
                         ('CUSTOMER_NAME', 'CUSTOMER_NAME'),                         
                         ('LOADDATE', 'LOADDATE'),                       
                         ('LOADDATE', 'EFFECTIVE_FROM')])                         }} 

```

!!! note 
    In future releases, this step shouldn't be necessary, as dbtvault will automatically include
    the rest of the columns found in our staging table for us. 
    
### Adding the footer

Finally, we need to provide a fully qualified source table name for our new staging layer to get data from.
In this example, this would be ```MYDATABASE.MYSCHEMA.stg_customer``` where ```MYDATABASE.MYSCHEMA``` is the 
database and schema in your Snowflake database where your raw staging table resides. 

This can be achieved without any SQL, by using the [staging_footer](macros.md#staging_footer) macro.

Explained in the documentation, this macro also has ```loaddate``` and ```source``` parameters. These are to simplify
the creation of ```SOURCE``` and ```LOADDATE``` columns. The parameters can be omitted in favour of adding them via the 
[add_columns](macros.md#add_columns) macro, as showcased in the snippet above with ```LOADDATE```.

After adding the footer, our completed model should now look like this:


```stg_customer_hashed.sql```
```sql

{{- config(materialized='view', schema='MYSCHEMA', enabled=true, tags='staging')    -}}
                                                                                    
{{ dbtvault.gen_hashing([('CUSTOMER_ID', 'CUSTOMER_PK')])                           -}},
                                                                                    
{{ dbtvault.add_columns([('CUSTOMER_ID', 'CUSTOMER_ID'),                            
                         ('CUSTOMER_DOB', 'CUSTOMER_DOB'),                          
                         ('CUSTOMER_NAME', 'CUSTOMER_NAME'),                        
                         ('LOADDATE', 'LOADDATE'),                                  
                         ('LOADDATE', 'EFFECTIVE_FROM')])                            }}
                                                                                    
{{- dbtvault.staging_footer(source="STG_CUSTOMER",
                            source_table='MYDATABASE.MYSCHEMA.stg_customer_hashed')  }} 

``` 

!!! tip
    In the call to [staging_footer](macros.md#staging_footer) we have provided ```STG_CUSTOMER``` as the value for the 
    ```source``` parameter, this will give every record in our new staging layer the value 
    ```STG_CUSTOMER``` as its ```SOURCE```. 
    This will allow us to trace this data back to the source once it is loaded into our vault from our new staging layer. 
    
    It is entirely optional, and if you already have a source column you can simply add it using 
    [add_columns](macros.md#add_columns) instead.

### Running dbt

With our model complete, we can run dbt and have our new staging layer materialised as configured in the header:

```dbt run --models stg_customer_hashed```

And our table will look like this:

| CUSTOMER_PK                      | CUSTOMER_ID  | CUSTOMER_DOB  | CUSTOMER_NAME  | LOADDATE   | EFFECTIVE_FROM | SOURCE       |
| -------------------------------- | ------------ | ------------- | -------------- | ---------- | -------------- | ------------ |
| B8C37E33DEFDE51CF91E1E03E51657DA | 1001         | 1997-04-24    | Alice          | 1993-01-01 | 1993-01-01     | STG_CUSTOMER |
|               .                  | .            | .             | .              | .          | .              | .            |
|               .                  | .            | .             | .              | .          | .              | .            |
| FED33392D3A48AA149A87A38B875BA4A | 1004         | 2018-04-13    | Dom            | 1993-01-01 | 1993-01-01     | STG_CUSTOMER |


### Next steps

Now that we have implemented a new staging layer with all of the required fields and hashes, we can start loading our vault
with hubs, links and satellites.

Click next below!