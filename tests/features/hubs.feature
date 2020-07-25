@fixture.set_workdir
Feature: Hubs

  @fixture.single_source_hub
  Scenario: [BASE-LOAD] Simple load of stage data into an empty hub
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
    And I hash the stage
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [BASE-LOAD] Simple load of distinct stage data into an empty hub
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
    And I hash the stage
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  @fixture.sha
  Scenario: [BASE-LOAD-SHA] Simple load of distinct stage data into an empty hub using SHA hashing
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
    And I hash the stage
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | sha('1001') | 1001        | 1993-01-01 | TPCH   |
      | sha('1002') | 1002        | 1993-01-01 | TPCH   |
      | sha('1003') | 1003        | 1993-01-01 | TPCH   |
      | sha('1004') | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [BASE-LOAD] Keys with NULL or empty values are not loaded into empty hub that doesn't exist
    Given the HUB hub is empty
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
    And I hash the stage
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [BASE-LOAD-EMPTY] Simple load of stage data into an empty hub
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
    And I hash the stage
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [BASE-LOAD-EMPTY] Simple load of distinct stage data into an empty hub
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
    And I hash the stage
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [BASE-LOAD-EMPTY] Keys with NULL or empty values are not loaded into an existing empty hub
    Given the HUB hub is empty
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
    And I hash the stage
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [POPULATED-LOAD] Load of stage data into a hub
    Given the HUB hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-02 | TPCH   |
    And I hash the stage
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |

  @fixture.single_source_hub
  Scenario: [POPULATED-LOAD] Load of distinct stage data into a hub
    Given the HUB hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-02 | TPCH   |
    And I hash the stage
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |

  @fixture.single_source_hub
  Scenario: [POPULATED-LOAD] Keys with NULL or empty values are not loaded into a hub
    Given the HUB hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
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
    And I hash the stage
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  @fixture.multi_source_hub
  Scenario: [BASE-LOAD-UNION] Union three staging tables to feed a empty hub which doesn't yet exist.
    Given the HUB table does not exist
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOADDATE   | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-01 | PART   |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-01 | PART   |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-01 | PART   |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-01 | PART   |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-01 | PART   |
    And I hash the stage
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOADDATE   | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-01 | SUPP   |
      | 1002    | 1           | 2        | 120.00     | 1993-01-01 | SUPP   |
      | 1003    | 1           | 1        | 29.87      | 1993-01-01 | SUPP   |
      | 1004    | 6           | 3        | 101.40     | 1993-01-01 | SUPP   |
      | 1005    | 7           | 8        | 10.50      | 1993-01-01 | SUPP   |
      | 1006    | 7           | 8        | 10.50      | 1993-01-01 | SUPP   |
    And I hash the stage
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | SOURCE |
      | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-01 | LINE   |
      | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-01 | LINE   |
      | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-01 | LINE   |
      | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-01 | LINE   |
      | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-01 | LINE   |
      | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-01 | LINE   |
      | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | 1993-01-01 | LINE   |
      | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | 1993-01-01 | LINE   |
      | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-01 | LINE   |
    And I hash the stage
    When I load the HUB hub
    Then the HUB table should contain expected data
      | PART_PK     | PART_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | *      |
      | md5('1002') | 1002    | 1993-01-01 | *      |
      | md5('1003') | 1003    | 1993-01-01 | *      |
      | md5('1004') | 1004    | 1993-01-01 | *      |
      | md5('1005') | 1005    | 1993-01-01 | *      |
      | md5('1006') | 1006    | 1993-01-01 | *      |

  @fixture.multi_source_hub
  Scenario: [BASE-LOAD-UNION] Keys with NULL or empty values in the union of three staging tables are not feed into an empty hub which doesn't yet exist.
    Given the HUB table does not exist
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOADDATE   | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-01 | PART   |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-01 | PART   |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-01 | PART   |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-01 | PART   |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-01 | PART   |
      | <null>  | Cover     | other     | L         | 1.50             | 1993-01-01 | PART   |
      |         | Pedal     | other     | L         | 1.50             | 1993-01-01 | PART   |
    And I hash the stage
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOADDATE   | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-01 | SUPP   |
      | 1002    | 1           | 2        | 120.00     | 1993-01-01 | SUPP   |
      | 1003    | 1           | 1        | 29.87      | 1993-01-01 | SUPP   |
      | 1004    | 6           | 3        | 101.40     | 1993-01-01 | SUPP   |
      | 1005    | 7           | 8        | 10.50      | 1993-01-01 | SUPP   |
      | 1006    | 7           | 8        | 10.50      | 1993-01-01 | SUPP   |
      | <null>  | 7           | 8        | 10.50      | 1993-01-01 | SUPP   |
    And I hash the stage
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | SOURCE |
      | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-01 | LINE   |
      | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-01 | LINE   |
      | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-01 | LINE   |
      | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-01 | LINE   |
      | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-01 | LINE   |
      | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-01 | LINE   |
      | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | 1993-01-01 | LINE   |
      | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | 1993-01-01 | LINE   |
      | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-01 | LINE   |
      | 10005    |         | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-01 | LINE   |
    And I hash the stage
    When I load the HUB hub
    Then the HUB table should contain expected data
      | PART_PK     | PART_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | LINE   |
      | md5('1002') | 1002    | 1993-01-01 | LINE   |
      | md5('1003') | 1003    | 1993-01-01 | LINE   |
      | md5('1004') | 1004    | 1993-01-01 | LINE   |
      | md5('1005') | 1005    | 1993-01-01 | LINE   |
      | md5('1006') | 1006    | 1993-01-01 | SUPP   |

  @fixture.multi_source_hub
  Scenario: [BASE-LOAD-UNION] Union three staging tables to feed an empty hub.
    Given the HUB hub is empty
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOADDATE   | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-01 | PART   |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-01 | PART   |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-01 | PART   |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-01 | PART   |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-01 | PART   |
    And I hash the stage
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOADDATE   | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-01 | SUPP   |
      | 1002    | 1           | 2        | 120.00     | 1993-01-01 | SUPP   |
      | 1003    | 1           | 1        | 29.87      | 1993-01-01 | SUPP   |
      | 1004    | 6           | 3        | 101.40     | 1993-01-01 | SUPP   |
      | 1005    | 7           | 8        | 10.50      | 1993-01-01 | SUPP   |
      | 1006    | 7           | 8        | 10.50      | 1993-01-01 | SUPP   |
    And I hash the stage
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | SOURCE |
      | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-01 | LINE   |
      | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-01 | LINE   |
      | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-01 | LINE   |
      | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-01 | LINE   |
      | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-01 | LINE   |
      | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-01 | LINE   |
      | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | 1993-01-01 | LINE   |
      | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | 1993-01-01 | LINE   |
      | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-01 | LINE   |
    And I hash the stage
    When I load the HUB hub
    Then the HUB table should contain expected data
      | PART_PK     | PART_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | LINE   |
      | md5('1002') | 1002    | 1993-01-01 | LINE   |
      | md5('1003') | 1003    | 1993-01-01 | LINE   |
      | md5('1004') | 1004    | 1993-01-01 | LINE   |
      | md5('1005') | 1005    | 1993-01-01 | LINE   |
      | md5('1006') | 1006    | 1993-01-01 | SUPP   |

  @fixture.multi_source_hub
  Scenario: [POPULATED-LOAD-UNION] Union three staging tables to feed an empty hub over two cycles.
    Given the HUB hub is already populated with data
      | PART_PK     | PART_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | *      |
      | md5('1002') | 1002    | 1993-01-01 | *      |
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOADDATE   | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-02 | PART   |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-02 | PART   |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-02 | PART   |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-02 | PART   |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-02 | PART   |
    And I hash the stage
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOADDATE   | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-02 | SUPP   |
      | 1002    | 1           | 2        | 120.00     | 1993-01-02 | SUPP   |
      | 1003    | 1           | 1        | 29.87      | 1993-01-02 | SUPP   |
      | 1004    | 6           | 3        | 101.40     | 1993-01-02 | SUPP   |
      | 1005    | 7           | 8        | 10.50      | 1993-01-02 | SUPP   |
      | 1006    | 7           | 8        | 10.50      | 1993-01-02 | SUPP   |
    And I hash the stage
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | SOURCE |
      | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-02 | LINE   |
      | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-02 | LINE   |
      | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-02 | LINE   |
      | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-02 | LINE   |
      | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-02 | LINE   |
      | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-02 | LINE   |
      | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | 1993-01-02 | LINE   |
      | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | 1993-01-02 | LINE   |
      | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-02 | LINE   |
    And I hash the stage
    And I load the HUB hub
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOADDATE   | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-03 | PART   |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-03 | PART   |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-03 | PART   |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-03 | PART   |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-03 | PART   |
    And I hash the stage
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOADDATE   | SOURCE |
      | 1001    | 9           | 5        | 68.00      | 1993-01-03 | SUPP   |
      | 1002    | 1           | 0        | 120.00     | 1993-01-03 | SUPP   |
      | 1002    | 1           | 13       | 110.00     | 1993-01-03 | SUPP   |
      | 1002    | 1           | 0        | 120.00     | 1993-01-03 | SUPP   |
      | 1002    | 1           | 0        | 120.00     | 1993-01-03 | SUPP   |
    And I hash the stage
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | SOURCE |
      | 10007    | 1007    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-03 | LINE   |
      | 10007    | 1007    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-03 | LINE   |
      | 10008    | 1008    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-03 | LINE   |
      | 10008    | 1008    | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-03 | LINE   |
      | 10009    | 1009    | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-03 | LINE   |
    And I hash the stage
    When I load the HUB hub
    Then the HUB table should contain expected data
      | PART_PK     | PART_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | *      |
      | md5('1002') | 1002    | 1993-01-01 | *      |
      | md5('1003') | 1003    | 1993-01-02 | *      |
      | md5('1004') | 1004    | 1993-01-02 | *      |
      | md5('1005') | 1005    | 1993-01-02 | *      |
      | md5('1006') | 1006    | 1993-01-02 | *      |
      | md5('1007') | 1007    | 1993-01-03 | *      |
      | md5('1008') | 1008    | 1993-01-03 | *      |
      | md5('1009') | 1009    | 1993-01-03 | *      |

  @fixture.multi_source_hub
  Scenario: [POPULATED-LOAD-UNION] Union three staging tables to feed a populated hub.
    Given the HUB hub is already populated with data
      | PART_PK     | PART_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | LINE   |
      | md5('1002') | 1002    | 1993-01-01 | LINE   |
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOADDATE   | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-02 | PART   |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-02 | PART   |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-02 | PART   |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-02 | PART   |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-02 | PART   |
    And I hash the stage
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOADDATE   | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-02 | SUPP   |
      | 1002    | 1           | 2        | 120.00     | 1993-01-02 | SUPP   |
      | 1003    | 1           | 1        | 29.87      | 1993-01-02 | SUPP   |
      | 1004    | 6           | 3        | 101.40     | 1993-01-02 | SUPP   |
      | 1005    | 7           | 8        | 10.50      | 1993-01-02 | SUPP   |
      | 1006    | 7           | 8        | 10.50      | 1993-01-02 | SUPP   |
    And I hash the stage
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | SOURCE |
      | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-02 | LINE   |
      | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-02 | LINE   |
      | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-02 | LINE   |
      | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-02 | LINE   |
      | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-02 | LINE   |
      | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-02 | LINE   |
      | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | 1993-01-02 | LINE   |
      | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | 1993-01-02 | LINE   |
      | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-02 | LINE   |
    And I hash the stage
    When I load the HUB hub
    Then the HUB table should contain expected data
      | PART_PK     | PART_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | LINE   |
      | md5('1002') | 1002    | 1993-01-01 | LINE   |
      | md5('1003') | 1003    | 1993-01-02 | LINE   |
      | md5('1004') | 1004    | 1993-01-02 | LINE   |
      | md5('1005') | 1005    | 1993-01-02 | LINE   |
      | md5('1006') | 1006    | 1993-01-02 | SUPP   |

  @fixture.multi_source_hub
  Scenario: [POPULATED-LOAD-UNION] Keys with a NULL or empty value in a union of three staging tables are not fed into a populated hub.
    Given the HUB hub is already populated with data
      | PART_PK     | PART_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | LINE   |
      | md5('1002') | 1002    | 1993-01-01 | LINE   |
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOADDATE   | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-02 | PART   |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-02 | PART   |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-02 | PART   |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-02 | PART   |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-02 | PART   |
      | <null>  | Cover     | other     | L         | 1.50             | 1993-01-02 | PART   |
      |         | Door      | other     | L         | 1.50             | 1993-01-02 | PART   |
    And I hash the stage
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOADDATE   | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-02 | SUPP   |
      | 1002    | 1           | 2        | 120.00     | 1993-01-02 | SUPP   |
      | 1003    | 1           | 1        | 29.87      | 1993-01-02 | SUPP   |
      | 1004    | 6           | 3        | 101.40     | 1993-01-02 | SUPP   |
      | 1005    | 7           | 8        | 10.50      | 1993-01-02 | SUPP   |
      | 1006    | 7           | 8        | 10.50      | 1993-01-02 | SUPP   |
      | <null>  | 7           | 8        | 10.50      | 1993-01-02 | SUPP   |
    And I hash the stage
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | SOURCE |
      | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-02 | LINE   |
      | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-02 | LINE   |
      | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-02 | LINE   |
      | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-02 | LINE   |
      | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-02 | LINE   |
      | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-02 | LINE   |
      | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | 1993-01-02 | LINE   |
      | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | 1993-01-02 | LINE   |
      | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-02 | LINE   |
      | 10005    |         | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-02 | LINE   |
    And I hash the stage
    When I load the HUB hub
    Then the HUB table should contain expected data
      | PART_PK     | PART_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | LINE   |
      | md5('1002') | 1002    | 1993-01-01 | LINE   |
      | md5('1003') | 1003    | 1993-01-02 | LINE   |
      | md5('1004') | 1004    | 1993-01-02 | LINE   |
      | md5('1005') | 1005    | 1993-01-02 | LINE   |
      | md5('1006') | 1006    | 1993-01-02 | SUPP   |