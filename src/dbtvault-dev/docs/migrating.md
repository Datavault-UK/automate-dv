# Migrating from v0.4 to v0.5

With the release of v0.5, we've moved metadata into vars on the ```dbt_project.yml``` file. Your old metadata would
have looked something like this: 

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

 - The metadata is now specified in the ```dbt_project.yml``` file. Below can be seen how to structure this metadata in
the ```dbt_project.yml``` file.
- You no longer need to specific target table mapping, your target table columns
will have to same as those from the stage meaning any aliasing or data-types must be specified and dealt with in the
staging layer. 

The metadata is structure as follows:

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

!!! note
    Please ensure that your ```dbt_project.yml``` file is formatted properly and contains the correct hierarchy.