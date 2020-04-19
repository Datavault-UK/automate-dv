Feature: Effectivity Satellites

    ===========================================================================
    Effectivity Satellites are used to record when foreign keys change.
    They record the time period when LINKS start and end effectivity.

    The Driving Key problem:
    - say we have a table A
    - it contains a column, a foreign key link to table B
    - in the data vault we model this as a link - HUB_A, HUB_B, LINK_AB
    - the link has no from and to dates, it declares that there is a link
      between A and B for a reason, that's all
    - so we create an Effectivity_satellite off LINK_AB
    - this contains information about the status of the LINK_AB
    - so we have 2 columns, effective_From, effective_to, plus a hashdiff (of
      these 2 columns), etc.
    - when the effectivity is created we set the effective_from date, and leave
      the effective_to empty (or set it to year 9999....)

    - now imagine, the foreign key link in table A changes for some reason,
      pointing to another record in B
    - the foreign key column in the row changes to point to the new record,
      it no longer points to the old record
    - we have 2 items of info - the new key and the ending of the old key
    - perhaps we have an order, and we want to change who placed the order

    - The load will create a new LINK_AB record with an effective_from date
    - so our old link now needs to be end-dated otherwise we have 2 open links

    - Ideally, we should end-date the original link inside the same
      transaction to avoid 2 SQL queries and possibly getting out of step

    - In any link there are 2 fk columns
    - One will change, the other remain constant
    - The one that does not change is called the DRIVING KEY
    - The one that does change is called the DRIVEN KEY

    - To make this work we need to:
        - Create the new link and effectivity satellite as usual
        - union it with the recording of the effectivity end date on the old link

    - Regular load:
        - LINK record uses the regular load pattern, no changes needed there
        - EFFECTIVITY_SATELLITE for the new link:
            - This is a regular satellite load,
            - effective_from is set to the business date
            - effective_to is set to the constant '9999-12-31 23:23:59'
    - EFFECTIVITY SATELLITE for the now ended link:
        - Find the records that are candidates for end-dating
            - Get the primary key for LINKS, where the list of DRIVING KEY
              / DRIVEN KEY pairs that are in the LINK table do not match the
              DRIVING KEY / DRIVEN KEY pairs provided in the staging table
            - We assume that if we have no information about a particular
              driving key in the stage table then we cannot take action, i.e.
              exclude any records where DRIVING KEYS are in the LINK but not in
              the Stage (use an equi-join).
            - We've effectively found the list of satellites to update.
            - So insert new satellite records, where the new satellites copy
              across the old satellites effective_from dates, insert an proper
              end_date, and calculate a new HASHDIFF
    - Union together these two queries and the update will cover off opening
      and closing of each LINK.

      HUB_CUSTOMER (customer_pk, source, ldts, customer_id)
      HUB_ORDER (order_pk, source, ldts, order_id)
      LINK_CUSTOMER_ORDER
        (customer_order_pk, customer_fk, order_Fk, source, ldts)
      EFF_CUSTOMER_ORDER
        (customer_order_pk, ldts, source, hashdiff, eff_from, eff_to)

      STAGE (customer_pk, customer_id, order_pk, order_id, customer_order_pk,
      ldts, source, effective_from)

    ===========================================================================

    Scenario: [BASE-LOAD] Empty Load with an Effectivity Satellite that does not exist
      Given an empty Link_Customer_Order
      And a EFF_CUSTOMER_ORDER table does not exist
      And staging_data loaded on 2020-01-10
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | EFFECTIVE_FROM |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | md5('1000') | 1000        | md5('AAA') | AAA      | 2020-01-09     |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | md5('2000') | 2000        | md5('BBB') | BBB      | 2020-01-09     |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | md5('3000') | 3000        | md5('CCC') | CCC      | 2020-01-09     |
      When I run the first Load Cycle for 2020-01-10
      Then I expect the following LINK_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      And I expect the following EFF_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |

    Scenario: [BASE-LOAD] Empty Load with existing Effectivity Satellite
      Given an empty Link_Customer_Order
      And an empty EFF_CUSTOMER_ORDER
      And staging_data loaded on 2020-01-10
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | EFFECTIVE_FROM |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | md5('1000') | 1000        | md5('AAA') | AAA      | 2020-01-09     |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | md5('2000') | 2000        | md5('BBB') | BBB      | 2020-01-09     |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | md5('3000') | 3000        | md5('CCC') | CCC      | 2020-01-09     |
      When I run the first Load Cycle for 2020-01-10
      Then I expect the following LINK_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      And I expect the following EFF_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |


    Scenario: [SUBSEQUENT-LOAD] No Effectivity Change
      Given there is a LINK_CUSTOMER_ORDER table
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      And there is a EFF_CUSTOMER_ORDER table
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      And staging_data loaded on 2020-01-11
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | EFFECTIVE_FROM |
      | md5('1000\|\|AAA') | 2020-01-11 | orders | md5('1000') | 1000        | md5('AAA') | AAA      | 2020-01-10     |
      | md5('2000\|\|BBB') | 2020-01-11 | orders | md5('2000') | 2000        | md5('BBB') | BBB      | 2020-01-10     |
      | md5('3000\|\|CCC') | 2020-01-11 | orders | md5('3000') | 3000        | md5('CCC') | CCC      | 2020-01-10     |
      When I run a Load Cycle for 2020-01-11
      Then I expect the following LINK_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      And I expect the following EFF_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |


    Scenario: [SUBSEQUENT-LOAD] New Link Added
      Given there is a LINK_CUSTOMER_ORDER table
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      And there is a EFF_CUSTOMER_ORDER table
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      And staging_data loaded on 2020-01-11
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | EFFECTIVE_FROM |
      | md5('1000\|\|AAA') | 2020-01-11 | orders | md5('1000') | 1000        | md5('AAA') | AAA      | 2020-01-09     |
      | md5('2000\|\|BBB') | 2020-01-11 | orders | md5('2000') | 2000        | md5('BBB') | BBB      | 2020-01-09     |
      | md5('3000\|\|CCC') | 2020-01-11 | orders | md5('3000') | 3000        | md5('CCC') | CCC      | 2020-01-09     |
      | md5('4000\|\|DDD') | 2020-01-11 | orders | md5('4000') | 4000        | md5('DDD') | DDD      | 2020-01-10     |
      | md5('5000\|\|EEE') | 2020-01-11 | orders | md5('5000') | 5000        | md5('EEE') | EEE      | 2020-01-10     |
      When I run a Load Cycle for 2020-01-11
      Then I expect the following LINK_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | orders |
      And I expect the following EFF_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('4000\|\|DDD') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      | md5('5000\|\|EEE') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |


    Scenario: [SUBSEQUENT-LOAD] Link is Changed
      Given there is a LINK_CUSTOMER_ORDER table
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | orders |
      And there is a EFF_CUSTOMER_ORDER table
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('4000\|\|DDD') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      | md5('5000\|\|EEE') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      And staging_data loaded on 2020-01-12
      | CUSTOMER_ORDER_PK  | LOADDATE   | Source | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | EFFECTIVE_FROM |
      | md5('1000\|\|AAA') | 2020-01-12 | orders | md5('1000') | 1000        | md5('AAA') | AAA      | 2020-01-11     |
      | md5('2000\|\|BBB') | 2020-01-12 | orders | md5('2000') | 2000        | md5('BBB') | BBB      | 2020-01-11     |
      | md5('3000\|\|CCC') | 2020-01-12 | orders | md5('3000') | 3000        | md5('CCC') | CCC      | 2020-01-11     |
      | md5('4000\|\|FFF') | 2020-01-12 | orders | md5('4000') | 4000        | md5('FFF') | FFF      | 2020-01-11     |
      | md5('5000\|\|GGG') | 2020-01-12 | orders | md5('5000') | 5000        | md5('GGG') | GGG      | 2020-01-11     |
      When I run a Load Cycle for 2020-01-12
      Then I expect the following LINK_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | orders |
      | md5('4000\|\|FFF') | md5('4000') | md5('FFF') | 2020-01-12 | orders |
      | md5('5000\|\|GGG') | md5('5000') | md5('GGG') | 2020-01-12 | orders |
      And I expect the following EFF_CUSTOMER_ORDER
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



    Scenario: [SUBSEQUENT-LOAD] 2 loads, Link is Changed Back Again
      Given there is a LINK_CUSTOMER_ORDER table
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
      And there is a EFF_CUSTOMER_ORDER table
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
      And staging_data loaded on 2020-01-13
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | EFFECTIVE_FROM |
      | md5('1000\|\|AAA') | 2020-01-13 | orders | md5('1000') | 1000        | md5('AAA') | AAA      | 2020-01-12     |
      | md5('2000\|\|BBB') | 2020-01-13 | orders | md5('2000') | 2000        | md5('BBB') | BBB      | 2020-01-12     |
      | md5('3000\|\|CCC') | 2020-01-13 | orders | md5('3000') | 3000        | md5('CCC') | CCC      | 2020-01-12     |
      | md5('4000\|\|DDD') | 2020-01-13 | orders | md5('4000') | 4000        | md5('DDD') | DDD      | 2020-01-12     |
      | md5('5000\|\|EEE') | 2020-01-13 | orders | md5('5000') | 5000        | md5('EEE') | EEE      | 2020-01-12     |
      | md5('6000\|\|HHH') | 2020-01-13 | orders | md5('6000') | 6000        | md5('HHH') | HHH      | 2020-01-12     |
      | md5('7000\|\|JJJ') | 2020-01-13 | orders | md5('7000') | 7000        | md5('JJJ') | JJJ      | 2020-01-12     |
      When I run a Load Cycle for 2020-01-13
      Then I expect the following LINK_CUSTOMER_ORDER
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
      And I expect the following EFF_CUSTOMER_ORDER
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
      Given there is a LINK_CUSTOMER_ORDER table
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | orders |
      And there is a EFF_CUSTOMER_ORDER table
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('4000\|\|DDD') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      | md5('5000\|\|EEE') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      And staging_data loaded on 2020-01-13
      | CUSTOMER_ORDER_PK   | LOADDATE   | Source | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | EFFECTIVE_FROM |
      | md5('1000\|\|AAA')  | 2020-01-13 | orders | md5('1000') | 1000        | md5('AAA') | AAA      | 2020-01-11     |
      | md5('2000\|\|BBB')  | 2020-01-13 | orders | md5('2000') | 2000        | md5('BBB') | BBB      | 2020-01-11     |
      | md5('3000\|\|CCC')  | 2020-01-13 | orders | md5('3000') | 3000        | md5('CCC') | CCC      | 2020-01-11     |
      | md5('4000\|\|DDD')  | 2020-01-13 | orders | md5('4000') | 4000        | md5('DDD') | DDD      | 2020-01-11     |
      | md5('5000\|\|^^')   | 2020-01-13 | orders | md5('5000') | 5000        | md5('^^')  | <null>   | 2020-01-12     |
      When I run a Load Cycle for 2020-01-13
      Then I expect the following LINK_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | orders |
      And I expect the following EFF_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
      | md5('4000\|\|DDD') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      | md5('5000\|\|EEE') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      | md5('5000\|\|EEE') | 2020-01-13 | orders | 2020-01-10     | 2020-01-10     | 2020-01-12   |

    Scenario: [NULL-DFK] No New Eff Sat Added if Driving Foreign Key is NULL and Latest EFF Sat Remain Open.
      Given there is a LINK_CUSTOMER_ORDER table
       | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
       | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
       | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
       | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
       | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-11 | orders |
       | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | orders |
      And there is a EFF_CUSTOMER_ORDER table
       | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
       | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
       | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
       | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
       | md5('4000\|\|DDD') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
       | md5('5000\|\|EEE') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
      And staging_data loaded on 2020-01-13
       | CUSTOMER_ORDER_PK   | LOADDATE   | Source | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | EFFECTIVE_FROM |
       | md5('1000\|\|AAA')  | 2020-01-13 | orders | md5('1000') | 1000        | md5('AAA') | AAA      | 2020-01-11     |
       | md5('2000\|\|BBB')  | 2020-01-13 | orders | md5('2000') | 2000        | md5('BBB') | BBB      | 2020-01-11     |
       | md5('3000\|\|CCC')  | 2020-01-13 | orders | md5('3000') | 3000        | md5('CCC') | CCC      | 2020-01-11     |
       | md5('4000\|\|DDD')  | 2020-01-13 | orders | md5('4000') | 4000        | md5('DDD') | DDD      | 2020-01-11     |
       | md5('^^\|\|EEE')    | 2020-01-13 | orders | md5('^^')   | <null>      | md5('EEE') | EEE      | 2020-01-12     |
      When I run a Load Cycle for 2020-01-13
      Then I expect the following LINK_CUSTOMER_ORDER
       | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
       | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
       | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
       | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
       | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-11 | orders |
       | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | orders |
      And I expect the following EFF_CUSTOMER_ORDER
       | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | START_DATETIME | END_DATETIME |
       | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
       | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
       | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 2020-01-09     | 9999-12-31   |
       | md5('4000\|\|DDD') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |
       | md5('5000\|\|EEE') | 2020-01-11 | orders | 2020-01-10     | 2020-01-10     | 9999-12-31   |

    Scenario: [MULTIPART-KEYS] Driving Key and Secondary Key are multipart keys.
      Given there is data in LINK_CUSTOMER_ORDER_MULTIPART
        | CUSTOMER_ORDER_PK                                | CUSTOMER_FK | NATION_FK  | ORDER_FK   | PRODUCT_FK    | ORGANISATION_FK  | LOADDATE   | SOURCE |
        | md5('1000\|\|DEU\|\|AAA\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('DEU') | md5('AAA') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-12 | orders |
        | md5('2000\|\|GBR\|\|BBB\|\|ONLINE\|\|DATAVAULT') | md5('2000') | md5('GBR') | md5('BBB') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-13 | orders |
        | md5('3000\|\|AUS\|\|CCC\|\|SHOP\|\|BUSSTHINK')   | md5('3000') | md5('AUS') | md5('CCC') | md5('SHOP')   | md5('BUSSTHINK') | 2020-01-13 | orders |
        | md5('4000\|\|POL\|\|DDD\|\|ONLINE\|\|BUSSTHINK') | md5('4000') | md5('POL') | md5('DDD') | md5('ONLINE') | md5('BUSSTHINK') | 2020-01-13 | orders |
        | md5('4000\|\|POL\|\|EEE\|\|ONLINE\|\|BUSSTHINK') | md5('4000') | md5('POL') | md5('EEE') | md5('ONLINE') | md5('BUSSTHINK') | 2020-01-13 | orders |
        | md5('5000\|\|SPA\|\|FFF\|\|SHOP\|\|DATAVAULT')   | md5('5000') | md5('SPA') | md5('FFF') | md5('SHOP')   | md5('DATAVAULT') | 2020-01-13 | orders |
      And there is data in EFF_CUSTOMER_ORDER_MULTIPART
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
      Then I expect to see the following multipart LINK_CUSTOMER_ORDER_MULTIPART
        | CUSTOMER_ORDER_PK                                | CUSTOMER_FK | NATION_FK  | ORDER_FK   | PRODUCT_FK    | ORGANISATION_FK  | LOADDATE   | SOURCE |
        | md5('1000\|\|DEU\|\|AAA\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('DEU') | md5('AAA') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-12 | orders |
        | md5('2000\|\|GBR\|\|BBB\|\|ONLINE\|\|DATAVAULT') | md5('2000') | md5('GBR') | md5('BBB') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-13 | orders |
        | md5('3000\|\|AUS\|\|CCC\|\|SHOP\|\|BUSSTHINK')   | md5('3000') | md5('AUS') | md5('CCC') | md5('SHOP')   | md5('BUSSTHINK') | 2020-01-13 | orders |
        | md5('4000\|\|POL\|\|DDD\|\|ONLINE\|\|BUSSTHINK') | md5('4000') | md5('POL') | md5('DDD') | md5('ONLINE') | md5('BUSSTHINK') | 2020-01-13 | orders |
        | md5('4000\|\|POL\|\|EEE\|\|ONLINE\|\|BUSSTHINK') | md5('4000') | md5('POL') | md5('EEE') | md5('ONLINE') | md5('BUSSTHINK') | 2020-01-13 | orders |
        | md5('5000\|\|SPA\|\|FFF\|\|SHOP\|\|DATAVAULT')   | md5('5000') | md5('SPA') | md5('FFF') | md5('SHOP')   | md5('DATAVAULT') | 2020-01-13 | orders |
        | md5('5000\|\|FRA\|\|FFF\|\|SHOP\|\|DATAVAULT')   | md5('5000') | md5('FRA') | md5('FFF') | md5('SHOP')   | md5('DATAVAULT') | 2020-01-14 | orders |
        | md5('6000\|\|FRA\|\|GGG\|\|SHOP\|\|DATAVAULT')   | md5('6000') | md5('FRA') | md5('GGG') | md5('SHOP')   | md5('DATAVAULT') | 2020-01-14 | orders |
      And I expect to see the following multipart EFF_CUSTOMER_ORDER_MULTIPART
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
