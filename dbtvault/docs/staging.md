{% docs macro__stage %}

A macro to aid in generating a staging layer for the raw vault. Allows users to:

- Create new columns from already existing columns (Derived columns)
- Create new hashed columns from already existing columns (Hashed columns)

[Read more online](https://dbtvault.readthedocs.io/en/latest/macros/#stage)

{% enddocs %}


{% docs arg__stage__include_source_columns %}

True by default. If true, all columns included in the source model for the stage layer, will be propagated to the stage layer.

If false, only derived and hash columns (if configured) will be present in the resulting stage layer. 

{% enddocs %}


{% docs arg__stage__source_model %}

The dbt model name or source to build a staging layer from. Can be provided in the following formats:

```
[REF STYLE]
source_model: model_name
OR
[SOURCES STYLE]
source_model:
    source_name: source_table_name"
```

{% enddocs %}


{% docs arg__stage__hashed_columns %}

A mapping of hash key names to column names which should be hashed to create that key.

e.g.

```
hashed_columns:
    SUPPLIER_PK: 'SUPPLIERKEY'
    SUPPLIER_NATION_PK: 'SUPPLIER_NATION_KEY'
    SUPPLIER_REGION_PK: 'SUPPLIER_REGION_KEY'
    REGION_PK: 'SUPPLIER_REGION_KEY'
    NATION_PK: 'SUPPLIER_NATION_KEY'
    NATION_REGION_PK:
      - 'SUPPLIER_NATION_KEY'
      - 'SUPPLIER_REGION_KEY'
    LINK_SUPPLIER_NATION_PK:
      - 'SUPPLIERKEY'
      - 'SUPPLIER_NATION_KEY'
    PART_PK: 'PARTKEY'
    INVENTORY_PK:
      - 'PARTKEY'
      - 'SUPPLIERKEY'
    INVENTORY_HASHDIFF:
      is_hashdiff: true
      columns:
        - 'PARTKEY'
        - 'SUPPLIERKEY'
        - 'AVAILQTY'
        - 'SUPPLYCOST'
        - 'PART_SUPPLY_COMMENT'
```

{% enddocs %}


{% docs arg__stage__derived_columns %}

A mapping of new column names to existing columns which should be hashed to create that key.

e.g.

```
derived_columns:
    NATION_KEY: 'SUPPLIER_NATION_KEY'
    REGION_KEY: 'SUPPLIER_REGION_KEY'
    SOURCE: '!TPCH-INVENTORY'
```

{% enddocs %}




{% docs macro__derive_columns %}

A macro used by the `stage` macro internally, which processes a mapping of new columns to source columns, in order to generate new columns. 

See also:
[stage](#!/macro/macro.dbtvault.stage)
[Online docs](https://dbtvault.readthedocs.io/en/latest/macros/#derive_columns)

{% enddocs %}


{% docs arg__derive_columns__source_relation %}

The source relation to extract columns from, for deriving from. 

{% enddocs %}



{% docs macro__hash_columns %}

A macro used by the `stage` macro internally, which processes a mapping of hash key names to source columns, in order to generate hash keys. 

See also:
[stage](#!/macro/macro.dbtvault.stage)
[Online docs](https://dbtvault.readthedocs.io/en/latest/macros/#hash_columns)

{% enddocs %}