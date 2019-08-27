{% macro hub_template(src_table, src_pk, src_nk, src_ldts, src_source, tgt_table, tgt_pk, tgt_nk) %}

 select
{{tgt_pk}}, {{tgt_nk}}
 from
 (select distinct {{src_pk}}, {{src_nk}}
  from (
    select {{src_pk}}, {{src_nk}}
    from
    {{src_table}} as a
    left join {{tgt_table}}
    as c
    on a.{{src_pk}}=c.{{tgt_pk}}
    and c.{{tgt_pk}} is null)
  as b)
 as stg

{% endmacro %}