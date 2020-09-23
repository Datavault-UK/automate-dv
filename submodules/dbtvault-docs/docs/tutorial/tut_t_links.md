# Transactional Links

Also known as non-historized or no-history links, transactional links record the transaction or 'event' components of 
their referenced hub tables. They allow us to model the more granular relationships between entities. Some prime examples
are purchases, flights or emails; there is a record in the table for every event or transaction between the entities 
instead of just one record per relation.

Our transactional links will contain:

1. A primary key. For t-links, we take the natural keys (prior to hashing) represented by the foreign key columns below and create a hash on a concatenation of them.
2. Foreign keys holding the primary key for each hub referenced in the link (2 or more depending on the number of hubs referenced)
3. A payload. The payload consists of concrete data for an entity, i.e. a transaction record. This could be
a transaction number, an amount paid, transaction type or more. The payload will contain all of the
concrete data for a transaction. 
4. An effectivity date. Usually called `EFFECTIVE_FROM`, this column is the business effective date of a 
satellite record. It records that a record is valid from a specific point in time. In the case of a transaction, this
is usually the date on which the transaction occurred. 

5. The load date or load date timestamp.
6. The source for the record

!!! note
    `LOADDATE` is the time the record is loaded into the database. `EFFECTIVE_FROM` is different and may hold a 
    different value, especially if there is a batch processing delay between when a business event happens and the 
    record arriving in the database for load. Having both dates allows us to ask the questions 'what did we know when' 
    and 'what happened when' using the `LOADDATE` and `EFFECTIVE_FROM` date accordingly. 
    
### Setting up t-link models

Create a new dbt model as before. We'll call this one `t_link_transactions`. 

`t_link_transactions.sql`
```sql
{{ dbtvault.t_link(var('src_pk'), var('src_fk'), var('src_payload'),
                   var('src_eff'), var('src_ldts'), var('src_source'),
                   var('source_model'))                                }}
```

To create a t-link model, we simply copy and paste the above template into a model named after the t-link we
are creating. dbtvault will generate a t-link using metadata provided in the next steps.

Transactional links should use the incremental materialization, as we load and add new records to the existing data set. 

We recommend setting the `incremental` materialization on all of your t-links using the `dbt_project.yml` file:

`dbt_project.yml`
```yaml
models:
  my_dbtvault_project:
   t_links:
    materialized: incremental
    tags:
      - t_link
    t_link_transactions:
      vars:
        ...
    t_link_call_feed:
      vars:
        ...
```

[Read more about incremental models](https://docs.getdbt.com/v0.15.0/docs/configuring-incremental-models)

### Adding the metadata

Let's look at the metadata we need to provide to the [t_link](../macros.md#t_link) macro.

#### Source table

The first piece of metadata we need is the source table. For transactional links this can sometimes be a little
trickier than other table types. We need particular columns to model the transaction or event which has occured in the 
relationship between the hubs we are referencing, and therefore may need to create a staging layer specifically for the 
purposes of feeding the transactional link. 

For this step, ensure you have the following columns present in the source table:

1. A hashed transaction number as the primary key
2. Hashed foreign keys, one for each of the referenced hubs.
3. A payload. This will be data about the transaction itself e.g. the amount, type, date or non-hashed transaction number.
4. An `EFFECTIVE_FROM` date. This will usually be the date of the transaction.
5. A load date timestamp
6. A source

Assuming you have a raw source table with these required columns, we can create a hashed staging table
using a dbt model, (let's call it `stg_transactions_hashed.sql`) and this is the table we reference in the 
`dbt_project.yml` file as a string.

`dbt_project.yml`
```yaml
t_link_transactions:
  vars:
    source_model: 'stg_transactions_hashed'
    ...
```   

#### Source columns

Next, we define the columns which we would like to bring from the source.
We can use the columns we identified in the `Source table` section, above. 

`dbt_project.yml`
```yaml hl_lines="4 5 6 7 8 9 10 11 12 13 14 15"
t_link_transactions:
  vars:
    source_model: 'stg_transactions_hashed'
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
```

### Running dbt

With our model complete and our YAML written, we can run dbt to create our `t_link_transactions` transactional link.

`dbt run -m +t_link_transactions`
    
And our table will look like this:

| TRANSACTION_PK  | CUSTOMER_FK | ORDER_FK  | TRANSACTION_NUMBER | TYPE | AMOUNT  | EFFECTIVE_FROM | LOADDATE    | SOURCE |
| --------------- | ----------- | --------- | ------------------ | ---- | ------- | -------------- | ----------- | ------ |
| BDEE76...       | CA02D6...   | CF97F1... | 123456789101       | CR   | 100.00  | 1993-01-28     | 1993-01-29  | 2      |
| .               | .           | .         | .                  | .    | .       | .              | .           | .      |
| .               | .           | .         | .                  | .    | .       | .              | .           | .      |
| E0E7A8...       | F67DF4...   | 2C95D4... | 123456789104       | CR   | 678.23  | 1993-01-28     | 1993-01-29  | 2      |


### Next steps

We have now created a staging layer and a hub, link, satellite and transactional link. We'll be bringing new
table structures in future releases. 

Take a look at our [worked example](../worked_example/we_worked_example.md) for a demonstration of a realistic environment with pre-written 
models for you to experiment with and learn from. 