{% docs macro__hub %}

A Hub contains a distinct set of keys for a given top-level business concept, for example a `HUB_CUSTOMER` hub may contain a distinct list
of Customer IDs. 

[Read more online](https://dbtvault.readthedocs.io/en/latest/macros/#hub)

{% enddocs %}




{% docs macro__link %}

A Link contains a distinct set of relationships between top-level business concepts. 
These structures 'link' hubs together based on a business relationship between the two.

[Read more online](https://dbtvault.readthedocs.io/en/latest/macros/#link)

{% enddocs %}




{% docs macro__sat %}

A Satellite contains records corresponding to Hub or Link records which provide concrete attributes for those records. For example a `SAT_CUSTOMER_DETAILS` Satellite
would contain details about the customer, by using the same primary key as the corresponding hub record. 
The payload for this example may contain `CUSTOMER_DOB`, `CUSTOMER_GIVEN_NAME`, `CUSTOMER_SURNAME` columns.

[Read more online](https://dbtvault.readthedocs.io/en/latest/macros/#sat) 

{% enddocs %}




{% docs macro__eff_sat %}

An Effectivity Satellite keeps track of the effective dates of relationships contained in links. 
If a relationship changes (for example, a Customer moves country, changing a customer and nation relation) 
then an effectivity satellite will record this change as a new entry, and when it happened. 

When a new relationship is loaded from the source, a new record will be created with the new relation and an open end date (the max date, `9999-12-31`).
If auto end-dating is enabled and a relationship changes which is already recorded in the effectivity satellite, then effectivity satellites in dbtvault will 
automatically create a record as a copy of the old record. This record will be created with the effective date of the new relation. 

If auto end-dating is not enabled, a new record with open end date will still be created, but additional business rules will need to be applied to work out the 
end dates manually. This may be useful when there is external business logic which describes under what situations a relationship is considered effective or not. 

[Read more online](https://dbtvault.readthedocs.io/en/latest/macros/#eff_sat)

{% enddocs %}




{% docs macro__t_link %}

A transactional link is an immutable list of transaction records. By definition transactions are never modified:
if a transaction needs to be updated, then a new transaction occurs. Transactional links contain a payload of columns which contain
details about the transaction, usually consisting of payments, location, type and more. 

[Read more online](https://dbtvault.readthedocs.io/en/latest/macros/#t_link) 

{% enddocs %}