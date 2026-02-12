# Redshift Table Macros

This directory contains Amazon Redshift-specific implementations of Data Vault table macros.

## Requirements

- **Minimum Redshift Version**: July 2023 or later (QUALIFY clause support required)
- **dbt Version**: >=1.0.0, <3.0.0
- **dbt-redshift adapter**: Latest version recommended

## Supported Hash Algorithms

- **MD5**: Fully supported via native `MD5()` function → `VARCHAR(32)`
- **SHA1**: Fully supported via native `SHA1()` function → `VARCHAR(40)`
- **SHA256**: Fully supported via native `SHA2(string, 256)` function → `VARCHAR(64)`

## Configuration

Configure your hash algorithm in `dbt_project.yml`:

```yaml
vars:
  # Use MD5 (default)
  hash: 'md5'

  # Or use SHA1
  hash: 'sha1'

  # Or use SHA256 for strongest hashing
  hash: 'sha'
```

## Implementation Details

### Hash Storage
Hashes are stored as **VARCHAR hex strings** rather than binary types:
- MD5: `VARCHAR(32)` - 32 hexadecimal characters
- SHA1: `VARCHAR(40)` - 40 hexadecimal characters
- SHA256: `VARCHAR(64)` - 64 hexadecimal characters

This approach simplifies the PIT (Point-in-Time) macro by avoiding PostgreSQL-specific `ENCODE/DECODE` operations.

### Performance Optimizations

**QUALIFY Clause**: Redshift macros use the modern `QUALIFY` clause for window function filtering, providing better performance than subquery approaches:

```sql
SELECT columns
FROM table
WHERE conditions
QUALIFY ROW_NUMBER() OVER(PARTITION BY pk ORDER BY ldts) = 1
```

### Table Macro Inheritance

- **Custom implementations**: `hub.sql`, `pit.sql`
- **PostgreSQL-based**: `link.sql`, `sat.sql`
- **Default inheritance**: `ref_table.sql`, `xts.sql`, `eff_sat.sql`, `ma_sat.sql`, `nh_link.sql`, `bridge.sql`

## Data Types

| AutomateDV Type | Redshift Type |
|----------------|---------------|
| type_binary    | VARCHAR(32) for MD5, VARCHAR(40) for SHA1, VARCHAR(64) for SHA256 |
| type_string    | VARCHAR |
| type_timestamp | TIMESTAMP (no timezone) |

## SQL Dialect Features Used

- **QUALIFY**: Window function result filtering
- **ROW_NUMBER()**: Row deduplication
- **LAG()**: Change detection in satellites
- **CONCAT_WS()**: String concatenation
- **MD5()**: MD5 hash computation
- **SHA1()**: SHA1 hash computation
- **SHA2(str, 256)**: SHA256 hash computation
- **MAX()**: Aggregate functions (including on VARCHAR hashes)

## Example Usage

```sql
-- models/raw_vault/hubs/hub_customer.sql
{{- config(
    materialized='incremental',
    schema='raw_vault'
) -}}

{%- set src_pk = 'CUSTOMER_PK' -%}
{%- set src_nk = 'CUSTOMER_ID' -%}
{%- set src_ldts = 'LOAD_DATETIME' -%}
{%- set src_source = 'RECORD_SOURCE' -%}

{{ automate_dv.hub(src_pk=src_pk,
                   src_nk=src_nk,
                   src_ldts=src_ldts,
                   src_source=src_source,
                   source_model='stg_customer') }}
```

## Differences from PostgreSQL

1. **PIT Macro**: Simplified to use direct `MAX()` on VARCHAR instead of `ENCODE(MAX(ENCODE()))`
2. **Hub Macro**: Uses `QUALIFY` instead of `DISTINCT ON`
3. **Binary Type**: Uses `VARCHAR` instead of `BYTEA`
4. **Hash Output**: Returns uppercase hex strings

## Troubleshooting

### QUALIFY not recognized
**Error**: `syntax error at or near "QUALIFY"`

**Solution**: Upgrade to Redshift version from July 2023 or later

### Hash configuration not working
**Error**: Hash values don't match expected algorithm

**Solution**: Ensure you're using the correct var name:
- `hash: 'md5'` for MD5
- `hash: 'sha1'` for SHA1
- `hash: 'sha'` for SHA256 (note: use 'sha', not 'sha256')

### VARCHAR length errors
**Error**: Value too long for type VARCHAR(32) or similar

**Solution**: Check your hash configuration vs table definition:
- MD5 needs VARCHAR(32)
- SHA1 needs VARCHAR(40)
- SHA256 needs VARCHAR(64)

If you changed hash algorithms, recreate the table with the correct VARCHAR length.
