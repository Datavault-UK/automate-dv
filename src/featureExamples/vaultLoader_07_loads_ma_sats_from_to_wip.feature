Feature: Loads MULTI-ACTIVE SATELLITES using date from and to
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 09-06-18 NS  1-0     First release-
#
# =============================================================================

As the data service manager
I need to load MULTI-ACTIVE SATELLITES into the vault
So I can analyse data about HUBS and LINKS for downstream analysis

# -----------------------------------------------------------------------------

There are some transformation rules that must be obeyed:
- Multi active satellites allow more than one record to be live at the same
  time (regular satellites only allow one value live at a time). This means 
  that we have a set of records each with their own series of start and end 
  dates modelling their PIT structures. Multi active satellites need a uid and
  this requires an additional field from the satellite (or in some cases, 
  fields) to be added to the parent hash and load_datetime to form the key.

- This load inserts new or updates existing multi-active records. Deletions
  are handled elsewhere. If a record is not present in the stage table it 
  does not mean it has been deleted, the only records in staging are those
  the feed considers might be new or updates.

- A hash is calculated for use in the primary key from the natural key columns
  that were used to construct the hash of the parent hub/link. The formula for 
  that function is tested elsewhere. The order of the columns is important and 
  should be preserved.

- As we are moving data within a database, from schema stg to schema vault we
  can do this by executing a sql statement. The metadata mapping is sufficient
  to complete a template of the sql statement.

- The hashdiff is calculated as the hash of the concatenated payload columns.
  The order of these columns is important. The formula for calculating the hash
  is tested elsewhere.

- The sequence of load of Satellite data is important. If we have a backlog of
  data to process we should process the earliest record first, then each
  subsequent record in turn. This is the only way we can accurately capture the
  changes in the data.

- Water levels are used to record the last successful load. So when a load 
  completes we set the waterlevel to the most recent load_datetime in the stg
  table, even if the load did not result in data being updated. If the load
  fails, then do not update the waterlevel and the system will autocorrect the
  next time it runs - just leave any data partly loaded in the vault and it 
  will be swept up in the next load cycle.

- We only ever truncate stg tables at the start of the process. When loading
  finishes we leave the stg data in place. This helps with diagnosis of errors
  if a load fails - we can inspect stg data to see if there is a problem.

- When running an initial load from a stage table then the waterlevel record
  will not exist in the control table. If you query for it you will get a not
  found message. Some of the tests below start with an empty waterlevel 
  implying an initial load. The code should create an entry for the waterlevel 
  if it does not exist, otherwise it should update it.

# -----------------------------------------------------------------------------

