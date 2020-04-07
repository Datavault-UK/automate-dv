{%- macro multikey(columns, aliases, type_for) -%}

{% if type_for == 'join' %}

{% for col in columns if not columns is string %}
    {% if loop.index == columns|length %}
        {{ dbtvault.prefix([col], aliases[0]) }}={{ dbtvault.prefix([col], aliases[1]) }}
    {% else %}
        {{ dbtvault.prefix([col], aliases[0]) }}={{ dbtvault.prefix([col], aliases[1]) }} AND
    {% endif %}
{% else %}
    {{ dbtvault.prefix([columns], aliases[0]) }}={{ dbtvault.prefix([columns], aliases[1]) }}
{% endfor %}

{% elif type_for ==  'where null'%}

{% for col in columns if not columns is string %}
    {% if loop.index == columns|length %}
        {{ dbtvault.prefix([col], aliases[0]) }} IS NULL
    {% else %}
        {{ dbtvault.prefix([col], aliases[0]) }} IS NULL AND
    {% endif %}
{% else %}
    {{ dbtvault.prefix([columns], aliases[0]) }} IS NULL
{% endfor %}

{% elif type_for == 'where not null'%}

{% for col in columns if not columns is string %}
    {% if loop.index == columns|length %}
        {{ dbtvault.prefix([col], aliases[0]) }}<>{{ dbtvault.hash_check(var('hash')) }}
    {% else %}
        {{ dbtvault.prefix([col], aliases[0]) }}<>{{ dbtvault.hash_check(var('hash')) }} AND
    {% endif %}
{% else %}
    {{ dbtvault.prefix([columns], aliases[0]) }}<>{{ dbtvault.hash_check(var('hash')) }}
{% endfor %}
{% endif %}
{% endmacro %}