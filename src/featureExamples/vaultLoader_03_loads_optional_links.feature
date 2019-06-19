@test_data
@log_cleanup
Feature: Loads LINKs that can be optional
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 09.06.18 NS  1.0     First release.
#
# =============================================================================

  As the data service manager
  I need to load LINKs into the vault that are optional
  So I can analyse transactional data for downstream analysis

# -----------------------------------------------------------------------------

  There are some transformation rules that must be obeyed:
  - A hash is calculated for use as the primary key from the foreign key columns,
  the formula for that function is tested elsewhere. The order of the columns
  is important and should be preserved. Note we use the natural key columns
  from the referenced tables not the pk hash.

  - Link records are not created if any of the fks are missing or null. The
  link's existence is optional.

  - As we are moving data within a database, from schema stg to schema vault we
  can do this by executing a sql statement. The metadata mapping is sufficient
  to complete a template of the sql statement.

  - As the stg data could contain multiple entries for each key it is best to
  select distinct values of the primary key from stg before inserting to the
  vault. This improves performance as we won't be trying to insert lots of
  duplicates and thrashing index look ups to see if the key already exists.

  - We want to record the earliest detected occurrence of the link. If we have
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
  Scenario: Empty Link loads de-duplicated staging data
    Given there is an empty vault.LINK_PARTY_BOOKING table
    And there are records in the stg.STG_PARTY_BOOKING table
      | party_booking_hash | party_hash  | booking_hash | load_datetime       | source_system |
      | md5(',B101')       | <null>      | md5('B101')  | 2018-01-20 10:00:01 | 1             |
      | md5('1001,B102')   | md5('1001') | md5('B102')  | 2018-01-20 10:00:01 | 1             |
      | md5('1002,B103')   | md5('1002') | md5('B103')  | 2018-01-20 10:00:01 | 1             |
      | md5('1002,')       | md5('1002') | <null>       | 2018-01-20 10:00:01 | 1             |
      | md5('1003,B105')   | md5('1003') | md5('B105')  | 2018-01-20 10:00:01 | 1             |
      | md5('1003,B105')   | md5('1003') | md5('B105')  | 2018-01-20 10:00:01 | 1             |
    And there is a view for the stg.STG_PARTY_BOOKING table
    And there is no waterlevel record for stg.STG_PARTY_BOOKING
    And there is metadata mapping stg.STG_PARTY_BOOKING_view to vault.LINK_PARTY_BOOKING
      | isActive  | true                       |
      | src_table | stg.STG_PARTY_BOOKING_view |
      | src_pk    | PARTY_BOOKING_HASH         |
      | src_fk    | PARTY_HASH, BOOKING_HASH   |
      | tgt_table | vault.LINK_PARTY_BOOKING   |
      | tgt_pk    | PARTY_BOOKING_HASH         |
      | tgt_fk    | PARTY_HASH, BOOKING_HASH   |
    When I run the vaultLoader with command line arguments
    Then the records in stg.STG_PARTY_BOOKING should have been inserted into vault.LINK_PARTY_BOOKING
      | party_booking_hash | party_hash  | booking_hash | load_datetime       | source_system |
      | md5('1001,B102')   | md5('1001') | md5('B102')  | 2018-01-20 10:00:01 | 1             |
      | md5('1002,B103')   | md5('1002') | md5('B103')  | 2018-01-20 10:00:01 | 1             |
      | md5('1003,B105')   | md5('1003') | md5('B105')  | 2018-01-20 10:00:01 | 1             |

  @log_cleanup
  @clean_data
  Scenario: Link already covers records
    Given there are records in the vault.LINK_PARTY_BOOKING table
      | party_booking_hash | party_hash  | booking_hash | load_datetime       | source_system |
      | md5('1001,B102')   | md5('1001') | md5('B102')  | 2018-01-20 10:00:01 | 1             |
      | md5('1002,B103')   | md5('1002') | md5('B103')  | 2018-01-20 10:00:01 | 1             |
      | md5('1003,B105')   | md5('1003') | md5('B105')  | 2018-01-20 10:00:01 | 1             |
    And there are overlapping records in the stg.STG_PARTY_BOOKING table
      | party_booking_hash | party_hash  | booking_hash | load_datetime       | source_system |
      | md5('1000,')       | md5('1000') | <null>       | 2018-01-21 10:00:01 | 1             |
      | md5('1001,B102')   | md5('1001') | md5('B102')  | 2018-01-21 10:00:01 | 1             |
      | md5('1002,B103')   | md5('1002') | md5('B103')  | 2018-01-21 10:00:01 | 1             |
      | md5(',B104')       | <null>      | md5('B104')  | 2018-01-21 10:00:01 | 1             |
      | md5('1003,B105')   | md5('1003') | md5('B105')  | 2018-01-21 10:00:01 | 1             |
      | md5('1003,B105')   | md5('1003') | md5('B105')  | 2018-01-21 10:00:01 | 1             |
    And there is a view for the stg.STG_PARTY_BOOKING table
    And there is metadata mapping stg.STG_PARTY_BOOKING_view to vault.LINK_PARTY_BOOKING
      | isActive  | true                       |
      | src_table | stg.STG_PARTY_BOOKING_view |
      | src_pk    | PARTY_BOOKING_HASH         |
      | src_fk    | PARTY_HASH, BOOKING_HASH   |
      | tgt_table | vault.LINK_PARTY_BOOKING   |
      | tgt_pk    | PARTY_BOOKING_HASH         |
      | tgt_fk    | PARTY_HASH, BOOKING_HASH   |
    When I run the vaultLoader with command line arguments
    Then there should be no change to the records in vault.LINK_PARTY_BOOKING
      | party_booking_hash | party_hash  | booking_hash | load_datetime       | source_system |
      | md5('1001,B102')   | md5('1001') | md5('B102')  | 2018-01-20 10:00:01 | 1             |
      | md5('1002,B103')   | md5('1002') | md5('B103')  | 2018-01-20 10:00:01 | 1             |
      | md5('1003,B105')   | md5('1003') | md5('B105')  | 2018-01-20 10:00:01 | 1             |

  @log_cleanup
  @clean_data
  Scenario: New records for Link
    Given there are records in the vault.LINK_PARTY_BOOKING table
      | party_booking_hash | party_hash  | booking_hash | load_datetime       | source_system |
      | md5('1000,B101')   | md5('1000') | md5('B101')  | 2018-01-20 10:00:01 | 1             |
      | md5('1002,B103')   | md5('1002') | md5('B103')  | 2018-01-20 10:00:01 | 1             |
      | md5('1003,B105')   | md5('1003') | md5('B105')  | 2018-01-20 10:00:01 | 1             |
    And there are overlapping and new records in the stg.STG_PARTY_BOOKING table
      | party_booking_hash | party_hash  | booking_hash | load_datetime       | source_system |
      | md5('1000,B101')   | md5('1000') | md5('B101')  | 2018-01-20 10:00:01 | 1             |
      | md5('1001,B102')   | md5('1001') | md5('B102')  | 2018-01-20 10:00:01 | 1             |
      | md5('1002,B103')   | md5('1002') | md5('B103')  | 2018-01-20 10:00:01 | 1             |
      | md5(',B104')       | <null>      | md5('B104')  | 2018-01-20 10:00:01 | 1             |
      | md5('1003,B105')   | md5('1003') | md5('B105')  | 2018-01-20 10:00:01 | 1             |
      | md5('1003,B105')   | md5('1003') | md5('B105')  | 2018-01-20 10:00:01 | 1             |
      | md5('1003,')       | md5('1002') | <null>       | 2018-01-21 10:00:01 | 1             |
      | md5('1004,B107')   | md5('1004') | md5('B107')  | 2018-01-21 10:00:01 | 1             |
      | md5('1004,B107')   | md5('1004') | md5('B107')  | 2018-01-21 10:00:01 | 1             |
      | md5('1004,B108')   | md5('1004') | md5('B108')  | 2018-01-21 10:00:01 | 1             |
    And there is a view for the stg.STG_PARTY_BOOKING table
    And there is metadata mapping stg.STG_PARTY_BOOKING_view to vault.LINK_PARTY_BOOKING
      | isActive  | true                       |
      | src_table | stg.STG_PARTY_BOOKING_view |
      | src_pk    | PARTY_BOOKING_HASH         |
      | src_fk    | PARTY_HASH, BOOKING_HASH   |
      | tgt_table | vault.LINK_PARTY_BOOKING   |
      | tgt_pk    | PARTY_BOOKING_HASH         |
      | tgt_fk    | PARTY_HASH, BOOKING_HASH   |
    When I run the vaultLoader with command line arguments
    Then the vault.LINK_PARTY_BOOKING table should include the new records
      | party_booking_hash | party_hash  | booking_hash | load_datetime       | source_system |
      | md5('1000,B101')   | md5('1000') | md5('B101')  | 2018-01-20 10:00:01 | 1             |
      | md5('1001,B102')   | md5('1001') | md5('B102')  | 2018-01-20 10:00:01 | 1             |
      | md5('1002,B103')   | md5('1002') | md5('B103')  | 2018-01-20 10:00:01 | 1             |
      | md5('1003,B105')   | md5('1003') | md5('B105')  | 2018-01-20 10:00:01 | 1             |
      | md5('1004,B107')   | md5('1004') | md5('B107')  | 2018-01-21 10:00:01 | 1             |
      | md5('1004,B108')   | md5('1004') | md5('B108')  | 2018-01-21 10:00:01 | 1             |

  @log_cleanup
  @clean_data
  Scenario: Multiple foreign keys are mapped
    Given there are records in the vault.LINK_PARTY_BOOKING table with an added country_code_hash column
      | party_booking_hash  | party_hash  | booking_hash | country_code_hash | load_datetime       | source_system |
      | md5('1000,B101,UK') | md5('1000') | md5('B101')  | md5('UK')         | 2018-01-20 10:00:01 | 1             |
      | md5('1001,B102,FR') | md5('1001') | md5('B102')  | md5('FR')         | 2018-01-20 10:00:01 | 1             |
      | md5('1002,B103,DE') | md5('1002') | md5('B103')  | md5('DE')         | 2018-01-20 10:00:01 | 1             |
      | md5('1002,B104,DE') | md5('1002') | md5('B104')  | md5('DE')         | 2018-01-20 10:00:01 | 1             |
      | md5('1003,B105,DK') | md5('1003') | md5('B105')  | md5('DK')         | 2018-01-20 10:00:01 | 1             |
    And there are overlapping and new records in the stg.STG_PARTY_BOOKING table with an added country_code_hash column
      | party_booking_hash  | party_hash  | booking_hash | country_code_hash | load_datetime       | source_system |
      | md5('1000,B101,UK') | md5('1000') | md5('B101')  | md5('UK')         | 2018-01-20 10:00:01 | 1             |
      | md5('1001,B102,FR') | md5('1001') | md5('B102')  | md5('FR')         | 2018-01-20 10:00:01 | 1             |
      | md5('1002,B103,DE') | md5('1002') | md5('B103')  | md5('DE')         | 2018-01-21 10:00:01 | 1             |
      | md5('1002,B104,DE') | md5('1002') | md5('B104')  | md5('DE')         | 2018-01-21 10:00:01 | 1             |
      | md5('1003,B105,DK') | md5('1003') | md5('B105')  | md5('DK')         | 2018-01-21 10:00:01 | 1             |
      | md5('1003,B105,')   | md5('1003') | md5('B105')  | <null>            | 2018-01-21 10:00:01 | 1             |
      | md5('1003,,DK')     | md5('1003') | <null>       | md5('DK')         | 2018-01-21 10:00:01 | 1             |
      | md5(',B107,UK')     | <null>      | md5('B107')  | md5('UK')         | 2018-01-21 10:00:01 | 1             |
      | md5('1004,B107,UK') | md5('1004') | md5('B107')  | md5('UK')         | 2018-01-21 10:00:01 | 1             |
      | md5('1004,B108,UK') | md5('1004') | md5('B108')  | md5('UK')         | 2018-01-21 10:00:01 | 1             |
    And there is a view for the stg.STG_PARTY_BOOKING table with added country_code_hash column
    And there is metadata mapping stg.STG_PARTY_BOOKING to vault.LINK_PARTY_BOOKING
      | isActive  | true                                        |
      | src_table | stg.STG_PARTY_BOOKING_view                  |
      | src_pk    | PARTY_BOOKING_HASH                          |
      | src_fk    | PARTY_HASH, BOOKING_HASH, COUNTRY_CODE_HASH |
      | tgt_table | vault.LINK_PARTY_BOOKING                    |
      | tgt_pk    | PARTY_BOOKING_HASH                          |
      | tgt_fk    | PARTY_HASH, BOOKING_HASH, COUNTRY_CODE_HASH |
    When I run the vaultLoader with command line arguments
    Then the vault.LINK_PARTY_BOOKING table should include the new records
      | party_booking_hash  | party_hash  | booking_hash | country_code_hash | load_datetime       | source_system |
      | md5('1000,B101,UK') | md5('1000') | md5('B101')  | md5('UK')         | 2018-01-20 10:00:01 | 1             |
      | md5('1001,B102,FR') | md5('1001') | md5('B102')  | md5('FR')         | 2018-01-20 10:00:01 | 1             |
      | md5('1002,B103,DE') | md5('1002') | md5('B103')  | md5('DE')         | 2018-01-20 10:00:01 | 1             |
      | md5('1002,B104,DE') | md5('1002') | md5('B104')  | md5('DE')         | 2018-01-20 10:00:01 | 1             |
      | md5('1003,B105,DK') | md5('1003') | md5('B105')  | md5('DK')         | 2018-01-20 10:00:01 | 1             |
      | md5('1004,B107,UK') | md5('1004') | md5('B107')  | md5('UK')         | 2018-01-21 10:00:01 | 1             |
      | md5('1004,B108,UK') | md5('1004') | md5('B108')  | md5('UK')         | 2018-01-21 10:00:01 | 1             |

  @log_cleanup
  @clean_data
  Scenario: Foreign keys include a fixed-value column
    Given there are records in the vault.LINK_PARTY_BOOKING table with an added country code column
      | party_booking_hash  | party_hash  | booking_hash | country_code | load_datetime       | source_system |
      | md5('1000,B101,UK') | md5('1000') | md5('B101')  | UK           | 2018-01-20 10:00:01 | 1             |
      | md5('1001,B102,FR') | md5('1001') | md5('B102')  | FR           | 2018-01-20 10:00:01 | 1             |
      | md5('1002,B103,DE') | md5('1002') | md5('B103')  | DE           | 2018-01-20 10:00:01 | 1             |
      | md5('1002,B104,DE') | md5('1002') | md5('B104')  | DE           | 2018-01-20 10:00:01 | 1             |
      | md5('1003,B105,DK') | md5('1003') | md5('B105')  | DK           | 2018-01-20 10:00:01 | 1             |
    And there are overlapping and new records in the stg.STG_PARTY_BOOKING table with an added country code column
      | party_booking_hash  | party_hash  | booking_hash | country_code | load_datetime       | source_system |
      | md5('1000,B101,UK') | md5('1000') | md5('B101')  | UK           | 2018-01-20 10:00:01 | 1             |
      | md5('1001,B102,FR') | md5('1001') | md5('B102')  | FR           | 2018-01-20 10:00:01 | 1             |
      | md5('1002,B103,DE') | md5('1002') | md5('B103')  | DE           | 2018-01-21 10:00:01 | 1             |
      | md5('1002,B104,DE') | md5('1002') | md5('B104')  | DE           | 2018-01-21 10:00:01 | 1             |
      | md5('1003,B105,DK') | md5('1003') | md5('B105')  | DK           | 2018-01-21 10:00:01 | 1             |
      | md5('1003,B105,DK') | md5('1003') | md5('B105')  | DK           | 2018-01-21 10:00:01 | 1             |
      | md5('1003,B106,DK') | md5('1003') | md5('B106')  | DK           | 2018-01-21 10:00:01 | 1             |
      | md5('1004,B107,')   | md5('1004') | md5('B107')  | <null>       | 2018-01-21 10:00:01 | 1             |
      | md5('1004,,UK')     | md5('1004') | <null>       | UK           | 2018-01-21 10:00:01 | 1             |
      | md5(',B108,UK')     | <null>      | md5('B108')  | UK           | 2018-01-21 10:00:01 | 1             |
      | md5('1005,B109,DK') | md5('1005') | md5('B109')  | DK           | 2018-01-21 10:00:01 | 1             |
      | md5('1006,B110,DK') | md5('1006') | md5('B110')  | DK           | 2018-01-21 10:00:01 | 1             |
    And there is a view for the stg.STG_PARTY_BOOKING table with added country code column
    And there is metadata mapping stg.STG_PARTY_BOOKING to vault.LINK_PARTY_BOOKING with a fixed value foreign key column
      | isActive  | true                                   |
      | src_table | stg.STG_PARTY_BOOKING_view             |
      | src_pk    | PARTY_BOOKING_HASH                     |
      | src_fk    | PARTY_HASH, BOOKING_HASH, COUNTRY_CODE |
      | tgt_table | vault.LINK_PARTY_BOOKING               |
      | tgt_pk    | PARTY_BOOKING_HASH                     |
      | tgt_fk    | PARTY_HASH, BOOKING_HASH, COUNTRY_CODE |
    When I run the vaultLoader with command line arguments
    Then the vault.LINK_PARTY_BOOKING table should include the new records
      | party_booking_hash  | party_hash  | booking_hash | country_code | load_datetime       | source_system |
      | md5('1000,B101,UK') | md5('1000') | md5('B101')  | UK           | 2018-01-20 10:00:01 | 1             |
      | md5('1001,B102,FR') | md5('1001') | md5('B102')  | FR           | 2018-01-20 10:00:01 | 1             |
      | md5('1002,B103,DE') | md5('1002') | md5('B103')  | DE           | 2018-01-20 10:00:01 | 1             |
      | md5('1002,B104,DE') | md5('1002') | md5('B104')  | DE           | 2018-01-20 10:00:01 | 1             |
      | md5('1003,B105,DK') | md5('1003') | md5('B105')  | DK           | 2018-01-20 10:00:01 | 1             |
      | md5('1003,B106,DK') | md5('1003') | md5('B106')  | DK           | 2018-01-21 10:00:01 | 1             |
      | md5('1005,B109,DK') | md5('1005') | md5('B109')  | DK           | 2018-01-21 10:00:01 | 1             |
      | md5('1006,B110,DK') | md5('1006') | md5('B110')  | DK           | 2018-01-21 10:00:01 | 1             |

