# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## Unreleased
These changes are a part of the latest version of the package but are not yet part
of any stable release. Use the new functionality at your own risk until
a stable release is added.

[Feedback is welcome!](https://github.com/Datavault-UK/dbtvault/issues)
 
### Improved
Read the linked documentation for more detail on how to take advantage of
the new and improved features.

- Table Macros:
    - All table macros now no longer require the ```tgt_cols``` parameter.
    This was unnecessary duplication of metadata and removing this now makes
    creating tables much simpler.
    
- Supporting Macros:
    - [add_columns](macros.md#add_columns)
        - Simplified the process of adding constants.
        - Can now use [dbt sources](https://docs.getdbt.com/docs/using-sources) to automatically
        retrieve all source columns without needing to type them all manually. 
   
- Staging Macros:
    - staging_footer renamed to [from](macros.md#from) and functionality for adding constants moved to
    [add_columns](macros.md#add_columns)
    - [multi-hash](macros.md#multi_hash): Formatting of output now more readable
    
        
        
## [v0.1-pre] - 2019-09 / 2019-10
### Added

- Table Macros:
    - [Hub](macros.md#hub_template)
    - [Link](macros.md#link_template)
    - [Satellite](macros.md#sat_template)

- Supporting Macros:
    - [cast](macros.md#cast)
    - [hash](macros.md#hash) (renamed from md5_binary)
    - [prefix](macros.md#prefix)

- Staging Macros:
    - [add_columns](macros.md#add_columns)
    - [multi_hash](macros.md#multi_hash) (renamed from gen_hashing)
    - [staging_footer](macros.md#staging_footer) 

### Documentation
   
- Numerous changes leading up to Version 1.0 release
