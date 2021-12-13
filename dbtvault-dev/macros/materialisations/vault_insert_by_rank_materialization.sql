{% materialization vault_insert_by_rank, default -%}

    {%- set full_refresh_mode = flags.FULL_REFRESH -%}

    {%- set target_relation = this -%}
    {%- set existing_relation = load_relation(this) -%}
    {%- set tmp_relation = make_temp_relation(this) -%}

    {%- set rank_column = config.require('rank_column') -%}
    {%- set rank_source_models = config.require('rank_source_models') -%}

    {%- set min_max_ranks = dbtvault.get_min_max_ranks(rank_column, rank_source_models) | as_native -%}

    {%- set to_drop = [] -%}

    {%- do dbtvault.check_placeholder(sql, "__RANK_FILTER__") -%}

    {{ run_hooks(pre_hooks, inside_transaction=False) }}

    -- `BEGIN` happens here:
    {{ run_hooks(pre_hooks, inside_transaction=True) }}

    {% if existing_relation is none %}

        {% set filtered_sql = dbtvault.replace_placeholder_with_rank_filter(sql, rank_column, 1) %}
        {% set build_sql = create_table_as(False, target_relation, filtered_sql) %}

        {% do to_drop.append(tmp_relation) %}

    {% elif existing_relation.is_view or full_refresh_mode %}
        {#-- Make sure the backup doesn't exist so we don't encounter issues with the rename below #}
        {% set backup_identifier = existing_relation.identifier ~ "__dbt_backup" %}
        {% set backup_relation = existing_relation.incorporate(path={"identifier": backup_identifier}) %}

        {% do adapter.drop_relation(backup_relation) %}
        {% do adapter.rename_relation(target_relation, backup_relation) %}

        {% set filtered_sql = dbtvault.replace_placeholder_with_rank_filter(sql, rank_column, 1) %}
        {% set build_sql = create_table_as(False, target_relation, filtered_sql) %}

        {% do to_drop.append(tmp_relation) %}
        {% do to_drop.append(backup_relation) %}
    {% else %}

        {% set target_columns = adapter.get_columns_in_relation(target_relation) %}
        {%- set target_cols_csv = target_columns | map(attribute='quoted') | join(', ') -%}
        {%- set loop_vars = {'sum_rows_inserted': 0} -%}

        {% for i in range(min_max_ranks.max_rank | int ) -%}

            {%- set iteration_number = i + 1 -%}

            {%- set filtered_sql = dbtvault.replace_placeholder_with_rank_filter(sql, rank_column, iteration_number) -%}

            {{ dbt_utils.log_info("Running for {} {} of {} on column '{}' [{}]".format('rank', iteration_number, min_max_ranks.max_rank, rank_column, model.unique_id)) }}

            {% set tmp_relation = make_temp_relation(this) %}

            {# This call statement drops and then creates a temporary table #}
            {# but MSSQL will fail to drop any temporary table created by a previous loop iteration #}
            {# See MSSQL note and drop code below #}
            {% call statement() -%}
                {{ create_table_as(True, tmp_relation, filtered_sql) }}
            {%- endcall %}

            {{ adapter.expand_target_column_types(from_relation=tmp_relation,
                                                  to_relation=target_relation) }}

            {%- set insert_query_name = 'main-' ~ i -%}
            {% call statement(insert_query_name, fetch_result=True) -%}
                INSERT INTO {{ target_relation }} ({{ target_cols_csv }})
                (
                    SELECT {{ target_cols_csv }}
                    FROM {{ tmp_relation.include(schema=True) }}
                );
            {%- endcall %}

            {% set result = load_result(insert_query_name) %}

            {% if 'response' in result.keys() %} {# added in v0.19.0 #}
                {% set rows_inserted = result['response']['rows_affected'] %}
            {% else %} {# older versions #}
                {% set rows_inserted = result['status'].split(" ")[2] | int %}
            {% endif %}

            {%- set sum_rows_inserted = loop_vars['sum_rows_inserted'] + rows_inserted -%}
            {%- do loop_vars.update({'sum_rows_inserted': sum_rows_inserted}) %}

            {{ dbt_utils.log_info("Ran for {} {} of {}; {} records inserted [{}]".format('rank', iteration_number,
                                                                                          min_max_ranks.max_rank,
                                                                                          rows_inserted,
                                                                                          model.unique_id)) }}

            {% do to_drop.append(tmp_relation) %}
            {% do adapter.commit() %}

        {% endfor %}
        {% call noop_statement('main', "INSERT {}".format(loop_vars['sum_rows_inserted']) ) -%}
            {{ filtered_sql }}
        {%- endcall %}

    {% endif %}

    {% if build_sql is defined %}
        {% call statement("main", fetch_result=True) %}
            {{ build_sql }}
        {% endcall %}

        {% set result = load_result('main') %}

        {% if 'response' in result.keys() %} {# added in v0.19.0 #}
            {% set rows_inserted = result['response']['rows_affected'] %}
        {% else %} {# older versions #}
            {% set rows_inserted = result['status'].split(" ")[2] | int %}
        {% endif %}

        {% call noop_statement('main', "BASE LOAD {}".format(rows_inserted)) -%}
            {{ build_sql }}
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