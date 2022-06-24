Feature: [HUB] Hubs

  @fixture.single_source_hub
  Scenario: [HUB-01] Simple load of stage data into an empty hub
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [HUB-02] Simple load of distinct stage data into an empty hub
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  @fixture.enable_sha
  Scenario: [HUB-03] Simple load of distinct stage data into an empty hub using SHA hashing
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | sha('1001') | 1001        | 1993-01-01 | TPCH   |
      | sha('1002') | 1002        | 1993-01-01 | TPCH   |
      | sha('1003') | 1003        | 1993-01-01 | TPCH   |
      | sha('1004') | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [HUB-04] Keys with NULL or empty values are not loaded into empty hub that does not exist
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
      | <null>      | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
      |             | Chad          | 2018-04-13   | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [HUB-05] Simple load of stage data into an empty hub
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [HUB-06] Simple load of distinct stage data into an empty hub
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [HUB-07] Keys with NULL or empty values are not loaded into an empty hub
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
      | <null>      | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
      |             | Chad          | 2018-04-13   | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [HUB-08] Load of stage data into a hub
    Given the HUB hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |

  @fixture.single_source_hub
  Scenario: [HUB-09] Load of distinct stage data into a hub
    Given the HUB hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |

  @fixture.single_source_hub
  Scenario: [HUB-10] Keys with NULL or empty values are not loaded into a hub
    Given the HUB hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-03 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-04 | TPCH   |
      | <null>      | Dom           | 2018-04-13   | 1993-01-02 | TPCH   |
      |             | Chad          | 2018-04-13   | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | 1004        | 1993-01-04 | TPCH   |

  @fixture.multi_source_hub
  Scenario: [HUB-11] Union three staging tables to feed a empty hub which does not exist
    Given the HUB table does not exist
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOAD_DATE  | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-01 | *      |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-01 | *      |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-01 | *      |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-01 | *      |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-01 | *      |
    And I stage the STG_PARTS data
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOAD_DATE  | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-01 | *      |
      | 1002    | 1           | 2        | 120.00     | 1993-01-01 | *      |
      | 1003    | 1           | 1        | 29.87      | 1993-01-01 | *      |
      | 1004    | 6           | 3        | 101.40     | 1993-01-01 | *      |
      | 1005    | 7           | 8        | 10.50      | 1993-01-01 | *      |
      | 1006    | 7           | 8        | 10.50      | 1993-01-01 | *      |
    And I stage the STG_SUPPLIER data
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOAD_DATE  | SOURCE |
      | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-01 | *      |
      | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-01 | *      |
      | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-01 | *      |
      | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-01 | *      |
      | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-01 | *      |
      | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-01 | *      |
      | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | 1993-01-01 | *      |
      | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | 1993-01-01 | *      |
      | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-01 | *      |
    And I stage the STG_LINEITEM data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | PART_PK     | PART_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | *      |
      | md5('1002') | 1002    | 1993-01-01 | *      |
      | md5('1003') | 1003    | 1993-01-01 | *      |
      | md5('1004') | 1004    | 1993-01-01 | *      |
      | md5('1005') | 1005    | 1993-01-01 | *      |
      | md5('1006') | 1006    | 1993-01-01 | *      |

  @fixture.multi_source_hub
  Scenario: [HUB-12] Keys with NULL or empty values in the union of three staging tables are not feed into an empty hub which does not exist
    Given the HUB table does not exist
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOAD_DATE  | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-01 | PART   |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-01 | PART   |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-01 | PART   |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-01 | PART   |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-01 | PART   |
      | <null>  | Cover     | other     | L         | 1.50             | 1993-01-01 | PART   |
      |         | Pedal     | other     | L         | 1.50             | 1993-01-01 | PART   |
    And I stage the STG_PARTS data
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOAD_DATE  | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-01 | SUPP   |
      | 1002    | 1           | 2        | 120.00     | 1993-01-01 | SUPP   |
      | 1003    | 1           | 1        | 29.87      | 1993-01-01 | SUPP   |
      | 1004    | 6           | 3        | 101.40     | 1993-01-01 | SUPP   |
      | 1005    | 7           | 8        | 10.50      | 1993-01-01 | SUPP   |
      | 1006    | 7           | 8        | 10.50      | 1993-01-01 | SUPP   |
      | <null>  | 7           | 8        | 10.50      | 1993-01-01 | SUPP   |
    And I stage the STG_SUPPLIER data
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOAD_DATE  | SOURCE |
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
    And I stage the STG_LINEITEM data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | PART_PK     | PART_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | LINE   |
      | md5('1002') | 1002    | 1993-01-01 | LINE   |
      | md5('1003') | 1003    | 1993-01-01 | LINE   |
      | md5('1004') | 1004    | 1993-01-01 | LINE   |
      | md5('1005') | 1005    | 1993-01-01 | LINE   |
      | md5('1006') | 1006    | 1993-01-01 | SUPP   |

  @fixture.multi_source_hub
  Scenario: [HUB-13] Union three staging tables to feed an empty hub
    Given the HUB hub is empty
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOAD_DATE  | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-01 | PART   |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-01 | PART   |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-01 | PART   |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-01 | PART   |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-01 | PART   |
    And I stage the STG_PARTS data
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOAD_DATE  | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-01 | SUPP   |
      | 1002    | 1           | 2        | 120.00     | 1993-01-01 | SUPP   |
      | 1003    | 1           | 1        | 29.87      | 1993-01-01 | SUPP   |
      | 1004    | 6           | 3        | 101.40     | 1993-01-01 | SUPP   |
      | 1005    | 7           | 8        | 10.50      | 1993-01-01 | SUPP   |
      | 1006    | 7           | 8        | 10.50      | 1993-01-01 | SUPP   |
    And I stage the STG_SUPPLIER data
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOAD_DATE  | SOURCE |
      | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-01 | LINE   |
      | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-01 | LINE   |
      | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-01 | LINE   |
      | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-01 | LINE   |
      | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-01 | LINE   |
      | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-01 | LINE   |
      | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | 1993-01-01 | LINE   |
      | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | 1993-01-01 | LINE   |
      | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-01 | LINE   |
    And I stage the STG_LINEITEM data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | PART_PK     | PART_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | LINE   |
      | md5('1002') | 1002    | 1993-01-01 | LINE   |
      | md5('1003') | 1003    | 1993-01-01 | LINE   |
      | md5('1004') | 1004    | 1993-01-01 | LINE   |
      | md5('1005') | 1005    | 1993-01-01 | LINE   |
      | md5('1006') | 1006    | 1993-01-01 | SUPP   |

  @fixture.multi_source_hub
  Scenario: [HUB-14] Union three staging tables to feed an empty hub over two cycles
    Given the HUB hub is already populated with data
      | PART_PK     | PART_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | *      |
      | md5('1002') | 1002    | 1993-01-01 | *      |
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOAD_DATE  | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-02 | *      |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-02 | *      |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-02 | *      |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-02 | *      |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-02 | *      |
    And I stage the STG_PARTS data
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOAD_DATE  | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-02 | *      |
      | 1002    | 1           | 2        | 120.00     | 1993-01-02 | *      |
      | 1003    | 1           | 1        | 29.87      | 1993-01-02 | *      |
      | 1004    | 6           | 3        | 101.40     | 1993-01-02 | *      |
      | 1005    | 7           | 8        | 10.50      | 1993-01-02 | *      |
      | 1006    | 7           | 8        | 10.50      | 1993-01-02 | *      |
    And I stage the STG_SUPPLIER data
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOAD_DATE  | SOURCE |
      | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-02 | *      |
      | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-02 | *      |
      | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-02 | *      |
      | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-02 | *      |
      | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-02 | *      |
      | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-02 | *      |
      | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | 1993-01-02 | *      |
      | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | 1993-01-02 | *      |
      | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-02 | *      |
    And I stage the STG_LINEITEM data
    And I load the HUB hub
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOAD_DATE  | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-03 | *      |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-03 | *      |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-03 | *      |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-03 | *      |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-03 | *      |
    And I stage the STG_PARTS data
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOAD_DATE  | SOURCE |
      | 1001    | 9           | 5        | 68.00      | 1993-01-03 | *      |
      | 1002    | 1           | 0        | 120.00     | 1993-01-03 | *      |
      | 1002    | 1           | 13       | 110.00     | 1993-01-03 | *      |
      | 1002    | 1           | 0        | 120.00     | 1993-01-03 | *      |
      | 1002    | 1           | 0        | 120.00     | 1993-01-03 | *      |
    And I stage the STG_SUPPLIER data
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOAD_DATE  | SOURCE |
      | 10007    | 1007    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-03 | *      |
      | 10007    | 1007    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-03 | *      |
      | 10008    | 1008    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-03 | *      |
      | 10008    | 1008    | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-03 | *      |
      | 10009    | 1009    | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-03 | *      |
    And I stage the STG_LINEITEM data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | PART_PK     | PART_ID | LOAD_DATE  | SOURCE |
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
  Scenario: [HUB-15] Union three staging tables to feed a populated hub
    Given the HUB hub is already populated with data
      | PART_PK     | PART_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | LINE   |
      | md5('1002') | 1002    | 1993-01-01 | LINE   |
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOAD_DATE  | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-02 | PART   |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-02 | PART   |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-02 | PART   |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-02 | PART   |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-02 | PART   |
    And I stage the STG_PARTS data
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOAD_DATE  | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-02 | SUPP   |
      | 1002    | 1           | 2        | 120.00     | 1993-01-02 | SUPP   |
      | 1003    | 1           | 1        | 29.87      | 1993-01-02 | SUPP   |
      | 1004    | 6           | 3        | 101.40     | 1993-01-02 | SUPP   |
      | 1005    | 7           | 8        | 10.50      | 1993-01-02 | SUPP   |
      | 1006    | 7           | 8        | 10.50      | 1993-01-02 | SUPP   |
    And I stage the STG_SUPPLIER data
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOAD_DATE  | SOURCE |
      | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-02 | LINE   |
      | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-02 | LINE   |
      | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-02 | LINE   |
      | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-02 | LINE   |
      | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-02 | LINE   |
      | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-02 | LINE   |
      | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | 1993-01-02 | LINE   |
      | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | 1993-01-02 | LINE   |
      | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-02 | LINE   |
    And I stage the STG_LINEITEM data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | PART_PK     | PART_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | LINE   |
      | md5('1002') | 1002    | 1993-01-01 | LINE   |
      | md5('1003') | 1003    | 1993-01-02 | LINE   |
      | md5('1004') | 1004    | 1993-01-02 | LINE   |
      | md5('1005') | 1005    | 1993-01-02 | LINE   |
      | md5('1006') | 1006    | 1993-01-02 | SUPP   |

  @fixture.multi_source_hub
  Scenario: [HUB-16] Keys with a NULL or empty value in a union of three staging tables are not fed into a populated hub
    Given the HUB hub is already populated with data
      | PART_PK     | PART_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | LINE   |
      | md5('1002') | 1002    | 1993-01-01 | LINE   |
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOAD_DATE  | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-02 | PART   |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-02 | PART   |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-02 | PART   |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-02 | PART   |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-02 | PART   |
      | <null>  | Cover     | other     | L         | 1.50             | 1993-01-02 | PART   |
      |         | Door      | other     | L         | 1.50             | 1993-01-02 | PART   |
    And I stage the STG_PARTS data
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOAD_DATE  | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-02 | SUPP   |
      | 1002    | 1           | 2        | 120.00     | 1993-01-02 | SUPP   |
      | 1003    | 1           | 1        | 29.87      | 1993-01-02 | SUPP   |
      | 1004    | 6           | 3        | 101.40     | 1993-01-02 | SUPP   |
      | 1005    | 7           | 8        | 10.50      | 1993-01-02 | SUPP   |
      | 1006    | 7           | 8        | 10.50      | 1993-01-02 | SUPP   |
      | <null>  | 7           | 8        | 10.50      | 1993-01-02 | SUPP   |
    And I stage the STG_SUPPLIER data
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOAD_DATE  | SOURCE |
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
    And I stage the STG_LINEITEM data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | PART_PK     | PART_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | LINE   |
      | md5('1002') | 1002    | 1993-01-01 | LINE   |
      | md5('1003') | 1003    | 1993-01-02 | LINE   |
      | md5('1004') | 1004    | 1993-01-02 | LINE   |
      | md5('1005') | 1005    | 1993-01-02 | LINE   |
      | md5('1006') | 1006    | 1993-01-02 | SUPP   |

  @fixture.single_source_hub
  Scenario: [HUB-17] Standard base load of a hub with additional columns added
    Given the HUB_AC table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | 1001        | Alice         | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | 1002        | Bob           | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | 1002        | Bob           | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | 1002        | Bob           | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | 1003        | Chad          | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | 1004        | Dom           | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB_AC hub
    Then the HUB_AC table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [HUB-18] Standard base load of a hub with multiple additional columns added
    Given the HUB_AC_MULTI table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_MT_ID | CUSTOMER_CK | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | TPCH_CUSTOMER  | CUSTOMER_CK | 1993-01-01 | TPCH   |
      | 1001        | Alice         | TPCH_CUSTOMER  | CUSTOMER_CK | 1993-01-01 | TPCH   |
      | 1002        | Bob           | TPCH_CUSTOMER  | CUSTOMER_CK | 1993-01-01 | TPCH   |
      | 1002        | Bob           | TPCH_CUSTOMER  | CUSTOMER_CK | 1993-01-01 | TPCH   |
      | 1002        | Bob           | TPCH_CUSTOMER  | CUSTOMER_CK | 1993-01-01 | TPCH   |
      | 1003        | Chad          | TPCH_CUSTOMER  | CUSTOMER_CK | 1993-01-01 | TPCH   |
      | 1004        | Dom           | TPCH_CUSTOMER  | CUSTOMER_CK | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB_AC_MULTI hub
    Then the HUB_AC_MULTI table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | CUSTOMER_MT_ID | CUSTOMER_CK | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | TPCH_CUSTOMER  | CUSTOMER_CK | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | TPCH_CUSTOMER  | CUSTOMER_CK | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | TPCH_CUSTOMER  | CUSTOMER_CK | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | TPCH_CUSTOMER  | CUSTOMER_CK | 1993-01-01 | TPCH   |

  @fixture.multi_source_hub
  Scenario: [HUB-19] Union three staging tables to feed a empty hub which does not exist, with additional columns
    Given the HUB_AC table does not exist
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1002    | Door      | external  | XL        | 150.00           | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1003    | Seat      | internal  | R         | 27.68            | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1004    | Aerial    | external  | S         | 10.40            | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1005    | Cover     | other     | L         | 1.50             | TPCH_CUSTOMER  | 1993-01-01 | *      |
    And I stage the STG_PARTS data
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1001    | 9           | 6        | 68.00      | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1002    | 1           | 2        | 120.00     | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1003    | 1           | 1        | 29.87      | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1004    | 6           | 3        | 101.40     | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1005    | 7           | 8        | 10.50      | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1006    | 7           | 8        | 10.50      | TPCH_CUSTOMER  | 1993-01-01 | *      |
    And I stage the STG_SUPPLIER data
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | TPCH_CUSTOMER  | 1993-01-01 | *      |
    And I stage the STG_LINEITEM data
    When I load the HUB_AC hub
    Then the HUB_AC table should contain expected data
      | PART_PK     | PART_ID | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001    | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | md5('1002') | 1002    | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | md5('1003') | 1003    | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | md5('1004') | 1004    | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | md5('1005') | 1005    | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | md5('1006') | 1006    | TPCH_CUSTOMER  | 1993-01-01 | *      |
