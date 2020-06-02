{% docs macro_alias %}

Perform aliasing on a mapping and optionally prefix the string as well.



See also:
[alias_all](#!/macro/macro.dbtvault.alias_all)

{% enddocs %}


{% docs arg_alias_alias_config %}
                                                
| Key           | Description          | Type   |
| ------------- | -------------------- | ------ |
| source_column | Column being aliased | string |
| alias         | Column alias         | string |
 
{% enddocs %}


{% docs arg_alias_prefix %}

A string to prefix the column with.
 
{% enddocs %}




{% docs macro_alias_all %}

Perform aliasing on a mapping and optionally prefix the string as well.
 
{% enddocs %}


{% docs arg_alias_all_columns %}

A list of columns, as strings or mappings.

e.g.

```
src_hashdiff: 
  source_column: "CUSTOMER_HASHDIFF"
  alias: "HASHDIFF"
```

{% enddocs %}

{% docs arg_alias_all_prefix %}

A string to prefix all columns with.

{% enddocs %}




{% docs macro_as_constant %}

 
{% enddocs %}


{% docs arg_as_constant_column_str %}

 
{% enddocs %}




{% docs macro_expand_column_list %}

 
{% enddocs %}


{% docs arg_expand_column_list_columns %}

 
{% enddocs %}




{% docs macro_multikey %}

 
{% enddocs %}


{% docs arg_multikey_columns %}

 
{% enddocs %}


{% docs arg_multikey_aliases %}

 
{% enddocs %}


{% docs arg_multikey_type_for %}

 
{% enddocs %}