<p align="left">
  <h3> News </h3>
  <p> Looking to use dbtvault or Data Vault in your project? We've written a document to give you a head start.
  
  <a href="https://www.data-vault.co.uk/using-dbtvault-in-datavault-project-download/">Download for FREE now! </a>
  </p>
</p>

<p align="center">
  <img src="https://user-images.githubusercontent.com/25080503/65772647-89525700-e132-11e9-80ff-12ad30a25466.png">
</p>

[![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=v0.4)](https://dbtvault.readthedocs.io/en/v0.4/?badge=v0.4)

[past docs versions](https://dbtvault.readthedocs.io/en/latest/changelog/)

# dbtvault by [Datavault](https://www.data-vault.co.uk)

Build your own Data Vault data warehouse! dbtvault is a free to use dbt package that generates & executes the ETL you need to run a Data Vault 2.0 Data Warehouse on a Snowflake database.

What does dbtvault offer?
- productivity gains, fewer errors
- multi-threaded execution of the generated SQL
- your data modeller can generate most of the ETL code directly from their mapping metadata
- your ETL developers can focus on the 5% of the SQL code that is different
- dbt generates documentation and data flow diagrams

powered by [dbt](https://www.getdbt.com/), a registered trademark of [Fishtown Analytics](https://www.fishtownanalytics.com/)

## Worked example project

Learn quickly with our worked example:

- [Read the docs](https://dbtvault.readthedocs.io/en/latest/workedexample/)

- [Project Repository](https://github.com/Datavault-UK/snowflakeDemo)

## Currently supported databases:

- [snowflake](https://www.snowflake.com/about/)

## Installation

Ensure you are using dbt 0.14 (0.15 support will be added soon!)
Add the following to your ```packages.yml```


```yaml
packages:

  - git: "https://github.com/Datavault-UK/dbtvault"
    revision: v0.4 # Latest stable version
```
And run 
```dbt deps```

[Read more on package installation](https://docs.getdbt.com/v0.14.0/docs/package-management)

## Usage

1. Create a model for your table.
2. Provide metadata
3. Call the appropriate template macro

```bash
{{- config(...)                                                           -}}

{%- set metadata = ...                                                    -%}

{%- set source = ...                                                      -%}

{{ dbtvault.hub_template(src_pk, src_nk, src_ldts, src_source,
                         tgt_pk, tgt_nk, tgt_ldts, tgt_source,
                         source)                                           }}
```

## Sign up for early-bird announcements 

[SIGN UP](https://www.data-vault.co.uk/dbtvault/) and get notified of new features and new releases 
before anyone else!

## Contributing
[View our contribution guidelines](CONTRIBUTING.md)

## License
[Apache 2.0](LICENSE.md)
