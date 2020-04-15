# Migrating from v0.4 to v0.5

With the release of v0.5, we moved the metadata into variables held in in the ```dbt_project.yml``` file.
Your old metadata would have looked something like this: 

```sql
{{- config(materialized='incremental', schema='vlt', enabled=true, tags='hubs')    -}}

{%- set source = [ref('v_stg_orders')]                            -%}

{%- set src_pk = 'CUSTOMER_PK'                                                     -%}
{%- set src_nk = 'CUSTOMER_ID'                                                     -%}
{%- set src_ldts = 'LOADDATE'                                                      -%}
{%- set src_source = 'SOURCE'                                                      -%}

{%- set tgt_pk = source                                                            -%}
{%- set tgt_nk = source                                                            -%}
{%- set tgt_ldts = source                                                          -%}
{%- set tgt_source = source                                                        -%}

{{ dbtvault.hub_template(src_pk, src_nk, src_ldts, src_source,
                         tgt_pk, tgt_nk, tgt_ldts, tgt_source,
                         source)                                                    }}
```

With v0.5, several things have changed:

 - The metadata is now specified in the ```dbt_project.yml``` file. Below is how to structure this metadata in
the ```dbt_project.yml``` file.
- You can no longer specify target column mappings, your target table columns
will be derived from your source table metadata.

The metadata is structured as follows in the ```dbt_project.yml``` file:

```yaml
hub_customer:
          vars:
            source: 'v_stg_orders'
            src_pk: 'CUSTOMER_PK'
            src_nk: 'CUSTOMER_KEY'
            src_ldts: 'LOADDATE'
            src_source: 'SOURCE'
```

The new example ```hub_customer.sql``` would then look like:

```sql
{{- config(materialized='incremental', schema='MYSCHEMA', tags='hub') -}}

{{ dbtvault.hub(var('src_pk'), var('src_nk'), var('src_ldts'),
                var('src_source'), var('source'))                      }}
```