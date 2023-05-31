<div align="center">
  <img src="https://user-images.githubusercontent.com/25080503/65772647-89525700-e132-11e9-80ff-12ad30a25466.png" alt="dbtvault">

  [![Documentation Status](https://img.shields.io/badge/docs-stable-blue)](https://dbtvault.readthedocs.io/en/stable/?badge=stable)
  [![Slack](https://img.shields.io/badge/Slack-Join-yellow?style=flat&logo=slack)](https://join.slack.com/t/dbtvault/shared_invite/enQtODY5MTY3OTIyMzg2LWJlZDMyNzM4YzAzYjgzYTY0MTMzNTNjN2EyZDRjOTljYjY0NDYyYzEwMTlhODMzNGY3MmU2ODNhYWUxYmM2NjA)
  
</div>


[Changelog and past doc versions](https://dbtvault.readthedocs.io/en/latest/changelog/stable)

# dbtvault by [Datavault](https://www.data-vault.co.uk)

Build your own Data Vault data warehouse! dbtvault is a free to use dbt package that generates & executes the ETL you need to run a Data Vault 2.0 Data Warehouse on your data platform.

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

## Supported platforms:

[Platform support matrix](https://dbtvault.readthedocs.io/en/latest/macros/#platform-support)

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

# Provide metadata
{%- set src_pk = ...                     -%}
...

# Call the macro
{{ dbtvault.hub(src_pk, src_nk, src_ldts,
                src_source, source_model) }}
```

## Join our Slack Channel

Talk to our developers and other members of our growing community, get support and discuss anything related to dbtvault or Data Vault 2.0

[![Join our Slack](https://img.shields.io/badge/Slack-Join-yellow?style=flat&logo=slack)](https://join.slack.com/t/dbtvault/shared_invite/enQtODY5MTY3OTIyMzg2LWJlZDMyNzM4YzAzYjgzYTY0MTMzNTNjN2EyZDRjOTljYjY0NDYyYzEwMTlhODMzNGY3MmU2ODNhYWUxYmM2NjA)

## Awards

<p align="left">
  <a href="https://www.portsmouth.co.uk/business/first-ever-innovation-awards-wow-guests-in-portsmouth-with-stunning-displays-of-impressive-work-as-honours-are-handed-out-in-10-categories-3445796"> 
    <img src="https://user-images.githubusercontent.com/25080503/140721804-9257d5fd-5e95-4c45-ada2-bc17d8089534.png" alt="innovation awards" 
    width="250" />
  </a>
</p>

## Contributing
[View our contribution guidelines](CONTRIBUTING.md)

## License
[Apache 2.0](LICENSE.md)
