## Introduction

!!! info
    The intent behind this demonstration is to give you further understanding of how 
    dbt and dbtvault could be used in a realistic environment. 
    For a more detailed guide on how to create your own Data Vault using dbtvault, 
    with a simplified example, take a look at our [walk-through](walkthrough.md) guide.

In this section we teach you how to use dbtvault by example. We guide you through developing a 
Data Vault 2.0 Data Warehouse based on the Snowflake TPC-H dataset, step-by-step using pre-written dbtvault models.

We will:

- setup a dbt project.
- examine and profile the TPCH dataset to explore how we can map it to the Data Vault architecture.
- create a raw staging layer.
- process the raw staging layer.
- create a Data Vault with hubs, links and satellites using dbtvault and pre-written models.


## Pre-requisites

These pre-requisites are separate from those found on the [getting started](walkthrough.md) page and will 
be the only necessary requirements you will need to get started with the example project. 

1. Some prior knowledge of Data Vault 2.0 architecture. Have a look at
[How can I get up to speed on Data Vault 2.0?](index.md#how-can-i-get-up-to-speed-on-data-vault-20)

2. A Snowflake trial account. [Sign up for a free 30-day trial here](https://trial.snowflake.com/ab/)

3. A Python 3.x installation.

!!! warning
    We suggest a trial account so that you have full privileges and assurance that the demo is isolated from any
    production warehouses. Whilst there shouldn't be any risk that the demo affects any unrelated data outside of the 
    scope of this project, you may use a corporate account or existing personal account at your own risk, 

!!! note
    We have provided a complete ```requirements.txt``` to install with ```pip install -r requirements.txt```
    as a quick way of getting your Python environment set up. This file includes dbt and comes with the download in the next section. 