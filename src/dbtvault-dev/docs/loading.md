We can begin loading our vault now that we have a staging layer with all of the columns we require.

## Hubs

Hubs are one of the core building blocks of a Data Vault. 

In general, they consist of 4 columns, but may have more: 

1. A primary key (or surrogate key) which is usually a hashed representation of the natural key (also known as the business key).

2. The natural key. This is usually a formal identification for the record such as a customer ID or 
order number (can be multi-column).

3. The load date or load date timestamp. This identifies when the record was first loaded into the vault.

4. The source for the record, a code identifying where the data comes from. 
(i.e. ```1``` from the [previous section](staging.md#adding-the-footer), which is the code fo stg_customer)

### Loading Hubs

To compile and load the provided hub models, run the following command:

```dbt run --models tag:hub```

This will run all models with the hub tag.

## Links

Links are another fundamental component in a Data Vault. 

Links model an association or link, between two business keys. They commonly hold business transactions or structural 
information. A link specifically contains the structural information.

Our links will contain:

1. A primary key. For links, we take the natural keys (prior to hashing) represented by the foreign key columns
and create a hash on a concatenation of them. 
2. Foreign keys holding the primary key for each hub referenced in the link (2 or more depending on the number of hubs 
referenced) 
3. The load date or load date timestamp.
4. The source for the record

### Loading Links

To compile and load the provided link models, run the following command:

```dbt run --models tag:link```

This will run all models with the link tag.

## Satellites

Satellites contain point-in-time payload data related to their parent hub or link records. 
Each hub or link record may have one or more child satellite records, allowing us to record changes in 
the data as they happen. 

They will usually consist of the following columns:

1. A primary key (or surrogate key) which is usually a hashed representation of the natural key.

2. A hashdiff. This is a concatenation of the payload (below) and the primary key. This
allows us to detect changes in a record. For example, if a customer changes their name, 
the hashdiff will change as a result of the payload changing. 

3. A payload. The payload consists of concrete data for an entity, i.e. a customer record. This could be
a name, a date of birth, nationality, age, gender or more. The payload will contain some or all of the
concrete data for an entity, depending on the purpose of the satellite. 

4. An effectivity date. Usually called ```EFFECTIVE_FROM```, this column is the business effective date of a 
satellite record. It records that a record is valid from a specific point in time.
If a customer changes their name, then the record with their 'old' name should no longer be valid, and it will no longer 
have the most recent ```EFFECTIVE_FROM``` value. 

5. The load date or load date timestamp. This identifies when the record was first loaded into the vault.

6. The source for the record.

!!! note
    ```LOADDATE``` is the time the record is loaded into the database. ```EFFECTIVE_FROM``` is different and may hold a 
    different value, especially if there is a batch processing delay between when a business event happens and the 
    record arriving in the database for load. Having both dates allows us to ask the questions 'what did we know when' 
    and 'what happened when' using the ```LOADDATE``` and ```EFFECTIVE_FROM``` date accordingly.

### Loading Satellites

To compile and load the provided satellite models, run the following command:

```dbt run --models tag:satellite``` 

This will run all models with the satellite tag.

## Transactional Links

Transactional Links are used to model transactions between entities in a Data Vault. 

Links model an association or link, between two business keys. They commonly hold business transactions or structural 
information. A transactional link specifically contains the business transactions.

Our transactional links will contain:

1. A primary key. For transactional links, we use the transaction number. If this is not already present in the dataset
then we create this by concatenating the foreign keys and hashing them. 
2. Foreign keys holding the primary key for each hub referenced in the transactional link (2 or more depending on the number of hubs 
referenced) 
3. A payload. This will be data about the transaction itself e.g. the amount, type, date or non-hashed transaction number.
4. An ```EFFECTIVE_FROM``` date. This will usually be the date of the transaction.
5. The load date or load date timestamp.
6. The source for the record

### Loading transactional links

To compile and load the provided t_link models, run the following command:

```dbt run --models tag:t_link```

This will run all models with the t_link tag.

## Loading the full system

Each of the commands above load a particular type of table, however, we may want to do a full system load.

To do this, run the command below:

```dbt run --models load.*``` 

This will run all models in the load directory, which is where all of the provided models are located.

## Loading the next day-feed

Now that we have loaded all records for the date ```1992-01-08```, we can increment the date to load the next day.

Return to the ```dbt_project.yml``` file and change the date to ```1992-01-09```:

```dbt_project.yml```
```yaml hl_lines="24"
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
      hubs:
        ...
      links:
        ...
      sats:
        ...
      t_links:
        ...
  vars:
    date: TO_DATE('1992-01-09')
```

And run:

```dbt run --models load.*``` 

This will load the next day-feed into the system.

## Next steps

Now that you have a taste for how dbtvault and Data Vault works, you may be itching to implement Data Vault in
a production system.

There are a range of skills you need to learn, but this is the same for all Data Warehouse architectures.

We understand that it's a daunting process, but not to worry! 

We can can shortcut your adoption process with Data Vault training, coaching and advice so that you can develop a 
practical Data Vault demonstration to impress your stakeholders. 

<a href="https://www.data-vault.co.uk/dbtvault/" class="btn">
<i class="fa fa-info-circle"></i> Find out more
</a>