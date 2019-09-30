**CURRENTLY IN PRE-RELEASE, STAY TUNED FOR AN OFFICAL ANNOUNCEMENT AND FULL DOCUMENTATION**

<p align="center">
  <img src="https://user-images.githubusercontent.com/25080503/65772647-89525700-e132-11e9-80ff-12ad30a25466.png">
</p>

[![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=latest)](https://dbtvault.readthedocs.io/en/latest/?badge=latest)

# dbtvault by [Datavault](https://www.data-vault.co.uk)

dbtvault is a DBT package for creating Data Vault 2.0 compliant Data Warehouses; 

powered by [dbt](https://www.getdbt.com/), a registered trademark of [Fishtown Analytics](https://www.fishtownanalytics.com/)


## Currently supported databases:

- [snowflake](https://www.snowflake.com/about/)

## Installation

Add the following to your ```packages.yml```


```bash
packages:

  - git: "https://github.com/Datavault-UK/dbtvault"
```
And run 
```dbt deps```

## Usage

1. Create a model for your hub, link or satellite
2. Set your metadata and hash model parameters
4. Call the appropriate template macro
```bash
{{- config(...)                                                           -}}

{%- set metadata = ...                                                    -%}

{%- set source = ...                                                      -%}

{{ dbtvault.hub_template(src_pk, src_nk, src_ldts, src_source,
                         tgt_cols, tgt_pk, tgt_nk, tgt_ldts, tgt_source,
                         source)                                           }}
```

## Contributing
Please open an issue first to discuss what you would like to change.

## License
[Apache 2.0](https://choosealicense.com/licenses/apache-2.0/)