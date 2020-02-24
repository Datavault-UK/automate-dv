We advise you follow these best practises when using dbtvault.

## Staging

Currently, we are only supporting one load date per load, as per the [prerequisites](walkthrough.md#prerequisites).

Until a future release solves this limitation, we suggest that if the raw staging layer has a mix of load dates, 
create a view on it and filter by the load date column to ensure only a single load date value is present.

After you have done this, follow the below steps: 

- Add a reference to the view in your [sources](walkthrough.md#setting-up-sources).
- Provide the source reference to the view as the source parameter in the [from](macros.md#from) 
macro when building your [staging](staging.md) model .

For the next load you then can re-create the view with a different load date and run dbt again, or alternatively 
manage a 'water-level' table which tracks the last load date for each source, and is incremented each load cycle.
Do a join to the table to soft-select the next load date.

## Source

We suggest you use a code. This can be anything that makes sense for your particular context, though usually an
integer or alpha-numeric value works well. The code is often used to look-up the full table name in a table.

You may do this with dbtvault by providing the code as a constant in the [staging](staging.md) layer,
using the [add_columns](macros.md#add_columns) macro. The [staging page](staging.md) presents this exact
use-case in the code examples.

If there is already a source in the raw staging layer, you may keep this or override it; 
[add_columns](macros.md#add_columns) can do either.

## Hashing

!!! seealso "See Also"
    - [hash](#hash)
    - [multi-hash](macros.md#multi_hash)
    
### The drawbacks of using MD5

We are using md5 to calculate the hash in the macros above. If your table contains more than a few billion rows, 
then there is a chance of a clash: where two different values generate the same hash value 
(see [Collision vulnerabilities](https://en.wikipedia.org/wiki/MD5#Collision_vulnerabilities)). 

For this reason, it **should not be** used for cryptographic purposes either.

!!! success 
    
    You may now choose between MD5 and SHA-256 in dbtvault, [read below](bestpractices.md#choosing-a-hashing-algorithm-in-dbtvault).

### Why do we hash?

Data Vault uses hashing for two different purposes.

#### Primary Key Hashing

A hash of the primary key. This creates a surrogate key, but it is calculated consistently across the database:
as it is a single column, same data type, it supports the use of pattern-based loading.

#### Hashdiffs

Used to finger-print the payload of a satellite (similar to a checksum) so it is easier to detect if there has been a 
change in payload, to trigger the load of a new satellite record. This simplifies the SQL as otherwise we'd have to 
compare each column in turn and handle nulls to see if a change had occured. 

Hashing is sensitive to column ordering. You can ask the macro to sort the columns alphabetically for you 
(as per best practices), or switch this off and let your order take precedence (by setting the sort parameter 
to true or false accordingly). Columns are sorted by their alias.

### Hashing best practices

Best practices for hashing include:

- Alpha sorting hashdiff columns. As mentioned, dbtvault can do this for us, so no worries! 
Refer to the [multi-hash](macros.md#multi_hash) docs for details on how to do this.

- Ensure all **hub** columns used to calculate a primary key hash are presented in the same order across all
staging tables 

!!! note
    Some tables may use different column names for primary key components, so you generally **should not** use 
    the sorting functionality for primary keys.

- For **links**, columns must be sorted by the primary key of the hub and arranged alphabetically by the hub name. 
The order must also be the same as each hub. 

### Choosing a hashing algorithm in dbtvault

With the release of dbtvault 0.4, you may now choose between ```MD5``` and ```SHA-256``` hashing. ```SHA-256``` was added
to dbtvault as an option for users who wish to reduce the hashing collision rates in larger data sets.

!!! note

    If a hashing algorithm configuration is missing or invalid, dbtvault will use ```MD5``` by default. 

Configuring the hashing algorithm which will be used by dbtvault is simple: simply add a variable to your 
```dbt_project.yml``` as follows:

```dbt_project.yml```
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