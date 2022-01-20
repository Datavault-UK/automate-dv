# todo: check test results
Feature: [SF-STS2-RM] Status Tracking Satellites Loaded using Rank Materialization

  @fixture.sts2
  Scenario: [SF-STS2-RM-01] Base load of a status tracking satellite with one value in rank column loads first rank
    Given the STS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1001        | Alice         | 1993-01-02 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | 1004        | Dom           | 1993-01-01 | *      |
      | 1004        | Dom           | 1993-01-02 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
      | md5('1004') | 1993-01-01 | *      | I      |
      | md5('1001') | 1993-01-02 | *      | U      |
      | md5('1002') | 1993-01-02 | *      | D      |
      | md5('1003') | 1993-01-02 | *      | D      |
      | md5('1004') | 1993-01-02 | *      | U      |

  @fixture.sts2
  Scenario: [SF-STS2-RM-02] Base load of a status tracking satellite with one value in rank column excludes NULL PKs and loads first rank
    Given the STS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1001        | Alice         | 1993-01-02 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | 1004        | Dom           | 1993-01-01 | *      |
      | 1004        | Dom           | 1993-01-02 | *      |
      | <null>      | Emily         | 1993-01-02 | *      |
      |             | Fred          | 1993-01-02 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
      | md5('1004') | 1993-01-01 | *      | I      |

  @fixture.sts2
  Scenario: [SF-STS2-RM-03] Incremental load of a status tracking satellite with one value in rank column loads all records
    Given the STS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | 1004        | Dom           | 1993-01-02 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the STS sts2
    And I insert by rank into the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
      | md5('1004') | 1993-01-01 | *      | I      |

  @fixture.sts2
  Scenario: [SF-STS2-RM-04] Incremental load of a status tracking satellite with one value in rank column loads all records, excluding NULL PKs
    Given the STS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | 1004        | Dom           | 1993-01-01 | *      |
      | <null>      | Emily         | 1993-01-01 | *      |
      |             | Fred          | 1993-01-01 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the STS sts2
    And I insert by rank into the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
      | md5('1004') | 1993-01-01 | *      | I      |

  @fixture.sts2
  Scenario: [SF-STS2-RM-05] Base load of a status tracking satellite with multiple and duplicated values in rank column loads first rank
    Given the STS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-03 | *      |
      | 1004        | Dom           | 1993-01-04 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by LOAD_DATE and ordered by CUSTOMER_ID
    And I stage the STG_CUSTOMER data
    And I insert by rank into the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1001') | 1993-01-02 | *      | D      |
      | md5('1002') | 1993-01-02 | *      | D      |
      | md5('1003') | 1993-01-03 | *      | I      |
      | md5('1003') | 1993-01-04 | *      | D      |
      | md5('1004') | 1993-01-04 | *      | I      |

