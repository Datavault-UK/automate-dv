## passing hard coded tests
Feature: [SF-STS2] Status Tracking Satellites
# RAW_STAGE table does not contain STATUS column

  @fixture.sts2
  Scenario: [SF-STS2-01] Load data into a non-existent status tracking satellite
    Given the STS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |

  @fixture.sts2
  Scenario: [SF-STS2-02] Load duplicated data into a non-existent status tracking satellite
    Given the STS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |

  @fixture.sts2
  Scenario: [SF-STS2-03] Load data with NULLs into a non-existent status tracking satellite
    Given the STS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | <null>      | <null>        | <null>     | *      |
      | <null>      | <null>        | 1993-01-01 | *      |
      | 1004        | <null>        | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
      | md5('1004') | 1993-01-01 | *      | I      |

  @fixture.sts2
  Scenario: [SF-STS2-04] Load data into an empty status tracking satellite
    Given the STS sts2 is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |

  @fixture.sts2
  Scenario: [SF-STS2-05] Load duplicated data into an empty status tracking satellite
    Given the STS sts2 is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |

  @fixture.sts2
  Scenario: [SF-STS2-06] Load data into a populated status tracking satellite
    Given the STS sts2 is already populated with data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1002        | Bob           | 1993-01-03 | *      |
      | 1003        | Chaz          | 1993-01-03 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
      | md5('1001') | 1993-01-03 | *      | D      |
      | md5('1002') | 1993-01-03 | *      | U      |
      | md5('1003') | 1993-01-03 | *      | U      |

  @fixture.sts2
  Scenario: [SF-STS2-07] Load duplicated data into a populated status tracking satellite
    Given the STS sts2 is already populated with data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1002        | Bob           | 1993-01-03 | *      |
      | 1002        | Bob           | 1993-01-03 | *      |
      | 1003        | Chaz          | 1993-01-03 | *      |
      | 1003        | Chaz          | 1993-01-03 | *      |
      | 1003        | Chaz          | 1993-01-03 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts2
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
      | md5('1001') | 1993-01-03 | *      | D      |
      | md5('1002') | 1993-01-03 | *      | U      |
      | md5('1003') | 1993-01-03 | *      | U      |


