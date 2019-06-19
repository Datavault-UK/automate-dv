@test_data
@log_cleanup
Feature: Loads SATELLITES using date from and to
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 24-04-18 NS  1-0     First release
# 05-09-18 NS  2-0     Second release,
#                      Added new data and effective_to/from column data
# =============================================================================

  As the data service manager
  I need to load SATELLITES into the vault
  So I can analyse data about HUBS and LINKS for downstream analysis

# -----------------------------------------------------------------------------

  There are some transformation rules that must be obeyed:
  - A hash is calculated for use as the primary key from the natural key columns
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

  - Waterlevels are used to record the last successful load. So when a load
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
  @log_cleanup
  @clean_data
  Scenario: Empty SATELLITE loads de-duplicated and stripped staging data
    Given there is an empty vault.SAT_PARTY_DETAILS table
    And there are records in the stg.STG_PARTY_DETAILS table
      | party_hash  | load_datetime       | source_system | party_name    | party_dob  | hash_diff                   | effective_from      | effective_to        |
      | md5('1000') | 2018-01-20 10:00:01 | 1             | Albert        | 1970-02-24 | md5('1970-02-24,ALBERT')    | 2018-01-20 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1001') | 2018-01-20 10:00:01 | 1             | Brian         | <null>     | md5(',BRIAN')               | 2018-01-20 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1002') | 2018-01-20 10:00:01 | 1             | Carol Ann     | 1982-05-23 | md5('1982-05-23,CAROL ANN') | 2018-01-20 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1002') | 2018-01-20 10:00:01 | 1             | '  CAROL Ann' | 1982-05-23 | md5('1982-05-23,CAROL ANN') | 2018-01-20 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1003') | 2018-01-20 10:00:01 | 1             | <null>        | 1953-05-07 | md5('1953-05-07,')          | 2018-01-20 09:00:00 | 9999-12-31 23:59:59 |
    And there is metadata mapping stg.STG_PARTY_DETAILS to vault.SAT_PARTY_DETAILS
      | isActive    | true                    |
      | src_table   | stg.STG_PARTY_DETAILS   |
      | src_pk      | PARTY_HASH              |
      | src_payload | PARTY_DOB, PARTY_NAME   |
      | tgt_table   | vault.SAT_PARTY_DETAILS |
      | tgt_pk      | PARTY_HASH              |
      | tgt_payload | PARTY_DOB, PARTY_NAME   |
    When I run the vaultLoader with command line arguments
    Then the records in stg.STG_PARTY_DETAILS should have been inserted into vault.SAT_PARTY_DETAILS
      | party_hash  | load_datetime       | source_system | party_name | party_dob  | hash_diff                   | effective_from      | effective_to        |
      | md5('1000') | 2018-01-20 10:00:01 | 1             | Albert     | 1970-02-24 | md5('1970-02-24,ALBERT')    | 2018-01-20 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1001') | 2018-01-20 10:00:01 | 1             | Brian      | <null>     | md5(',BRIAN')               | 2018-01-20 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1002') | 2018-01-20 10:00:01 | 1             | Carol Ann  | 1982-05-23 | md5('1982-05-23,CAROL ANN') | 2018-01-20 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1003') | 2018-01-20 10:00:01 | 1             | <null>     | 1953-05-07 | md5('1953-05-07,')          | 2018-01-20 09:00:00 | 9999-12-31 23:59:59 |

  @log_cleanup
  @clean_data
  Scenario: SATELLITE has no new data to add from staging data
    Given there are records in the vault.SAT_PARTY_DETAILS table
      | party_hash  | load_datetime       | source_system | party_name | party_dob  | hash_diff                   | effective_from      | effective_to        |
      | md5('1000') | 2018-01-20 10:00:01 | 1             | Albert     | 1970-02-24 | md5('1970-02-24,ALBERT')    | 2018-01-20 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1001') | 2018-01-20 10:00:01 | 1             | Brian      | <null>     | md5(',BRIAN')               | 2018-01-20 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1002') | 2018-01-20 10:00:01 | 1             | Carol Ann  | 1982-05-23 | md5('1982-05-23,CAROL ANN') | 2018-01-20 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1003') | 2018-01-20 10:00:01 | 1             | <null>     | 1953-05-07 | md5('1953-05-07,')          | 2018-01-20 09:00:00 | 9999-12-31 23:59:59 |
    And there are records in the stg.STG_PARTY_DETAILS table
      | party_hash  | load_datetime       | source_system | party_name | party_dob  | hash_diff                   | effective_from      | effective_to        |
      | md5('1000') | 2018-01-22 10:00:01 | 1             | Albert     | 1970-02-24 | md5('1970-02-24,ALBERT')    | 2018-01-22 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1001') | 2018-01-22 10:00:01 | 1             | Brian      | <null>     | md5(',BRIAN')               | 2018-01-22 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1002') | 2018-01-22 10:00:01 | 1             | Carol Ann  | 1982-05-23 | md5('1982-05-23,CAROL ANN') | 2018-01-22 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1003') | 2018-01-22 10:00:01 | 1             | <null>     | 1953-05-07 | md5('1953-05-07,')          | 2018-01-22 09:00:00 | 9999-12-31 23:59:59 |
    And there is metadata mapping stg.STG_PARTY_DETAILS to vault.SAT_PARTY_DETAILS
      | isActive    | true                    |
      | src_table   | stg.STG_PARTY_DETAILS   |
      | src_pk      | PARTY_HASH              |
      | src_payload | PARTY_DOB, PARTY_NAME   |
      | tgt_table   | vault.SAT_PARTY_DETAILS |
      | tgt_pk      | PARTY_HASH              |
      | tgt_payload | PARTY_DOB, PARTY_NAME   |
    When I run the vaultLoader with command line arguments
    Then the records in vault.SAT_PARTY_DETAILS should not have changed
      | party_hash  | load_datetime       | source_system | party_name | party_dob  | hash_diff                   | effective_from      | effective_to        |
      | md5('1000') | 2018-01-20 10:00:01 | 1             | Albert     | 1970-02-24 | md5('1970-02-24,ALBERT')    | 2018-01-20 10:00:01 | 9999-12-31 23:59:59 |
      | md5('1001') | 2018-01-20 10:00:01 | 1             | Brian      | <null>     | md5(',BRIAN')               | 2018-01-20 10:00:01 | 9999-12-31 23:59:59 |
      | md5('1002') | 2018-01-20 10:00:01 | 1             | Carol Ann  | 1982-05-23 | md5('1982-05-23,CAROL ANN') | 2018-01-20 10:00:01 | 9999-12-31 23:59:59 |
      | md5('1003') | 2018-01-20 10:00:01 | 1             | <null>     | 1953-05-07 | md5('1953-05-07,')          | 2018-01-20 10:00:01 | 9999-12-31 23:59:59 |

  @log_cleanup
  @clean_data
  Scenario: SATELLITE is updated with staging data
    Given there are records in the vault.SAT_PARTY_DETAILS table
      | party_hash  | load_datetime       | source_system | party_name | party_dob  | hash_diff                   | effective_from      | effective_to        |
      | md5('1000') | 2018-01-20 10:00:01 | 1             | Albert     | 1970-02-24 | md5('1970-02-24,ALBERT')    | 2018-01-20 10:00:01 | 9999-12-31 23:59:59 |
      | md5('1001') | 2018-01-20 10:00:01 | 1             | Brian      | <null>     | md5(',BRIAN')               | 2018-01-20 10:00:01 | 9999-12-31 23:59:59 |
      | md5('1002') | 2018-01-20 10:00:01 | 1             | Carol Ann  | 1982-05-23 | md5('1982-05-23,CAROL ANN') | 2018-01-20 10:00:01 | 9999-12-31 23:59:59 |
      | md5('1003') | 2018-01-20 10:00:01 | 1             | <null>     | 1953-05-07 | md5('1953-05-07,')          | 2018-01-20 10:00:01 | 9999-12-31 23:59:59 |
    And there are records in the stg.STG_PARTY_DETAILS table
      | party_hash  | load_datetime       | source_system | party_name   | party_dob  | hash_diff                      | effective_from      | effective_to        |
      | md5('1000') | 2018-01-22 10:00:01 | 1             | Albert Smith | 1970-02-24 | md5('1970-02-24,ALBERT SMITH') | 2018-01-22 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1001') | 2018-01-22 10:00:01 | 1             | Brian        | <null>     | md5(',BRIAN')                  | 2018-01-22 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1002') | 2018-01-22 10:00:01 | 1             | CAROL Ann    | <null>     | md5(',CAROL ANN')              | 2018-01-22 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1003') | 2018-01-22 10:00:01 | 1             | EDWIN        | 1953-05-07 | md5('1953-05-07,EDWIN')        | 2018-01-22 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1004') | 2018-01-22 10:00:01 | 1             | FREDDY       | 1963-05-19 | md5('1963-05-19,FREDDY')       | 2018-01-22 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1005') | 2018-01-22 10:00:01 | 1             | GEORGINA     | 1973-11-16 | md5('1973-11-16,GEORGINA')     | 2018-01-22 09:00:00 | 9999-12-31 23:59:59 |
    And there is metadata mapping stg.STG_PARTY_DETAILS to vault.SAT_PARTY_DETAILS
      | isActive    | true                    |
      | src_table   | stg.STG_PARTY_DETAILS   |
      | src_pk      | PARTY_HASH              |
      | src_payload | PARTY_DOB, PARTY_NAME   |
      | tgt_table   | vault.SAT_PARTY_DETAILS |
      | tgt_pk      | PARTY_HASH              |
      | tgt_payload | PARTY_DOB, PARTY_NAME   |
    When I run the vaultLoader with command line arguments
    Then the records in vault.SAT_PARTY_DETAILS should load new and changed data and end date older data
      | party_hash  | load_datetime       | source_system | party_name   | party_dob  | hash_diff                      | effective_from      | effective_to        |
      | md5('1000') | 2018-01-20 10:00:01 | 1             | Albert       | 1970-02-24 | md5('1970-02-24,ALBERT')       | 2018-01-20 10:00:01 | 2018-01-22 09:00:00 |
      | md5('1000') | 2018-01-22 10:00:01 | 1             | Albert Smith | 1970-02-24 | md5('1970-02-24,ALBERT SMITH') | 2018-01-22 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1001') | 2018-01-20 10:00:01 | 1             | Brian        | <null>     | md5(',BRIAN')                  | 2018-01-20 10:00:01 | 9999-12-31 23:59:59 |
      | md5('1002') | 2018-01-20 10:00:01 | 1             | Carol Ann    | 1982-05-23 | md5('1982-05-23,CAROL ANN')    | 2018-01-20 10:00:01 | 2018-01-22 09:00:00 |
      | md5('1002') | 2018-01-22 10:00:01 | 1             | CAROL Ann    | <null>     | md5(',CAROL ANN')              | 2018-01-22 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1003') | 2018-01-20 10:00:01 | 1             | <null>       | 1953-05-07 | md5('1953-05-07,')             | 2018-01-20 10:00:01 | 2018-01-22 09:00:00 |
      | md5('1003') | 2018-01-22 10:00:01 | 1             | EDWIN        | 1953-05-07 | md5('1953-05-07,EDWIN')        | 2018-01-22 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1004') | 2018-01-22 10:00:01 | 1             | FREDDY       | 1963-05-19 | md5('1963-05-19,FREDDY')       | 2018-01-22 09:00:00 | 9999-12-31 23:59:59 |
      | md5('1005') | 2018-01-22 10:00:01 | 1             | GEORGINA     | 1973-11-16 | md5('1973-11-16,GEORGINA')     | 2018-01-22 09:00:00 | 9999-12-31 23:59:59 |

  @log_cleanup
  @clean_data
  Scenario: SATELLITE has deleted record that is resurrected
    Given there are records in the vault.SAT_PARTY_DETAILS table
      | party_hash  | load_datetime       | source_system | party_name | party_dob  | hash_diff                | effective_from      | effective_to        |
      | md5('1000') | 2018-01-10 10:00:01 | 1             | Albert     | 1970-02-24 | md5('1970-02-24,ALBERT') | 2018-01-10 09:00:00 | 2018-01-15 09:00:00 |
      | md5('1000') | 2018-01-15 10:00:01 | 1             | Albert     | 1970-02-23 | md5('1970-02-23,ALBERT') | 2018-01-15 09:00:00 | 2018-01-18 09:00:00 |
      | md5('1000') | 2018-01-18 10:00:01 | 1             | Albert     | 1970-02-24 | md5('1970-02-24,ALBERT') | 2018-01-18 09:00:00 | 2018-01-19 09:00:00 |
    And there are records in the stg.STG_PARTY_DETAILS table
      | party_hash  | load_datetime       | source_system | party_name   | party_dob  | hash_diff                      | effective_from      | effective_to        |
      | md5('1000') | 2018-01-22 10:00:01 | 1             | Albert Smith | 1970-02-27 | md5('1970-02-27,ALBERT SMITH') | 2018-01-22 09:00:00 | 9999-12-31 23:59:59 |
    And there is metadata mapping stg.STG_PARTY_DETAILS to vault.SAT_PARTY_DETAILS
      | isActive    | true                    |
      | src_table   | stg.STG_PARTY_DETAILS   |
      | src_pk      | PARTY_HASH              |
      | src_payload | PARTY_DOB, PARTY_NAME   |
      | tgt_table   | vault.SAT_PARTY_DETAILS |
      | tgt_pk      | PARTY_HASH              |
      | tgt_payload | PARTY_DOB, PARTY_NAME   |
    When I run the vaultLoader with command line arguments
    Then the records in vault.SAT_PARTY_DETAILS should load new and changed data and end date older data
      | party_hash  | load_datetime       | source_system | party_name   | party_dob  | hash_diff                      | effective_from      | effective_to        |
      | md5('1000') | 2018-01-10 10:00:01 | 1             | Albert       | 1970-02-24 | md5('1970-02-24,ALBERT')       | 2018-01-10 09:00:00 | 2018-01-15 09:00:00 |
      | md5('1000') | 2018-01-15 10:00:01 | 1             | Albert       | 1970-02-23 | md5('1970-02-23,ALBERT')       | 2018-01-15 09:00:00 | 2018-01-18 09:00:00 |
      | md5('1000') | 2018-01-18 10:00:01 | 1             | Albert       | 1970-02-24 | md5('1970-02-24,ALBERT')       | 2018-01-18 09:00:00 | 2018-01-19 09:00:00 |
      | md5('1000') | 2018-01-22 10:00:01 | 1             | Albert Smith | 1970-02-27 | md5('1970-02-27,ALBERT SMITH') | 2018-01-22 09:00:00 | 9999-12-31 23:59:59 |