#Scenario: empty SATELLITE loads deduplicated staging data
#  Given there is an empty vault.SAT_SHAREHOLDER_DETAILS table
#  And there are records in the stg.STG_SHAREHOLDER table
#    | party_hash  | load_datetime         | source_system | shareholder_name    | shareholder_dob | country | hash_diff                          | clean_shareholder_name |
#    | md5('1000') | '20-01-2018 10:00:01' | 1             | 'Albert'            | 24-02-1970      | 'uk'    | md5(concat('uk',',','24-02-1970')) | 'ALBERT'               |
#    | md5('1000') | '20-01-2018 10:00:01' | 1             | 'Brian'             |                 | 'dk'    | md5(concat('dk',''))               | 'BRIAN'                |
#    | md5('1000') | '20-01-2018 10:00:01' | 1             | 'Carol Ann'         | 23-05-1982      | 'fr'    | md5(concat('fr',',','23-05-1982')) | 'CAROL ANN'            |
#    | md5('1000') | '20-01-2018 10:00:01' | 1             | '  CAROL Ann'       | 23-05-1982      | 'fr'    | md5(concat('fr',',','23-05-1982')) | 'CAROL ANN'            |
#    | md5('1001') | '20-01-2018 10:00:01' | 1             | 'Reginald Doberman' | 07-05-1953      | 'uk'    | md5(concat('uk',',','07-05-1953')) | 'REGINALD DOBERMAN'    |
#  And there is metadata mapping stg.STG_SHAREHOLDER to vault.SAT_SHAREHOLDER_DETAILS
#    | src          | 'stg.STG_SHAREHOLDER'                               |
#    | src_pk       | 'PARTY_HASH, LOAD_DATETIME, CLEAN_SHAREHOLDER_NAME' |
#    | src_payload  | 'COUNTRY, SHAREHOLDER_DOB, SHAREHOLDER_NAME'        |
#    | src_hashdiff | 'COUNTRY, SHAREHOLDER_DOB'                          |
#    | tgt          | 'vault.SAT_SHAREHOLDER_DETAILS'                     |
#    | tgt_pk       | 'PARTY_HASH, LOAD_DATETIME, CLEAN_SHAREHOLDER_NAME' |
#    | tgt_payload  | 'COUNTRY, SHAREHOLDER_DOB, SHAREHOLDER_NAME'        |
#  When the vaultLoader is run
#  Then the unique records in stg.STG_SHAREHOLDER should have been inserted into vault.SAT_SHAREHOLDER_DETAILS
#    | party_hash  | load_datetime         | source_system | shareholder_name    | shareholder_dob | country | hash_diff                   | date_from           | date_to             |
#    | md5('1000') | '20-01-2018 10:00:01' | 1             | 'Albert'            | 24-02-1970      | 'uk'    | md5('24-02-1970,ALBERT')    | 20-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#    | md5('1000') | '20-01-2018 10:00:01' | 1             | 'Brian'             |                 | 'dk'    | md5(',BRIAN')               | 20-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#    | md5('1000') | '20-01-2018 10:00:01' | 1             | 'Carol Ann'         | 23-05-1982      | 'fr'    | md5('23-05-1982,CAROL ANN') | 20-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#    | md5('1001') | '20-01-2018 10:00:01' | 1             | 'Reginald Doberman' | 07-05-1953      | 'uk'    | md5('07-05-1953,')          | 20-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#
#
#Scenario SATELLITE has no new data to add from staging data
#  Given there are records in the vault.SAT_SHAREHOLDER_DETAILS table:
#    | party_hash  | load_datetime         | source_system | shareholder_name    | shareholder_dob | country | hash_diff                   | date_from           | date_to             |
#    | md5('1000') | '20-01-2018 10:00:01' | 1             | 'Albert'            | 24-02-1970      | 'uk'    | md5('24-02-1970,ALBERT')    | 20-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#    | md5('1000') | '20-01-2018 10:00:01' | 1             | 'Brian'             |                 | 'dk'    | md5(',BRIAN')               | 20-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#    | md5('1000') | '20-01-2018 10:00:01' | 1             | 'Carol Ann'         | 23-05-1982      | 'fr'    | md5('23-05-1982,CAROL ANN') | 20-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#    | md5('1001') | '20-01-2018 10:00:01' | 1             | 'Reginald Doberman' | 07-05-1953      | 'uk'    | md5('07-05-1953,')          | 20-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#  And there are records in the stg.STG_SHAREHOLDER table:
#    | party_hash  | load_datetime         | source_system | shareholder_name    | party_dob  | country | hash_diff                   |
#    | md5('1000') | '22-01-2018 10:00:01' | 1             | 'Albert'            | 24-02-1970 | 'uk'    | md5('24-02-1970,ALBERT')    |
#    | md5('1001') | '22-01-2018 10:00:01' | 1             | 'Brian'             |            | 'dk'    | md5(',BRIAN')               |
#    | md5('1002') | '22-01-2018 10:00:01' | 1             | 'Carol Ann'         | 23-05-1982 | 'fr'    | md5('23-05-1982,CAROL ANN') |
#    | md5('1002') | '22-01-2018 10:00:01' | 1             | '  CAROL Ann'       | 23-05-1982 | 'fr'    | md5('23-05-1982,CAROL ANN') |
#    | md5('1003') | '22-01-2018 10:00:01' | 1             |                     | 07-05-1953 | 'uk'    | md5('07-05-1953,')          |
#  And there is metadata mapping stg.STG_SHAREHOLDER to vault.SAT_SHAREHOLDER_DETAILS
#    | src          | 'stg.STG_SHAREHOLDER'                         |
#    | src_pk       | 'PARTY_HASH, LOAD_DATETIME, SHAREHOLDER_NAME' |
#    | src_payload  | 'SHAREHOLDER_DOB'                             |
#    | tgt          | 'vault.SAT_SHAREHOLDER_DETAILS'               |
#    | tgt_pk       | 'PARTY_HASH, LOAD_DATETIME, SHAREHOLDER_NAME' |
#    | tgt_payload  | 'SHAREHOLDER_DOB'                             |
#  When the vaultLoader is run
#  Then the records in vault.SAT_SHAREHOLDER_DETAILS should not change:
#    | party_hash  | load_datetime         | source_system | shareholder_name    | shareholder_dob | hash_diff                   | date_from           | date_to             |
#    | md5('1000') | '20-01-2018 10:00:01' | 1             | 'Albert'            | 24-02-1970      | md5('24-02-1970,ALBERT')    | 20-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#    | md5('1001') | '20-01-2018 10:00:01' | 1             | 'Brian'             |                 | md5(',BRIAN')               | 20-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#    | md5('1002') | '20-01-2018 10:00:01' | 1             | 'Carol Ann'         | 23-05-1982      | md5('23-05-1982,CAROL ANN') | 20-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#    | md5('1003') | '20-01-2018 10:00:01' | 1             |                     | 07-05-1953      | md5('07-05-1953,')          | 20-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#
#
#Scenario SATELLITE is updated with staging data
#  Given there are records in the vault.SAT_SHAREHOLDER_DETAILS table:
#    | party_hash  | load_datetime         | source_system | shareholder_name    | shareholder_dob | hash_diff                   | date_from           | date_to             |
#    | md5('1000') | '20-01-2018 10:00:01' | 1             | 'Albert'            | 24-02-1970      | md5('24-02-1970,ALBERT')    | 20-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#    | md5('1001') | '20-01-2018 10:00:01' | 1             | 'Brian'             |                 | md5(',BRIAN')               | 20-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#    | md5('1002') | '20-01-2018 10:00:01' | 1             | 'Carol Ann'         | 23-05-1982      | md5('23-05-1982,CAROL ANN') | 20-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#    | md5('1003') | '20-01-2018 10:00:01' | 1             |                     | 07-05-1953      | md5('07-05-1953,')          | 20-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#  And there are records in the stg.STG_SHAREHOLDER table:
#    | party_hash  | load_datetime         | source_system | party_name     | party_dob  | hash_diff                         |
#    | md5('1000') | '22-01-2018 10:00:01' | 1             | 'Albert Smith' | 24-02-1970 | md5('24-02-1970,ALBERT SMITH')    |
#    | md5('1001') | '22-01-2018 10:00:01' | 1             | 'Brian'        |            | md5(',BRIAN')                     |
#    | md5('1002') | '22-01-2018 10:00:01' | 1             | '  CAROL Ann'  |            | md5(',CAROL ANN')                 |
#    | md5('1003') | '22-01-2018 10:00:01' | 1             | 'EDWIN'        | 07-05-1953 | md5('07-05-1953,EDWIN')           |
#    | md5('1004') | '22-01-2018 10:00:01' | 1             | 'FREDDY'       | 19-05-1963 | md5('19-05-1963,FREDDY')          |
#    | md5('1005') | '22-01-2018 10:00:01' | 1             | 'GEORGINA'     | 16-11-1973 | md5('16-11-1973,GEORGINA')        |
#  And there is metadata mapping stg.STG_SHAREHOLDER to vault.SAT_SHAREHOLDER_DETAILS
#    | src          | 'stg.STG_SHAREHOLDER'                         |
#    | src_pk       | 'PARTY_HASH, LOAD_DATETIME, SHAREHOLDER_NAME' |
#    | src_payload  | 'SHAREHOLDER_DOB'                             |
#    | tgt          | 'vault.SAT_SHAREHOLDER_DETAILS'               |
#    | tgt_pk       | 'PARTY_HASH, LOAD_DATETIME, SHAREHOLDER_NAME' |
#    | tgt_payload  | 'SHAREHOLDER_DOB'                             |
#  When the vaultLoader is run
#  Then the records in vault.STG_SHAREHOLDER_DETAILS should not change:
#    | party_hash  | load_datetime         | source_system | party_name     | party_dob  | hash_diff                      | date_from           | date_to             |
#    | md5('1000') | '20-01-2018 10:00:01' | 1             | 'Albert'       | 24-02-1970 | md5('24-02-1970,ALBERT')       | 20-01-2018 10:00:01 | 22-01-2018 10:00:00 |
#    | md5('1000') | '22-01-2018 10:00:01' | 1             | 'Albert Smith' | 24-02-1970 | md5('24-02-1970,ALBERT SMITH') | 22-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#    | md5('1001') | '20-01-2018 10:00:01' | 1             | 'Brian'        |            | md5(',BRIAN')                  | 20-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#    | md5('1002') | '20-01-2018 10:00:01' | 1             | 'Carol Ann'    | 23-05-1982 | md5('23-05-1982,CAROL ANN')    | 20-01-2018 10:00:01 | 22-01-2018 10:00:00 |
#    | md5('1002') | '20-01-2018 10:00:01' | 1             | 'Carol Ann'    | 23-05-1982 | md5('23-05-1982,CAROL ANN')    | 22-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#    | md5('1003') | '20-01-2018 10:00:01' | 1             |                | 07-05-1953 | md5('07-05-1953,')             | 20-01-2018 10:00:01 | 22-01-2018 10:00:00 |
#    | md5('1003') | '20-01-2018 10:00:01' | 1             | 'EDWIN'        | 07-05-1953 | md5('07-05-1953,EDWIN')        | 22-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#    | md5('1004') | '22-01-2018 10:00:01' | 1             | 'FREDDY'       | 19-05-1963 | md5('19-05-1963,FREDDY')       | 22-01-2018 10:00:01 | 31-12-9999 23:59:59 |
#    | md5('1005') | '22-01-2018 10:00:01' | 1             | 'GEORGINA'     | 16-11-1973 | md5('16-11-1973,GEORGINA')     | 22-01-2018 10:00:01 | 31-12-9999 23:59:59 |
