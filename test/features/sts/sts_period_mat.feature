Feature: [STS-PM] Status Tracking Satellites - Period Materialisation

  @fixture.sts
  Scenario: [STS-PM-01] Load data into an non-existent status tracking satellite
    Given the STS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | 1001        | Alison        | 1993-01-02 | *      |
      | 1002        | Bobby         | 1993-01-02 | *      |
      | 1004        | Dom           | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the STS sts by day
    And I insert by period into the STS sts by day
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS | STATUS_HASHDIFF |
      | md5('1001') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1002') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1003') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1001') | 1993-01-02 | *      | U      | md5('U')        |
      | md5('1002') | 1993-01-02 | *      | U      | md5('U')        |
      | md5('1003') | 1993-01-02 | *      | D      | md5('D')        |
      | md5('1004') | 1993-01-02 | *      | I      | md5('I')        |

  @fixture.sts
  Scenario: [STS-PM-02] Load data into an empty status tracking satellite
    Given the STS sts is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | 1001        | Alison        | 1993-01-02 | *      |
      | 1002        | Bobby         | 1993-01-02 | *      |
      | 1004        | Dom           | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the STS sts by day
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS | STATUS_HASHDIFF |
      | md5('1001') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1002') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1003') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1001') | 1993-01-02 | *      | U      | md5('U')        |
      | md5('1002') | 1993-01-02 | *      | U      | md5('U')        |
      | md5('1003') | 1993-01-02 | *      | D      | md5('D')        |
      | md5('1004') | 1993-01-02 | *      | I      | md5('I')        |

  @fixture.sts
  Scenario: [STS-RM-03] Load data into an existing status tracking satellite
    Given the STS sts is already populated with data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-02 | *      |
      | 1002        | Bob           | 1993-01-02 | *      |
      | 1004        | Dom           | 1993-01-02 | *      |
      | 1001        | Alison        | 1993-01-03 | *      |
      | 1002        | Bobby         | 1993-01-03 | *      |
      | 1004        | Dom           | 1993-01-03 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the STS sts by day
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS | STATUS_HASHDIFF |
      | md5('1001') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1002') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1003') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1001') | 1993-01-02 | *      | U      | md5('U')        |
      | md5('1002') | 1993-01-02 | *      | U      | md5('U')        |
      | md5('1003') | 1993-01-02 | *      | D      | md5('D')        |
      | md5('1004') | 1993-01-02 | *      | I      | md5('I')        |
      | md5('1001') | 1993-01-03 | *      | U      | md5('U')        |
      | md5('1002') | 1993-01-03 | *      | U      | md5('U')        |
      | md5('1004') | 1993-01-03 | *      | U      | md5('U')        |
