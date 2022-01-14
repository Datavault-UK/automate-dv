Feature: [SF-STS2-CYC] Status Tracking Satellites

  @fixture.sts2_cycle
  Scenario: [SF-STS2-CYC-01] Load data into a non-existent status tracking satellite
    Given the RAW_STAGE stage is empty
    And the STS sts2 is empty

    # ================ DAY 1 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE               | SOURCE |
      | 1001        | Alice         | 1993-01-01 00:00:00.000 | *      |
      | 1002        | Bob           | 1993-01-01 00:00:00.000 | *      |
      | 1003        | Chad          | 1993-01-01 00:00:00.000 | *      |
    And I stage the STG_CUSTOMER data
    And I load the STS sts2

     # ================ DAY 2 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE               | SOURCE |
      | 1002        | Bob           | 1993-01-02 00:00:00.000 | *      |
      | 1003        | Chad          | 1993-01-02 00:00:00.000 | *      |
    And I stage the STG_CUSTOMER data
    And I load the STS sts2

    # ================ DAY 3 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE               | SOURCE |
      | 1001        | Alice         | 1993-01-03 00:00:00.000 | *      |
      | 1002        | Bob           | 1993-01-03 00:00:00.000 | *      |
      | 1004        | Dan           | 1993-01-03 00:00:00.000 | *      |
    And I stage the STG_CUSTOMER data
    And I load the STS sts2

    # =============== CHECKS ===================
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE               | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 00:00:00.000 | *      | I      |
      | md5('1002') | 1993-01-01 00:00:00.000 | *      | I      |
      | md5('1003') | 1993-01-01 00:00:00.000 | *      | I      |
      | md5('1001') | 1993-01-01 00:00:00.001 | *      | D      |
      | md5('1002') | 1993-01-02 00:00:00.000 | *      | U      |
      | md5('1003') | 1993-01-02 00:00:00.000 | *      | U      |
      | md5('1001') | 1993-01-03 00:00:00.000 | *      | I      |
      | md5('1002') | 1993-01-03 00:00:00.000 | *      | U      |
      | md5('1003') | 1993-01-02 00:00:00.001 | *      | D      |
      | md5('1004') | 1993-01-03 00:00:00.000 | *      | I      |
