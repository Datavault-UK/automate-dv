Feature: [SF-TLK_COMPPK] Transactional Links with composite src_pk

  @fixture.t_link_comppk
  Scenario: [SF-TLK-COMPPK_001] Load a non-existent Transactional Link
    Given the T_LINK_COMPPK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | TRANSACTION_NUMBER | TRANSACTION_DATE | TYPE | AMOUNT   | LOAD_DATE  | SOURCE |
      | 1234        | 4321     | 12345678           | 2019-09-19       | DR   | 2340.50  | 2019-09-21 | SAP    |
      | 1234        | 4322     | 12345679           | 2019-09-19       | CR   | 123.40   | 2019-09-21 | SAP    |
      | 1234        | 4323     | 12345680           | 2019-09-19       | DR   | 2546.23  | 2019-09-21 | SAP    |
      | 1234        | 4324     | 12345681           | 2019-09-19       | CR   | -123.40  | 2019-09-21 | SAP    |
      | 1235        | 4325     | 12345682           | 2019-09-19       | CR   | 37645.34 | 2019-09-21 | SAP    |
      | 1236        | 4326     | 12345683           | 2019-09-19       | CR   | 236.55   | 2019-09-21 | SAP    |
      | 1237        | 4327     | 12345684           | 2019-09-19       | DR   | 3567.34  | 2019-09-21 | SAP    |
    And I stage the STG_CUSTOMER data
    When I load the T_LINK_COMPPK t_link
    Then the T_LINK_COMPPK table should contain expected data
      | TRANSACTION_PK                  | CUSTOMER_FK | ORDER_FK    | TRANSACTION_NUMBER | TRANSACTION_DATE | TYPE | AMOUNT   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1234\|\|4321\|\|12345678') | md5('1234') | md5('4321') | 12345678           | 2019-09-19       | DR   | 2340.50  | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1234\|\|4322\|\|12345679') | md5('1234') | md5('4322') | 12345679           | 2019-09-19       | CR   | 123.40   | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1234\|\|4323\|\|12345680') | md5('1234') | md5('4323') | 12345680           | 2019-09-19       | DR   | 2546.23  | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1234\|\|4324\|\|12345681') | md5('1234') | md5('4324') | 12345681           | 2019-09-19       | CR   | -123.40  | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1235\|\|4325\|\|12345682') | md5('1235') | md5('4325') | 12345682           | 2019-09-19       | CR   | 37645.34 | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1236\|\|4326\|\|12345683') | md5('1236') | md5('4326') | 12345683           | 2019-09-19       | CR   | 236.55   | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1237\|\|4327\|\|12345684') | md5('1237') | md5('4327') | 12345684           | 2019-09-19       | DR   | 3567.34  | 2019-09-19     | 2019-09-21 | SAP    |

  @fixture.t_link_comppk
  Scenario: [SF-TLK-COMPPK-002] Load an a non-existent Transactional Link with the period materialisation
    Given the T_LINK_COMPPK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | TRANSACTION_NUMBER | TRANSACTION_DATE | TYPE | AMOUNT   | LOAD_DATE  | SOURCE |
      | 1234        | 4321     | 12345678           | 2019-09-19       | DR   | 2340.50  | 2019-09-21 | SAP    |
      | 1234        | 4322     | 12345679           | 2019-09-19       | CR   | 123.40   | 2019-09-22 | SAP    |
      | 1234        | 4323     | 12345680           | 2019-09-19       | DR   | 2546.23  | 2019-09-22 | SAP    |
      | 1234        | 4324     | 12345681           | 2019-09-19       | CR   | -123.40  | 2019-09-23 | SAP    |
      | 1235        | 4325     | 12345682           | 2019-09-19       | CR   | 37645.34 | 2019-09-24 | SAP    |
      | 1236        | 4326     | 12345683           | 2019-09-19       | CR   | 236.55   | 2019-09-25 | SAP    |
      | 1237        | 4327     | 12345684           | 2019-09-19       | DR   | 3567.34  | 2019-09-26 | SAP    |
    And I stage the STG_CUSTOMER data
    And I insert by period into the T_LINK_COMPPK t_link by day
    And I insert by period into the T_LINK_COMPPK t_link by day
    Then the T_LINK_COMPPK table should contain expected data
      | TRANSACTION_PK                  | CUSTOMER_FK | ORDER_FK    | TRANSACTION_NUMBER | TRANSACTION_DATE | TYPE | AMOUNT   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1234\|\|4321\|\|12345678') | md5('1234') | md5('4321') | 12345678           | 2019-09-19       | DR   | 2340.50  | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1234\|\|4322\|\|12345679') | md5('1234') | md5('4322') | 12345679           | 2019-09-19       | CR   | 123.40   | 2019-09-19     | 2019-09-22 | SAP    |
      | md5('1234\|\|4323\|\|12345680') | md5('1234') | md5('4323') | 12345680           | 2019-09-19       | DR   | 2546.23  | 2019-09-19     | 2019-09-22 | SAP    |
      | md5('1234\|\|4324\|\|12345681') | md5('1234') | md5('4324') | 12345681           | 2019-09-19       | CR   | -123.40  | 2019-09-19     | 2019-09-23 | SAP    |
      | md5('1235\|\|4325\|\|12345682') | md5('1235') | md5('4325') | 12345682           | 2019-09-19       | CR   | 37645.34 | 2019-09-19     | 2019-09-24 | SAP    |
      | md5('1236\|\|4326\|\|12345683') | md5('1236') | md5('4326') | 12345683           | 2019-09-19       | CR   | 236.55   | 2019-09-19     | 2019-09-25 | SAP    |
      | md5('1237\|\|4327\|\|12345684') | md5('1237') | md5('4327') | 12345684           | 2019-09-19       | DR   | 3567.34  | 2019-09-19     | 2019-09-26 | SAP    |

  @fixture.t_link_comppk
  Scenario: [SF-TLK-COMPPK-003] Load an a non-existent Transactional Link with the period materialisation, duplicates should not be loaded
    Given the T_LINK_COMPPK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | TRANSACTION_NUMBER | TRANSACTION_DATE | TYPE | AMOUNT   | LOAD_DATE  | SOURCE |
      | 1234        | 4321     | 12345678           | 2019-09-19       | DR   | 2340.50  | 2019-09-21 | SAP    |
      | 1234        | 4321     | 12345678           | 2019-09-19       | DR   | 2340.50  | 2019-09-21 | SAP    |
      | 1234        | 4322     | 12345679           | 2019-09-19       | CR   | 123.40   | 2019-09-22 | SAP    |
      | 1234        | 4323     | 12345680           | 2019-09-19       | DR   | 2546.23  | 2019-09-22 | SAP    |
      | 1234        | 4324     | 12345681           | 2019-09-19       | CR   | -123.40  | 2019-09-23 | SAP    |
      | 1235        | 4325     | 12345682           | 2019-09-19       | CR   | 37645.34 | 2019-09-24 | SAP    |
      | 1236        | 4326     | 12345683           | 2019-09-19       | CR   | 236.55   | 2019-09-25 | SAP    |
      | 1237        | 4327     | 12345684           | 2019-09-19       | DR   | 3567.34  | 2019-09-26 | SAP    |
      | 1234        | 4321     | 12345678           | 2019-09-19       | DR   | 2340.50  | 2019-09-26 | SAP    |
      | 1234        | 4321     | 12345678           | 2019-09-19       | DR   | 2340.50  | 2019-09-27 | SAP    |
    And I stage the STG_CUSTOMER data
    And I insert by period into the T_LINK_COMPPK t_link by day
    And I insert by period into the T_LINK_COMPPK t_link by day
    Then the T_LINK_COMPPK table should contain expected data
      | TRANSACTION_PK                  | CUSTOMER_FK | ORDER_FK    | TRANSACTION_NUMBER | TRANSACTION_DATE | TYPE | AMOUNT   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1234\|\|4321\|\|12345678') | md5('1234') | md5('4321') | 12345678           | 2019-09-19       | DR   | 2340.50  | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1234\|\|4322\|\|12345679') | md5('1234') | md5('4322') | 12345679           | 2019-09-19       | CR   | 123.40   | 2019-09-19     | 2019-09-22 | SAP    |
      | md5('1234\|\|4323\|\|12345680') | md5('1234') | md5('4323') | 12345680           | 2019-09-19       | DR   | 2546.23  | 2019-09-19     | 2019-09-22 | SAP    |
      | md5('1234\|\|4324\|\|12345681') | md5('1234') | md5('4324') | 12345681           | 2019-09-19       | CR   | -123.40  | 2019-09-19     | 2019-09-23 | SAP    |
      | md5('1235\|\|4325\|\|12345682') | md5('1235') | md5('4325') | 12345682           | 2019-09-19       | CR   | 37645.34 | 2019-09-19     | 2019-09-24 | SAP    |
      | md5('1236\|\|4326\|\|12345683') | md5('1236') | md5('4326') | 12345683           | 2019-09-19       | CR   | 236.55   | 2019-09-19     | 2019-09-25 | SAP    |
      | md5('1237\|\|4327\|\|12345684') | md5('1237') | md5('4327') | 12345684           | 2019-09-19       | DR   | 3567.34  | 2019-09-19     | 2019-09-26 | SAP    |

  @fixture.t_link_comppk
  Scenario: [SF-TLK-COMPPK-004] Load a populated Transactional Link
    Given the T_LINK_COMPPK t_link is already populated with data
      | TRANSACTION_PK                  | CUSTOMER_FK | ORDER_FK    | TRANSACTION_NUMBER | TRANSACTION_DATE | TYPE | AMOUNT   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1234\|\|4321\|\|12345678') | md5('1234') | md5('4321') | 12345678           | 2019-09-19       | DR   | 2340.50  | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1234\|\|4322\|\|12345679') | md5('1234') | md5('4322') | 12345679           | 2019-09-19       | CR   | 123.40   | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1234\|\|4323\|\|12345680') | md5('1234') | md5('4323') | 12345680           | 2019-09-19       | DR   | 2546.23  | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1234\|\|4324\|\|12345681') | md5('1234') | md5('4324') | 12345681           | 2019-09-19       | CR   | -123.40  | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1235\|\|4325\|\|12345682') | md5('1235') | md5('4325') | 12345682           | 2019-09-19       | CR   | 37645.34 | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1236\|\|4326\|\|12345683') | md5('1236') | md5('4326') | 12345683           | 2019-09-19       | CR   | 236.55   | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1237\|\|4327\|\|12345684') | md5('1237') | md5('4327') | 12345684           | 2019-09-19       | DR   | 3567.34  | 2019-09-19     | 2019-09-21 | SAP    |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | TRANSACTION_NUMBER | TRANSACTION_DATE | TYPE | AMOUNT   | LOAD_DATE  | SOURCE |
      | 1234        | 1238     | 12345685           | 2019-09-20       | DR   | 3478.50  | 2019-09-22 | SAP    |
      | 1234        | 1239     | 12345686           | 2019-09-20       | DR   | 10.00    | 2019-09-22 | SAP    |
      | 1235        | 1240     | 12345687           | 2019-09-20       | DR   | 1734.65  | 2019-09-22 | SAP    |
      | 1236        | 1241     | 12345688           | 2019-09-20       | DR   | 4832.56  | 2019-09-22 | SAP    |
      | 1237        | 1242     | 12345689           | 2019-09-20       | DR   | 10000.00 | 2019-09-22 | SAP    |
      | 1238        | 1243     | 12345690           | 2019-09-20       | CR   | 6823.55  | 2019-09-22 | SAP    |
      | 1238        | 1244     | 12345691           | 2019-09-20       | CR   | 4578.34  | 2019-09-22 | SAP    |
    And I stage the STG_CUSTOMER data
    When I load the T_LINK_COMPPK t_link
    Then the T_LINK_COMPPK table should contain expected data
      | TRANSACTION_PK                  | CUSTOMER_FK | ORDER_FK    | TRANSACTION_NUMBER | TRANSACTION_DATE | TYPE | AMOUNT   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1234\|\|4321\|\|12345678') | md5('1234') | md5('4321') | 12345678           | 2019-09-19       | DR   | 2340.50  | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1234\|\|4322\|\|12345679') | md5('1234') | md5('4322') | 12345679           | 2019-09-19       | CR   | 123.40   | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1234\|\|4323\|\|12345680') | md5('1234') | md5('4323') | 12345680           | 2019-09-19       | DR   | 2546.23  | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1234\|\|4324\|\|12345681') | md5('1234') | md5('4324') | 12345681           | 2019-09-19       | CR   | -123.40  | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1235\|\|4325\|\|12345682') | md5('1235') | md5('4325') | 12345682           | 2019-09-19       | CR   | 37645.34 | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1236\|\|4326\|\|12345683') | md5('1236') | md5('4326') | 12345683           | 2019-09-19       | CR   | 236.55   | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1237\|\|4327\|\|12345684') | md5('1237') | md5('4327') | 12345684           | 2019-09-19       | DR   | 3567.34  | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1234\|\|1238\|\|12345685') | md5('1234') | md5('1238') | 12345685           | 2019-09-20       | DR   | 3478.50  | 2019-09-20     | 2019-09-22 | SAP    |
      | md5('1234\|\|1239\|\|12345686') | md5('1234') | md5('1239') | 12345686           | 2019-09-20       | DR   | 10.00    | 2019-09-20     | 2019-09-22 | SAP    |
      | md5('1235\|\|1240\|\|12345687') | md5('1235') | md5('1240') | 12345687           | 2019-09-20       | DR   | 1734.65  | 2019-09-20     | 2019-09-22 | SAP    |
      | md5('1236\|\|1241\|\|12345688') | md5('1236') | md5('1241') | 12345688           | 2019-09-20       | DR   | 4832.56  | 2019-09-20     | 2019-09-22 | SAP    |
      | md5('1237\|\|1242\|\|12345689') | md5('1237') | md5('1242') | 12345689           | 2019-09-20       | DR   | 10000.00 | 2019-09-20     | 2019-09-22 | SAP    |
      | md5('1238\|\|1243\|\|12345690') | md5('1238') | md5('1243') | 12345690           | 2019-09-20       | CR   | 6823.55  | 2019-09-20     | 2019-09-22 | SAP    |
      | md5('1238\|\|1244\|\|12345691') | md5('1238') | md5('1244') | 12345691           | 2019-09-20       | CR   | 4578.34  | 2019-09-20     | 2019-09-22 | SAP    |

  @fixture.t_link_comppk
  Scenario: [SF-TLK-COMPPK-005] Load an a non-existent Transactional Link with the rank materialisation
    Given the T_LINK_COMPPK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | TRANSACTION_NUMBER | TRANSACTION_DATE | TYPE | AMOUNT   | LOAD_DATE  | SOURCE |
      | 1234        | 4321     | 12345678           | 2019-09-19       | DR   | 2340.50  | 2019-09-21 | SAP    |
      | 1234        | 4322     | 12345679           | 2019-09-19       | CR   | 123.40   | 2019-09-22 | SAP    |
      | 1234        | 4323     | 12345680           | 2019-09-19       | DR   | 2546.23  | 2019-09-22 | SAP    |
      | 1234        | 4324     | 12345681           | 2019-09-19       | CR   | -123.40  | 2019-09-23 | SAP    |
      | 1235        | 4325     | 12345682           | 2019-09-19       | CR   | 37645.34 | 2019-09-24 | SAP    |
      | 1236        | 4326     | 12345683           | 2019-09-19       | CR   | 236.55   | 2019-09-25 | SAP    |
      | 1237        | 4327     | 12345684           | 2019-09-19       | DR   | 3567.34  | 2019-09-26 | SAP    |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the T_LINK_COMPPK t_link
    And I insert by rank into the T_LINK_COMPPK t_link
    Then the T_LINK_COMPPK table should contain expected data
      | TRANSACTION_PK                  | CUSTOMER_FK | ORDER_FK    | TRANSACTION_NUMBER | TRANSACTION_DATE | TYPE | AMOUNT   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1234\|\|4321\|\|12345678') | md5('1234') | md5('4321') | 12345678           | 2019-09-19       | DR   | 2340.50  | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1234\|\|4322\|\|12345679') | md5('1234') | md5('4322') | 12345679           | 2019-09-19       | CR   | 123.40   | 2019-09-19     | 2019-09-22 | SAP    |
      | md5('1234\|\|4323\|\|12345680') | md5('1234') | md5('4323') | 12345680           | 2019-09-19       | DR   | 2546.23  | 2019-09-19     | 2019-09-22 | SAP    |
      | md5('1234\|\|4324\|\|12345681') | md5('1234') | md5('4324') | 12345681           | 2019-09-19       | CR   | -123.40  | 2019-09-19     | 2019-09-23 | SAP    |
      | md5('1235\|\|4325\|\|12345682') | md5('1235') | md5('4325') | 12345682           | 2019-09-19       | CR   | 37645.34 | 2019-09-19     | 2019-09-24 | SAP    |
      | md5('1236\|\|4326\|\|12345683') | md5('1236') | md5('4326') | 12345683           | 2019-09-19       | CR   | 236.55   | 2019-09-19     | 2019-09-25 | SAP    |
      | md5('1237\|\|4327\|\|12345684') | md5('1237') | md5('4327') | 12345684           | 2019-09-19       | DR   | 3567.34  | 2019-09-19     | 2019-09-26 | SAP    |

  @fixture.t_link_comppk
  Scenario: [SF-TLK-COMPPK-006] Load an a non-existent Transactional Link with the incremental materialisation
    Given the T_LINK_COMPPK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | TRANSACTION_NUMBER | TRANSACTION_DATE | TYPE | AMOUNT   | LOAD_DATE  | SOURCE |
      | 1234        | 4321     | 12345678           | 2019-09-19       | DR   | 2340.50  | 2019-09-21 | SAP    |
    And I stage the STG_CUSTOMER data
    And I load the T_LINK_COMPPK t_link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | TRANSACTION_NUMBER | TRANSACTION_DATE | TYPE | AMOUNT   | LOAD_DATE  | SOURCE |
      | 1234        | 4322     | 12345679           | 2019-09-19       | CR   | 123.40   | 2019-09-22 | SAP    |
      | 1234        | 4323     | 12345680           | 2019-09-19       | DR   | 2546.23  | 2019-09-22 | SAP    |
    And I stage the STG_CUSTOMER data
    And I load the T_LINK_COMPPK t_link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | TRANSACTION_NUMBER | TRANSACTION_DATE | TYPE | AMOUNT   | LOAD_DATE  | SOURCE |
      | 1234        | 4324     | 12345681           | 2019-09-19       | CR   | -123.40  | 2019-09-23 | SAP    |
    And I stage the STG_CUSTOMER data
    And I load the T_LINK_COMPPK t_link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | TRANSACTION_NUMBER | TRANSACTION_DATE | TYPE | AMOUNT   | LOAD_DATE  | SOURCE |
      | 1235        | 4325     | 12345682           | 2019-09-19       | CR   | 37645.34 | 2019-09-24 | SAP    |
    And I stage the STG_CUSTOMER data
    And I load the T_LINK_COMPPK t_link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | TRANSACTION_NUMBER | TRANSACTION_DATE | TYPE | AMOUNT   | LOAD_DATE  | SOURCE |
      | 1236        | 4326     | 12345683           | 2019-09-19       | CR   | 236.55   | 2019-09-25 | SAP    |
    And I stage the STG_CUSTOMER data
    And I load the T_LINK_COMPPK t_link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | TRANSACTION_NUMBER | TRANSACTION_DATE | TYPE | AMOUNT   | LOAD_DATE  | SOURCE |
      | 1237        | 4327     | 12345684           | 2019-09-19       | DR   | 3567.34  | 2019-09-26 | SAP    |
    And I stage the STG_CUSTOMER data
    When I load the T_LINK_COMPPK t_link
    Then the T_LINK_COMPPK table should contain expected data
      | TRANSACTION_PK                  | CUSTOMER_FK | ORDER_FK    | TRANSACTION_NUMBER | TRANSACTION_DATE | TYPE | AMOUNT   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1234\|\|4321\|\|12345678') | md5('1234') | md5('4321') | 12345678           | 2019-09-19       | DR   | 2340.50  | 2019-09-19     | 2019-09-21 | SAP    |
      | md5('1234\|\|4322\|\|12345679') | md5('1234') | md5('4322') | 12345679           | 2019-09-19       | CR   | 123.40   | 2019-09-19     | 2019-09-22 | SAP    |
      | md5('1234\|\|4323\|\|12345680') | md5('1234') | md5('4323') | 12345680           | 2019-09-19       | DR   | 2546.23  | 2019-09-19     | 2019-09-22 | SAP    |
      | md5('1234\|\|4324\|\|12345681') | md5('1234') | md5('4324') | 12345681           | 2019-09-19       | CR   | -123.40  | 2019-09-19     | 2019-09-23 | SAP    |
      | md5('1235\|\|4325\|\|12345682') | md5('1235') | md5('4325') | 12345682           | 2019-09-19       | CR   | 37645.34 | 2019-09-19     | 2019-09-24 | SAP    |
      | md5('1236\|\|4326\|\|12345683') | md5('1236') | md5('4326') | 12345683           | 2019-09-19       | CR   | 236.55   | 2019-09-19     | 2019-09-25 | SAP    |
      | md5('1237\|\|4327\|\|12345684') | md5('1237') | md5('4327') | 12345684           | 2019-09-19       | DR   | 3567.34  | 2019-09-19     | 2019-09-26 | SAP    |

