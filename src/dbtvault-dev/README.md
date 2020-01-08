<p align="left">
  <img src="https://user-images.githubusercontent.com/25080503/69713956-6249de80-10fd-11ea-8120-413db42d50ac.png">
  <p> There will be a live demonstration of dbtvault at the next UK Data Vault User Group on Tuesday, December 3, 2019 @ 6pm in LONDON.
    
  <a href="https://www.meetup.com/UK-Data-Vault-User-Group/events/266604902/">Sign up for FREE now! </a>
  </p>
</p>

<p align="center">
  <img src="https://user-images.githubusercontent.com/25080503/65772647-89525700-e132-11e9-80ff-12ad30a25466.png">
</p>

latest [![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=latest)](https://dbtvault.readthedocs.io/en/latest/?badge=latest)

stable [![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=v0.4)](https://dbtvault.readthedocs.io/en/v0.4/?badge=v0.4)

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

Get started quickly with our worked example:

- [Read the docs](https://dbtvault.readthedocs.io/en/latest/workedexample/)

- [Project Repository](https://github.com/Datavault-UK/snowflakeDemo)

## Currently supported databases:

- [snowflake](https://www.snowflake.com/about/)

## Installation

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

1. Create a model for your hub, link or satellite
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