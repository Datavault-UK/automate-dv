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

To compile and load the hubs, run the following command:

```dbt run --models tag:hub```

## Links

Links are another fundamental component in a Data Vault. 

Links model an association or link, between two business keys. They commonly hold business transactions or structural 
information.

Our links will contain:

1. A primary key. For links, we take the natural keys (prior to hashing) represented by the foreign key columns below 
and create a hash on a concatenation of them. 
2. Foreign keys holding the primary key for each hub referenced in the link (2 or more depending on the number of hubs 
referenced) 
3. The load date or load date timestamp.
4. The source for the record

To compile and load the links, run the following command:

```dbt run --models tag:link```

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

To compile and load the satellites, run the following command:

```dbt run --models tag:satellite``` 