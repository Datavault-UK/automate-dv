Feature: [HUB-COMP-PK] Hubs with composite src_pk

  @fixture.single_source_comp_pk_hub
  Scenario: [HUB-COMP-PK-01] Simple load of stage data into an empty hub
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | A           | Alice         | 1993-01-01 | TPCH   |
      | 1001        | A           | Alice         | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-01 | TPCH   |
      | 1003        | A           | Chad          | 1993-01-01 | TPCH   |
      | 1004        | A           | Dom           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_CK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | A           | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | B           | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | A           | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | A           | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_comp_pk_hub
  Scenario: [HUB-COMP-PK-02] Simple load of distinct stage data into an empty hub
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | A           | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1001        | A           | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | A           | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | A           | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_CK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | A           | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | B           | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | A           | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | A           | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_comp_pk_hub
  @fixture.enable_sha
  Scenario: [HUB-COMP-PK-03] Simple load of distinct stage data into an empty hub using SHA hashing
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | A           | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1001        | A           | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | A           | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | A           | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_CK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | sha('1001') | A           | 1001        | 1993-01-01 | TPCH   |
      | sha('1002') | B           | 1002        | 1993-01-01 | TPCH   |
      | sha('1003') | A           | 1003        | 1993-01-01 | TPCH   |
      | sha('1004') | A           | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_comp_pk_hub
  Scenario: [HUB-COMP-PK-04] Keys with NULL or empty values are not loaded into empty hub that does not exist
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | A           | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1001        | A           | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | A           | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | A           | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
      | <null>      | A           | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
      |             | A           | Chad          | 2018-04-13   | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_CK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | A           | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | B           | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | A           | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | A           | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_comp_pk_hub
  Scenario: [HUB-COMP-PK-05] Load of stage data into a hub
    Given the HUB hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_CK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | A           | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | B           | 1002        | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | A           | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1003        | A           | Chad          | 2013-02-04   | 1993-01-02 | TPCH   |
      | 1004        | A           | Dom           | 2018-04-13   | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_CK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | A           | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | B           | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | A           | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | A           | 1004        | 1993-01-02 | TPCH   |

  @fixture.single_source_comp_pk_hub
  Scenario: [HUB-COMP-PK-06] Load of distinct stage data into a hub
    Given the HUB hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_CK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | A           | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | B           | 1002        | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | A           | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1001        | A           | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1003        | A           | Chad          | 2013-02-04   | 1993-01-02 | TPCH   |
      | 1003        | A           | Chad          | 2013-02-04   | 1993-01-02 | TPCH   |
      | 1004        | A           | Dom           | 2018-04-13   | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_CK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | A           | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | B           | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | A           | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | A           | 1004        | 1993-01-02 | TPCH   |

  @fixture.single_source_comp_pk_hub
  Scenario: [HUB-COMP-PK-07] Keys with NULL or empty values are not loaded into a hub
    Given the HUB hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_CK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | A           | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | B           | 1002        | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | A           | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1001        | A           | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1003        | A           | Chad          | 2013-02-04   | 1993-01-03 | TPCH   |
      | 1004        | A           | Dom           | 2018-04-13   | 1993-01-04 | TPCH   |
      | <null>      | A           | Dom           | 2018-04-13   | 1993-01-02 | TPCH   |
      |             | A           | Chad          | 2018-04-13   | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_CK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | A           | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | B           | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | A           | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | A           | 1004        | 1993-01-04 | TPCH   |

  @fixture.multi_source_comp_pk_hub
  Scenario: [HUB-COMP-PK-08] Union three staging tables to feed a empty hub which does not exist
    Given the HUB table does not exist
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_CK | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOAD_DATE  | SOURCE |
      | 1001    | A       | Pedal     | internal  | M         | 60.00            | 1993-01-01 | *      |
      | 1002    | B       | Door      | external  | XL        | 150.00           | 1993-01-01 | *      |
      | 1003    | A       | Seat      | internal  | R         | 27.68            | 1993-01-01 | *      |
      | 1004    | A       | Aerial    | external  | S         | 10.40            | 1993-01-01 | *      |
      | 1005    | A       | Cover     | other     | L         | 1.50             | 1993-01-01 | *      |
    And I stage the STG_PARTS data
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | PART_CK | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOAD_DATE  | SOURCE |
      | 1001    | A       | 9           | 6        | 68.00      | 1993-01-01 | *      |
      | 1002    | B       | 1           | 2        | 120.00     | 1993-01-01 | *      |
      | 1003    | A       | 1           | 1        | 29.87      | 1993-01-01 | *      |
      | 1004    | A       | 6           | 3        | 101.40     | 1993-01-01 | *      |
      | 1005    | A       | 7           | 8        | 10.50      | 1993-01-01 | *      |
      | 1006    | A       | 7           | 8        | 10.50      | 1993-01-01 | *      |
    And I stage the STG_SUPPLIER data
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | PART_CK | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOAD_DATE  | SOURCE |
      | 10001    | 1001    | A       | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-01 | *      |
      | 10001    | 1002    | B       | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-01 | *      |
      | 10001    | 1003    | A       | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-01 | *      |
      | 10002    | 1002    | B       | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-01 | *      |
      | 10003    | 1003    | A       | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-01 | *      |
      | 10003    | 1004    | A       | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-01 | *      |
      | 10004    | 1004    | A       | 6           | 1          | 3        | 10.40          | 5.50     | 1993-01-01 | *      |
      | 10004    | 1005    | A       | 1           | 2          | 3        | 10.40          | 5.50     | 1993-01-01 | *      |
      | 10005    | 1005    | A       | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-01 | *      |
    And I stage the STG_LINEITEM data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | PART_PK     | PART_CK | PART_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | A       | 1001    | 1993-01-01 | *      |
      | md5('1002') | B       | 1002    | 1993-01-01 | *      |
      | md5('1003') | A       | 1003    | 1993-01-01 | *      |
      | md5('1004') | A       | 1004    | 1993-01-01 | *      |
      | md5('1005') | A       | 1005    | 1993-01-01 | *      |
      | md5('1006') | A       | 1006    | 1993-01-01 | *      |

  @fixture.multi_source_comp_pk_hub
  Scenario: [HUB-COMP-PK-09] Union three staging tables to feed an empty hub over two cycles
    Given the HUB hub is already populated with data
      | PART_PK     | PART_CK | PART_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | A       | 1001    | 1993-01-01 | *      |
      | md5('1002') | B       | 1002    | 1993-01-01 | *      |
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_CK | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOAD_DATE  | SOURCE |
      | 1001    | A       | Pedal     | internal  | M         | 60.00            | 1993-01-02 | *      |
      | 1002    | B       | Door      | external  | XL        | 150.00           | 1993-01-02 | *      |
      | 1003    | A       | Seat      | internal  | R         | 27.68            | 1993-01-02 | *      |
      | 1004    | A       | Aerial    | external  | S         | 10.40            | 1993-01-02 | *      |
      | 1005    | A       | Cover     | other     | L         | 1.50             | 1993-01-02 | *      |
    And I stage the STG_PARTS data
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | PART_CK | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOAD_DATE  | SOURCE |
      | 1001    | A       | 9           | 6        | 68.00      | 1993-01-02 | *      |
      | 1002    | B       | 1           | 2        | 120.00     | 1993-01-02 | *      |
      | 1003    | A       | 1           | 1        | 29.87      | 1993-01-02 | *      |
      | 1004    | A       | 6           | 3        | 101.40     | 1993-01-02 | *      |
      | 1005    | A       | 7           | 8        | 10.50      | 1993-01-02 | *      |
      | 1006    | A       | 7           | 8        | 10.50      | 1993-01-02 | *      |
    And I stage the STG_SUPPLIER data
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | PART_CK | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOAD_DATE  | SOURCE |
      | 10001    | 1001    | A       | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-02 | *      |
      | 10001    | 1002    | B       | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-02 | *      |
      | 10001    | 1003    | A       | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-02 | *      |
      | 10002    | 1002    | B       | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-02 | *      |
      | 10003    | 1003    | A       | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-02 | *      |
      | 10003    | 1004    | A       | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-02 | *      |
      | 10004    | 1004    | A       | 6           | 1          | 3        | 10.40          | 5.50     | 1993-01-02 | *      |
      | 10004    | 1005    | A       | 1           | 2          | 3        | 10.40          | 5.50     | 1993-01-02 | *      |
      | 10005    | 1005    | A       | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-02 | *      |
    And I stage the STG_LINEITEM data
    And I load the HUB hub
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_CK | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOAD_DATE  | SOURCE |
      | 1001    | A       | Pedal     | internal  | M         | 60.00            | 1993-01-03 | *      |
      | 1002    | B       | Door      | external  | XL        | 150.00           | 1993-01-03 | *      |
      | 1003    | A       | Seat      | internal  | R         | 27.68            | 1993-01-03 | *      |
      | 1004    | A       | Aerial    | external  | S         | 10.40            | 1993-01-03 | *      |
      | 1005    | A       | Cover     | other     | L         | 1.50             | 1993-01-03 | *      |
    And I stage the STG_PARTS data
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | PART_CK | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOAD_DATE  | SOURCE |
      | 1001    | A       | 9           | 5        | 68.00      | 1993-01-03 | *      |
      | 1002    | B       | 1           | 0        | 120.00     | 1993-01-03 | *      |
      | 1002    | B       | 1           | 13       | 110.00     | 1993-01-03 | *      |
      | 1002    | B       | 1           | 0        | 120.00     | 1993-01-03 | *      |
      | 1002    | B       | 1           | 0        | 120.00     | 1993-01-03 | *      |
    And I stage the STG_SUPPLIER data
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | PART_CK | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOAD_DATE  | SOURCE |
      | 10007    | 1007    | C       | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-03 | *      |
      | 10007    | 1007    | C       | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-03 | *      |
      | 10008    | 1008    | C       | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-03 | *      |
      | 10008    | 1008    | C       | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-03 | *      |
      | 10009    | 1009    | C       | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-03 | *      |
    And I stage the STG_LINEITEM data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | PART_PK     | PART_CK | PART_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | A       | 1001    | 1993-01-01 | *      |
      | md5('1002') | B       | 1002    | 1993-01-01 | *      |
      | md5('1003') | A       | 1003    | 1993-01-02 | *      |
      | md5('1004') | A       | 1004    | 1993-01-02 | *      |
      | md5('1005') | A       | 1005    | 1993-01-02 | *      |
      | md5('1006') | A       | 1006    | 1993-01-02 | *      |
      | md5('1007') | C       | 1007    | 1993-01-03 | *      |
      | md5('1008') | C       | 1008    | 1993-01-03 | *      |
      | md5('1009') | C       | 1009    | 1993-01-03 | *      |

  @fixture.single_source_comp_pk_hub
  Scenario: [HUB-COMP-PK-10] Simple load of stage data into an empty hub using insert-by-period
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | A           | Alice         | 1993-01-01 | TPCH   |
      | 1001        | A           | Alice         | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-02 | TPCH   |
      | 1003        | A           | Chad          | 1993-01-03 | TPCH   |
      | 1004        | A           | Dom           | 1993-01-04 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I insert by period into the HUB hub by day
    And I insert by period into the HUB hub by day
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_CK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | A           | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | B           | 1002        | 1993-01-02 | TPCH   |
      | md5('1003') | A           | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | A           | 1004        | 1993-01-04 | TPCH   |

  @fixture.single_source_comp_pk_hub
  Scenario: [HUB-COMP-PK-11] Simple load of stage data into an empty hub using insert-by-rank
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | A           | Alice         | 1993-01-01 | TPCH   |
      | 1001        | A           | Alice         | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-03 | TPCH   |
      | 1003        | A           | Chad          | 1993-01-03 | TPCH   |
      | 1004        | A           | Dom           | 1993-01-04 | TPCH   |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the HUB hub
    And I insert by rank into the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_CK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | A           | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | B           | 1002        | 1993-01-02 | TPCH   |
      | md5('1003') | A           | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | A           | 1004        | 1993-01-04 | TPCH   |

  @fixture.single_source_comp_pk_hub
  Scenario: [HUB-COMP-PK-12] Simple load of stage data into an empty hub
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | A           | Alice         | 1993-01-01 | TPCH   |
      | 1001        | A           | Alice         | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-01 | TPCH   |
      | 1002        | C           | Bob           | 1993-01-01 | TPCH   |
      | 1003        | A           | Chad          | 1993-01-01 | TPCH   |
      | 1004        | A           | Dom           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_CK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | A           | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | B           | 1002        | 1993-01-01 | TPCH   |
      | md5('1002') | C           | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | A           | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | A           | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_comp_pk_nk_hub
  Scenario: [HUB-COMP-PK-13] Simple load of stage data into an empty hub
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | A           | Alice         | 1993-01-01 | TPCH   |
      | 1001        | A           | Alice         | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-01 | TPCH   |
      | 1003        | A           | Chad          | 1993-01-01 | TPCH   |
      | 1004        | A           | Dom           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_EMP_DEP_HK | CUSTOMER_ID | CUSTOMER_CK | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('A')            | 1001        | A           | 1993-01-01 | TPCH   |
      | md5('1002') | md5('B')            | 1002        | B           | 1993-01-01 | TPCH   |
      | md5('1003') | md5('A')            | 1003        | A           | 1993-01-01 | TPCH   |
      | md5('1004') | md5('A')            | 1004        | A           | 1993-01-01 | TPCH   |

  @fixture.multi_source_comp_pk_hub
  Scenario: [HUB-COMP-PK-14] Union three staging tables to feed a empty hub which does not exist, load using period materialisation
    Given the HUB table does not exist
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_CK | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOAD_DATE  | SOURCE |
      | 1001    | A       | Pedal     | internal  | M         | 60.00            | 1993-01-01 | *      |
      | 1002    | B       | Door      | external  | XL        | 150.00           | 1993-01-01 | *      |
      | 1003    | A       | Seat      | internal  | R         | 27.68            | 1993-01-01 | *      |
      | 1004    | A       | Aerial    | external  | S         | 10.40            | 1993-01-02 | *      |
      | 1005    | A       | Cover     | other     | L         | 1.50             | 1993-01-02 | *      |
    And I stage the STG_PARTS data
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | PART_CK | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOAD_DATE  | SOURCE |
      | 1001    | A       | 9           | 6        | 68.00      | 1993-01-01 | *      |
      | 1002    | B       | 1           | 2        | 120.00     | 1993-01-01 | *      |
      | 1003    | A       | 1           | 1        | 29.87      | 1993-01-01 | *      |
      | 1004    | A       | 6           | 3        | 101.40     | 1993-01-02 | *      |
      | 1005    | A       | 7           | 8        | 10.50      | 1993-01-02 | *      |
      | 1006    | A       | 7           | 8        | 10.50      | 1993-01-02 | *      |
    And I stage the STG_SUPPLIER data
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | PART_CK | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOAD_DATE  | SOURCE |
      | 10001    | 1001    | A       | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-01 | *      |
      | 10001    | 1002    | B       | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-01 | *      |
      | 10001    | 1003    | A       | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-01 | *      |
      | 10002    | 1002    | B       | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-01 | *      |
      | 10003    | 1003    | A       | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-01 | *      |
      | 10003    | 1004    | A       | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-02 | *      |
      | 10004    | 1004    | A       | 6           | 1          | 3        | 10.40          | 5.50     | 1993-01-02 | *      |
      | 10004    | 1005    | A       | 1           | 2          | 3        | 10.40          | 5.50     | 1993-01-02 | *      |
      | 10005    | 1005    | A       | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-02 | *      |
    And I stage the STG_LINEITEM data
    And I insert by period into the HUB hub by day
    And I insert by period into the HUB hub by day
    Then the HUB table should contain expected data
      | PART_PK     | PART_CK | PART_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | A       | 1001    | 1993-01-01 | *      |
      | md5('1002') | B       | 1002    | 1993-01-01 | *      |
      | md5('1003') | A       | 1003    | 1993-01-01 | *      |
      | md5('1004') | A       | 1004    | 1993-01-02 | *      |
      | md5('1005') | A       | 1005    | 1993-01-02 | *      |
      | md5('1006') | A       | 1006    | 1993-01-02 | *      |

  @fixture.single_source_comp_pk_nk_hub
  Scenario: [HUB-COMP-PK-15] Simple load of stage data into an empty hub, composite PK and NK, load using period materialisation
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | A           | Alice         | 1993-01-01 | TPCH   |
      | 1001        | A           | Alice         | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-02 | TPCH   |
      | 1003        | A           | Chad          | 1993-01-03 | TPCH   |
      | 1004        | A           | Dom           | 1993-01-04 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I insert by period into the HUB hub by day
    And I insert by period into the HUB hub by day
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_EMP_DEP_HK | CUSTOMER_CK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('A')            | A           | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | md5('B')            | B           | 1002        | 1993-01-02 | TPCH   |
      | md5('1003') | md5('A')            | A           | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | md5('A')            | A           | 1004        | 1993-01-04 | TPCH   |

  @fixture.single_source_comp_pk_hub
  Scenario: [HUB-COMP-PK-16] Simple load of stage data into an empty hub, incremental loads
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | A           | Alice         | 1993-01-01 | TPCH   |
      | 1001        | A           | Alice         | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1002        | B           | Bob           | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1003        | A           | Chad          | 1993-01-03 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1004        | A           | Dom           | 1993-01-04 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_CK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | A           | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | B           | 1002        | 1993-01-02 | TPCH   |
      | md5('1003') | A           | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | A           | 1004        | 1993-01-04 | TPCH   |

  @fixture.multi_source_comp_pk_hub
  Scenario: [HUB-COMP-PK-17] Union three staging tables to feed a empty hub which does not exist, incremental loads
    Given the HUB table does not exist
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_CK | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOAD_DATE  | SOURCE |
      | 1001    | A       | Pedal     | internal  | M         | 60.00            | 1993-01-01 | *      |
      | 1002    | B       | Door      | external  | XL        | 150.00           | 1993-01-01 | *      |
      | 1003    | A       | Seat      | internal  | R         | 27.68            | 1993-01-01 | *      |
    And I stage the STG_PARTS data
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | PART_CK | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOAD_DATE  | SOURCE |
      | 1001    | A       | 9           | 6        | 68.00      | 1993-01-01 | *      |
      | 1002    | B       | 1           | 2        | 120.00     | 1993-01-01 | *      |
      | 1003    | A       | 1           | 1        | 29.87      | 1993-01-01 | *      |
    And I stage the STG_SUPPLIER data
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | PART_CK | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOAD_DATE  | SOURCE |
      | 10001    | 1001    | A       | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-01 | *      |
      | 10001    | 1002    | B       | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-01 | *      |
      | 10001    | 1003    | A       | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-01 | *      |
      | 10002    | 1002    | B       | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-01 | *      |
      | 10003    | 1003    | A       | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-01 | *      |
    And I stage the STG_LINEITEM data
    And I load the HUB hub
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_CK | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOAD_DATE  | SOURCE |
      | 1004    | A       | Aerial    | external  | S         | 10.40            | 1993-01-02 | *      |
      | 1005    | A       | Cover     | other     | L         | 1.50             | 1993-01-02 | *      |
    And I stage the STG_PARTS data
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | PART_CK | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOAD_DATE  | SOURCE |
      | 1004    | A       | 6           | 3        | 101.40     | 1993-01-02 | *      |
      | 1005    | A       | 7           | 8        | 10.50      | 1993-01-02 | *      |
      | 1006    | A       | 7           | 8        | 10.50      | 1993-01-02 | *      |
    And I stage the STG_SUPPLIER data
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | PART_CK | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOAD_DATE  | SOURCE |
      | 10003    | 1004    | A       | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-02 | *      |
      | 10004    | 1004    | A       | 6           | 1          | 3        | 10.40          | 5.50     | 1993-01-02 | *      |
      | 10004    | 1005    | A       | 1           | 2          | 3        | 10.40          | 5.50     | 1993-01-02 | *      |
      | 10005    | 1005    | A       | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-02 | *      |
    And I stage the STG_LINEITEM data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | PART_PK     | PART_CK | PART_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | A       | 1001    | 1993-01-01 | *      |
      | md5('1002') | B       | 1002    | 1993-01-01 | *      |
      | md5('1003') | A       | 1003    | 1993-01-01 | *      |
      | md5('1004') | A       | 1004    | 1993-01-02 | *      |
      | md5('1005') | A       | 1005    | 1993-01-02 | *      |
      | md5('1006') | A       | 1006    | 1993-01-02 | *      |

  @fixture.single_source_comp_pk_nk_hub
  Scenario: [HUB-COMP-PK-18] Simple load of stage data into an empty hub, composite PK and NK, incremental loads
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | A           | Alice         | 1993-01-01 | TPCH   |
      | 1001        | A           | Alice         | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1002        | B           | Bob           | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-02 | TPCH   |
      | 1002        | B           | Bob           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1003        | A           | Chad          | 1993-01-03 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1004        | A           | Dom           | 1993-01-04 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_EMP_DEP_HK | CUSTOMER_CK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('A')            | A           | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | md5('B')            | B           | 1002        | 1993-01-02 | TPCH   |
      | md5('1003') | md5('A')            | A           | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | md5('A')            | A           | 1004        | 1993-01-04 | TPCH   |

