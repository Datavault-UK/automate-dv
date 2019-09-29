# Macros

## Internal

Internal macros support the utility macros provided in this package. 
They are used in the utility macros to process provided metadata and it should not be necessary to use them directly. 

## Utility

Utility macros are helper macros for use in models. These macros are used extensively in the [table template](#table-templates) macros


### add_columns

A simple macro for generating sequences of the following SQL:
```mysql 
column AS alias
```

#### Parameters

| Parameter     | Description      | Required?                                                |
| ------------- | ---------------- | -------------------------------------------------------- |
| pairs         | A list of tuples | <i class="md-icon" alt="Yes" style="color: green">check_circle</i> |

#### Usage

```yaml
{{ dbtvault.add_columns([('PARTKEY', 'PART_ID'),
                         ('PART_NAME', 'NAME'),
                         ('PART_TYPE', 'TYPE'),
                         ('PART_SIZE', 'SIZE'),
                         ('PART_RETAILPRICE', 'RETAILPRICE'),
                         ('LOADDATE', 'LOADDATE'),
                         ('SOURCE', 'SOURCE')])                }}
```

#### Output

```mysql 
PARTKEY AS PART_ID, 
PART_NAME AS NAME, 
PART_TYPE AS TYPE, 
PART_SIZE AS SIZE, 
PART_RETAILPRICE AS RETAILPRICE, 
LOADDATE AS LOADDATE, 
SOURCE AS SOURCE
```


### cast

A macro for generating cast sequences:

```mysql
CAST(prefix.column AS type) AS alias
```

#### Parameters

| Parameter        |  Description                  | Required?                                                |
| ---------------- | ----------------------------- | -------------------------------------------------------- |
| columns          |  Triples or strings | <i class="md-icon" style="color: green">check_circle</i> |
| prefix           |  A string                     | <i class="md-icon" style="color: red">clear</i>          |

#### Usage

!!! note
    As shown in the snippet below, columns must be provided as a list. 
    The collection of items in this list can be any combination of:

    - ```(column, type, alias) ``` 3-tuples 
    - ```[column, type, alias] ``` 3-item lists
    - ```'DOB'``` Single strings.

```yaml

{%- set tgt_pk = ['PART_PK', 'BINARY(16)', 'PART_PK']        -%}

{{ dbtvault.cast([tgt_pk,
                  'DOB',
                  ('PART_PK', 'NUMBER(38,0)', 'PART_ID'),
                  ('LOADDATE', 'DATE', 'LOADDATE'),
                  ('SOURCE', 'VARCHAR(15)', 'SOURCE')], 
                  'stg')                                      }}
```

#### Output

```mysql
CAST(stg.PART_PK AS BINARY(16)) AS PART_PK,
stg.DOB,
CAST(stg.PART_ID AS NUMBER(38,0)) AS PART_ID,
CAST(stg.LOADDATE AS DATE) AS LOADDATE,
CAST(stg.SOURCE AS VARCHAR(15)) AS SOURCE
```


### md5_binary

!!! warning
    This macro ***should not be*** used for any kind of password obfuscation or security purposes, the intended use is for creating checksum-like fields only. 
    
    [Read More](https://www.md5online.org/blog/why-md5-is-not-safe/)
A macro for generating hashing SQL for columns:
```sql 
CAST(MD5_BINARY(UPPER(TRIM(CAST(column AS VARCHAR)))) AS BINARY(16)) AS alias
```

- Accounts for null values
- Can provide multiple columns as a list to create a concatenated hash

#### Parameters

| Parameter        |  Description                                   | Required?                                                |
| ---------------- | ---------------------------------------------- | -------------------------------------------------------- |
| columns          |  Single column string or list of columns       | <i class="md-icon" style="color: green">check_circle</i> |
| alias            |  A string                                      | <i class="md-icon" style="color: green">check_circle</i> |

#### Usage

```yaml
{{ dbtvault.md5_binary('CUSTOMERKEY', 'CUSTOMER_PK') }},
{{ dbtvault.md5_binary(['CUSTOMERKEY', 'DOB', 'NAME', 'PHONE'], 'HASHDIFF') }}
```

!!! tip
    [gen_hashing](#gen_hashing) may be used to simplify the hashing process and generate multiple hashes with one macro.

#### Output

```mysql
CAST(MD5_BINARY(UPPER(TRIM(CAST(CUSTOMERKEY AS VARCHAR)))) AS BINARY(16)) AS CUSTOMER_PK,
CAST(MD5_BINARY(CONCAT(IFNULL(UPPER(TRIM(CAST(CUSTOMERKEY AS VARCHAR))), '^^'), '||',
                       IFNULL(UPPER(TRIM(CAST(DOB AS VARCHAR))), '^^'), '||',
                       IFNULL(UPPER(TRIM(CAST(NAME AS VARCHAR))), '^^'), '||',
                       IFNULL(UPPER(TRIM(CAST(PHONE AS VARCHAR))), '^^') )) 
                       AS BINARY(16)) AS HASHDIFF
```

### prefix

A macro for quickly prefixing a list of columns with a string:
```mysql
a.column1, a.column2, a.column3, a.column4
```

#### Parameters

| Parameter        |  Description                  | Required?                                                |
| ---------------- | ----------------------------- | -------------------------------------------------------- |
| columns          |  A list of column names       | <i class="md-icon" style="color: green">check_circle</i> |
| prefix_str       |  A string                     | <i class="md-icon" style="color: green">check_circle</i> |

#### Usage

```yaml
{{ dbtvault.prefix(['CUSTOMERKEY', 'DOB', 'NAME', 'PHONE'], 'a') }}
{{ dbtvault.prefix(['CUSTOMERKEY'], 'a') 
```

!!! Note
    Single columns must be provided as a 1-item list, as in the second example above.

#### Output

```mysql
a.CUSTOMERKEY, a.DOB, a.NAME, a.PHONE
a.CUSTOMERKEY
```

## Table templates