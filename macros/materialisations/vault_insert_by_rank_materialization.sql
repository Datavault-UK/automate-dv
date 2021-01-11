{% materialization vault_insert_by_rank, default -%}

    {%- set full_refresh_mode = flags.FULL_REFRESH -%}

    {%- set target_relation = this -%}
    {%- set existing_relation = load_relation(this) -%}
    {%- set tmp_relation = make_temp_relation(this) -%}

    {%- set partition_by_column = config.require('partition_by_column') -%}
    {%- set order_by_column = config.require('order_by_column') -%}

    {%- set to_drop = [] -%}

    {%- do dbtvault.check_placeholder(sql, "__RANK_FILTER__") -%}
    {%- do dbtvault.check_placeholder(sql, "__RANK_COLUMN__") -%}

    {{ run_hooks(pre_hooks, inside_transaction=False) }}

    -- `BEGIN` happens here:
    {{ run_hooks(pre_hooks, inside_transaction=True) }}

    {% if existing_relation is none %}

        {% set filtered_sql = dbtvault.replace_placeholder_with_rank_filter(sql, partition_by_column, order_by_column, 1) %}

        {% do log("filtered sql: " ~ filtered_sql, true) %}

        {% set build_sql = create_table_as(False, target_relation, filtered_sql) %}

        {% do to_drop.append(tmp_relation) %}

    {% elif existing_relation.is_view or full_refresh_mode %}
        {#-- Make sure the backup doesn't exist so we don't encounter issues with the rename below #}
        {% set backup_identifier = existing_relation.identifier ~ "__dbt_backup" %}
        {% set backup_relation = existing_relation.incorporate(path={"identifier": backup_identifier}) %}

        {% do adapter.drop_relation(backup_relation) %}
        {% do adapter.rename_relation(target_relation, backup_relation) %}

        {% set filtered_sql = dbtvault.replace_placeholder_with_rank_filter(sql, partition_by_column, order_by_column, 1) %}
        {% set build_sql = create_table_as(False, target_relation, filtered_sql) %}
        {% do log("filtered sql: " ~ filtered_sql, true) %}
        {% do to_drop.append(tmp_relation) %}
        {% do to_drop.append(backup_relation) %}
    {% else %}

        {% set target_columns = adapter.get_columns_in_relation(target_relation) %}
        {%- set target_cols_csv = target_columns | map(attribute='quoted') | join(', ') -%}
        {%- set loop_vars = {'sum_rows_inserted': 0} -%}

        {% call noop_statement(name='main', status="INSERT {}".format(loop_vars['sum_rows_inserted']) ) -%}
            -- no-op
        {%- endcall %}

    {% endif %}

    {% if build_sql is defined %}
        {% call statement("main", fetch_result=True) %}
            {{ build_sql }}
        {% endcall %}

        {%- set rows_inserted = (load_result("main")['status'].split(" "))[1] | int -%}

        {% call noop_statement(name='main', status="BASE LOAD {}".format(rows_inserted)) -%}
            -- no-op
        {%- endcall %}

        -- `COMMIT` happens here
        {% do adapter.commit() %}
    {% endif %}

    {{ run_hooks(post_hooks, inside_transaction=True) }}

    {% for rel in to_drop %}
        {% if rel.type is not none %}
            {% do adapter.drop_relation(rel) %}
        {% endif %}
    {% endfor %}

    {{ run_hooks(post_hooks, inside_transaction=False) }}

    {{ return({'relations': [target_relation]}) }}

{%- endmaterialization %}