{%- macro union(src_table, src_pk, src_nk, src_ldts, src_source, tgt_pk, hash_model) -%}

 {%- set letters='abcdefghijklmnopqrstuvwxyz' -%}

    FROM (
        {%- for src in src_table -%}

        {%- set letter = letters[loop.index0] -%}

        SELECT DISTINCT {{ snow_vault.prefix([
        src_pk[loop.index0],
        src_nk[loop.index0],
        src_ldts,
        src_source], letter ) }}
        {% if hash_model is none -%}
        FROM {{ src }} AS {{ letter }}
        {% else -%}
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