{%- macro bridge(src_pk, src_dfk, src_sfk, src_start_date, src_end_date, src_eff, src_ldts, src_source, source_model) -%}

    {{- adapter.dispatch('bridge', packages = dbtvault.get_dbtvault_namespaces())(src_pk=src_pk, src_dfk=src_dfk, src_sfk=src_sfk,
                                                                                   src_start_date=src_start_date, src_end_date=src_end_date,
                                                                                   src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                                                                                   source_model=source_model) -}}
{%- endmacro -%}

{%- macro default__bridge(src_pk, src_dfk, src_sfk, src_start_date, src_end_date, src_eff, src_ldts, src_source, source_model) -%}

{{- dbtvault.check_required_parameters(src_pk=src_pk, src_dfk=src_dfk, src_sfk=src_sfk,
                                       src_start_date=src_start_date, src_end_date=src_end_date,
                                       src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                                       source_model=source_model) -}}

{%- endmacro -%}