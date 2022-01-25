# todo: check test results
Feature: [SF-STS2-IM] Status Tracking Satellites - Incremental Materialisation

  @fixture.sts2
  Scenario: [SF-STS2-IM-01] Load data from empty 2nd stage into a non-existent status tracking satellite
    Given the STS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the STS sts2
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
      | md5('1001') | 1993-01-02 | *      | D      |
      | md5('1002') | 1993-01-02 | *      | D      |
      | md5('1003') | 1993-01-02 | *      | D      |

  @fixture.sts2
  Scenario: [SF-STS2-IM-02] Load data into an non-existent status tracking satellite - one cycle
    Given the STS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the STS sts2
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-02 | *      |
      | 1002        | Bobby         | 1993-01-02 | *      |
      | 1004        | Dom           | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
      | md5('1001') | 1993-01-02 | *      | U      |
      | md5('1002') | 1993-01-02 | *      | U      |
      | md5('1003') | 1993-01-02 | *      | D      |
      | md5('1004') | 1993-01-02 | *      | I      |

  @fixture.sts2
  Scenario: [SF-STS2-IM-03] Load data from empty 2nd stage into an empty status tracking satellite
    Given the STS sts2 is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the STS sts2
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
      | md5('1001') | 1993-01-02 | *      | D      |
      | md5('1002') | 1993-01-02 | *      | D      |
      | md5('1003') | 1993-01-02 | *      | D      |

  @fixture.sts2
  Scenario: [SF-STS2-IM-04] Load data into an empty status tracking satellite - one cycle
    Given the STS sts2 is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the STS sts2
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-02 | *      |
      | 1002        | Bobby         | 1993-01-02 | *      |
      | 1004        | Dom           | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
      | md5('1001') | 1993-01-02 | *      | U      |
      | md5('1002') | 1993-01-02 | *      | U      |
      | md5('1003') | 1993-01-02 | *      | D      |
      | md5('1004') | 1993-01-02 | *      | I      |

  @fixture.sts2
  Scenario: [SF-STS2-IM-05] Load data from empty 2nd stage into an existing status tracking satellite
    Given the STS sts2 is already populated with data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
      | md5('1001') | 1993-01-02 | *      | D      |
      | md5('1002') | 1993-01-02 | *      | D      |
      | md5('1003') | 1993-01-02 | *      | D      |

  @fixture.sts2
  Scenario: [SF-STS2-IM-06] Load data into an existing status tracking satellite - one cycle
    Given the STS sts2 is already populated with data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-02 | *      |
      | 1002        | Bobby         | 1993-01-02 | *      |
      | 1004        | Dom           | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
      | md5('1001') | 1993-01-02 | *      | U      |
      | md5('1002') | 1993-01-02 | *      | U      |
      | md5('1003') | 1993-01-02 | *      | D      |
      | md5('1004') | 1993-01-02 | *      | I      |

