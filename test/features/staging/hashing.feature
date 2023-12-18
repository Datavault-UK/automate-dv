@postgres
Feature: [HASH] Check the hash string length for postgres

  @fixture.hashing
  Scenario: [HASH-01] Check hash value length for MD5 hashing in postgres
    Given there is data available
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    And using test hash calculation on table
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    Then the SAMPLE_DATA table should contain the following data
      | value_string    | hash_value_length |
      | postgres_hash   | 16                |
      | snowflake_hash  | 16                |
      | databricks_hash | 16                |
      | bigquery_hash   | 16                |
      | sqlserver_hash  | 16                |


  @fixture.hashing
  @fixture.enable_sha
  Scenario: [HASH-02] Check hash value length for SHA hashing in postgres
    Given there is data available
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    And using test hash calculation on table
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    Then the SAMPLE_DATA table should contain the following data
      | value_string    | hash_value_length |
      | postgres_hash   | 32                |
      | snowflake_hash  | 32                |
      | databricks_hash | 32                |
      | bigquery_hash   | 32                |
      | sqlserver_hash  | 32                |

  @fixture.hashing
  @fixture.enable_sha1
  Scenario: [HASH-03] Check hash value length for SHA1 hashing in postgres
    Given there is data available
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    And using test hash calculation on table
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    Then the SAMPLE_DATA table should contain the following data
      | value_string    | hash_value_length |
      | postgres_hash   | 16                |
      | snowflake_hash  | 16                |
      | databricks_hash | 16                |
      | bigquery_hash   | 16                |
      | sqlserver_hash  | 16                |

  @fixture.hashing
  Scenario: [HASH-04] Check hash value length for MD5 hashing in postgres
    Given there is data available
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    And using dbtvault hash calculation on table
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    Then the SAMPLE_DATA table should contain the following data
      | value_string    | hash_value_length |
      | postgres_hash   | 16                |
      | snowflake_hash  | 16                |
      | databricks_hash | 16                |
      | bigquery_hash   | 16                |
      | sqlserver_hash  | 16                |


  @fixture.hashing
  @fixture.enable_sha
  Scenario: [HASH-05] Check hash value length for SHA hashing in postgres
    Given there is data available
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    And using dbtvault hash calculation on table
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    Then the SAMPLE_DATA table should contain the following data
      | value_string    | hash_value_length |
      | postgres_hash   | 32                |
      | snowflake_hash  | 32                |
      | databricks_hash | 32                |
      | bigquery_hash   | 32                |
      | sqlserver_hash  | 32                |

  @fixture.hashing
  @fixture.enable_sha1
  Scenario: [HASH-06] Check hash value length for SHA1 hashing in postgres
    Given there is data available
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    And using dbtvault hash calculation on table
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    Then the SAMPLE_DATA table should contain the following data
      | value_string    | hash_value_length |
      | postgres_hash   | 16                |
      | snowflake_hash  | 16                |
      | databricks_hash | 16                |
      | bigquery_hash   | 16                |
      | sqlserver_hash  | 16                |

  @fixture.hashing
  @fixture.disable_hashing_upper_case
  Scenario: [HASH-07] Check hash value length for MD5 hashing in postgres with upper casing disabled
    Given there is data available
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    And using dbtvault hash calculation on table
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    Then the SAMPLE_DATA table should contain the following data
      | value_string    | hash_value_length |
      | postgres_hash   | 16                |
      | snowflake_hash  | 16                |
      | databricks_hash | 16                |
      | bigquery_hash   | 16                |
      | sqlserver_hash  | 16                |


  @fixture.hashing
  @fixture.enable_sha
  @fixture.disable_hashing_upper_case
  Scenario: [HASH-08] Check hash value length for SHA hashing in postgres with upper casing disabled
    Given there is data available
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    And using dbtvault hash calculation on table
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    Then the SAMPLE_DATA table should contain the following data
      | value_string    | hash_value_length |
      | postgres_hash   | 32                |
      | snowflake_hash  | 32                |
      | databricks_hash | 32                |
      | bigquery_hash   | 32                |
      | sqlserver_hash  | 32                |

  @fixture.hashing
  @fixture.enable_sha1
  @fixture.disable_hashing_upper_case
  Scenario: [HASH-09] Check hash value length for SHA1 hashing in postgres with upper casing disabled
    Given there is data available
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    And using dbtvault hash calculation on table
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    Then the SAMPLE_DATA table should contain the following data
      | value_string    | hash_value_length |
      | postgres_hash   | 16                |
      | snowflake_hash  | 16                |
      | databricks_hash | 16                |
      | bigquery_hash   | 16                |
      | sqlserver_hash  | 16                |