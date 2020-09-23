# Changelog (Stable)
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

[View Beta Releases](beta.md)

## [v0.6.1] - 2020-06-24
[![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=v0.6.1)](https://dbtvault.readthedocs.io/en/v0.6.1/?badge=v0.6.1)

### Added

- dbt 0.17.0 support 
**WARNING** This comes with a caveat that you must use `config-version: 1` in your `dbt_project.yml`

- All macros now support multiple dispatch. This update is to make way for additional platform support (BigQuery, Postgres etc.)

### Changed

- A hashdiff in the stage macro now uses `is_hashdiff` as a flag instead of `hashdiff`, 
this is to clarify this config option as a boolean flag.

### Improved
#### Macros
- Minor macro re-factors to improve readability

### Removed
#### Macros
- Cast macro (supporting) - No longer used. 
- Check relation (internal) - No longer used.

## [v0.6] - 2020-05-26
[![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=v0.6)](https://dbtvault.readthedocs.io/en/v0.6/?badge=v0.6)

**MAJOR UPDATE**

We've added a whole host of interesting new features.

[Read our v0.5 to v0.6 migration guide](../migration_guides/migrating_v0.5_v0.6.md)

### Added

- Staging has now been moved to YAML format, meaning dbtvault is now entirely YAML and metadata driven.
See the new [stage](../macros.md#stage) macro and the [staging tutorial](../tutorial/tut_staging.md) for more details.

- Renamed `source` metadata configuration to `source_model` to clear up some confusion.
A big thank you to @balmasi for this suggestion.

- `HASHDIFF` aliasing is now available for Satellites
[Read More](../migration_guides/migrating_v0.5_v0.6.md#hashdiff-aliasing)

### Upgraded

- [hub](../macros.md#hub) and [link](../macros.md#link) macros have been given a makeover.
They can now handle multi-day loads, meaning no more loading from single-date views.
We'll be updating the other macros soon, stay tuned!

### Fixed 

- Fixed `NULL` handling when hashing. We broke this in v0.5 ([see related issue](https://github.com/Datavault-UK/dbtvault/issues/5))
[Read more](../best_practices.md#how-do-we-hash)

### Removed

- Deprecated macros (old table template macros) 
- A handful of now unused internal macros
- Documentation website from main repository (this makes the package smaller!) 
[New docs repo](https://github.com/Datavault-UK/dbtvault-docs)

## [v0.5] - 2020-02-24
[![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=v0.5)](https://dbtvault.readthedocs.io/en/v0.5/?badge=v0.5)

### Added

- Metadata is now provided in the ```dbt_project.yml``` file. This means metadata can be managed in one place. 
Read [Migrating from v0.4](../migration_guides/migrating_v0.4_v0.5.md) for more information.

### Removed

- Target column metadata mappings are no longer required.
- Manual column mapping using triples to provide data-types and aliases (messy and bad practice).
- Removed copyright notice from generated tables (we are open source, duh!)

### Fixed

- Hashing a single column which contains a ```NULL``` value now works as intended (related to: [hash](../macros.md#hash), 
[multi_hash](../macros.md#multi_hash), [staging](../macros.md#staging-macros)).   

## [v0.4.1] - 2020-01-08
[![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=v0.4.1)](https://dbtvault.readthedocs.io/en/v0.4.1/?badge=v0.4.1)

### Added

- Support for dbt v0.15


## [v0.4] - 2019-11-27
[![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=v0.4)](https://dbtvault.readthedocs.io/en/v0.4-pre/?badge=v0.4)

### Added

- Table Macros:
    - [Transactional Links](../macros.md#t_link_template)

### Improved

- Hashing:
    - You may now choose between ```MD5``` and ```SHA-256``` hashing with a simple yaml configuration
    [Learn how!](../best_practices.md#choosing-a-hashing-algorithm-in-dbtvault)
    
### Worked example

- Transactional Links
    - Added a transactional link model using a simulated transaction feed.
    
### Documentation

- Updated macros, best practices, roadmap, and other pages to account for new features
- Updated worked example documentation
- Replaced all dbt documentation links with links to the 0.14 documentation as dbtvault
is using dbt 0.14 currently (we will be updating to 0.15 soon!)
- Minor corrections

## [v0.3.3-pre] - 2019-10-31
[![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=v0.3.3-pre)](https://dbtvault.readthedocs.io/en/v0.3.3-pre/?badge=v0.3.3-pre)

### Documentation

- Added full demonstration project/worked example, using snowflake. 
- Minor corrections

## [v0.3.2-pre] - 2019-10-28
[![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=v0.3.2-pre)](https://dbtvault.readthedocs.io/en/v0.3.2-pre/?badge=v0.3.2-pre)

### Bug Fixes

- Fixed a bug where the logic for performing a base-load (loading for the first time) on a union-based hub or link was incorrect, causing a load failure.

### Documentation

- Various corrections and clarifications on the macros page.

## [v0.3.1-pre] - 2019-10-25
[![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=v0.3.1-pre)](https://dbtvault.readthedocs.io/en/v0.3.1-pre/?badge=v0.3.1-pre)

### Error handling

- An exception is now raised with an informative message when an incorrect source mapping is 
provided for a model in the case where a source relation is also provided for a target mapping. 
This caused missing columns in generated SQL, and a misleading error message from dbt. 

## [v0.3-pre] - 2019-10-24
[![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=v0.3-pre)](https://dbtvault.readthedocs.io/en/v0.3-pre/?badge=v0.3-pre)

### Improvements

- We've removed the need to specify full mappings in the ```tgt``` metadata when creating table models.
Users may now provide a table reference instead, as a shorthand way to keep the column name 
and date type the same as the source.
The option to provide a mapping is still available.

- The check for whether a load is a union load or not is now more reliable.

### Documentation

- Updated code samples and explanations according to new functionality
- Added a best practises page
- Various clarifications added and errors fixed

## [v0.2.4-pre] - 2019-10-17
[![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=v0.2.4-pre)](https://dbtvault.readthedocs.io/en/v0.2.4-pre/?badge=v0.2.4-pre)

### Bug Fixes

- Fixed a bug where the target alias would be used instead of the source alias when incrementally loading a hub or link,
causing subsequent loads after the initial load, to fail.


## [v0.2.3-pre] - 2019-10-08
[![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=v0.2.3-pre)](https://dbtvault.readthedocs.io/en/v0.2.3-pre/?badge=v0.2.3-pre)

### Macros

- Updated [hash](../macros.md#hash) and [multi-hash](../macros.md#multi_hash)
    - [hash](../macros.md#hash) now accepts a third parameter, ```sort```
    which will alpha-sort provided columns when set to true.
    - [multi-hash](../macros.md#multi_hash) updated to take advantage of
    the the [hash](../macros.md#hash) functionality.

### Documentation

- Updated [hash](../macros.md#hash) and [multi-hash](../macros.md#multi_hash) according to new changes.

## [v0.2.2-pre]  - 2019-10-08
[![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=v0.2.2-pre)](https://dbtvault.readthedocs.io/en/v0.2.2-pre/?badge=v0.2.2-pre)

### Documentation

- Finished Satellite page
- Added Union sections to Hub and Link pages
- Updated staging page with Satellite fields
- Renamed ```stg_orders_hashed``` back to ```stg_customers_hashed```

## [v0.2.1-pre] - 2019-10-07
[![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=v0.2.1-pre)](https://dbtvault.readthedocs.io/en/v0.2.1-pre/?badge=v0.2.1-pre)

### Documentation

- Minor additions and corrections to documentation:
    - Fixed website URL in footer
    - Added contribution page to docs
    - Corrected version in dbt_project.yml

## [v0.2-pre] - 2019-10-07
[![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=v0.2-pre)](https://dbtvault.readthedocs.io/en/v0.2-pre/?badge=v0.2-pre)

[Feedback is welcome!](https://github.com/Datavault-UK/dbtvault/issues)
 
### Improved
Read the linked documentation for more detail on how to take advantage of
the new and improved features.

- Table Macros:
    - All table macros now no longer require the ```tgt_cols``` parameter.
    This was unnecessary duplication of metadata and removing this now makes
    creating tables much simpler.
    
- Supporting Macros:
    - [add_columns](../macros.md#add_columns)
        - Simplified the process of adding constants.
        - Can now optionally provide a [dbt source](https://docs.getdbt.com/docs/using-sources) to automatically
        retrieve all source columns without needing to type them all manually.
        - If not adding any calculated columns or constants, column pairs can be omitted, enabling you to provide the 
        source parameter above only.
    - [hash](../macros.md#hash) now alpha-sorts columns prior to hashing, as
    per best practises. 
   
- Staging Macros:
    - staging_footer renamed to [from](../macros.md#from) and functionality for adding constants moved to
    [add_columns](../macros.md#add_columns)
    - [multi-hash](../macros.md#multi_hash)
        - Formatting of output now more readable
        - Now alpha-sorts columns prior to hashing, as
          per best practises. 

## [v0.1-pre] - 2019-09 / 2019-10
[![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=v0.1-pre)](https://dbtvault.readthedocs.io/en/v0.1-pre/?badge=v0.1-pre)

### Added

- Table Macros:
    - [Hub](../macros.md#hub_template)
    - [Link](../macros.md#link_template)
    - [Satellite](../macros.md#sat_template)

- Supporting Macros:
    - [cast](../macros.md#cast)
    - [hash](../macros.md#hash) (renamed from md5_binary)
    - [prefix](../macros.md#prefix)

- Staging Macros:
    - [add_columns](../macros.md#add_columns)
    - [multi_hash](../macros.md#multi_hash) (renamed from gen_hashing)
    - [staging_footer](../macros.md#from) 

### Documentation
   
- Numerous changes for version 0.1 release
