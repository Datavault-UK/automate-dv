
![alt text](./assets/images/staging.png "Staging from a raw table to the raw vault")

The dbtvault package assumes you've already loaded a Snowflake database staging table with raw data 
from a source system or feed.

There are a few conditions that need to be met for the dbtvault package to work:

- All records are for the same ```load_datetime```
- The table is truncated & loaded with data for each load cycle

The raw staging table needs to be pre processed to add extra columns of data to make it ready to load to the raw vault.
Specifically, we need to add primary key hashes, hashdiffs, and any implied fixed-value columns (see the diagram).

### Creating the model header

First we create a new dbt model. Our source table is called ```stg_customer``` 
and we should name our additional layer ```stg_orders_hashed```, although any sensible naming convention will work if 
kept consistent. In this case, we create a new file ```stg_orders_hashed.sql``` in our models folder.

!!! info
    We are using the name ```stg_orders_hashed``` for reasons that will become clear as we progress through the guide.
    Our hubs, links and satellites will require more than just customer data, and so ```orders``` makes more sense.

Let's start by adding the model header to the file:

```stg_orders_hashed.sql```
```sql

{{- config(materialized='view', schema='MYSCHEMA', enabled=true, tags='staging') -}}

```

This is a simple header block. You may add tags if necessary, the important parts are the materialization type and 
our schema name:

- The ```materialized``` parameter defines how our table will be materialised in our database. 
Usually we want hashing layers to be views.
- The ```schema``` parameter is the name of the schema where this staging table will be created.

### Adding the metadata

Now we get into the core component of staging: the metadata. 
The metadata consists of the column names we want to hash, and the alias for our new 
column containing the hash representation.

