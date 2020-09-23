{% docs arg__tables__src_pk %}

The column used as the primary key of the table. This must be a hash key generated from a natural key in the staging layer. 
In future versions of dbtvault, hashing will not be a requirement.


{% enddocs %}


{% docs arg__tables__src_nk %}

The column used as the natural or business key of the table. This must be the non-hashed version of the column used for the `src_pk`.

{% enddocs %}


{% docs arg__tables__src_fk %}

A single column or list of columns which are the primary key columns of other, related tables. Used in links to shows hubs associated with the link. 

{% enddocs %}


{% docs arg__tables__src_hashdiff %}

A column which contains a single hash, composed of a list of columns and alpha-sorted. A hashdiff is used as a kind of checksum, to detect changes in records. 
If any of the columns which form the hashdiff change their value, then the hashdiff itself will change. This is used in satellites to detect changes in the payload.


{% enddocs %}


{% docs arg__tables__src_payload_sat %}

A list or single list of columns which contains the payload of the satellite. 
A satellite payload should contain the concrete attributes for entity descried in the corresponding hub record.  


{% enddocs %}


{% docs arg__tables__src_payload__t_link %}

A list or single list of columns which contains the payload of the t-link. 
A t-link payload should contain the transactional/event attributes for entity descried in the corresponding hub record.  

{% enddocs %}


{% docs arg__tables__src_eff %}

The effective from column for a record. This is the business-effective date of a record. 

- For a transactional link, this would be the time at which the transaction occurred. 
- For a satellite, this would be the time at which we first saw this data in the system (i.e when the payload changed) in a given form.
- For an effectivity satellite, this is the time at which we first saw the link relationship in a given form.

{% enddocs %}


{% docs arg__tables__src_ldts %}

The load datetime stamp of the record. When this record appeared/was loaded into the database. 

{% enddocs %}


{% docs arg__tables__src_source %}

The source for a given record. This can be a code which corresponds to a lookup table or simply a string with a named system. 

{% enddocs %}


{% docs arg__tables__source_model %}

The name of the model which contains the data which needs to be loaded. This can be a list for Hubs and Links, which could have multiple sources. 

{% enddocs %}