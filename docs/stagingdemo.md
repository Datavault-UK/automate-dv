![alt text](./assets/images/staging.png "Staging from a raw table to the raw vault")

We have two staging layers, as shown in the diagram above.

## The raw staging layer

First we create a raw staging layer. This feeds in data from the source system so that we can process it
more easily. In the ```models/raw``` folder we have provided two models which set up a raw staging layer.

### raw_orders

The ```raw_orders``` model feeds data from TPC-H, into a wide table containing all of the orders data
for a single day-feed. The day-feed will load data from the day given in the ```date``` var. 

### raw_inventory

The ```raw_inventory``` model feeds the static inventory from TPC-H. As this data does not contain any dates,
we do not need to do any additional date processing or use the ```date``` var as we did for the raw orders data.
The inventory consists of the ```PARTSUPP```, ```SUPPLIER```, ```PART``` and ```LINEITEM``` tables.

### raw_transactions

The ```raw_inventory``` simulates transactions so that we can create transactional links. It does this by
making a number of calculations on orders made by customers and creating transaction records.

[Read more](sourceprofile.md#transactions)

## Building the raw staging layer

To build this layer with dbtvault, run the below command:

```dbt run --models tag:raw```

Running this command will run all models which have the ``raw`` tag. We have given the ```raw``` tag to the
two raw staging layer models, so this will compile and run both models.

The dbt output should give something like this:

```shell
14:18:17 | Concurrency: 4 threads (target='dev')
14:18:17 | 
14:18:17 | 1 of 3 START view model DEMO_RAW.raw_inventory....................... [RUN]
14:18:17 | 2 of 3 START view model DEMO_RAW.raw_orders.......................... [RUN]
14:18:17 | 3 of 3 START view model DEMO_RAW.raw_transactions.................... [RUN]
14:18:19 | 3 of 3 OK created view model DEMO_RAW.raw_transactions............... [SUCCESS 1 in 1.49s]
14:18:19 | 1 of 3 OK created view model DEMO_RAW.raw_inventory.................. [SUCCESS 1 in 1.71s]
14:18:20 | 2 of 3 OK created view model DEMO_RAW.raw_orders..................... [SUCCESS 1 in 2.06s]
14:18:20 | 
14:18:20 | Finished running 3 view models in 8.10s.

```

## The hashed staging layer

The tables in the raw staging layer need to be processed to add extra columns of data to make it ready 
to load to the raw vault. 

Specifically, we need to add primary key hashes, hashdiffs, and any implied fixed-value columns 
(see the diagram at the top of the page).

We have created a number of macros for dbtvault, to make this step easier. Below are some links to
the macro documentation to provide a deeper understanding of how the macros work. 

- [multi-hash](macros.md#multi_hash) Generates SQL for hashes from lists of column/alias pairs.
- [add-columns](macros.md#add_columns) Generates SQL for additional columns with constant or function-derived values, 
from lists of column/alias pairs.
- [from](macros.md#from) Generates SQL for selecting from the source table.

## The model header

For the staging layers we use a header as follows:

```sql
{{- config(materialized='view', schema='STG', enabled=true, tags='stage') -}}
```

This header is fairly-straight forward and defines the model as a view, as well as defining the schema as ```STG```
to ensure that the location we are materializing this model in makes sense in the overall system.

We also define the ```stage``` tag to categorise this model and make it easier to isolate when
we want to only run staging layer models.

## The source table

In the ```v_stg_orders``` model, we use set the following ``source_table``` variable:

```sql
{%- set source_table = ref('raw_orders') -%}
```

This allows us to make use of the additional functionality of the [add-columns](macros.md#add_columns) macro
which will enable it to automatically bring in all columns from the defined ```source_table```.

This will be very convenient for when we need to access the data when creating the raw vault later. 

## Hashing

We provide a number of column/alias pairs to the [multi-hash](macros.md#multi_hash) macro
to generate hashing SQL. These hashes will be used in the raw vault tables as primary key 
and hashdiff fields. 

!!! note "Why do we hash?"
    For more information on why we hash, refer to the [best practices](bestpractices.md#why-do-we-hash) page.

For hashdiff columns, we provide an additional parameter, ```sort``` with the value ```true``` to get 
dbtvault to sort the columns alphabetically when hashing, as per best practices. 

## Additional columns

We also provide a number of column/alias pairs to the [add-columns](macros.md#add_columns) macro
to generate SQL for adding additional columns to our hashed stage view.

AS we mentioned before, if the ```source_table``` variable we created is provided as the first parameter,
all of the ```source_table``` columns will automatically be selected.

If there are any constants which overlap with the ```source_table```, and the ```source_table``` has been
provided as a parameter, the constants provided to this macro will take precedence.

This macro can crate any number of extra columns, which may contain values generated by database function calls
or contain constant values provided by you, the user.

There's a simple shorthand method for providing constants which you can observe being used in the hashed 
staging models. If we provide a ```!``` in the string value, it will create a column with that string 
(minus the ```!```) as its value in every row. This is very useful when defining a source,
as you may want to force it to a certain value for auditing purposes. 

## From

This is a simple convenience macro which generates SQL in the form ```FROM <source_table>```.

## The hashed staging models

### v_stg_orders and v_stg_inventory

The ```v_stg_orders``` and ```v_stg_inventory``` models use the raw layer's ```raw_orders``` and ```raw_inventory``` 
models as sources, respectively. Both are created as views on the raw staging layer, as they are intended as
transformations on the data which already exists.

Each view adds a number of primary keys, hashdiffs and additional constants for use in the raw vault.

### v_stg_transactions

The ```v_stg_transactions``` model uses the raw layer's ```raw_transactions``` model as its source.
For the load date, we add a day to the ```TRANSACTION_DATE``` to simulate the fact we are loading the data in the date 
after the transaction was made.

## Building the hashed staging layer

To build this layer with dbtvault, run the below command:

```dbt run --models tag:stage```

Running this command will run all models which have the ``stage`` tag. We have given the ```stage``` tag to the
two hashed staging layer models, so this will compile and run both models.

The dbt output should give something like this:

```shell
14:19:17 | Concurrency: 4 threads (target='dev')
14:19:17 | 
14:19:17 | 1 of 3 START view model DEMO_STG.v_stg_inventory..................... [RUN]
14:19:17 | 2 of 3 START view model DEMO_STG.v_stg_orders........................ [RUN]
14:19:17 | 3 of 3 START view model DEMO_STG.v_stg_transactions.................. [RUN]
14:19:19 | 3 of 3 OK created view model DEMO_STG.v_stg_transactions............. [SUCCESS 1 in 1.99s]
14:19:20 | 2 of 3 OK created view model DEMO_STG.v_stg_orders................... [SUCCESS 1 in 2.52s]
14:19:20 | 1 of 3 OK created view model DEMO_STG.v_stg_inventory................ [SUCCESS 1 in 2.59s]
14:19:20 | 
14:19:20 | Finished running 3 view models in 7.98s.
```