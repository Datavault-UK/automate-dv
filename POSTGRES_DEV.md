# dbtvault-postgres release notes

Author: @johnoscott

## Questions
1. How can I (and should I) read env vars from .env in docker-compose ?
   Difficult because location is `env/db.env`

## TODO
1. set threads in `profiles_external.tpl.yml` (currently commented out)

## Getting Started
1. checkout the branch `feat/postgres` from the dbtvault GitHub repo
2. install python packages (adds the `dbt-postgres = "==1.1.0"` package)
    
    ```bash
    pipenv install --dev
    
    ```
    
3. Set environment variables by creating `/env/db.env` with this configuration:
    
    ```dotenv
    # /env/db.env
    
    # Postgres
    POSTGRES_DB_HOST="localhost"
    POSTGRES_DB_PORT="5434"
    POSTGRES_DB_DATABASE="dbtvault_db"
    POSTGRES_DB_SCHEMA="development"
    POSTGRES_DB_USER="dbtvault_user"
    POSTGRES_DB_PW="password"
    ```
    
4. Initialise postgres dbtvault config by running:
    
    ```bash
    inv init-external --platform postgres
    
    # NOTE: will generate `env/profiles.yml` which does NOT need to be configured
    #      since it now uses environment variables
    ```

5. Start a local postgresql server 
   Easiest way is to use the included docker compose (which has same config as /env/db.env above)

    ```bash
    docker compose up
    
    ```

6. Set the project to use postgres and run config checks
    
    ```bash
    inv setup --platform postgres --disable-op
    
    # -d, --disable-op Disables 1Password CLI integration, which is used by Datavault Developers internally for secrets management.
    
    ```
    
7. Run the tests
    
    <aside>
    💡 only Hub tests in `test/features/hubs/hubs.feature` are currently implemented
    
    </aside>