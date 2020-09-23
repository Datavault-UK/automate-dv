With each release we will be adding more Data Vault 2.0 table templates, helpful macros and productivity enhancements.
We hope to tailor new features to the requirements of our community, making the package 
the best and most useful it can be.

We will be releasing changes incrementally, so you can reap the benefits as soon as features are developed.

#### Contribute to dbtvault

- Do you have some ideas? [Let us know what you want added](https://github.com/Datavault-UK/dbtvault/issues)
- Want to contribute your own work? [Read our contribution guidelines](https://github.com/Datavault-UK/dbtvault/blob/master/CONTRIBUTING.md)

## Coming soon (next release)

These features are currently planned for the near-future:

- Effectivity satellites, [try it out now!](changelog/beta.md)
- Custom materialization for periodic loading similar to the 
[dbt_utils offering for Redshift](https://github.com/fishtown-analytics/dbt-utils/blob/master/README.md#insert_by_period-source)
- Removal of single-day loading restrictions ([v0.6 already adds this for Hubs and Links](migration_guides/migrating_v0.5_v0.6.md#table-macros)

## Future releases

In future releases, we hope to include the following:

### Platform support

- Google BigQuery
- Microsoft SQL Server
- Amazon Redshift
- Postgres 

!!! tip "Google BigQuery Support"
    We're looking to add BigQuery support soon. If you'd like to contribute we are happy to consider pull requests.
    You can also [join our slack](https://dbtvault.slack.com/join/shared_invite/enQtODY5MTY3OTIyMzg2LWJlZDMyNzM4YzAzYjgzYTY0MTMzNTNjN2EyZDRjOTljYjY0NDYyYzEwMTlhODMzNGY3MmU2ODNhYWUxYmM2NjA#/)
    and get involved, we have a channel specifically for it!
    
### Tables

- Multi-active satellites
- Status tracking satellites
- Point-in-Time tables (also know as PITs)
- Bridge tables
- Reference Tables
- Mart loading helpers
- And more!

    
### Additional features

- Auditing 
- Logging
- Global configuration options (particularly around column naming)
