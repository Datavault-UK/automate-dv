# Introduction
We have developed a walkthrough guide for creating a Data Vault 2.0 system based on the Snowflake TPC-H dataset.

We will:

- examine the TPCH dataset and its specification and explore how we can map it to the Data Vault architecture.
- setup a dbt project and snowflake database connection with a trial account
- create a raw staging layer
- process the raw staging layer
- create a Data Vault with hubs, links and satellites using dbtvault