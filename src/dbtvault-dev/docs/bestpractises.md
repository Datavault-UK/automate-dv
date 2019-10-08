We advise you follow these best practises when using dbtvault.

## Staging

Currently, we are only supporting one load date per load, as per the [prerequisites](gettingstarted.md#prerequisites).

Until a future release solves this limitation, we suggest that if the raw staging layer has a mix of load dates, 
create a view on it and filter by the load date column to ensure only a single load date value is present.

After you have done this, follow the below steps: 

- Add a reference to the view in your [sources](gettingstarted.md#setting-up-sources).
- Provide the source reference to the view as the source parameter in the [from](macros.md#from) 
macro when building your staging model [staging](staging.md).

For the next load you then can re-create the view with a different load date and run dbt again.

## Source

We suggest you use a code. This can be anything that makes sense for your particular context, though usually an
integer or alpha-numeric value works well. The code is often used to look-up the full table name in a table.

You may do this with dbtvault by providing the code as a constant in the [staging](staging.md) layer,
using the [add_columns](macros.md#add_columns) macro. The [staging page](staging.md) presents this exact
use-case in the code examples.

If there is already a source in the raw staging layer, you may keep this or override it; 
[add_columns](macros.md#add_columns) can do either.

## Hashing

Best practises for hashing include:

- Alpha sorting hashdiff columns. dbtvault does this for us, so no worries!

- Ensure all **hub** columns used to calculate a primary key hash are presented in the same order across all
staging tables 

!!! note
    Some tables may use different column names, so we cannot sort this for you.

!!! bug
    Currently dbtvault incorrectly alpha-sorts primary key hashes as well. This will be fixed in a release coming very soon.

- For **links**, columns must be sorted by the primary key of the hub and arranged alphabetically by the hub name. 
The order must also be the same as each hub. 