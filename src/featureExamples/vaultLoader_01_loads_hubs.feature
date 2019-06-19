@test_data
@log_cleanup
Feature: Loads HUBs
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 24.04.18 NS  1.0     First release.
# 08.06.18 NS  1.1     Added waterlevel tests and selection of earliest date
#                      in staging for each potential load.
# 24.08.18 Ah  2.0     Fully re-formatted with correct dates formats and
#                      metadata parameters
# =============================================================================

  As the data service manager
  I need to load HUB data into the vault from the latest data refresh in staging
  So I can integrate source data around key entities for downstream analysis

# -----------------------------------------------------------------------------

  There are some transformation rules that must be obeyed:
  - A hash is calculated for use as the primary key from the natural key columns,
  the formula for that function is tested elsewhere. The order of the columns
  is important and should be preserved.

  - As we are moving data within a database, from schema stg to schema vault we
  can do this by executing a sql statement. The metadata mapping is sufficient
  to complete a template of the sql statement.

  - As the stg data could contain multiple entries for each key it is best to
  select distinct values of the primary key from stg before inserting to the
  vault. This improves performance as we won't be trying to insert lots of
  duplicates and thrashing index look ups to see if the key already exists.

  - We want to record the earliest detected occurrence of the hub. If we have
  a backlog of data (with multiple load dates) to be processed then our sql
  must not only choose distinct values but also the entry with the earliest
  load_datetime.

  - We only ever truncate stg tables at the start of the process. When loading
  finishes we leave the stg data in place. This helps with diagnosis of errors
  if a load fails - we can inspect stg data to see if there is a problem.

  - Waterlevels are used to record the last successful load. So when a load
  completes we set the waterlevel to the most recent load_datetime in the stg
  table, even if the load did not result in data being updated. If the load
  fails, then do not update the waterlevel and the system will autocorrect the
  next time it runs - just leave any data partly loaded in the vault and it
  will be swept up in the next load cycle.

  - When running an initial load from a stage table then the waterlevel record
  will not exist in the control table. If you query for it you will get a not
  found message. Some of the tests below start with an empty hub table implying
  an initial load. The code should create an entry for the waterlevel if it
  does not exist, otherwise it should update it.

