We advise you follow these best practises when using dbtvault.

## Staging

Currently, we are only supporting one load date per load, as per the [prerequisites](tutorial/tut_getting_started.md#pre-requisites).

Until a future release solves this limitation, we suggest that if the raw staging layer has a mix of load dates, 
create a view on it and filter by the load date column to ensure only a single load date value is present.

For the next load you then re-create the view with a different load date and run dbt again, or alternatively 
manage a 'water-level' table which tracks the last load date for each source, and is incremented each load cycle.
Join to the table to soft-select the next load date.

The staging layer must include all columns which are required in the raw vault.

This is an opinionated design feature which dramatically simplifies the mapping of data into 
the raw vault. This means that everything is derived from the staging layer. 

## Record source table code

We suggest you use a code for your record source. This can be anything that makes sense for your particular context, though usually an
integer or alpha-numeric value works well. The code is often used to look up the full table name in a reference table.

You may do this with dbtvault by providing the code as a constant in the [staging](tutorial/tut_staging.md) layer,
using the [stage](macros.md#stage) macro. The [staging walk-through](tutorial/tut_staging.md) presents this exact
use-case in the code examples.

If there is already a source in the raw staging layer, you may keep this or override it using the [stage](macros.md#stage) macro.

## Hashing

!!! seealso "See Also"
    - [hash](macros.md#hash)
    - [hash_columns](macros.md#hash_columns)
    
### The drawbacks of using MD5

By default, dbtvault uses MD5 hashing to calculate hashes using [hash](macros.md#hash) and [hash_columns](macros.md#hash_columns).
If your table contains more than a few billion rows, then there is a chance of a clash: where two different values generate the same hash value 
(see [Collision vulnerabilities](https://en.wikipedia.org/wiki/MD5#Collision_vulnerabilities)). 

For this reason, it **should not be** used for cryptographic purposes either.

You can however, choose between MD5 and SHA-256 in dbtvault, [read below](best_practices.md#choosing-a-hashing-algorithm-in-dbtvault),
which will help with reducing the possibility of collision in larger data sets. 
    
#### Personally Identifiable Information (PII)

Although we do not use hashing for the purposes of security (but rather optimisation and uniqueness) using unsalted MD5
and SHA-256 could still pose a security risk for your organisation. If any of your presentation layer (marts) tables or views
are accessed with malicious intent and any hashed PII is held in the data, an attacker may be able to brute-force the hashing to 
gain access to the PII. For this reason, we highly recommend concatenating a salt to your hashed columns in the staging layer using
the [stage](macros.md#stage) macro. 

It's generally ill-advised to store this salt in the database alongside your hashed values, so we recommend injecting it as
an environment variable for dbt to access via the [env_var jinja context macro](https://docs.getdbt.com/docs/writing-code-in-dbt/jinja-context/env_var/).

This salt **must** be a constant, as we still need to ensure that the same value produces the same hash each and every time for
so that we may reliably look-up and reference the hashed values. The salt could be an (initially) randomly generated 128-bit string, for example, which is then
never changed and stored securely in a secrets manager. 

In future, we plan to develop a helper macro for achieving these salted hashes, to cater to this use case.

### Why do we hash?

Data Vault uses hashing for two different purposes.

#### Primary Key Hashing

A hash of the primary key. This creates a surrogate key, but it is calculated consistently across the database:
as it is a single column, same data type, it supports pattern-based loading.

#### Hashdiffs

Used to finger-print the payload of a satellite (similar to a checksum) so it is easier to detect if there has been a 
change in payload, to trigger the load of a new satellite record. This simplifies the SQL as otherwise we'd have to 
compare each column in turn and handle nulls to see if a change had occurred. 

Hashing is sensitive to column ordering. If you provide the `is_hashdiff: true` flag to your column specification 
in the [stage](macros.md#stage) macro, dbtvault will automatically sort the provided columns alphabetically. 
Columns are sorted by their alias.

### How do we hash?

Our hashing approach is designed to standardise the hashing process, and ensure hashing is kept consistent across
a data warehouse. 

#### Single-column hashing

When we hash single columns, we take the following approach:

```sql 
CAST((MD5_BINARY(NULLIF(UPPER(TRIM(CAST(BOOKING_REF AS VARCHAR))), ''))) AS BINARY(16)) AS BOOKING_PK
```

Single-column hashing step by step:

1. `CAST` to `VARCHAR` First we ensure that all data is treated the same way in the next steps by casting everything to
strings (`VARCHAR`). For example, this means that the number 1001 and the string '1001' will always hash to the same value.

2. `TRIM` We trim whitespace from string to ensure that values with arbitrary leading or trailing whitespace will
always hash to the same value. For example `1001    ` and `1001 `. 

3. `UPPER` Next we eliminate problems where the casing in a string will cause a different hash value to be generated for
the same word, for example `DBTVAULT` and `dbtvault`.

4. `NULLIF ''` At this point we ensure that if an empty string has been provided, it is considered to be `NULL`. This kind of problem
can arise if data is ingested into your warehouse from semi-structured data such as JSON or CSV, where `NULL` values can sometimes be encoded as empty strings.

5. `MD5_BINARY` At this point, we are ready to perform a hashing process on the string, having cleaned and normalised it. 
This will not necessarily use `MD5_BINARY` if you have chosen to use `SHA`, in which case the `SHA2_BINARY` function will be used.

6. `CAST AS BINARY` We then store it as a `BINARY` datatype

#### Multi-column hashing

When we hash multiple columns, we take the following approach:

```sql 
CAST(MD5_BINARY(CONCAT(
    IFNULL(NULLIF(UPPER(TRIM(CAST(CUSTOMER_ID AS VARCHAR))), ''), '^^'), '||',
    IFNULL(NULLIF(UPPER(TRIM(CAST(DOB AS VARCHAR))), ''), '^^'), '||',
    IFNULL(NULLIF(UPPER(TRIM(CAST(PHONE AS VARCHAR))), ''), '^^') ))
AS BINARY(16)) AS HASHDIFF
```

This is similar to single-column hashing aside from the use of `IFNULL` and `CONCAT`, the step-by-step process
is described below.

1\. Steps 1-4 are described in single-column hashing above and are performed on each column 
which comprises the multi-column hash.

5\. `IFNULL` if Steps 1-4 resolve in a NULL value (in the case of the empty string or a true `NULL`)
then we output a double-hat string, `^^`. This ensures that we can detect changes in columns between `NULL` 
and non-NULL values. This is particularly important for `HASHDIFFS`.

6\. `CONCAT` Next, we concatenate the column values using a double-pipe string, `||`. This ensures we have
consistent concatenation, using a string which is unlikely to be contained in the columns we are concatenating.
Concatenating in this way means that we can be more confident that a combination of columns will always generate the same
hash value, particularly where `NULLS` are concerned. 

7\. Steps 7 and 8 are identical to steps 5 and 6 described in single-column hashing.

#### The future of hashing in dbtvault

[We plan to make hashing more configurable in the future](https://github.com/Datavault-UK/dbtvault/pull/4), meaning that
the concatenation string (`||`), `NULL` string (`^^`) and trimming, casing and `NULL` handling in general will be fully configurable. 

As mentioned elsewhere in the documentation, we will also add functionality to allow hashing to be disabled entirely. 

In summary, the intent behind our hashing approach is to provide a robust method of ensuring consistent hashing (same input gives same output).
Until we provide more configuration options, feel free to modify our macros for your needs, as long as you stick to a standard that makes sense to you or your organisation.
If you need advice, [feel free to join our slack and ask our developers](https://join.slack.com/t/dbtvault/shared_invite/enQtODY5MTY3OTIyMzg2LWJlZDMyNzM4YzAzYjgzYTY0MTMzNTNjN2EyZDRjOTljYjY0NDYyYzEwMTlhODMzNGY3MmU2ODNhYWUxYmM2NjA)!.

### Hashing best practices

Best practices for hashing include:

- Alpha sorting Hashdiff columns. As mentioned, dbtvault can do this for us, so no worries! 
Refer to the [stage](macros.md#stage) docs for details on how to do this.

- Ensure all **hub** columns used to calculate a primary key hash are presented in the same order across all
staging tables 

!!! note
    Some tables may use different column names for primary key components, so you generally **should not** use 
    the sorting functionality for primary keys.

- For **links**, columns must be sorted by the primary key of the hub and arranged alphabetically by the hub name. 
The order must also be the same as each hub. 

### Hashdiff Aliasing

`HASHDIFF` columns should be called `HASHDIFF`, as per Data Vault 2.0 standards. Due to the fact we have a shared 
staging layer for the raw vault, we cannot have multiple columns sharing the same name. This means we have to name each 
of our `HASHDIFF` columns differently.

Below is an example satellite YAML config from a `dbt_project.yml` file:

```yaml hl_lines="9 10 11"
sat_customer_details:
  materialized: incremental
  schema: "vlt"
  tags:
    - sat
  vars:
    source_model: "stg_customer_details_hashed"
    src_pk: "CUSTOMER_PK"
    src_hashdiff: 
      source_column: "CUSTOMER_HASHDIFF"
      alias: "HASHDIFF"
    src_payload:
      - "CUSTOMER_NAME"
      - "CUSTOMER_DOB"
      - "CUSTOMER_PHONE"
    src_eff: "EFFECTIVE_FROM"
    src_ldts: "LOADDATE"
    src_source: "SOURCE"
```

The highlighted lines show the syntax required to alias a column named `CUSTOMER_HASHDIFF` (present in the
`stg_customer_details_hashed` staging layer) as `HASHDIFF`.

### Choosing a hashing algorithm in dbtvault

You may choose between ```MD5``` and ```SHA-256``` hashing. ```SHA-256``` is an option for users who wish to reduce 
the hashing collision rates in larger data sets.

!!! note

    If a hashing algorithm configuration is missing or invalid, dbtvault will use ```MD5``` by default. 

Configuring the hashing algorithm which will be used by dbtvault is simple: add a global variable to your 
`dbt_project.yml` as follows:

`dbt_project.yml`
```yaml

name: 'my_project'
version: '1'

profile: 'my_project'

source-paths: ["models"]
analysis-paths: ["analysis"]
test-paths: ["tests"]
data-paths: ["data"]
macro-paths: ["macros"]

target-path: "target"
clean-targets:
    - "target"
    - "dbt_modules"

models:
  vars:
    hash: SHA # or MD5
```

It is possible to configure a hashing algorithm on a model-by-model basis using the hierarchical structure of the ```yaml``` file.
We recommend you keep the hashing algorithm consistent across all tables, however, as per best practise.

Read the [dbt documentation](https://docs.getdbt.com/v0.15.0/docs/var) for further information on variable scoping.

!!! warning
    Stick with your chosen algorithm unless you can afford to full-refresh and you still have access to source data.
    Changing between hashing configurations when data has already been loaded will require a full-refresh 
    of your models in order to re-calculate all hashes.