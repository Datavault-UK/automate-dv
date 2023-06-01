Feature: [EFF-SAT-COMP-PK] Effectivity Satellites with composite keys

  @fixture.enable_auto_end_date
  @fixture.eff_satellite
  Scenario: [EFF-COMP-PK-01] Load data into a non-existent effectivity satellite with multiple foreign keys
    Given the EFF_SAT_COMP_FK table does not exist
    And the RAW_STAGE_COMP table contains data
      | CUSTOMER_ID | ORDER_ID | PART_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE      |
      | 1000        | AAA      | CAR     | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders      |
      | 2000        | BBB      | BUS     | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders      |
      | 3000        | CCC      | VAN     | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders      |
      | 3000        | CCC      | <null>  | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | other_place |
    And I stage the STG_CUSTOMER_COMP data
    When I load the EFF_SAT_COMP_FK eff_sat
    Then the EFF_SAT_COMP_FK table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | PART_PK    | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | md5('CAR') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | md5('BUS') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | md5('VAN') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite
  Scenario: [EFF-COMP-PK-02] New Link record Added with multiple driving keys
    Given the EFF_SAT_COMP_DK eff_sat is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | PART_PK    | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | md5('CAR') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | md5('BUS') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | md5('VAN') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    And the RAW_STAGE_COMP table contains data
      | CUSTOMER_ID | ORDER_ID | PART_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | CAR     | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-11 | orders |
      | 2000        | BBB      | BUS     | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-11 | orders |
      | 3000        | CCC      | VAN     | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-11 | orders |
      | 4000        | DDD      | BIKE    | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
      | 6000        | EEE      | BIKE    | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
      | 5000        | EEE      | <null>  | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    And I stage the STG_CUSTOMER_COMP data
    When I load the EFF_SAT_COMP_DK eff_sat
    Then the EFF_SAT_COMP_DK table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | PART_PK     | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | md5('CAR')  | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | md5('BUS')  | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | md5('VAN')  | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | md5('BIKE') | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
      | md5('6000\|\|EEE') | md5('6000') | md5('EEE') | md5('BIKE') | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite
  Scenario: [EFF-COMP-PK-03] Link is Changed and eff sat has multiple primary keys
    Given the EFF_SAT_COMP_PK eff_sat is already populated with data
      | CUSTOMER_ORDER_PK  | ORDER_PART_PK     | CUSTOMER_PK | ORDER_PK   | PART_PK    | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('AAA\|\|CAR') | md5('1000') | md5('AAA') | md5('CAR') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('BBB\|\|BUS') | md5('2000') | md5('BBB') | md5('BUS') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('CCC\|\|VAN') | md5('3000') | md5('CCC') | md5('VAN') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    And the RAW_STAGE_COMP table contains data
      | CUSTOMER_ID | ORDER_ID | PART_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 4000        | CCC      | VAN     | 2020-01-11 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
      | 4000        | BBB      | BUS     | 2020-01-12 | 9999-12-31 | 2020-01-12     | 2020-01-12 | orders |
    And I stage the STG_CUSTOMER_COMP data
    When I load the EFF_SAT_COMP_PK eff_sat
    Then the EFF_SAT_COMP_PK table should contain expected data
      | CUSTOMER_ORDER_PK  | ORDER_PART_PK     | CUSTOMER_PK | ORDER_PK   | PART_PK    | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('AAA\|\|CAR') | md5('1000') | md5('AAA') | md5('CAR') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('BBB\|\|BUS') | md5('2000') | md5('BBB') | md5('BUS') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('CCC\|\|VAN') | md5('3000') | md5('CCC') | md5('VAN') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('CCC\|\|VAN') | md5('3000') | md5('CCC') | md5('VAN') | 2020-01-09 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
      | md5('4000\|\|CCC') | md5('CCC\|\|VAN') | md5('4000') | md5('CCC') | md5('VAN') | 2020-01-11 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
      | md5('2000\|\|BBB') | md5('BBB\|\|BUS') | md5('2000') | md5('BBB') | md5('BUS') | 2020-01-09 | 2020-01-12 | 2020-01-12     | 2020-01-12 | orders |
      | md5('4000\|\|BBB') | md5('BBB\|\|BUS') | md5('4000') | md5('BBB') | md5('BUS') | 2020-01-12 | 9999-12-31 | 2020-01-12     | 2020-01-12 | orders |