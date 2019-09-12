{%- macro union(src_table, src_pk, src_nk, src_ldts, src_source, tgt_pk, hash_model, src_eff=none, src_hash=none) -%}

 {%- set letters='abcdefghijklmnopqrstuvwxyz' -%}

    FROM (
        {%- for src in src_table -%}

        {%- set letter = letters[loop.index0] -%}

        SELECT DISTINCT
        {% if src_table|length <= 1 -%}
            {{- snow_vault.prefix([src_hash if src_hash, src_pk, src_nk, src_ldts, src_eff if src_eff, src_source], letter) -}}
        {% else %}
            {{- snow_vault.prefix([src_hash[loop.index0] if src_hash, src_pk[loop.index0], src_nk[loop.index0], src_ldts, src_eff if src_eff, src_source], letter) -}}
        {% endif %}
        {% if hash_model is none -%}
        FROM {{ src }} AS {{ letter }}
        {%- else -%}
        FROM {{ hash_model[loop.index0] }} AS {{ letter }}
        {%- endif %}
        {%- if is_incremental() %}
        LEFT JOIN {{ this }} AS tgt_{{ letter }}
        ON {{ letter }}.{{ src_pk[loop.index0] }} = tgt_{{ letter }}.{{ tgt_pk }}
        AND tgt_{{ letter }}.{{ tgt_pk }} IS NULL
        {%- endif %}
        {% if not loop.last -%}
        UNION
        {% endif %}
        {%- endfor %})
{%- endmacro -%}