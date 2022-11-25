Feature: [REF-NH] No-History Reference Tables

  @fixture.single_source_ref_table
  Scenario: [REF-NH-01] Simple load of reference data into an empty reference table
    Given the REF_TABLE table does not exist
    And the RAW_REF_TABLE table contains data
      | DATE_PK    | YEAR | MONTH | DAY | DAY_OF_WEEK | LOAD_DATE  | SOURCE |
      | 2022-11-01 | 2022 | 11    | 1   | Tuesday     | 2022-11-01 | MDS    |
      | 2022-11-02 | 2022 | 11    | 2   | Wednesday   | 2022-11-01 | MDS    |
      | 2022-11-03 | 2022 | 11    | 3   | Thursday    | 2022-11-01 | MDS    |
      | 2022-11-04 | 2022 | 11    | 4   | Friday      | 2022-11-01 | MDS    |
      | 2022-11-05 | 2022 | 11    | 5   | Saturday    | 2022-11-01 | MDS    |
      | 2022-11-06 | 2022 | 11    | 6   | Sunday      | 2022-11-01 | MDS    |
      | 2022-11-07 | 2022 | 11    | 7   | Monday      | 2022-11-01 | MDS    |
    And I stage the REF_DATE data
    When I load the REF_TABLE ref_table
    Then the REF_TABLE table should contain expected data
      | DATE_PK    | YEAR | MONTH | DAY | DAY_OF_WEEK | LOAD_DATE  | SOURCE |
      | 2022-11-01 | 2022 | 11    | 1   | Tuesday     | 2022-11-01 | MDS    |
      | 2022-11-02 | 2022 | 11    | 2   | Wednesday   | 2022-11-01 | MDS    |
      | 2022-11-03 | 2022 | 11    | 3   | Thursday    | 2022-11-01 | MDS    |
      | 2022-11-04 | 2022 | 11    | 4   | Friday      | 2022-11-01 | MDS    |
      | 2022-11-05 | 2022 | 11    | 5   | Saturday    | 2022-11-01 | MDS    |
      | 2022-11-06 | 2022 | 11    | 6   | Sunday      | 2022-11-01 | MDS    |
      | 2022-11-07 | 2022 | 11    | 7   | Monday      | 2022-11-01 | MDS    |

  @fixture.single_source_ref_table
  Scenario: [REF-NH-02] Simple load of distinct reference data into an empty reference table
    Given the REF_TABLE table does not exist
    And the RAW_REF_TABLE table contains data
      | DATE_PK    | YEAR | MONTH | DAY | DAY_OF_WEEK | LOAD_DATE  | SOURCE |
      | 2022-11-01 | 2022 | 11    | 1   | Tuesday     | 2022-11-01 | MDS    |
      | 2022-11-02 | 2022 | 11    | 2   | Wednesday   | 2022-11-01 | MDS    |
      | 2022-11-03 | 2022 | 11    | 3   | Thursday    | 2022-11-01 | MDS    |
      | 2022-11-03 | 2022 | 11    | 3   | Thursday    | 2022-11-01 | MDS    |
      | 2022-11-04 | 2022 | 11    | 4   | Friday      | 2022-11-01 | MDS    |
      | 2022-11-05 | 2022 | 11    | 5   | Saturday    | 2022-11-01 | MDS    |
      | 2022-11-06 | 2022 | 11    | 6   | Sunday      | 2022-11-01 | MDS    |
      | 2022-11-06 | 2022 | 11    | 6   | Sunday      | 2022-11-01 | MDS    |
      | 2022-11-06 | 2022 | 11    | 6   | Sunday      | 2022-11-01 | MDS    |
      | 2022-11-07 | 2022 | 11    | 7   | Monday      | 2022-11-01 | MDS    |
    And I stage the REF_DATE data
    When I load the REF_TABLE ref_table
    Then the REF_TABLE table should contain expected data
      | DATE_PK    | YEAR | MONTH | DAY | DAY_OF_WEEK | LOAD_DATE  | SOURCE |
      | 2022-11-01 | 2022 | 11    | 1   | Tuesday     | 2022-11-01 | MDS    |
      | 2022-11-02 | 2022 | 11    | 2   | Wednesday   | 2022-11-01 | MDS    |
      | 2022-11-03 | 2022 | 11    | 3   | Thursday    | 2022-11-01 | MDS    |
      | 2022-11-04 | 2022 | 11    | 4   | Friday      | 2022-11-01 | MDS    |
      | 2022-11-05 | 2022 | 11    | 5   | Saturday    | 2022-11-01 | MDS    |
      | 2022-11-06 | 2022 | 11    | 6   | Sunday      | 2022-11-01 | MDS    |
      | 2022-11-07 | 2022 | 11    | 7   | Monday      | 2022-11-01 | MDS    |

  @fixture.single_source_ref_table
  Scenario: [REF-NH-03] Keys with NULL or empty values are not loaded into empty reference table that does not exist
    Given the REF_TABLE ref_table is empty
    And the RAW_REF_TABLE table contains data
      | DATE_PK    | YEAR | MONTH | DAY | DAY_OF_WEEK | LOAD_DATE  | SOURCE |
      | 2022-11-01 | 2022 | 11    | 1   | Tuesday     | 2022-11-01 | MDS    |
      | 2022-11-02 | 2022 | 11    | 2   | Wednesday   | 2022-11-01 | MDS    |
      | 2022-11-03 | 2022 | 11    | 3   | Thursday    | 2022-11-01 | MDS    |
      | 2022-11-04 | 2022 | 11    | 4   | Friday      | 2022-11-01 | MDS    |
      | 2022-11-05 | 2022 | 11    | 5   | Saturday    | 2022-11-01 | MDS    |
      | <null>     | 2022 | 11    | 6   | Sunday      | 2022-11-01 | MDS    |
      |            | 2022 | 11    | 7   | Monday      | 2022-11-01 | MDS    |
    And I stage the REF_DATE data
    When I load the REF_TABLE ref_table
    Then the REF_TABLE table should contain expected data
      | DATE_PK    | YEAR | MONTH | DAY | DAY_OF_WEEK | LOAD_DATE  | SOURCE |
      | 2022-11-01 | 2022 | 11    | 1   | Tuesday     | 2022-11-01 | MDS    |
      | 2022-11-02 | 2022 | 11    | 2   | Wednesday   | 2022-11-01 | MDS    |
      | 2022-11-03 | 2022 | 11    | 3   | Thursday    | 2022-11-01 | MDS    |
      | 2022-11-04 | 2022 | 11    | 4   | Friday      | 2022-11-01 | MDS    |
      | 2022-11-05 | 2022 | 11    | 5   | Saturday    | 2022-11-01 | MDS    |

  @fixture.single_source_ref_table
  Scenario: [REF-NH-04] Load of reference data into a reference table
    Given the REF_TABLE ref_table is already populated with data
      | DATE_PK    | YEAR | MONTH | DAY | DAY_OF_WEEK | LOAD_DATE  | SOURCE |
      | 2022-11-01 | 2022 | 11    | 1   | Tuesday     | 2022-11-01 | MDS    |
      | 2022-11-02 | 2022 | 11    | 2   | Wednesday   | 2022-11-01 | MDS    |
      | 2022-11-03 | 2022 | 11    | 3   | Thursday    | 2022-11-01 | MDS    |
      | 2022-11-04 | 2022 | 11    | 4   | Friday      | 2022-11-01 | MDS    |
    And the RAW_REF_TABLE table contains data
      | DATE_PK    | YEAR | MONTH | DAY | DAY_OF_WEEK | LOAD_DATE  | SOURCE |
      | 2022-11-01 | 2022 | 11    | 1   | Tuesday     | 2022-11-01 | MDS    |
      | 2022-11-02 | 2022 | 11    | 2   | Wednesday   | 2022-11-01 | MDS    |
      | 2022-11-03 | 2022 | 11    | 3   | Thursday    | 2022-11-01 | MDS    |
      | 2022-11-04 | 2022 | 11    | 4   | Friday      | 2022-11-01 | MDS    |
      | 2022-11-05 | 2022 | 11    | 5   | Saturday    | 2022-11-01 | MDS    |
      | 2022-11-06 | 2022 | 11    | 6   | Sunday      | 2022-11-01 | MDS    |
      | 2022-11-07 | 2022 | 11    | 7   | Monday      | 2022-11-01 | MDS    |
    And I stage the REF_DATE data
    When I load the REF_TABLE ref_table
    Then the REF_TABLE table should contain expected data
      | DATE_PK    | YEAR | MONTH | DAY | DAY_OF_WEEK | LOAD_DATE  | SOURCE |
      | 2022-11-01 | 2022 | 11    | 1   | Tuesday     | 2022-11-01 | MDS    |
      | 2022-11-02 | 2022 | 11    | 2   | Wednesday   | 2022-11-01 | MDS    |
      | 2022-11-03 | 2022 | 11    | 3   | Thursday    | 2022-11-01 | MDS    |
      | 2022-11-04 | 2022 | 11    | 4   | Friday      | 2022-11-01 | MDS    |
      | 2022-11-05 | 2022 | 11    | 5   | Saturday    | 2022-11-01 | MDS    |
      | 2022-11-06 | 2022 | 11    | 6   | Sunday      | 2022-11-01 | MDS    |
      | 2022-11-07 | 2022 | 11    | 7   | Monday      | 2022-11-01 | MDS    |
