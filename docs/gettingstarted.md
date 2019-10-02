## Intoduction

This dbtvault package is very much a work in progress – we’ll up the version number to 1.0 when we’re satisfied it works out in the wild.

We know that it deserves new features, that the code base can be tidied up and the SQL better tuned. Rest assured we’re working on it for future releases – our roadmap contains information on what’s coming.
 
If you spot anything you’d like to bring to our attention, have a request for new features, have spotted an improvement we could make, or want to tell us about a typo, 
then please don’t hesitate to let us know via [Github](https://github.com/Datavault-UK/dbtvault/issues). 

We’d rather know you are making active use of this package than hearing nothing from all of you out there! 

Happy Data Vaulting! :smile:

## Prerequisites 

!!! note
    These requirements are subject to change as we improve the package.

1. Some prior knowledge of Data Vault 2.0 architecture. Have a look at
[How can I get up to speed on Data Vault 2.0?](index.md#how-can-i-get-up-to-speed-on-data-vault-20)

2. A Snowflake account, trial or otherwise. [Sign up for a free 30-day trial here](https://trial.snowflake.com/ab/)

2. We assume you already have a raw staging layer.

3. Our macros assume that you are only loading from one set of load dates in a single load cycle. We will be removing this
   restriction in future versions.

## Installation 

Add the following to your ```packages.yml```:

```yaml
packages:

  - git: "https://github.com/Datavault-UK/dbtvault"
```
And run 
```dbt deps```

###### [Read more on package installation (from dbt)](https://docs.getdbt.com/docs/package-management)