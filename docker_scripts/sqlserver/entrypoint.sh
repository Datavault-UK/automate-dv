# Start SQL Server, start the initialisation script to create the DB, etc.
/opt/mssql/bin/sqlservr & /usr/src/app/initialisation.sh & tail -f /dev/null
