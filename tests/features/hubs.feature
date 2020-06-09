@fixture.set_workdir
Feature: Hubs

  Background: Hubs follow a pattern
    Given that hubs will be generated with metadata
      | src_pk      | src_nk      | src_ldts | src_source |
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE | SOURCE     |

  Scenario: Simple load of stage data into an empty hub
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 1993-01-01 | TPCH   |
    And I hash the raw data
    When I load the HUB table
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  Scenario: [BASE-LOAD-SINGLE] Simple load of distinct stage data into an empty hub
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
    And I hash the raw data
    When I load the HUB table
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  Scenario: [BASE-LOAD-SHA] Simple load of distinct stage data into an empty hub using SHA hashing
    Given the HUB table is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
    And I hash the raw data
    When I load the HUB table
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | sha('1001') | 1001        | 1993-01-01 | TPCH   |
      | sha('1002') | 1002        | 1993-01-01 | TPCH   |
      | sha('1003') | 1003        | 1993-01-01 | TPCH   |
      | sha('1004') | 1004        | 1993-01-01 | TPCH   |

  Scenario: [BASE-LOAD-SINGLE] Keys with NULL or empty values are not loaded into empty hub that doesn't exist
    Given the HUB table is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
      | <null>      | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
      |             | Chad          | 2018-04-13   | 1993-01-01 | TPCH   |
    And I hash the raw data
    When I load the HUB table
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  Scenario: [SINGLE-SOURCE] Simple load of stage data into an empty hub
    Given the HUB table is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
    And I hash the raw data
    When I load the HUB table
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |
