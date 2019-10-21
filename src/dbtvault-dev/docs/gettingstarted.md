## Intoduction

This dbtvault package is very much a work in progress – we’ll up the version number to 1.0 when we’re satisfied it works out in the wild.

We know that it deserves new features, that the code base can be tidied up and the SQL better tuned. Rest assured we’re working on it for future releases – [our roadmap contains information on what’s coming](roadmap.md).
 
If you spot anything you’d like to bring to our attention, have a request for new features, have spotted an improvement we could make, or want to tell us about a typo, 
then please don’t hesitate to let us know via [Github](https://github.com/Datavault-UK/dbtvault/issues). 

We’d rather know you are making active use of this package than hearing nothing from all of you out there! 

Happy Data Vaulting! :smile:

## Prerequisites 

1. Some prior knowledge of Data Vault 2.0 architecture. Have a look at
[How can I get up to speed on Data Vault 2.0?](index.md#how-can-i-get-up-to-speed-on-data-vault-20)

2. A Snowflake account, trial or otherwise. [Sign up for a free 30-day trial here](https://trial.snowflake.com/ab/)

3. You must have downloaded and installed dbt, and [set up a project](https://docs.getdbt.com/docs/dbt-projects).

4. Sources should be set up in dbt [(see below)](#setting-up-sources).

5. We assume you already have a raw staging layer.

6. Our macros assume that you are only loading from one set of load dates in a single load cycle (i.e. Your staging layer
contains data for one ```load_datetime``` value only). **We will be removing this restriction in future releases**.

7. You should read our [best practises](bestpractises.md) guidance, this is coming up next.

## Setting up sources

We will be using the ```source``` feature of dbt extensively throughout the documentation to make access to source
data much easier, cleaner and more modular. The main advantage of this is that sources will be included in 
dbt dependency graphs

We have provided an example below which shows a configuration similar to that used for the examples in our documentation, 
however this feature is documented extensively in [the documentation for dbt itself](https://docs.getdbt.com/docs/using-sources).

After reading the above documentation, we recommend you place the ```schema.yml``` file you create for your sources, 
in the root of your ```models``` folder, however you can place it where needed for your specific project and models.

```schema.yml```

```yaml
version: 2

sources:
  - name: MYSOURCE
    database: MYDATABASE
    schema: MYSCHEMA
    tables:
      - name: stg_customer
        identifier: table_1
      - name: ...
```

## Installation 

Add the following to your ```packages.yml```:

```yaml
packages:

  - git: "https://github.com/Datavault-UK/dbtvault"
```
And run 
```dbt deps```

[Read more on package installation (from dbt)](https://docs.getdbt.com/docs/package-management)