We need to call the [multi_hash](macros.md#multi_hash) macro and provide the appropriate parameters. The macro takes
our provided column names and generates all of the necessary SQL for us. More on how to use this macro is 
provided in the link above.

After adding the macro call, our model will now look something like this:

```stg_orders_hashed.sql```
```sql hl_lines="3 4 5"

{{- config(materialized='view', schema='MYSCHEMA', enabled=true, tags='staging') -}} 
                                                                                     
{{ dbtvault.multi_hash([('CUSTOMER_ID', 'CUSTOMER_PK'),
                        ('NATION_ID', 'NATION_PK'),
                        (['CUSTOMER_ID', 'NATION_ID'], 'CUSTOMER_NATION_PK')])   -}},
```

!!! note
    Make sure you add the trailing comma after the call, at the end of line 5.
    
This call will:

- Hash the ```CUSTOMER_ID``` column, and create a new column called ```CUSTOMER_PK``` containing the hash 
value.
- Hash the ```NATION_ID``` column, and create a new column called ```NATION_PK``` containing the hash 
value.
- Concatenate the values in the ```CUSTOMER_ID``` and ```NATION_ID``` columns and hash them, creating a new
column called ```CUSTOMER_NATION_PK``` containing the hash of the combination of the values.

The latter two pairs will be used later when creating [links](links.md).
    
### Additional columns

We now add the column names we want to bring forward/feed from the raw staging table into the raw vault.
We list them by name, and provide an alias (how we want to name them in the raw vault tables). You will also
have another opportunity to rename these columns later when creating the raw vault tables.

We will need to add some additional columns to our staging layer, containing 'constants' implied by the context of the 
staging data. For example, we may add a source table code value, or the the load date, or some other constant needed in
the primary key. Load dates and sources are also handled in the next section, as you have a choice of techniques.

With the [add_columns](macros.md#add_columns) macro, we can provide a list of columns and any corresponding aliases for 
those columns.


```stg_orders_hashed.sql```
```sql hl_lines="7 8 9 10 11 12"

{{- config(materialized='view', schema='MYSCHEMA', enabled=true, tags='staging') -}} 
                                                                                     
{{ dbtvault.multi_hash([('CUSTOMER_ID', 'CUSTOMER_PK'),
                        ('NATION_ID', 'NATION_PK'),
                        (['CUSTOMER_ID', 'NATION_ID'], 'CUSTOMER_NATION_PK')])   -}},

{{ dbtvault.add_columns([('CUSTOMER_ID', 'CUSTOMER_ID'), 
                         ('NATION_ID', 'NATION_ID'),                        
                         ('CUSTOMER_DOB', 'CUSTOMER_DOB'),                       
                         ('CUSTOMER_NAME', 'CUSTOMER_NAME'),                     
                         ('LOADDATE', 'LOADDATE'),                               
                         ('LOADDATE', 'EFFECTIVE_FROM')])                         }}

```

!!! note 
    In future releases, this step won't be necessary for adding columns which already exist in the raw stage,
    as dbtvault will automatically include the rest of the columns found in our staging table for us. 
    
In the example above we have have a header, have defined some hashing to create primary keys, and added 6 columns: 
5 from the raw stage table, and an added value (```EFFECTIVE_FROM```).
    
### Adding the footer

Finally, we need to provide a fully qualified source table name for our staging layer SQL to get data from.
In this example, this would be ```MYDATABASE.MYSCHEMA.stg_customer``` where ```MYDATABASE.MYSCHEMA``` is the 
database and schema in your Snowflake database where your raw staging table resides.

The [staging_footer](macros.md#staging_footer) macro generates the SQL using the metadata.

As explained in the [documentation](macros.md#staging_footer), this macro also has ```loaddate``` and ```source``` parameters. 
These are to simplify the creation of ```SOURCE``` and ```LOADDATE``` columns.
 The parameters can be omitted in favour of adding them via the [add_columns](macros.md#add_columns) macro, 
 as showcased in the snippet above with ```LOADDATE```. 

After adding the footer, our completed model should now look like this:


```stg_orders_hashed.sql```
```sql hl_lines="14 15"

{{- config(materialized='view', schema='MYSCHEMA', enabled=true, tags='staging') -}}
                                                                                 
{{ dbtvault.multi_hash([('CUSTOMER_ID', 'CUSTOMER_PK'),                                
                        ('NATION_ID', 'NATION_PK'),                                    
                        (['CUSTOMER_ID', 'NATION_ID'], 'CUSTOMER_NATION_PK')])   -}},  
                                                                                 
{{ dbtvault.add_columns([('CUSTOMER_ID', 'CUSTOMER_ID'), 
                         ('NATION_ID', 'NATION_ID'),                        
                         ('CUSTOMER_DOB', 'CUSTOMER_DOB'),                       
                         ('CUSTOMER_NAME', 'CUSTOMER_NAME'),                     
                         ('LOADDATE', 'LOADDATE'),                               
                         ('LOADDATE', 'EFFECTIVE_FROM')])                         }}
                                                                                 
{{- dbtvault.staging_footer(source="1",                               
                            source_table='MYDATABASE.MYSCHEMA.stg_customer')      }} 

``` 

!!! tip
    In the call to [staging_footer](macros.md#staging_footer) we have provided ```1``` as the value for the 
    ```source``` parameter, this will give every record in our new staging layer the value 
    ```1``` as its ```SOURCE```. This is a code which can be used to find the source in a lookup table.
    This will allow us to trace this data back to the source once it is loaded into our vault from our new staging layer. 
    
    It is entirely optional, and if you already have a source column in your raw staging, you can simply add it using 
    [add_columns](macros.md#add_columns) instead.

This model is now ready to run to create a view with all the added data/columns needed to load the raw vault.

### Running dbt

With our model complete, we can run dbt and have our new staging layer materialised as configured in the header:

```dbt run --models stg_orders_hashed```

And our table will look like this:

| CUSTOMER_PK  | NATION_PK    | CUSTOMER_NATION_PK  | CUSTOMER_ID  | NATION_ID    | CUSTOMER_DOB  | CUSTOMER_NAME  | LOADDATE   | EFFECTIVE_FROM | SOURCE       |
| ------------ | ------------ | ------------        | ------------ | ------------ | ------------- | -------------- | ---------- | -------------- | ------------ |
| B8C37E...    | D89F3A...    | 72A160...           | 1001         | 10001        | 1997-04-24    | Alice          | 1993-01-01 | 1993-01-01     | 1            |
| .            | .            | .                   | .            | .            | .             | .              | .          | .              | .            |
| .            | .            | .                   | .            | .            | .             | .              | .          | .              | .            |
| FED333...    | D78382...    | 1CE6A9...           | 1004         | 10004        | 2018-04-13    | Dom            | 1993-01-01 | 1993-01-01     | 1            |

!!! info
    - Hashing of primary keys is optional in Snowflake
    - Natural keys alone can be used
    - We've implemented hashing as the only option, for now
    - A non-hashed version will be added in future releases

### Next steps

Now that we have implemented a new staging layer with all of the required fields and hashes, we can start loading our vault
with hubs, links and satellites.