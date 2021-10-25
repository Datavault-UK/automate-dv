<p align="center">
  <img src="https://user-images.githubusercontent.com/25080503/65772647-89525700-e132-11e9-80ff-12ad30a25466.png" alt="dbtvault">
</p>

<p align="center">
  <a href="https://dbtvault.readthedocs.io/en/stable/?badge=v0.7.7"><img
    src="https://readthedocs.org/projects/dbtvault/badge/?version=v0.7.7" 
    alt="Documentation Status"
  /></a>
  <a href="https://join.slack.com/t/dbtvault/shared_invite/enQtODY5MTY3OTIyMzg2LWJlZDMyNzM4YzAzYjgzYTY0MTMzNTNjN2EyZDRjOTljYjY0NDYyYzEwMTlhODMzNGY3MmU2ODNhYWUxYmM2NjA"><img
    src="https://img.shields.io/badge/Slack-Join-yellow?style=flat&logo=slack" 
    alt="Join our slack"
  /></a>
</p>


[Changelog and past doc versions](https://dbtvault.readthedocs.io/en/latest/changelog/stable)

# dbtvault by [Datavault](https://www.data-vault.co.uk)

Build your own Data Vault data warehouse! dbtvault is a free to use dbt package that generates & executes the ETL you need to run a Data Vault 2.0 Data Warehouse on a Snowflake database.

What does dbtvault offer?
- productivity gains, fewer errors
- multi-threaded execution of the generated SQL
- your data modeller can generate most of the ETL code directly from their mapping metadata
- your ETL developers can focus on the 5% of the SQL code that is different
- dbt generates documentation and data flow diagrams

powered by [dbt](https://www.getdbt.com/), a registered trademark of [dbt Labs](https://www.getdbt.com/dbt-labs/about-us/)

## Worked example project

Learn quickly with our worked example:

- [Read the docs](https://dbtvault.readthedocs.io/en/latest/worked_example/we_worked_example/)

- [Project Repository](https://github.com/Datavault-UK/snowflakeDemo)

## Currently supported databases:

- [snowflake](https://www.snowflake.com/about/)

## Installation

Check [dbt Hub](https://hub.getdbt.com/datavault-uk/dbtvault/latest/) for the latest installation instructions, 
or [read the docs](https://docs.getdbt.com/docs/building-a-dbt-project/package-management/) for more information on installing packages.

## Usage

1. Create a model for your table.
2. Provide metadata
3. Call the appropriate template macro

```bash
# Configure model
{{- config(...)                          -}}

# Set metadata
{%- set src_pk = ...                     -%}
...

# Call the macro
{{ dbtvault.hub(src_pk, src_nk, src_ldts,
                src_source, source_model) }}
```

## Join our Slack Channel

Talk to our developers and other members of our growing community, get support and discuss anything related to dbtvault or Data Vault 2.0

[![Join our Slack](https://img.shields.io/badge/Slack-Join-yellow?style=flat&logo=slack)](https://join.slack.com/t/dbtvault/shared_invite/enQtODY5MTY3OTIyMzg2LWJlZDMyNzM4YzAzYjgzYTY0MTMzNTNjN2EyZDRjOTljYjY0NDYyYzEwMTlhODMzNGY3MmU2ODNhYWUxYmM2NjA)

## Contributing
[View our contribution guidelines](CONTRIBUTING.md)

## License
[Apache 2.0](LICENSE.md)
