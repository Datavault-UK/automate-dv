{%- macro bigquery__bridge(src_pk, as_of_dates_table, bridge_walk, stage_tables_ldts, src_extra_columns, src_ldts, source_model) -%}

{{ dbtvault.default__bridge(src_pk=src_pk,
                            as_of_dates_table=as_of_dates_table,
                            bridge_walk=bridge_walk,
                            stage_tables_ldts=stage_tables_ldts,
                            src_extra_columns=src_extra_columns,
                            src_ldts=src_ldts,
                            source_model=source_model) }}

{%- endmacro -%}
