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
    - so we create an Effectivty_satellite off LINK_AB
    - this contains information about the status of the LINK_AB
    - so we have 2 columns, effective_From, effective_to, plus a hashdiff (of
      these 2 columns), etc.
    - when the effectivity is created we set the effective_from date, and leave
      the effective_to empty (or set it to year 9999....)

    - now imagine, the foreigh key link in table A changes for some reason,
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
        - union it with the recording of the effectivty end date on the old link

    - Regular load:
        - LINK record uses the regular load pattern, no changes needed there
        - EFFECTIVITY_SATELLITE for the new link:
            - This is a regular satellite load,
            - effective_from is set to the business date
            - effective_to is set to the constant '9999-12-31 23:23:59'
    - EFFECTIVTY SATELLITE for the now ended link:
        - Find the records that are candidates for end-dating
            - Get the primary key for LINKS, where the list of DRIVING KEY
              / DRIVEN KEY pairs that are in the LINK table do not match the
              DRIVING KEY / DRIVEN KEY pairs provided in the staging table
            - We assume that if we have no information about a particular
              driving key in the stage table then we cannot take action, i.e.
              exclude any records where DRIVING KEYS are in the LINK but not in
              the Stage (use an equi join).
            - We've effectively found the list of satellites to update.
            - So insert new satellite records, where the new satellites copy
              across the old satellites effective_from dates, insert an proper
              end_date, and calculate a new HASHDIFF
    - Union together these two queries and the update will cover off opening
      and closing of each LINK.

      HUB_CUSTOMER (customer_pk, source, ldts, customer_id)
      HUB_ORDER (order_pk, source, ldts, order_id)
      LINK_CUSTOMER_ORDER
        (customer_order_pk, customer_fk, order_Fk, source, ltds)
      EFF_CUSTOMER_ORDER
        (customer_order_pk, ldts, source, hashdiff, eff_from, eff_to)

      STAGE (customer_pk, customer_id, order_pk, order_id, customer_order_pk,
      ldts, source, effective_from)

    ===========================================================================

    Scenario: Empty Load
      Given an empty Link_Customer_Order
      And an empty EFF_SAT_LINK_ORDER_CUSTOMER
      And staging_data loaded on 10.01.2020
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | EFFECTIVE_FROM |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | md5('1000') | 1000        | md5('AAA') | AAA      | 2020-01-09     |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | md5('2000') | 2000        | md5('BBB') | BBB      | 2020-01-09     |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | md5('3000') | 3000        | md5('CCC') | CCC      | 2020-01-09     |
      When I run a Load Cycle for 10.01.2020
      Then I expect the following LINK_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10 | orders |
      And the following EFF_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | EFFECTIVE_TO |
      | md5('1000\|\|AAA') | 2020-01-10 | orders | 2020-01-09     | 9999-12-31   |
      | md5('2000\|\|BBB') | 2020-01-10 | orders | 2020-01-09     | 9999-12-31   |
      | md5('3000\|\|CCC') | 2020-01-10 | orders | 2020-01-09     | 9999-12-31   |


    Scenario: Subsequent Load, No Effectivity Change
      Given Link_Customer_Order
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5(1000)   | md5(AAA) | 11.01.2020 | orders |
      | md5('2000\|\|BBB') | md5(2000)   | md5(BBB) | 11.01.2020 | orders |
      | md5('3000\|\|CCC') | md5(3000)   | md5(CCC) | 11.01.2020 | orders |
      And Eff_Customer_Order
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | EFFECTIVE_TO |
      | md5('1000\|\|AAA') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('2000\|\|BBB') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('3000\|\|CCC') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      And staging_data for 11.01.2020
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | CUSTOMER_PK | CUSTOMER_ID | ORDER_PK | ORDER_ID | EFFECTIVE_FROM |
      | md5('1000\|\|AAA') | 11.01.2020 | orders | md5(1000)   | 1000        | md5(AAA) | AAA      | 10.01.2020     |
      | md5('2000\|\|BBB') | 11.01.2020 | orders | md5(2000)   | 2000        | md5(BBB) | BBB      | 10.01.2020     |
      | md5('3000\|\|CCC') | 11.01.2020 | orders | md5(3000)   | 3000        | md5(CCC) | CCC      | 10.01.2020     |
      And mapping configuration from stage to vault
      When I run a Load Cycle for 11.01.2020
      Then I expect the following CUSTOMER_ORDER_LINK
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5(1000)   | md5(AAA) | 10.01.2020 | orders |
      | md5('2000\|\|BBB') | md5(2000)   | md5(BBB) | 10.01.2020 | orders |
      | md5('3000\|\|CCC') | md5(3000)   | md5(CCC) | 10.01.2020 | orders |
      And the following EFF_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | EFFECTIVE_TO |
      | md5('1000\|\|AAA') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('2000\|\|BBB') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('3000\|\|CCC') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |


    Scenario: Subsequent Load, New Link Added
      Given Link_Customer_Order
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5(1000)   | md5(AAA) | 11.01.2020 | orders |
      | md5('2000\|\|BBB') | md5(2000)   | md5(BBB) | 11.01.2020 | orders |
      | md5('3000\|\|CCC') | md5(3000)   | md5(CCC) | 11.01.2020 | orders |
      And Eff_Customer_Order
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | EFFECTIVE_TO |
      | md5('1000\|\|AAA') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('2000\|\|BBB') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('3000\|\|CCC') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      And staging_data for 11.01.2020
       | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | CUSTOMER_PK | CUSTOMER_ID | ORDER_PK | ORDER_ID | EFFECTIVE_FROM |
       | md5('1000\|\|AAA') | 11.01.2020 | orders | md5(1000)   | 1000        | md5(AAA) | AAA      | 09.01.2020     |
       | md5('2000\|\|BBB') | 11.01.2020 | orders | md5(2000)   | 2000        | md5(BBB) | BBB      | 09.01.2020     |
       | md5('3000\|\|CCC') | 11.01.2020 | orders | md5(3000)   | 3000        | md5(CCC) | CCC      | 09.01.2020     |
       | md5('4000\|\|DDD') | 11.01.2020 | orders | md5(4000)   | 4000        | md5(DDD) | DDD      | 10.01.2020     |
       | md5('5000\|\|EEE') | 11.01.2020 | orders | md5(5000)   | 5000        | md5(EEE) | EEE      | 10.01.2020     |
      And mapping configuration from stage to vault
      When I run a Load Cycle for 11.01.2020
      Then I expect the following CUSTOMER_ORDER_LINK
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5(1000)   | md5(AAA) | 10.01.2020 | orders |
      | md5('2000\|\|BBB') | md5(2000)   | md5(BBB) | 10.01.2020 | orders |
      | md5('3000\|\|CCC') | md5(3000)   | md5(CCC) | 10.01.2020 | orders |
      | md5('4000\|\|DDD') | md5(4000)   | md5(DDD) | 11.01.2020 | orders |
      | md5('5000\|\|EEE') | md5(5000)   | md5(EEE) | 11.01.2020 | orders |
      And the following EFF_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | EFFECTIVE_TO |
      | md5('1000\|\|AAA') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('2000\|\|BBB') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('3000\|\|CCC') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('4000\|\|DDD') | 11.01.2020 | orders | 10.01.2020     | 31.12.9999   |
      | md5('5000\|\|EEE') | 11.01.2020 | orders | 10.01.2020     | 31.12.9999   |


    Scenario: Subsequent Load, Link is Changed
      Given Link_Customer_Order
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5(1000)   | md5(AAA) | 10.01.2020 | orders |
      | md5('2000\|\|BBB') | md5(2000)   | md5(BBB) | 10.01.2020 | orders |
      | md5('3000\|\|CCC') | md5(3000)   | md5(CCC) | 10.01.2020 | orders |
      | md5('4000\|\|DDD') | md5(4000)   | md5(DDD) | 11.01.2020 | orders |
      | md5('5000\|\|EEE') | md5(5000)   | md5(EEE) | 11.01.2020 | orders |
      And Eff_Customer_Order
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | EFFECTIVE_TO |
      | md5('1000\|\|AAA') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('2000\|\|BBB') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('3000\|\|CCC') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('4000\|\|DDD') | 11.01.2020 | orders | 10.01.2020     | 31.12.9999   |
      | md5('5000\|\|EEE') | 11.01.2020 | orders | 10.01.2020     | 31.12.9999   |
      And staging_data for 12.01.2020
      | CUSTOMER_ORDER_PK  | LOADDATE   | Source | CUSTOMER_PK | CUSTOMER_ID | ORDER_PK | ORDER_ID | EFFECTIVE_FROM |
      | md5('1000\|\|AAA') | 12.01.2020 | orders | md5(1000)   | 1000        | md5(AAA) | AAA      | 11.01.2020     |
      | md5('2000\|\|BBB') | 12.01.2020 | orders | md5(2000)   | 2000        | md5(BBB) | BBB      | 11.01.2020     |
      | md5('3000\|\|CCC') | 12.01.2020 | orders | md5(3000)   | 3000        | md5(CCC) | CCC      | 11.01.2020     |
      | md5('4000\|\|FFF') | 12.01.2020 | orders | md5(4000)   | 4000        | md5(FFF) | FFF      | 11.01.2020     |
      | md5('5000\|\|GGG') | 12.01.2020 | orders | md5(5000)   | 5000        | md5(GGG) | GGG      | 11.01.2020     |
      And mapping configuration from stage to vault
      When I run a Load Cycle for 12.01.2020
      Then I expect the following CUSTOMER_ORDER_LINK
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5(1000)   | md5(AAA) | 10.01.2020 | orders |
      | md5('2000\|\|BBB') | md5(2000)   | md5(BBB) | 10.01.2020 | orders |
      | md5('3000\|\|CCC') | md5(3000)   | md5(CCC) | 10.01.2020 | orders |
      | md5('4000\|\|DDD') | md5(4000)   | md5(DDD) | 11.01.2020 | orders |
      | md5('5000\|\|EEE') | md5(5000)   | md5(EEE) | 11.01.2020 | orders |
      | md5('4000\|\|DDD') | md5(4000)   | md5(FFF) | 12.01.2020 | orders |
      | md5('5000\|\|EEE') | md5(5000)   | md5(GGG) | 12.01.2020 | orders |
      And the following EFF_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | EFFECTIVE_TO |
      | md5('1000\|\|AAA') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('2000\|\|BBB') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('3000\|\|CCC') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('4000\|\|DDD') | 11.01.2020 | orders | 10.01.2020     | 31.12.9999   |
      | md5('5000\|\|EEE') | 11.01.2020 | orders | 10.01.2020     | 31.12.9999   |
      | md5('4000\|\|DDD') | 12.01.2020 | orders | 10.01.2020     | 11.01.2020   |
      | md5('5000\|\|EEE') | 12.01.2020 | orders | 10.01.2020     | 11.01.2020   |
      | md5('4000\|\|FFF') | 12.01.2020 | orders | 11.01.2020     | 31.12.9999   |
      | md5('5000\|\|GGG') | 12.01.2020 | orders | 11.01.2020     | 31.12.9999   |



    Scenario: Subsequent 2 Loads, Link is Changed Back Again
      Given Link_Customer_Order
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5(1000)   | md5(AAA) | 10.01.2020 | orders |
      | md5('2000\|\|BBB') | md5(2000)   | md5(BBB) | 10.01.2020 | orders |
      | md5('3000\|\|CCC') | md5(3000)   | md5(CCC) | 10.01.2020 | orders |
      | md5('4000\|\|DDD') | md5(4000)   | md5(DDD) | 11.01.2020 | orders |
      | md5('4000\|\|FFF') | md5(4000)   | md5(FFF) | 12.01.2020 | orders |
      | md5('5000\|\|EEE') | md5(5000)   | md5(EEE) | 11.01.2020 | orders |
      | md5('5000\|\|GGG') | md5(5000)   | md5(GGG) | 12.01.2020 | orders |
      And Eff_Customer_Order
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | EFFECTIVE_TO |
      | md5('1000\|\|AAA') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('2000\|\|BBB') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('3000\|\|CCC') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('4000\|\|DDD') | 12.01.2020 | orders | 10.01.2020     | 11.01.2020   |
      | md5('4000\|\|DDD') | 11.01.2020 | orders | 10.01.2020     | 31.12.9999   |
      | md5('4000\|\|FFF') | 12.01.2020 | orders | 11.01.2020     | 31.12.9999   |
      | md5('5000\|\|EEE') | 11.01.2020 | orders | 10.01.2020     | 31.12.9999   |
      | md5('5000\|\|EEE') | 12.01.2020 | orders | 10.01.2020     | 11.01.2020   |
      | md5('5000\|\|GGG') | 12.01.2020 | orders | 11.01.2020     | 31.12.9999   |
      And staging_data for 13.01.2020
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | CUSTOMER_PK | CUSTOMER_ID | ORDER_PK | ORDER_ID | EFFECTIVE_FROM |
      | md5('1000\|\|AAA') | 13.01.2020 | orders | md5(1000)   | 1000        | md5(AAA) | AAA      | 12.01.2020     |
      | md5('2000\|\|BBB') | 13.01.2020 | orders | md5(2000)   | 2000        | md5(BBB) | BBB      | 12.01.2020     |
      | md5('3000\|\|CCC') | 13.01.2020 | orders | md5(3000)   | 3000        | md5(CCC) | CCC      | 12.01.2020     |
      | md5('4000\|\|DDD') | 13.01.2020 | orders | md5(4000)   | 4000        | md5(DDD) | DDD      | 12.01.2020     |
      | md5('5000\|\|EEE') | 13.01.2020 | orders | md5(5000)   | 5000        | md5(EEE) | EEE      | 12.01.2020     |
      And mapping configuration from stage to vault
      When I run a Load Cycle for 13.01.2020
      Then I expect the following CUSTOMER_ORDER_LINK
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK | LOADDATE   | SOURCE |
      | md5('1000\|\|AAA') | md5(1000)   | md5(AAA) | 10.01.2020 | orders |
      | md5('2000\|\|BBB') | md5(2000)   | md5(BBB) | 10.01.2020 | orders |
      | md5('3000\|\|CCC') | md5(3000)   | md5(CCC) | 10.01.2020 | orders |
      | md5('4000\|\|DDD') | md5(4000)   | md5(DDD) | 11.01.2020 | orders |
      | md5('4000\|\|FFF') | md5(4000)   | md5(FFF) | 12.01.2020 | orders |
      | md5('5000\|\|EEE') | md5(5000)   | md5(EEE) | 11.01.2020 | orders |
      | md5('5000\|\|GGG') | md5(5000)   | md5(GGG) | 12.01.2020 | orders |
      And the following EFF_CUSTOMER_ORDER
      | CUSTOMER_ORDER_PK  | LOADDATE   | SOURCE | EFFECTIVE_FROM | EFFECTIVE_TO |
      | md5('1000\|\|AAA') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('2000\|\|BBB') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('3000\|\|CCC') | 10.01.2020 | orders | 09.01.2020     | 31.12.9999   |
      | md5('4000\|\|DDD') | 11.01.2020 | orders | 10.01.2020     | 31.12.9999   |
      | md5('4000\|\|DDD') | 12.01.2020 | orders | 10.01.2020     | 11.01.2020   |
      | md5('4000\|\|FFF') | 12.01.2020 | orders | 11.01.2020     | 31.12.9999   |
      | md5('4000\|\|FFF') | 13.01.2020 | orders | 11.01.2020     | 12.01.2020   |
      | md5('4000\|\|DDD') | 13.01.2020 | orders | 12.01.2020     | 31.12.9999   |
      | md5('5000\|\|EEE') | 11.01.2020 | orders | 10.01.2020     | 31.12.9999   |
      | md5('5000\|\|EEE') | 12.01.2020 | orders | 10.01.2020     | 11.01.2020   |
      | md5('5000\|\|GGG') | 12.01.2020 | orders | 11.01.2020     | 31.12.9999   |
      | md5('5000\|\|GGG') | 13.01.2020 | orders | 11.01.2020     | 11.01.2020   |
      | md5('5000\|\|EEE') | 13.01.2020 | orders | 12.01.2020     | 31.12.9999   |


