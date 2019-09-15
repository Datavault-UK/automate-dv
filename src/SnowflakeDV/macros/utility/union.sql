{%- macro union(src_pk, src_nk, src_ldts, src_source, tgt_pk, src_table,  hash_model) -%}

 {%- set letters='abcdefghijklmnopqrstuvwxyz' -%}

    FROM (
        {%- for src in src_table -%}

        {%- set letter = letters[loop.index0] -%}

        {{- snow_vault.single(src_pk[loop.index0], src_nk[loop.index0], src_ldts, src_source,
                              tgt_pk[loop.index0], letters[loop.index0]) }}
        {% if not loop.last -%}
        UNION
        {% endif %}
        {%- endfor %})
{%- endmacro -%}