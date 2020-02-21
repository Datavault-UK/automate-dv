### Metadata notes
#### Using a source reference for the target metadata

In the usage examples for the table template macros in this section, you will see ```source``` provided as the values
for some of the target metadata variables. ```source``` has been declared as a variable at the top of the models, 
and holds a reference to the source table we are loading from. This is shorthand for retaining the name and data types 
of the columns as they are provided in the ```src``` variables. You may wish to alias the columns or change their data 
types in specific circumstances, which is possible by providing an additional parameter as a list of triples: 
``` (source column name, data type to cast to, target column name)```.

Both approaches are shown in the snippet below:

```mysql
{%- set src_pk = 'CUSTOMER_NATION_PK'                           -%}
{%- set src_fk = ['CUSTOMER_PK', 'NATION_PK']                   -%}
{%- ...other src metadata...                                    -%}

{%- set tgt_pk = source                                         -%}
{%- set tgt_fk = [['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_FK'], 
                  ['NATION_PK', 'BINARY(16)', 'NATION_FK']]     -%}
```

Here, we are keeping the ```tgt_pk``` (the target table's primary key) the same as the primary key identified in the
source (```src_pk```).
Behind the scenes, the macro will get the datatype of the column provided in the ```src_pk``` variable and generate a 
mapping for us. If the ```src_pk``` column does not exist, an appropriate exception will be raised.

Alternatively we have provided a manual mapping for the ```tgt_fk``` (the target table's foreign key). 

*For further details and examples on both methods, refer to the usage examples 
and snippets in the table template documentation below (both Single-Source and Union).*

!!! note
    If only aliasing and **not** changing data types, we suggest using the [add_columns](#add_columns) macro. 
    
    This aliasing approach is much simpler and processed in the staging layer instead. 
___