# -----------------------------------------------------------------------------
  @log_cleanup
  @clean_data
  Scenario: Empty Hub loads de-duplicated staging data
    Given there is an empty vault.HUB_PARTY table
    And there is no waterlevel record for stg.STG_PARTY
    And there are records in the stg.STG_PARTY table
      | party_hash  | load_datetime       | source_system | party_reference |
      | md5('1000') | 2018-01-20 10:00:01 | 1             | 1000            |
      | md5('1001') | 2018-01-20 10:00:01 | 1             | 1001            |
      | md5('1002') | 2018-01-20 10:00:01 | 1             | 1002            |
      | md5('1003') | 2018-01-20 10:00:01 | 1             | 1003            |
      | md5('1004') | 2018-01-20 10:00:01 | 1             | 1004            |
    And there is metadata mapping stg.STG_PARTY to vault.HUB_PARTY
      | isActive  | true            |
      | src_table | stg.STG_PARTY   |
      | src_pk    | party_hash      |
      | src_nk    | party_reference |
      | tgt_table | vault.HUB_PARTY |
      | tgt_pk    | party_hash      |
      | tgt_nk    | party_reference |
    When I run the vaultLoader with command line arguments
    Then the records in stg.STG_PARTY should have been inserted into vault.HUB_PARTY
      | party_hash  | load_datetime       | source_system | party_reference |
      | md5('1000') | 2018-01-20 10:00:01 | 1             | 1000            |
      | md5('1001') | 2018-01-20 10:00:01 | 1             | 1001            |
      | md5('1002') | 2018-01-20 10:00:01 | 1             | 1002            |
      | md5('1003') | 2018-01-20 10:00:01 | 1             | 1003            |
      | md5('1004') | 2018-01-20 10:00:01 | 1             | 1004            |


  @log_cleanup
  @clean_data
  Scenario: Hub already covers staged records
    Given there are records in the vault.HUB_PARTY table
      | party_hash  | load_datetime       | source_system | party_reference |
      | md5('1000') | 2018-01-20 10:00:01 | 1             | 1000            |
      | md5('1001') | 2018-01-20 10:00:01 | 1             | 1001            |
      | md5('1002') | 2018-01-20 10:00:01 | 1             | 1002            |
      | md5('1003') | 2018-01-20 10:00:01 | 1             | 1003            |
      | md5('1004') | 2018-01-20 10:00:01 | 1             | 1004            |
    And there are records in the stg.STG_PARTY table
      | party_hash  | load_datetime       | source_system | party_reference |
      | md5('1000') | 2018-01-20 10:00:01 | 1             | 1000            |
      | md5('1001') | 2018-01-20 10:00:01 | 1             | 1001            |
      | md5('1002') | 2018-01-20 10:00:01 | 1             | 1002            |
      | md5('1003') | 2018-01-20 10:00:01 | 1             | 1003            |
      | md5('1004') | 2018-01-20 10:00:01 | 1             | 1004            |
    And there is metadata mapping stg.STG_PARTY to vault.HUB_PARTY
      | isActive  | true            |
      | src_table | stg.STG_PARTY   |
      | src_pk    | party_hash      |
      | src_nk    | party_reference |
      | tgt_table | vault.HUB_PARTY |
      | tgt_pk    | party_hash      |
      | tgt_nk    | party_reference |
    When I run the vaultLoader with command line arguments
    Then there should be no change to the records in vault.HUB_PARTY
      | party_hash  | load_datetime       | source_system | party_reference |
      | md5('1000') | 2018-01-20 10:00:01 | 1             | 1000            |
      | md5('1001') | 2018-01-20 10:00:01 | 1             | 1001            |
      | md5('1002') | 2018-01-20 10:00:01 | 1             | 1002            |
      | md5('1003') | 2018-01-20 10:00:01 | 1             | 1003            |
      | md5('1004') | 2018-01-20 10:00:01 | 1             | 1004            |

  @log_cleanup
  @clean_data
  Scenario: New records in staging for Hub
    Given there are records in the vault.HUB_PARTY table
      | party_hash  | load_datetime       | source_system | party_reference |
      | md5('1000') | 2018-01-20 10:00:01 | 1             | 1000            |
      | md5('1001') | 2018-01-20 10:00:01 | 1             | 1001            |
      | md5('1002') | 2018-01-20 10:00:01 | 1             | 1002            |
      | md5('1003') | 2018-01-20 10:00:01 | 1             | 1003            |
      | md5('1004') | 2018-01-20 10:00:01 | 1             | 1004            |
    And there are overlapping and new records in the stg.STG_PARTY table
      | party_hash  | load_datetime       | source_system | party_reference |
      | md5('1000') | 2018-01-20 10:00:01 | 1             | 1000            |
      | md5('1001') | 2018-01-20 10:00:01 | 1             | 1001            |
      | md5('1002') | 2018-01-20 10:00:01 | 1             | 1002            |
      | md5('1003') | 2018-01-20 10:00:01 | 1             | 1003            |
      | md5('1003') | 2018-01-20 10:00:01 | 1             | 1003            |
      | md5('1004') | 2018-01-20 10:00:01 | 1             | 1004            |
      | md5('1005') | 2018-01-20 10:00:01 | 1             | 1005            |
      | md5('1006') | 2018-01-20 10:00:01 | 1             | 1006            |
      | md5('1007') | 2018-01-20 10:00:01 | 1             | 1007            |
    And there is metadata mapping stg.STG_PARTY to vault.HUB_PARTY
      | isActive  | true            |
      | src_table | stg.STG_PARTY   |
      | src_pk    | party_hash      |
      | src_nk    | party_reference |
      | tgt_table | vault.HUB_PARTY |
      | tgt_pk    | party_hash      |
      | tgt_nk    | party_reference |
    When I run the vaultLoader with command line arguments
    Then the vault.HUB_PARTY table should include the new records
      | party_hash  | load_datetime       | source_system | party_reference |
      | md5('1000') | 2018-01-20 10:00:01 | 1             | 1000            |
      | md5('1001') | 2018-01-20 10:00:01 | 1             | 1001            |
      | md5('1002') | 2018-01-20 10:00:01 | 1             | 1002            |
      | md5('1003') | 2018-01-20 10:00:01 | 1             | 1003            |
      | md5('1004') | 2018-01-20 10:00:01 | 1             | 1004            |
      | md5('1005') | 2018-01-20 10:00:01 | 1             | 1005            |
      | md5('1006') | 2018-01-20 10:00:01 | 1             | 1006            |
      | md5('1007') | 2018-01-20 10:00:01 | 1             | 1007            |

  @log_cleanup
  @clean_data
  Scenario: Hub loads the earliest instance of a record
    Given there is an empty vault.HUB_PARTY table
    And there is no waterlevel record for stg.STG_PARTY
    And there are records in the stg.STG_PARTY table
      | party_hash  | load_datetime       | source_system | party_reference |
      | md5('1000') | 2018-01-21 10:00:01 | 1             | 1000            |
      | md5('1000') | 2018-01-22 10:00:01 | 1             | 1000            |
      | md5('1000') | 2018-01-23 10:00:01 | 1             | 1000            |
      | md5('1001') | 2018-01-20 10:00:01 | 1             | 1001            |
      | md5('1001') | 2018-01-22 10:00:01 | 1             | 1001            |
      | md5('1002') | 2018-01-22 10:00:01 | 1             | 1002            |
      | md5('1003') | 2018-01-21 10:00:01 | 1             | 1003            |
      | md5('1003') | 2018-01-19 10:00:01 | 1             | 1003            |
      | md5('1003') | 2018-01-23 10:00:01 | 1             | 1003            |
    And there is metadata mapping stg.STG_PARTY to vault.HUB_PARTY
      | isActive  | true            |
      | src_table | stg.STG_PARTY   |
      | src_pk    | party_hash      |
      | src_nk    | party_reference |
      | tgt_table | vault.HUB_PARTY |
      | tgt_pk    | party_hash      |
      | tgt_nk    | party_reference |
    When I run the vaultLoader with command line arguments
    Then the vault.HUB_PARTY table should include the earliest unique records
      | party_hash  | load_datetime       | source_system | party_reference |
      | md5('1000') | 2018-01-21 10:00:01 | 1             | 1000            |
      | md5('1001') | 2018-01-20 10:00:01 | 1             | 1001            |
      | md5('1002') | 2018-01-22 10:00:01 | 1             | 1002            |
      | md5('1003') | 2018-01-19 10:00:01 | 1             | 1003            |

  @log_cleanup
  @clean_data
  Scenario: Multi-column natural key
    Given there is an empty vault.HUB_PARTY table with an added country code column
    And there is no waterlevel record for stg.STG_PARTY
    And there are records in the stg.STG_PARTY table with an added country code column
      | party_hash     | load_datetime       | source_system | party_reference | country_code |
      | md5('1000,UK') | 2018-01-20 10:00:01 | 1             | 1000            | UK           |
      | md5('1001,DE') | 2018-01-20 10:00:01 | 1             | 1001            | DE           |
      | md5('1002,SE') | 2018-01-20 10:00:01 | 1             | 1002            | SE           |
      | md5('1003,UK') | 2018-01-20 10:00:01 | 1             | 1003            | UK           |
      | md5('1003,UK') | 2018-01-20 10:00:01 | 1             | 1003            | UK           |
      | md5('1004,UK') | 2018-01-20 10:00:01 | 1             | 1004            | UK           |
    And there is metadata mapping stg.STG_PARTY to vault.HUB_PARTY
      | isActive  | true                          |
      | src_table | stg.STG_PARTY                 |
      | src_pk    | party_hash                    |
      | src_nk    | party_reference, country_code |
      | tgt_table | vault.HUB_PARTY               |
      | tgt_pk    | party_hash                    |
      | tgt_nk    | party_reference, country_code |
    When I run the vaultLoader with command line arguments
    Then the vault.HUB_PARTY table should include all the natural key columns
      | party_hash     | load_datetime       | source_system | party_reference | country_code |
      | md5('1000,UK') | 2018-01-20 10:00:01 | 1             | 1000            | UK           |
      | md5('1001,DE') | 2018-01-20 10:00:01 | 1             | 1001            | DE           |
      | md5('1002,SE') | 2018-01-20 10:00:01 | 1             | 1002            | SE           |
      | md5('1003,UK') | 2018-01-20 10:00:01 | 1             | 1003            | UK           |
      | md5('1004,UK') | 2018-01-20 10:00:01 | 1             | 1004            | UK           |