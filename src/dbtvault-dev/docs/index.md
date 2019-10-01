# Welcome to dbtvault!
dbtvault is a dbt package that implements a Data Vault 2.0 Data Warehouse on a Snowflake database.

!!! Note
    You need to be running dbt to use the package.
    
    [dbt](https://www.getdbt.com/) is a registered trademark of [Fishtown Analytics](https://www.fishtownanalytics.com/).
    
    Go check them out!

dbt is designed for ease of use in data engineering: for when you need to develop a data pipeline. It is a single executable that can run on your desktop or a VM in your network, it is developed in Python, and is free to download and use.

## What is Data Vault 2.0?
Data Vault 2.0 is an Agile method used to deliver a highly scalable enterprise Data Warehouse. 

The method covers the full approach for developing a Data Warehouse: architecture, data modelling, the development approach, and includes a number of unique techniques. 

If you want to learn about the method, your best starting point is the book Building a Scalable Data Warehouse with Data Vault 2.0 (see details below).

Data Vault 2.0 supports code automation. 
Essentially the method uses a small set of standard building blocks to model your data warehouse (Hubs, Links and Satellites in the Raw Data Vault) and, because they are standardised, you can load these blocks with templated SQL. The result is a template-driven implementation, populated by metadata. You provide the metadata (table names and mapping details) and SQL is generated automatically. This leads to better quality code, fewer mistakes, and greatly improved productivity: i.e. Agility.

## What does dbtvault do?
The dbtvault package generates and runs Data Vault ETL code from your metadata. 

Just like other dbt projects, you write a model for each ETL step. You provide the metadata for each model as declared variables and include code to invoke a macro from the dbtvault package. 
The macro does the rest of the work – it processes the metadata, generates Snowflake SQL and executes the load respecting any and all dependencies. 

dbt even runs the load in parallel. As Data Vault 2.0 is designed for parallel load and Snowflake is highly performant, your ETL load will finish in rapid time. 

dbtvault reduces the need to write Snowflake SQL by hand to load the Data Vault. This is a repetitive, time-consuming and potentially error prone task.


## What features does dbt running the dbtvault package offer?
dbt works with the dbtvault package to:

- Generate SQL to process the staging layer and load the data vault.
- Ensures consistency and correctness in the generated SQL.
- Identify dependencies between SQL statements.
- Create Raw Data Vault tables when a release first identifies them.
- Execute all generated SQL statements as a complete set.
- Execute data load in parallel up to a user-defined number of parallel threads.
- Generate data flow diagrams showing data lineage.

## dbtvault versions and roadmap

Version 1 of the dbtvault package provides a suite of macros that generate Snowflake SQL statements to pre-process staging layer tables and load hubs, links and satellite to a raw Data Vault.

Later versions will extend the range of table types that the package handles. We are already working on Version 2 which will add support for non-historised links (also known as transactional links).

## You Do Need Some Prior Knowledge About the Data Vault 2.0 Method
If you are going to use the dbtvault package for your Data Vault 2.0 project, then we expect you to have some prior knowledge about the Data Vault 2.0 method.


## How Can You Get Up to Speed on Data Vault 2.0?
You can get further information about the Data Vault 2.0 method from the following resources:

### Books (from Amazon)

- [Building a Scalable Data Warehouse with Data Vault 2.0, Dan Linstedt and Michael Olschimke](https://www.amazon.co.uk/Building-Scalable-Data-Warehouse-Vault-ebook/dp/B015KKYFGO/)
- [Better Data Modelling: An Introduction to Agile Data Engineering Using Data Vault 2.0, Kent Graziano](https://www.amazon.co.uk/Better-Data-Modeling-Introduction-Engineering-ebook/dp/B018BREV1C)

### Blogs and Downloads

- [What is Data Vault?](https://www.data-vault.co.uk/what-is-data-vault/)
- [Agile Modeling: Not an Option Anymore](https://www.vertabelo.com/blog/data-vault-series-agile-modeling-not-an-option-anymore/)
