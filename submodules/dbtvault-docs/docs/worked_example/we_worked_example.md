In this section we demonstrate dbtvault by example. We guide you through developing a 
Data Vault 2.0 Data Warehouse based on the Snowflake TPC-H dataset, step-by-step using pre-written dbtvault models.

This demonstration was developed to give users a further understanding of how dbt and dbtvault could be used to build
a Data Vault using an actual data set.  

For a more detailed guide on how to use the provided macros create your own Data Vault using dbtvault, 
with a simplified example, take a look at our [walk-through](../tutorial/tut_getting_started.md) guide.

We will:

- setup a dbt project.
- examine and profile the TPCH dataset to explore how we can map it to the Data Vault architecture.
- create a raw staging layer.
- process the raw staging layer.
- create a Data Vault with hubs, links, satellites and transactional links using dbtvault and pre-written models.

## Pre-requisites

These pre-requisites are separate from those found on the [getting started](../tutorial/tut_getting_started.md) page and will 
be the only necessary requirements you will need to get started with the example project. 

1. Some prior knowledge of Data Vault 2.0 architecture. Have a look at
[How can I get up to speed on Data Vault 2.0?](../index.md#how-can-i-get-up-to-speed-on-data-vault-20)

2. A Snowflake trial account. [Sign up for a free 30-day trial here](https://trial.snowflake.com/ab/)

3. A Python 3.x installation.

!!! warning
    We suggest a trial account so that you have full privileges and assurance that the demo is isolated from any
    production warehouses. Whilst there is no risk that the demo affects any unrelated data outside of the 
    scope of this project, you will incur compute costs. 
    You may use a corporate account or existing personal account at your own risk.

!!! note
    We have provided a complete ```requirements.txt``` to install with ```pip install -r requirements.txt```
    as a quick way of getting your Python environment set up. This file includes dbt and comes with the download in the 
    next section.

## Performance note

Please be aware that table structures are simulated from the TPC-H dataset. The TPC-H dataset is a static view of data. 

Only a subset of the data contains dates which allow us to simulate daily feeds. The ```v_stg_orders``` orders view is 
filtered by date, unfortunately the ```v_stg_inventory``` view cannot be filtered by date, so it ends up being a feed of 
the entire contents of the view each cycle. 

This means that inventory related hubs, links and satellites are populated once during the initial load cycle with 
everything and later cycles insert 0 new records in their left outer joins. 

As the dataset increases in size, e.g if you run with a larger TPC-H dataset (100, 1000 etc.) then be aware you are 
processing the entire inventory dataset each cycle, which results in unrepresentative load cycle times.

We have minimised the impact of this by adding a join in the raw inventory table on the raw orders table to ensure only 
inventory items which are included in orders are loaded into the raw staging layer. The outcome is the same, but it 
significantly optimises the loading process and thereby reduces load time.