Feature: [HUB-CK] Hubs - Collision Keys

  @fixture.single_source_hub_with_collision_key
  Scenario: [HUB-CK-01] Simple load of stage data into non existent hub with collision keys
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
      | CUSTOMER_PK      | CUSTOMER_ID | COLLISION_KEY | LOAD_DATE  | SOURCE |
      | md5('A\|\|1001') | 1001        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1002') | 1002        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1003') | 1003        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1004') | 1004        | A             | 1993-01-01 | TPCH   |

  # todo: test fails; stage macro needs an update to deal with "null NKs + non null CKs" when creating HKs
  @fixture.single_source_hub_with_collision_key
  Scenario: [HUB-CK-02] Keys with NULL or empty values are not loaded into non existent hub with collision key that does not exist
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
      | <null>      | Frida         | 1993-01-01 | TPCH   |
      |             | George        | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK      | CUSTOMER_ID | COLLISION_KEY | LOAD_DATE  | SOURCE |
      | md5('A\|\|1001') | 1001        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1002') | 1002        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1003') | 1003        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1004') | 1004        | A             | 1993-01-01 | TPCH   |

  @fixture.single_source_hub_with_collision_key
  Scenario: [HUB-CK-03] Simple load of stage data into an empty hub with collision keys
    Given the HUB hub is empty
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
      | CUSTOMER_PK      | CUSTOMER_ID | COLLISION_KEY | LOAD_DATE  | SOURCE |
      | md5('A\|\|1001') | 1001        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1002') | 1002        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1003') | 1003        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1004') | 1004        | A             | 1993-01-01 | TPCH   |

  # todo: test fails; stage macro needs an update to deal with "null NKs + non null CKs" when creating HKs
  @fixture.single_source_hub_with_collision_key
  Scenario: [HUB-CK-04] Keys with NULL or empty values are not loaded into empty hub with collision key that does not exist
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 1993-01-01 | TPCH   |
      | <null>      | Frida         | 1993-01-01 | TPCH   |
      |             | George        | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK      | CUSTOMER_ID | COLLISION_KEY | LOAD_DATE  | SOURCE |
      | md5('A\|\|1001') | 1001        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1002') | 1002        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1003') | 1003        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1004') | 1004        | A             | 1993-01-01 | TPCH   |

  @fixture.single_source_hub_with_collision_key
  Scenario: [HUB-CK-05] Simple load of stage data into a populated hub with collision keys
    Given the HUB hub is already populated with data
      | CUSTOMER_PK      | CUSTOMER_ID | COLLISION_KEY | LOAD_DATE  | SOURCE |
      | md5('A\|\|1001') | 1001        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1002') | 1002        | A             | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-02 | TPCH   |
      | 1001        | Alice         | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK      | CUSTOMER_ID | COLLISION_KEY | LOAD_DATE  | SOURCE |
      | md5('A\|\|1001') | 1001        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1002') | 1002        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1003') | 1003        | A             | 1993-01-02 | TPCH   |
      | md5('A\|\|1004') | 1004        | A             | 1993-01-02 | TPCH   |

  # todo: test fails; stage macro needs an update to deal with "null NKs + non null CKs" when creating HKs
  @fixture.single_source_hub_with_collision_key
  Scenario: [HUB-CK-06] Keys with NULL or empty values are not loaded into populated hub with collision key that does not exist
    Given the HUB hub is already populated with data
      | CUSTOMER_PK      | CUSTOMER_ID | COLLISION_KEY | LOAD_DATE  | SOURCE |
      | md5('A\|\|1001') | 1001        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1002') | 1002        | A             | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-02 | TPCH   |
      | 1001        | Alice         | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
      | <null>      | Frida         | 1993-01-02 | TPCH   |
      |             | George        | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK      | CUSTOMER_ID | COLLISION_KEY | LOAD_DATE  | SOURCE |
      | md5('A\|\|1001') | 1001        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1002') | 1002        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1003') | 1003        | A             | 1993-01-02 | TPCH   |
      | md5('A\|\|1004') | 1004        | A             | 1993-01-02 | TPCH   |

  @fixture.multi_source_hub_with_collision_key
  Scenario: [HUB-CK-07] Simple load of identical stage data from multiple sources into a non existent hub with collision keys
    Given the HUB table does not exist
    And the RAW_STAGE_A table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER_A data
    And the RAW_STAGE_B table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1012        | Bobby         | 1993-01-01 | TPCH   |
      | 1012        | Bobby         | 1993-01-01 | TPCH   |
      | 1012        | Bobby         | 1993-01-01 | TPCH   |
      | 1013        | Chaz          | 1993-01-01 | TPCH   |
      | 1014        | Don           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER_B data
    And the RAW_STAGE_C table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1022        | Boby          | 1993-01-01 | TPCH   |
      | 1022        | Boby          | 1993-01-01 | TPCH   |
      | 1022        | Boby          | 1993-01-01 | TPCH   |
      | 1023        | Chat          | 1993-01-01 | TPCH   |
      | 1024        | Doc           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER_C data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK      | CUSTOMER_ID | COLLISION_KEY | LOAD_DATE  | SOURCE |
      | md5('A\|\|1001') | 1001        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1002') | 1002        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1003') | 1003        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1004') | 1004        | A             | 1993-01-01 | TPCH   |
      | md5('B\|\|1001') | 1001        | B             | 1993-01-01 | TPCH   |
      | md5('B\|\|1012') | 1012        | B             | 1993-01-01 | TPCH   |
      | md5('B\|\|1013') | 1013        | B             | 1993-01-01 | TPCH   |
      | md5('B\|\|1014') | 1014        | B             | 1993-01-01 | TPCH   |
      | md5('C\|\|1001') | 1001        | C             | 1993-01-01 | TPCH   |
      | md5('C\|\|1022') | 1022        | C             | 1993-01-01 | TPCH   |
      | md5('C\|\|1023') | 1023        | C             | 1993-01-01 | TPCH   |
      | md5('C\|\|1024') | 1024        | C             | 1993-01-01 | TPCH   |

  # todo: test fails; stage macro needs an update to deal with "null NKs + non null CKs" when creating HKs
  @fixture.multi_source_hub_with_collision_key
  Scenario: [HUB-CK-08]  Keys with NULL or empty values are not loaded into a multi sourced non existent hub with collision keys
    Given the HUB table does not exist
    And the RAW_STAGE_A table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | <null>      | Chad          | 1993-01-01 | TPCH   |
      |             | Dom           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER_A data
    And the RAW_STAGE_B table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1012        | Bobby         | 1993-01-01 | TPCH   |
      |  <null>     | Chaz          | 1993-01-01 | TPCH   |
      |             | Don           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER_B data
    And the RAW_STAGE_C table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1022        | Boby          | 1993-01-01 | TPCH   |
      | <null>      | Chat          | 1993-01-01 | TPCH   |
      |             | Doc           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER_C data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK      | CUSTOMER_ID | COLLISION_KEY | LOAD_DATE  | SOURCE |
      | md5('A\|\|1001') | 1001        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1002') | 1002        | A             | 1993-01-01 | TPCH   |
      | md5('B\|\|1001') | 1001        | B             | 1993-01-01 | TPCH   |
      | md5('B\|\|1012') | 1012        | B             | 1993-01-01 | TPCH   |
      | md5('C\|\|1001') | 1001        | C             | 1993-01-01 | TPCH   |
      | md5('C\|\|1022') | 1022        | C             | 1993-01-01 | TPCH   |

  @fixture.multi_source_hub_with_collision_key
  Scenario: [HUB-CK-09] Simple load of identical stage data from multiple sources into an empty hub with collision keys
    Given the HUB hub is empty
    And the RAW_STAGE_A table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER_A data
    And the RAW_STAGE_B table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1012        | Bobby         | 1993-01-01 | TPCH   |
      | 1012        | Bobby         | 1993-01-01 | TPCH   |
      | 1012        | Bobby         | 1993-01-01 | TPCH   |
      | 1013        | Chaz          | 1993-01-01 | TPCH   |
      | 1014        | Don           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER_B data
    And the RAW_STAGE_C table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1022        | Boby          | 1993-01-01 | TPCH   |
      | 1022        | Boby          | 1993-01-01 | TPCH   |
      | 1022        | Boby          | 1993-01-01 | TPCH   |
      | 1023        | Chat          | 1993-01-01 | TPCH   |
      | 1024        | Doc           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER_C data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK      | CUSTOMER_ID | COLLISION_KEY | LOAD_DATE  | SOURCE |
      | md5('A\|\|1001') | 1001        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1002') | 1002        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1003') | 1003        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1004') | 1004        | A             | 1993-01-01 | TPCH   |
      | md5('B\|\|1001') | 1001        | B             | 1993-01-01 | TPCH   |
      | md5('B\|\|1012') | 1012        | B             | 1993-01-01 | TPCH   |
      | md5('B\|\|1013') | 1013        | B             | 1993-01-01 | TPCH   |
      | md5('B\|\|1014') | 1014        | B             | 1993-01-01 | TPCH   |
      | md5('C\|\|1001') | 1001        | C             | 1993-01-01 | TPCH   |
      | md5('C\|\|1022') | 1022        | C             | 1993-01-01 | TPCH   |
      | md5('C\|\|1023') | 1023        | C             | 1993-01-01 | TPCH   |
      | md5('C\|\|1024') | 1024        | C             | 1993-01-01 | TPCH   |

  # todo: test fails; stage macro needs an update to deal with "null NKs + non null CKs" when creating HKs
  @fixture.multi_source_hub_with_collision_key
  Scenario: [HUB-CK-10]  Keys with NULL or empty values are not loaded into a multi sourced empty hub with collision keys
    Given the HUB hub is empty
    And the RAW_STAGE_A table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | <null>      | Chad          | 1993-01-01 | TPCH   |
      |             | Dom           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER_A data
    And the RAW_STAGE_B table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1012        | Bobby         | 1993-01-01 | TPCH   |
      |  <null>     | Chaz          | 1993-01-01 | TPCH   |
      |             | Don           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER_B data
    And the RAW_STAGE_C table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1022        | Boby          | 1993-01-01 | TPCH   |
      | <null>      | Chat          | 1993-01-01 | TPCH   |
      |             | Doc           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER_C data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK      | CUSTOMER_ID | COLLISION_KEY | LOAD_DATE  | SOURCE |
      | md5('A\|\|1001') | 1001        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1002') | 1002        | A             | 1993-01-01 | TPCH   |
      | md5('B\|\|1001') | 1001        | B             | 1993-01-01 | TPCH   |
      | md5('B\|\|1012') | 1012        | B             | 1993-01-01 | TPCH   |
      | md5('C\|\|1001') | 1001        | C             | 1993-01-01 | TPCH   |
      | md5('C\|\|1022') | 1022        | C             | 1993-01-01 | TPCH   |

  @fixture.multi_source_hub_with_collision_key
  Scenario: [HUB-CK-11] Simple load of identical stage data from multiple sources into a populated hub with collision keys
    Given the HUB hub is already populated with data
      | CUSTOMER_PK      | CUSTOMER_ID | COLLISION_KEY | LOAD_DATE  | SOURCE |
      | md5('A\|\|1001') | 1001        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1002') | 1002        | A             | 1993-01-01 | TPCH   |
      | md5('B\|\|1001') | 1001        | B             | 1993-01-01 | TPCH   |
      | md5('B\|\|1012') | 1012        | B             | 1993-01-01 | TPCH   |
      | md5('C\|\|1001') | 1001        | C             | 1993-01-01 | TPCH   |
      | md5('C\|\|1022') | 1022        | C             | 1993-01-01 | TPCH   |
    And the RAW_STAGE_A table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-02 | TPCH   |
      | 1001        | Alice         | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER_A data
    And the RAW_STAGE_B table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-02 | TPCH   |
      | 1001        | Alice         | 1993-01-02 | TPCH   |
      | 1012        | Bobby         | 1993-01-02 | TPCH   |
      | 1012        | Bobby         | 1993-01-02 | TPCH   |
      | 1012        | Bobby         | 1993-01-02 | TPCH   |
      | 1013        | Chaz          | 1993-01-02 | TPCH   |
      | 1014        | Don           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER_B data
    And the RAW_STAGE_C table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-02 | TPCH   |
      | 1001        | Alice         | 1993-01-02 | TPCH   |
      | 1022        | Boby          | 1993-01-02 | TPCH   |
      | 1022        | Boby          | 1993-01-02 | TPCH   |
      | 1022        | Boby          | 1993-01-02 | TPCH   |
      | 1023        | Chat          | 1993-01-02 | TPCH   |
      | 1024        | Doc           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER_C data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK      | CUSTOMER_ID | COLLISION_KEY | LOAD_DATE  | SOURCE |
      | md5('A\|\|1001') | 1001        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1002') | 1002        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1003') | 1003        | A             | 1993-01-02 | TPCH   |
      | md5('A\|\|1004') | 1004        | A             | 1993-01-02 | TPCH   |
      | md5('B\|\|1001') | 1001        | B             | 1993-01-01 | TPCH   |
      | md5('B\|\|1012') | 1012        | B             | 1993-01-01 | TPCH   |
      | md5('B\|\|1013') | 1013        | B             | 1993-01-02 | TPCH   |
      | md5('B\|\|1014') | 1014        | B             | 1993-01-02 | TPCH   |
      | md5('C\|\|1001') | 1001        | C             | 1993-01-01 | TPCH   |
      | md5('C\|\|1022') | 1022        | C             | 1993-01-01 | TPCH   |
      | md5('C\|\|1023') | 1023        | C             | 1993-01-02 | TPCH   |
      | md5('C\|\|1024') | 1024        | C             | 1993-01-02 | TPCH   |

  # todo: test fails; stage macro needs an update to deal with "null NKs + non null CKs" when creating HKs
  @fixture.multi_source_hub_with_collision_key
  Scenario: [HUB-CK-12]  Keys with NULL or empty values are not loaded into a multi sourced populated hub with collision keys
    Given the HUB hub is already populated with data
      | CUSTOMER_PK      | CUSTOMER_ID | COLLISION_KEY | LOAD_DATE  | SOURCE |
      | md5('A\|\|1001') | 1001        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1002') | 1002        | A             | 1993-01-01 | TPCH   |
      | md5('B\|\|1001') | 1001        | B             | 1993-01-01 | TPCH   |
      | md5('B\|\|1012') | 1012        | B             | 1993-01-01 | TPCH   |
      | md5('C\|\|1001') | 1001        | C             | 1993-01-01 | TPCH   |
      | md5('C\|\|1022') | 1022        | C             | 1993-01-01 | TPCH   |
    And the RAW_STAGE_A table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-02 | TPCH   |
      | 1001        | Alice         | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | <null>      | Chad          | 1993-01-02 | TPCH   |
      |             | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER_A data
    And the RAW_STAGE_B table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-02 | TPCH   |
      | 1001        | Alice         | 1993-01-02 | TPCH   |
      | 1012        | Bobby         | 1993-01-02 | TPCH   |
      |  <null>     | Chaz          | 1993-01-02 | TPCH   |
      |             | Don           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER_B data
    And the RAW_STAGE_C table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-02 | TPCH   |
      | 1001        | Alice         | 1993-01-02 | TPCH   |
      | 1022        | Boby          | 1993-01-02 | TPCH   |
      | <null>      | Chat          | 1993-01-02 | TPCH   |
      |             | Doc           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER_C data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK      | CUSTOMER_ID | COLLISION_KEY | LOAD_DATE  | SOURCE |
      | md5('A\|\|1001') | 1001        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1002') | 1002        | A             | 1993-01-01 | TPCH   |
      | md5('B\|\|1001') | 1001        | B             | 1993-01-01 | TPCH   |
      | md5('B\|\|1012') | 1012        | B             | 1993-01-01 | TPCH   |
      | md5('C\|\|1001') | 1001        | C             | 1993-01-01 | TPCH   |
      | md5('C\|\|1022') | 1022        | C             | 1993-01-01 | TPCH   |

