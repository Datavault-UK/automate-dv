@postgres
Feature: [HASH] Check the hash string length for postgres

  Scenario: [HASH-01] Check hash value length for MD5 hashing in postgres
    Given there is data available
      | VALUE_STRING  |
      | postgres_hash |
    And using hash calculation on table
      | VALUE_STRING  |
      | postgres_hash |
    Then the SAMPLE_DATA table should contain the following data
      | value_string  | hash_value_length |
      | postgres_hash | 16                |

  @enable_sha
  Scenario: [HASH-02] Check hash value length for SHA hashing in postgres
    Given there is data available
      | VALUE_STRING  |
      | postgres_hash |
    And using hash calculation on table
      | VALUE_STRING  |
      | postgres_hash |
    Then the SAMPLE_DATA table should contain the following data
      | value_string  | hash_value_length |
      | postgres_hash | 32                |