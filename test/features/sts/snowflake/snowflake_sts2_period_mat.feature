# todo: check test results
Feature: [SF-STS2-PM-B] Status Tracking Satellites Loaded using Period Materialization for base loads

  @fixture.sts2
  Scenario: [SF-STS2-PM-B-01] Base load of a status tracking satellite with one value in rank column loads first rank
    Given the STS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | 1004        | Dom           | 1993-01-01 | *      |
      | 1004        | Dom           | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the STS sts2 by day with date range: 1993-01-01 to 1993-01-03 and LDTS LOAD_DATE
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
      | md5('1004') | 1993-01-01 | *      | I      |
      | md5('1001') | 1993-01-02 | *      | D      |
      | md5('1002') | 1993-01-02 | *      | D      |
      | md5('1003') | 1993-01-02 | *      | D      |
      | md5('1004') | 1993-01-02 | *      | U      |

  @fixture.sts2
  Scenario: [SF-STS2-PM-B-02] Incremental load of a status tracking satellite with one value in rank column loads all records
    Given the STS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | 1004        | Dom           | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the STS sts2 by day with date range: 1993-01-01 to 1993-01-03 and LDTS LOAD_DATE
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
      | md5('1004') | 1993-01-01 | *      | I      |

  @fixture.sts2
  Scenario: [SF-STS2-PM-B-03] Incremental load of a status tracking satellite should not load PK NULLs
    Given the STS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | 1004        | Dom           | 1993-01-01 | *      |
      | <null>      | Emily         | 1993-01-01 | *      |
      |             | Fred          | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the STS sts2 by day with date range: 1993-01-01 to 1993-01-03 and LDTS LOAD_DATE
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
      | md5('1004') | 1993-01-01 | *      | I      |

  @fixture.enable_full_refresh
  @fixture.sts2_cycle
  Scenario: [SF-STS2-PM-B-04] Base load of a status tracking satellite using full refresh and start and end dates should only contain first period records
    Given the RAW_STAGE stage is empty
    And the STS sts2 is already populated with data
      | CUSTOMER_PK | LOAD_DATE               | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 00:00:00.000 | *      | I      |
      | md5('1002') | 1993-01-01 00:00:00.000 | *      | I      |
      | md5('1003') | 1993-01-01 00:00:00.000 | *      | I      |
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE               | SOURCE |
      | 1004        | Dom           | 1993-01-02 00:00:00.000 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the STS sts2 by day with date range: 1993-01-01 to 1993-01-03 and LDTS LOAD_DATE
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE               | SOURCE | STATUS |
      | md5('1004') | 1993-01-02 00:00:00.000 | *      | I      |

  @fixture.sts2_cycle
  Scenario: [SF-STS2-PM-B-05] Base load of a status tracking satellite should not load PK NULLs
    Given the RAW_STAGE stage is empty
    And the STS sts2 is already populated with data
      | CUSTOMER_PK | LOAD_DATE               | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 00:00:00.000 | *      | I      |
      | md5('1002') | 1993-01-01 00:00:00.000 | *      | I      |
      | md5('1003') | 1993-01-01 00:00:00.000 | *      | I      |
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE               | SOURCE |
      | <null>      | Dom           | 1993-01-02 00:00:00.000 | *      |
      |             | Frida         | 1993-01-02 00:00:00.000 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the STS sts2 by day with date range: 1993-01-01 to 1993-01-03 and LDTS LOAD_DATE
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE               | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 00:00:00.000 | *      | I      |
      | md5('1002') | 1993-01-01 00:00:00.000 | *      | I      |
      | md5('1003') | 1993-01-01 00:00:00.000 | *      | I      |

  @fixture.enable_full_refresh
  @fixture.sts2_cycle
  Scenario: [SF-STS2-PM-B-06] Base load of a status tracking satellite using full refresh and only start date should only contain first period records
    Given the RAW_STAGE stage is empty
    And the STS sts2 is already populated with data
      | CUSTOMER_PK | LOAD_DATE               | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 00:00:00.000 | *      | I      |
      | md5('1002') | 1993-01-01 00:00:00.000 | *      | I      |
      | md5('1003') | 1993-01-01 00:00:00.000 | *      | I      |
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE               | SOURCE |
      | 1004        | Dom           | 1993-01-02 00:00:00.000 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period starting from 1993-01-02 by day into the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE               | SOURCE | STATUS |
      | md5('1004') | 1993-01-02 00:00:00.000 | *      | I      |
