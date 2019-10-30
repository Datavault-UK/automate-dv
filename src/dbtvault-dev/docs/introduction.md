# Introduction
In this section we teach you how to use dbtvault by example. We take you through developing a 
Data Vault 2.0 Data Warehouse based on the Snowflake TPC-H dataset, step-by-step using pre-written models.

We will:

- examine and profile the TPCH dataset to explore how we can map it to the Data Vault architecture.
- setup a dbt project.
- create a raw staging layer.
- process the raw staging layer.
- create a Data Vault with hubs, links and satellites using dbtvault.

## Pre-requisites

These pre-requisites are separate from those found on the [getting started](gettingstarted.md) page and will 
be the only necessary requirements you will need to get started with the example project. 

- A Snowflake trial account. [Sign up for a free 30-day trial here](https://trial.snowflake.com/ab/)

!!! warning
    We suggest a trial account so that you have full privileges and assurance that the demo is isolated from any
    production warehouses. Whilst there shouldn't be any risk that the demo affects any unrelated data outside of the 
    scope of this project, you may use a corporate account or existing personal account at your own risk, 
    
- An [installation of dbt](https://docs.getdbt.com/docs/installation).

!!! note
    We have provided a complete ```requirements.txt``` to install with ```pip install -r requirements.txt```
    as a quick start method. This comes with the download in the next section below,

## Downloading

The first step is to download the latest Snowflake example project from the repository.

Using the button below, find the latest release and download the zip file, listed under assets.

<a href="https://github.com/Datavault-UK/snowflakeDemo/releases" class="btn">
<i class="fa fa-download"></i> View Downloads
</a>

Once downloaded, unzip the project.