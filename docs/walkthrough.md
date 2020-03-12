## Introduction

!!! info
    This walk-through intends to give you a detailed understanding of how to use 
    dbtvault and the provided macros to develop a Data Vault Data Warehouse from the ground up. 
    If you're looking to quickly experiment and learn using pre-written models, 
    take a look at our [worked example](workedexample.md).

In this section we teach you how to use dbtvault step-by-step, explaining the use of macros and the
different components of the Data Vault in detail.

We will:

- process a raw staging layer.
- create a Data Vault with hubs, links and satellites using dbtvault.

## Pre-requisites 

1. Some prior knowledge of Data Vault 2.0 architecture. Have a look at
[How can I get up to speed on Data Vault 2.0?](index.md#how-can-i-get-up-to-speed-on-data-vault-20)

2. A Snowflake account, trial or otherwise. [Sign up for a free 30-day trial here](https://trial.snowflake.com/ab/)

3. You must have downloaded and installed dbt 0.15.x, 
and [set up a project](https://docs.getdbt.com/v0.15.0/docs/dbt-projects).

4. Sources should be set up in dbt [(see below)](walkthrough.md#setting-up-sources).

5. We assume you already have a raw staging layer.

6. Our macros assume that you are only loading from one set of load dates in a single load cycle (i.e. your staging layer
contains data for one ```load_datetime``` value only). **We will be removing this restriction in future releases**.

7. You should read our [best practices](bestpractices.md) guidance.

## Setting up sources

We will be using the ```source``` feature of dbt extensively throughout the documentation to make access to source
data much easier, cleaner and more modular.

We have provided an example below which shows a configuration similar to that used for the examples in our documentation, 
however this feature is documented extensively in [the documentation for dbt](https://docs.getdbt.com/v0.15.0/docs/using-sources).

We recommend that you place the ```schema.yml``` file you create for your sources, 
in the root of your ```models``` folder, however you can place it wherever needed for your specific project and models.

```schema.yml```

```yaml
version: 2

sources:
  - name: MYSOURCE
    database: MYDATABASE
    schema: MYSCHEMA
    tables:
      - name: stg_customer # alias
        identifier: stg_customer_hashed # table name
      - name: ...
```

## Installation 

Add the following to your ```packages.yml```:

```yaml
packages:

  - git: "https://github.com/Datavault-UK/dbtvault"
    revision: v0.5
```

And run 
```dbt deps```

[Read more on package installation (from dbt)](https://docs.getdbt.com/v0.15.0/docs/package-management)