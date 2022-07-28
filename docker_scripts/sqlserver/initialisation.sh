# Run the setup script to create the DB, etc.
# Loop until the SQL instance is ready, up to 100 times
for i in {1..100};
do
    /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P SlA7Qs3w!O -d master -i setup.sql
    if [ $? -eq 0 ]
    then
        echo "Setup completed"
        break
    else
        echo "Not ready yet..."
        sleep 1
    fi
done
