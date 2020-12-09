{% docs macro__hash %}

Generate SQL to hash one or more columns using MD5 or SHA256. 

See [How do we hash?](https://dbtvault.readthedocs.io/en/latest/best_practices/#how-do-we-hash) for an in-depth look at how dbtvault does hashing. 

[Read more online](https://dbtvault.readthedocs.io/en/latest/macros/#hash)

{% enddocs %}


{% docs arg__hash__columns %}

A list of one or more columns to hash. 

{% enddocs %}


{% docs arg__hash__alias %}

The alias (name) for the new column output using the hash macro. 

{% enddocs %}


{% docs arg__hash__is_hashdiff %}

Boolean flag. If true, sort the column names in alphabetical order prior to hashing.
This is required for hashdiffs to ensure consistent hashing.

{% enddocs %}




{% docs macro__prefix %}

Prefix one or more strings with a given string and print each one.

[Read more online](https://dbtvault.readthedocs.io/en/latest/macros/#prefix)

{% enddocs %}


{% docs arg__prefix__columns %}

A list of columns (string or mapping) to prefix.

If a column is specified using an alias mapping as follows:

{'source_column': <'column name'>, 'alias': <'alias string'>}

Then it will also be aliased using `AS <column name>`.

{% enddocs %}


{% docs arg__prefix__prefix_str %}

The string to prepend to each column/string. 

{% enddocs %}



{% docs arg__prefix__alias_target %}

Switch the aliasing target. `source` by default.

If a column is specified using an alias mapping as follows:

`{'source_column': <'column name'>, 'alias': <'alias string'>}`

Then it will also be aliased using `AS <column name>`.

However, if the `alias_target` is `target` instead of `source`, the column will be rendered as follows:

`AS <alias string>`

{% enddocs %}