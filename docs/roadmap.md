With each release we will be adding more Data Vault 2.0 tables and helpful macros.
We hope to tailor new features to the requirements of our community, making the package 
the best and most useful it can be.

We will be releasing changes incrementally rather than jumping from Release 1 to Release 2 and beyond, so you can reap 
the benefits as soon as features are developed.

#### Contribute to dbtvault

- Do you have some ideas? [Let us know what you want added](https://github.com/Datavault-UK/dbtvault/issues)
- Want to contribute your own work? [Read our contribution guidelines](https://github.com/Datavault-UK/dbtvault/blob/master/CONTRIBUTING.md)

## Release 1.0

We're currently working towards release 1! 

Everything is ready to go and can be used as it is, we're just cleaning up some of the rough edges and making sure the 
documentation is up to scratch.

Release 1 will include:

#### Tables

- Staging
- Hubs
- Link
- Satellite    

#### Supporting Macros

- cast
- hash
- prefix

#### Planned improvements

- Make providing aliases and types optional when defining target metadata in table template macros.

!!! success "New in v0.2-pre:"
    - Removed the need to add columns which already exist in raw staging.
    [add_columns](macros.md#add_columns) is now only requires entry of metadata for calculated columns or other user-defined additions.
    - Removed of the ```tgt_cols``` parameter in the table templates, as this was duplication of metadata.
    - Hashing now alpha-sorts columns automatically.

## Release 2.0

#### Tables

- Transactional Links (Also known as non-historised links)
- PITs
- Bridges
- And more