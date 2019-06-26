#!/usr/bin/env bash
dbt run --full-refresh # The history run (1st run of incremental models)

echo "History loaded."
echo "Adding relevant keys to Hubs, Links, and Satellites..."

python3 addKeys.py

echo "Done."
echo "Running day 1 load..."

dbt run --vars "{'date':TO_DATE('1993-01-02')}" # Day 1 run

echo "Day 1 data loaded."
echo "Finished Demo."
