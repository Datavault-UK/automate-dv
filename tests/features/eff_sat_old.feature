Feature: Effectivity Satellites
  
    Scenario: [BASE-LOAD] Empty Load with an Effectivity Satellite that does not exist
      Given an empty TEST_LINK_CUSTOMER_ORDER
      And a TEST_EFF_CUSTOMER_ORDER table does not exist
      And there was staging data loaded on 2020-01-10
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | EFFECTIVE_FROM |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | md5('1000') | 1000        | md5('AAA') | AAA      | 2020-01-09     |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | md5('2000') | 2000        | md5('BBB') | BBB      | 2020-01-09     |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | md5('3000') | 3000        | md5('CCC') | CCC      | 2020-01-09     |
      When I run the first Load Cycle for 2020-01-10
      Then I expect the following TEST_LINK_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      And I expect the following TEST_EFF_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |

    Scenario: [BASE-LOAD] Empty Load with existing Effectivity Satellite
      Given an empty TEST_LINK_CUSTOMER_ORDER
      And an empty TEST_EFF_CUSTOMER_ORDER
      And there was staging data loaded on 2020-01-10
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | EFFECTIVE_FROM |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | md5('1000') | 1000        | md5('AAA') | AAA      | 2020-01-09     |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | md5('2000') | 2000        | md5('BBB') | BBB      | 2020-01-09     |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | md5('3000') | 3000        | md5('CCC') | CCC      | 2020-01-09     |
      When I run the first Load Cycle for 2020-01-10
      Then I expect the following TEST_LINK_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      And I expect the following TEST_EFF_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |


    Scenario: [INCREMENTAL-LOAD] No Effectivity Change
      Given there is a TEST_LINK_CUSTOMER_ORDER table
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      And there is a TEST_EFF_CUSTOMER_ORDER table
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      And there was staging data loaded on 2020-01-11
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | EFFECTIVE_FROM |
      | md5('1000\|\|AAA') | 2020-01-11 | orders | md5('1000') | 1000        | md5('AAA') | AAA      | 2020-01-10     |
      | md5('2000\|\|BBB') | 2020-01-11 | orders | md5('2000') | 2000        | md5('BBB') | BBB      | 2020-01-10     |
      | md5('3000\|\|CCC') | 2020-01-11 | orders | md5('3000') | 3000        | md5('CCC') | CCC      | 2020-01-10     |
      When I run a Load Cycle for 2020-01-11
      Then I expect the following TEST_LINK_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      And I expect the following TEST_EFF_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |


    Scenario: [INCREMENTAL-LOAD] New Link Added
      Given there is a TEST_LINK_CUSTOMER_ORDER table
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      And there is a TEST_EFF_CUSTOMER_ORDER table
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      And there was staging data loaded on 2020-01-11
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | EFFECTIVE_FROM |
      | md5('1000\|\|AAA') | 2020-01-11 | orders | md5('1000') | 1000        | md5('AAA') | AAA      | 2020-01-09     |
      | md5('2000\|\|BBB') | 2020-01-11 | orders | md5('2000') | 2000        | md5('BBB') | BBB      | 2020-01-09     |
      | md5('3000\|\|CCC') | 2020-01-11 | orders | md5('3000') | 3000        | md5('CCC') | CCC      | 2020-01-09     |
      | md5('4000\|\|DDD') | 2020-01-11 | orders | md5('4000') | 4000        | md5('DDD') | DDD      | 2020-01-10     |
      | md5('5000\|\|EEE') | 2020-01-11 | orders | md5('5000') | 5000        | md5('EEE') | EEE      | 2020-01-10     |
      When I run a Load Cycle for 2020-01-11
      Then I expect the following TEST_LINK_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | orders |
      And I expect the following TEST_EFF_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('4000\|\|DDD') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      | md5('5000\|\|EEE') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |


    Scenario: [INCREMENTAL-LOAD] Link is Changed
      Given there is a TEST_LINK_CUSTOMER_ORDER table
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | orders |
      And there is a TEST_EFF_CUSTOMER_ORDER table
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('4000\|\|DDD') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      | md5('5000\|\|EEE') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      And there was staging data loaded on 2020-01-12
      | CUSTOMER_ORDER_PK  | LOADDATE   | Source | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | EFFECTIVE_FROM |
      | md5('1000\|\|AAA') | 2020-01-12 | orders | md5('1000') | 1000        | md5('AAA') | AAA      | 2020-01-11     |
      | md5('2000\|\|BBB') | 2020-01-12 | orders | md5('2000') | 2000        | md5('BBB') | BBB      | 2020-01-11     |
      | md5('3000\|\|CCC') | 2020-01-12 | orders | md5('3000') | 3000        | md5('CCC') | CCC      | 2020-01-11     |
      | md5('4000\|\|FFF') | 2020-01-12 | orders | md5('4000') | 4000        | md5('FFF') | FFF      | 2020-01-11     |
      | md5('5000\|\|GGG') | 2020-01-12 | orders | md5('5000') | 5000        | md5('GGG') | GGG      | 2020-01-11     |
      When I run a Load Cycle for 2020-01-12
      Then I expect the following TEST_LINK_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | orders |
      | md5('4000\|\|FFF') | md5('4000') | md5('FFF') | 2020-01-12 | orders |
      | md5('5000\|\|GGG') | md5('5000') | md5('GGG') | 2020-01-12 | orders |
      And I expect the following TEST_EFF_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('4000\|\|DDD') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      | md5('5000\|\|EEE') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      | md5('4000\|\|DDD') | 2020-01-12 | orders | 2020-01-10     | 2020-01-10     | 2020-01-11   |
      | md5('5000\|\|EEE') | 2020-01-12 | orders | 2020-01-10     | 2020-01-10     | 2020-01-11   |
      | md5('4000\|\|FFF') | 2020-01-12 | orders | 2020-01-11     | 2020-01-11     | 9999-12-31   |
      | md5('5000\|\|GGG') | 2020-01-12 | orders | 2020-01-11     | 2020-01-11     | 9999-12-31   |



    Scenario: [INCREMENTAL-LOAD] 2 loads, Link is Changed Back Again
      Given there is a TEST_LINK_CUSTOMER_ORDER table
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-11 | orders |
      | md5('4000\|\|FFF') | md5('4000') | md5('FFF') | 2020-01-12 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | orders |
      | md5('5000\|\|GGG') | md5('5000') | md5('GGG') | 2020-01-12 | orders |
      | md5('7000\|\|III') | md5('7000') | md5('III') | 2020-01-11 | orders |
      | md5('7000\|\|JJJ') | md5('7000') | md5('JJJ') | 2020-01-10 | orders |
      And there is a TEST_EFF_CUSTOMER_ORDER table
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('4000\|\|DDD') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      | md5('4000\|\|FFF') | 2020-01-12 | orders | 2020-01-11     | 2020-01-11     | 9999-12-31   |
      | md5('4000\|\|DDD') | 2020-01-12 | orders | 2020-01-11     | 2020-01-10     | 2020-01-11   |
      | md5('5000\|\|EEE') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      | md5('5000\|\|GGG') | 2020-01-12 | orders | 2020-01-11     | 2020-01-11     | 9999-12-31   |
      | md5('5000\|\|EEE') | 2020-01-12 | orders | 2020-01-10     | 2020-01-10     | 2020-01-11   |
      | md5('7000\|\|JJJ') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('7000\|\|III') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      | md5('7000\|\|JJJ') | 2020-01-11 | orders | 2020-01-10     | 2020-01-09     | 2020-01-10   |
      | md5('7000\|\|III') | 2020-01-12 | orders | 2020-01-11     | 2020-01-10     | 2020-01-11   |
      And there was staging data loaded on 2020-01-13
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | EFFECTIVE_FROM |
      | md5('1000\|\|AAA') | 2020-01-13 | orders | md5('1000') | 1000        | md5('AAA') | AAA      | 2020-01-12     |
      | md5('2000\|\|BBB') | 2020-01-13 | orders | md5('2000') | 2000        | md5('BBB') | BBB      | 2020-01-12     |
      | md5('3000\|\|CCC') | 2020-01-13 | orders | md5('3000') | 3000        | md5('CCC') | CCC      | 2020-01-12     |
      | md5('4000\|\|DDD') | 2020-01-13 | orders | md5('4000') | 4000        | md5('DDD') | DDD      | 2020-01-12     |
      | md5('5000\|\|EEE') | 2020-01-13 | orders | md5('5000') | 5000        | md5('EEE') | EEE      | 2020-01-12     |
      | md5('6000\|\|HHH') | 2020-01-13 | orders | md5('6000') | 6000        | md5('HHH') | HHH      | 2020-01-12     |
      | md5('7000\|\|JJJ') | 2020-01-13 | orders | md5('7000') | 7000        | md5('JJJ') | JJJ      | 2020-01-12     |
      When I run a Load Cycle for 2020-01-13
      Then I expect the following TEST_LINK_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-11 | orders |
      | md5('4000\|\|FFF') | md5('4000') | md5('FFF') | 2020-01-12 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | orders |
      | md5('5000\|\|GGG') | md5('5000') | md5('GGG') | 2020-01-12 | orders |
      | md5('6000\|\|HHH') | md5('6000') | md5('HHH') | 2020-01-13 | orders |
      | md5('7000\|\|III') | md5('7000') | md5('III') | 2020-01-11 | orders |
      | md5('7000\|\|JJJ') | md5('7000') | md5('JJJ') | 2020-01-10 | orders |
      And I expect the following TEST_EFF_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('4000\|\|DDD') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      | md5('4000\|\|DDD') | 2020-01-12 | orders | 2020-01-11     | 2020-01-10     | 2020-01-11   |
      | md5('4000\|\|FFF') | 2020-01-12 | orders | 2020-01-11     | 2020-01-11     | 9999-12-31   |
      | md5('4000\|\|FFF') | 2020-01-13 | orders | 2020-01-11     | 2020-01-11     | 2020-01-12   |
      | md5('4000\|\|DDD') | 2020-01-13 | orders | 2020-01-12     | 2020-01-12     | 9999-12-31   |
      | md5('5000\|\|EEE') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      | md5('5000\|\|EEE') | 2020-01-12 | orders | 2020-01-10     | 2020-01-10     | 2020-01-11   |
      | md5('5000\|\|GGG') | 2020-01-12 | orders | 2020-01-11     | 2020-01-11     | 9999-12-31   |
      | md5('5000\|\|GGG') | 2020-01-13 | orders | 2020-01-11     | 2020-01-11     | 2020-01-12   |
      | md5('5000\|\|EEE') | 2020-01-13 | orders | 2020-01-12     | 2020-01-12     | 9999-12-31   |
      | md5('6000\|\|HHH') | 2020-01-13 | orders | 2020-01-12     | 2020-01-12     | 9999-12-31   |
      | md5('7000\|\|JJJ') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('7000\|\|III') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      | md5('7000\|\|JJJ') | 2020-01-11 | orders | 2020-01-10     | 2020-01-09     | 2020-01-10   |
      | md5('7000\|\|III') | 2020-01-12 | orders | 2020-01-11     | 2020-01-10     | 2020-01-11   |
      | md5('7000\|\|JJJ') | 2020-01-13 | orders | 2020-01-12     | 2020-01-12     | 9999-12-31   |
      
    Scenario: [NULL-SFK] No New Eff Sat Added if Secondary Foreign Key is NULL and Latest EFF Sat with Common DFK is Closed.
      Given there is a TEST_LINK_CUSTOMER_ORDER table
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | orders |
      And there is a TEST_EFF_CUSTOMER_ORDER table
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('4000\|\|DDD') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      | md5('5000\|\|EEE') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      And there was staging data loaded on 2020-01-13
      | CUSTOMER_ORDER_PK   | LOADDATE   | Source | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | EFFECTIVE_FROM |
      | md5('1000\|\|AAA')  | 2020-01-13 | orders | md5('1000') | 1000        | md5('AAA') | AAA      | 2020-01-11     |
      | md5('2000\|\|BBB')  | 2020-01-13 | orders | md5('2000') | 2000        | md5('BBB') | BBB      | 2020-01-11     |
      | md5('3000\|\|CCC')  | 2020-01-13 | orders | md5('3000') | 3000        | md5('CCC') | CCC      | 2020-01-11     |
      | md5('4000\|\|DDD')  | 2020-01-13 | orders | md5('4000') | 4000        | md5('DDD') | DDD      | 2020-01-11     |
      | <null>              | 2020-01-13 | orders | md5('5000') | 5000        | <null>     | <null>   | 2020-01-12     |
      When I run a Load Cycle for 2020-01-13
      Then I expect the following TEST_LINK_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | orders |
      And I expect the following TEST_EFF_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('4000\|\|DDD') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      | md5('5000\|\|EEE') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      | md5('5000\|\|EEE') | 2020-01-13 | orders | 2020-01-10     | 2020-01-10     | 2020-01-12   |

    Scenario: [NULL-DFK] No New Eff Sat Added if Driving Foreign Key is NULL and Latest EFF Sat Remain Open.
      Given there is a TEST_LINK_CUSTOMER_ORDER table
       | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
       | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
       | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
       | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
       | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-11 | orders |
       | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | orders |
      And there is a TEST_EFF_CUSTOMER_ORDER table
       | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
       | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
       | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
       | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
       | md5('4000\|\|DDD') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
       | md5('5000\|\|EEE') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      And there was staging data loaded on 2020-01-13
       | CUSTOMER_ORDER_PK   | LOADDATE   | Source | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | EFFECTIVE_FROM |
       | md5('1000\|\|AAA')  | 2020-01-13 | orders | md5('1000') | 1000        | md5('AAA') | AAA      | 2020-01-11     |
       | md5('2000\|\|BBB')  | 2020-01-13 | orders | md5('2000') | 2000        | md5('BBB') | BBB      | 2020-01-11     |
       | md5('3000\|\|CCC')  | 2020-01-13 | orders | md5('3000') | 3000        | md5('CCC') | CCC      | 2020-01-11     |
       | md5('4000\|\|DDD')  | 2020-01-13 | orders | md5('4000') | 4000        | md5('DDD') | DDD      | 2020-01-11     |
       | <null>              | 2020-01-13 | orders | <null>      | <null>      | md5('EEE') | EEE      | 2020-01-12     |
      When I run a Load Cycle for 2020-01-13
      Then I expect the following TEST_LINK_CUSTOMER_ORDER
       | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
       | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
       | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
       | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
       | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-11 | orders |
       | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | orders |
      And I expect the following TEST_EFF_CUSTOMER_ORDER
       | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
       | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
       | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
       | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
       | md5('4000\|\|DDD') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
       | md5('5000\|\|EEE') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |

    Scenario: [MULTIPART-KEYS] Driving Key and Secondary Key are multipart keys.
      Given there is data in TEST_LINK_CUSTOMER_ORDER_MULTIPART
        | CUSTOMER_ORDER_PK                                | CUSTOMER_FK | NATION_FK  | ORDER_FK   | PRODUCT_FK    | ORGANISATION_FK  | LOADDATE   | SOURCE |
        | md5('1000\|\|DEU\|\|AAA\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('DEU') | md5('AAA') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-12 | orders |
        | md5('2000\|\|GBR\|\|BBB\|\|ONLINE\|\|DATAVAULT') | md5('2000') | md5('GBR') | md5('BBB') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-13 | orders |
        | md5('3000\|\|AUS\|\|CCC\|\|SHOP\|\|BUSSTHINK')   | md5('3000') | md5('AUS') | md5('CCC') | md5('SHOP')   | md5('BUSSTHINK') | 2020-01-13 | orders |
        | md5('4000\|\|POL\|\|DDD\|\|ONLINE\|\|BUSSTHINK') | md5('4000') | md5('POL') | md5('DDD') | md5('ONLINE') | md5('BUSSTHINK') | 2020-01-13 | orders |
        | md5('4000\|\|POL\|\|EEE\|\|ONLINE\|\|BUSSTHINK') | md5('4000') | md5('POL') | md5('EEE') | md5('ONLINE') | md5('BUSSTHINK') | 2020-01-13 | orders |
        | md5('5000\|\|SPA\|\|FFF\|\|SHOP\|\|DATAVAULT')   | md5('5000') | md5('SPA') | md5('FFF') | md5('SHOP')   | md5('DATAVAULT') | 2020-01-13 | orders |
      And there is data in TEST_EFF_CUSTOMER_ORDER_MULTIPART
        | CUSTOMER_ORDER_PK                                | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
        | md5('1000\|\|DEU\|\|AAA\|\|ONLINE\|\|DATAVAULT') | 2020-01-12 | orders | 2020-01-11     | 2020-01-11     | 9999-12-31   |
        | md5('2000\|\|GBR\|\|BBB\|\|ONLINE\|\|DATAVAULT') | 2020-01-13 | orders | 2020-01-12     | 2020-01-12     | 9999-12-31   |
        | md5('3000\|\|AUS\|\|CCC\|\|SHOP\|\|BUSSTHINK')   | 2020-01-13 | orders | 2020-01-12     | 2020-01-12     | 9999-12-31   |
        | md5('4000\|\|POL\|\|DDD\|\|ONLINE\|\|BUSSTHINK') | 2020-01-13 | orders | 2020-01-12     | 2020-01-12     | 9999-12-31   |
        | md5('4000\|\|POL\|\|DDD\|\|ONLINE\|\|BUSSTHINK') | 2020-01-13 | orders | 2020-01-12     | 2020-01-12     | 2020-01-13   |
        | md5('4000\|\|POL\|\|EEE\|\|ONLINE\|\|BUSSTHINK') | 2020-01-13 | orders | 2020-01-13     | 2020-01-13     | 9999-12-31   |
        | md5('5000\|\|SPA\|\|FFF\|\|SHOP\|\|DATAVAULT')   | 2020-01-13 | orders | 2020-01-12     | 2020-01-12     | 9999-12-31   |
      And the multipart staging_data loaded on 2020-01-14
        | CUSTOMER_ORDER_PK                                | LOADDATE   | Source | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | NATION_FK  | NATION_ID | PRODUCT_FK    | PRODUCT_GROUP | ORGANISATION_FK  | ORGANISATION_ID | EFFECTIVE_FROM |
        | md5('1000\|\|DEU\|\|AAA\|\|ONLINE\|\|DATAVAULT') | 2020-01-14 | orders | md5('1000') | 1000        | md5('AAA') | AAA      | md5('DEU') | DEU       | md5('ONLINE') | ONLINE        | md5('DATAVAULT') | DATAVAULT       | 2020-01-11     |
        | md5('2000\|\|GBR\|\|BBB\|\|ONLINE\|\|DATAVAULT') | 2020-01-14 | orders | md5('2000') | 2000        | md5('BBB') | BBB      | md5('GBR') | GBR       | md5('ONLINE') | ONLINE        | md5('DATAVAULT') | DATAVAULT       | 2020-01-12     |
        | md5('3000\|\|AUS\|\|CCC\|\|SHOP\|\|BUSSTHINK')   | 2020-01-14 | orders | md5('3000') | 3000        | md5('CCC') | CCC      | md5('AUS') | AUS       | md5('SHOP')   | SHOP          | md5('BUSSTHINK') | BUSSTHINK       | 2020-01-12     |
        | md5('4000\|\|POL\|\|DDD\|\|ONLINE\|\|BUSSTHINK') | 2020-01-14 | orders | md5('4000') | 4000        | md5('DDD') | DDD      | md5('POL') | POL       | md5('ONLINE') | ONLINE        | md5('BUSSTHINK') | BUSSTHINK       | 2020-01-13     |
        | md5('5000\|\|FRA\|\|FFF\|\|SHOP\|\|DATAVAULT')   | 2020-01-14 | orders | md5('5000') | 5000        | md5('FFF') | FFF      | md5('FRA') | FRA       | md5('SHOP')   | SHOP          | md5('DATAVAULT') | DATAVAULT       | 2020-01-13     |
        | md5('6000\|\|FRA\|\|GGG\|\|SHOP\|\|DATAVAULT')   | 2020-01-14 | orders | md5('6000') | 6000        | md5('GGG') | GGG      | md5('FRA') | FRA       | md5('SHOP')   | SHOP          | md5('DATAVAULT') | DATAVAULT       | 2020-01-13     |
      When I run a multipart Load Cycle for 2020-01-14
      Then I expect to see the following multipart TEST_LINK_CUSTOMER_ORDER_MULTIPART
        | CUSTOMER_ORDER_PK                                | CUSTOMER_FK | NATION_FK  | ORDER_FK   | PRODUCT_FK    | ORGANISATION_FK  | LOADDATE   | SOURCE |
        | md5('1000\|\|DEU\|\|AAA\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('DEU') | md5('AAA') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-12 | orders |
        | md5('2000\|\|GBR\|\|BBB\|\|ONLINE\|\|DATAVAULT') | md5('2000') | md5('GBR') | md5('BBB') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-13 | orders |
        | md5('3000\|\|AUS\|\|CCC\|\|SHOP\|\|BUSSTHINK')   | md5('3000') | md5('AUS') | md5('CCC') | md5('SHOP')   | md5('BUSSTHINK') | 2020-01-13 | orders |
        | md5('4000\|\|POL\|\|DDD\|\|ONLINE\|\|BUSSTHINK') | md5('4000') | md5('POL') | md5('DDD') | md5('ONLINE') | md5('BUSSTHINK') | 2020-01-13 | orders |
        | md5('4000\|\|POL\|\|EEE\|\|ONLINE\|\|BUSSTHINK') | md5('4000') | md5('POL') | md5('EEE') | md5('ONLINE') | md5('BUSSTHINK') | 2020-01-13 | orders |
        | md5('5000\|\|SPA\|\|FFF\|\|SHOP\|\|DATAVAULT')   | md5('5000') | md5('SPA') | md5('FFF') | md5('SHOP')   | md5('DATAVAULT') | 2020-01-13 | orders |
        | md5('5000\|\|FRA\|\|FFF\|\|SHOP\|\|DATAVAULT')   | md5('5000') | md5('FRA') | md5('FFF') | md5('SHOP')   | md5('DATAVAULT') | 2020-01-14 | orders |
        | md5('6000\|\|FRA\|\|GGG\|\|SHOP\|\|DATAVAULT')   | md5('6000') | md5('FRA') | md5('GGG') | md5('SHOP')   | md5('DATAVAULT') | 2020-01-14 | orders |
      And I expect to see the following multipart TEST_EFF_CUSTOMER_ORDER_MULTIPART
        | CUSTOMER_ORDER_PK                                | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
        | md5('1000\|\|DEU\|\|AAA\|\|ONLINE\|\|DATAVAULT') | 2020-01-12 | orders | 2020-01-11     | 2020-01-11     | 9999-12-31   |
        | md5('2000\|\|GBR\|\|BBB\|\|ONLINE\|\|DATAVAULT') | 2020-01-13 | orders | 2020-01-12     | 2020-01-12     | 9999-12-31   |
        | md5('3000\|\|AUS\|\|CCC\|\|SHOP\|\|BUSSTHINK')   | 2020-01-13 | orders | 2020-01-12     | 2020-01-12     | 9999-12-31   |
        | md5('4000\|\|POL\|\|DDD\|\|ONLINE\|\|BUSSTHINK') | 2020-01-13 | orders | 2020-01-12     | 2020-01-12     | 9999-12-31   |
        | md5('4000\|\|POL\|\|DDD\|\|ONLINE\|\|BUSSTHINK') | 2020-01-13 | orders | 2020-01-12     | 2020-01-12     | 2020-01-13   |
        | md5('4000\|\|POL\|\|EEE\|\|ONLINE\|\|BUSSTHINK') | 2020-01-13 | orders | 2020-01-13     | 2020-01-13     | 9999-12-31   |
        | md5('4000\|\|POL\|\|EEE\|\|ONLINE\|\|BUSSTHINK') | 2020-01-14 | orders | 2020-01-13     | 2020-01-13     | 2020-01-13   |
        | md5('4000\|\|POL\|\|DDD\|\|ONLINE\|\|BUSSTHINK') | 2020-01-14 | orders | 2020-01-13     | 2020-01-13     | 9999-12-31   |
        | md5('5000\|\|SPA\|\|FFF\|\|SHOP\|\|DATAVAULT')   | 2020-01-13 | orders | 2020-01-12     | 2020-01-12     | 9999-12-31   |
        | md5('5000\|\|FRA\|\|FFF\|\|SHOP\|\|DATAVAULT')   | 2020-01-14 | orders | 2020-01-13     | 2020-01-13     | 9999-12-31   |
        | md5('6000\|\|FRA\|\|GGG\|\|SHOP\|\|DATAVAULT')   | 2020-01-14 | orders | 2020-01-13     | 2020-01-13     | 9999-12-31   |
