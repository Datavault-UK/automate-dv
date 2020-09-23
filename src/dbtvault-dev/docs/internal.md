{% docs macro__alias %}

Perform aliasing on a mapping and optionally prefix the string as well.



See also:
[alias_all](#!/macro/macro.dbtvault.alias_all)

{% enddocs %}


{% docs arg__alias__alias_config %}
                                                
| Key           | Description          | Type   |
| ------------- | -------------------- | ------ |
| source_column | Column being aliased | string |
| alias         | Column alias         | string |
 
{% enddocs %}


{% docs arg__alias__prefix %}

A string to prefix the column with.
 
{% enddocs %}




{% docs macro__alias_all %}

Perform aliasing on a mapping and optionally prefix the string as well.
 
{% enddocs %}


{% docs arg__alias_all__columns %}

A list of columns, as strings or mappings.

e.g.

```
src_hashdiff: 
  source_column: "CUSTOMER_HASHDIFF"
  alias: "HASHDIFF"
```

{% enddocs %}

{% docs arg__alias_all__prefix %}

A string to prefix all columns with.

{% enddocs %}




{% docs macro__as_constant %}

.

{% enddocs %}


{% docs arg__as_constant__column_str %}

.
 
{% enddocs %}




{% docs macro__expand_column_list %}

.
 
{% enddocs %}


{% docs arg__expand_column_list__columns %}

.
 
{% enddocs %}




{% docs macro__multikey %}

. 

{% enddocs %}


{% docs arg__multikey__columns %}

. 

{% enddocs %}


{% docs arg__multikey__prefix %}

. 

{% enddocs %}


{% docs arg__multikey__condition %}

. 

{% enddocs %}


{% docs arg__multikey__operator %}

. 

{% enddocs %}




{% docs macro__prepend_generated_by %}

. 

{% enddocs %}