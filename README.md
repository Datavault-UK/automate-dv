# dbtvault Development Repository

This repository contains a development environment for dbtvault which facilitates secure development of dbtvault using a
snowflake (and soon BigQuery) data warehouse.

SecretHub is a secrets manager which can be installed locally as a CLI tool, which provides features such as secret 
injection into local environments and into files temporarily. This provides the means to provide database credentials 
securely, and can be customised by individual developers with their own credentials, meaning both external contributors 
and internal developers have a secure way to develop dbtvault.

### Setting up SecretHub

#### Installation
Follow the [SecretHub getting started guide](https://secrethub.io/docs/start/getting-started/)

#### Creating secrets
[Write](https://se9crethub.io/docs/reference/cli/write/) your secrets to SecretHub using the CLI. 
The secrets are injected into the `profiles/profiles.yml` file at runtime. 


The following secrets are required for Snowflake:

```
user
password
account
wh
db
schema
role
```

The following secrets are required for BigQuery:

```
gcp_project_id
gcp_dataset
gcp_keyfile_path
```

These can be stored in any directory structure in SecretHub which makes sense for you or your organisation. 
At Datavault, we use the following:

`{{ Datavault/dbtvault-db-creds/snowflake/$user/role }}`


#### Modifying the .env file

The `secrethub_tmpl.env` file provides a template environment file which you may copy, paste and modify. The purposes 
of the `.env` file are described [here](https://secrethub.io/docs/reference/cli/run/#environment-files). 

In `dbtvault` this `.env` file will be used to populate environment variables at runtime, which will be picked up and
used by the dbt profiles, for example: `account: "{{ env_var('SNOWFLAKE_DB_ACCOUNT') }}"`

By taking this approach instead of using SecretHub's config file injection, developers only need to provide their own
`secrethub.env` file with paths to their own secrets, instead of needing to modify the dbt profiles directly. 


#### Running dbt


##### Method 1

Navigate to the project folder for the dbt project you would like to run (the location of the `dbt_project.yml`) 
and run the following command:

```secrethub run -- dbt run```

This will run `dbt run` with secrets from SecretHub. You may type any command you wish to run with secrets, after `--`.

##### Method 2

Using helper commands, it becomes simpler to run dbt with credentials, using different environments. 

From the root directory of the repository, you may run `pipenv run inv run-dbt "run"`.

This command takes optional arguments `-t`, `-u`, `-p` and `-d`

###### -t, --target

Specify the dbt profile to use for this run, either `snowflake` or `bigquery`.

###### -u, --user

Specify the user to run as. This is mapped 1-1 with a user directory in SecretHub and will be substituted into 
the `$user` variable in the SecretHub paths, if used. 

e.g. Given a config file with the following: ```{{ Datavault/dbtvault-db-creds/snowflake/$user/schema }}``` 
This will evaluate to: `{{ Datavault/dbtvault-db-creds/snowflake/dev/schema }}`
if the following command is used:

`pipenv run inv run-dbt -u dev -d "run"`.

###### -p, --project 

This specifies a project to run the command in, the following are available:

- core: 'project_root/src/dbtvault'
- dev: 'project_root/src/dbtvault-dev'
- test: 'project_root/tests/dbtvault_test'
- sf_demo: 'project_root/src/snowflakeDemo'
- sf_demo_dev: 'project_root/src/snowflakeDemo-dev/src'

###### -d, --dbt_args

Commands to run dbt with, must be provided in quotes and not include `dbt`.

e.g. If the command you want to run is:

`dbt run -m tag:hub`

then the equivalent is:

`-d "run -m tag:hub"`

###### Specifying defaults

If you prefer not to specify the project and user with each and every run, then you may set defaults using the 
`set_defaults` command as follows:

`pipenv run inv set-defaults -t snowflake -u dev -p test` 

This will set the following accordingly:

```
target = snowflake
user = dev
project = test
```

This will create an `invoke.yml` file in the root of the repository, which will store these defaults. This is ignored
by git by default. 

#### Running tests

There are two types of test:

Macro tests (unit) and BDD Tests (integration tests).

Given your SecretHub environment is correctly set up you may run the following commands:

- `pipenv run inv macro_tests`

- `pipenv run inv bdd_tests`

Both of these commands can be provided a `-t` and `-u` flag to specify a target and user respectively, as documented in
Method 2 for running dbt, above. 

Macro tests are run in parallel (4 at a time) and should be fairly fast, though it depends on your system specification.

The BDD tests are significantly slower, and we'll soon be adding functionality to accept additional parameters to run specific tests instead of the whole suite.
