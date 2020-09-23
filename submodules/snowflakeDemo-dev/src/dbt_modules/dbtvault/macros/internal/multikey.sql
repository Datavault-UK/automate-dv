{#- Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-#}
{%- macro multikey(columns=none, aliases=none, type_for=none) -%}

    {{- adapter_macro('dbtvault.multikey', columns=columns, aliases=aliases, type_for=type_for) -}}

{%- endmacro %}

{%- macro default__multikey(columns, aliases, type_for) -%}

{% if type_for == 'join' %}

{% for col in columns if not columns is string %}
    {{ dbtvault.prefix([col], aliases[0]) }} = {{ dbtvault.prefix([col], aliases[1]) }}
    {% if not loop.last %} AND {% endif %}
{% else %}
    {{ dbtvault.prefix([columns], aliases[0]) }} = {{ dbtvault.prefix([columns], aliases[1]) }}
{% endfor %}

{% elif type_for == 'where null' %}

{% for col in columns if not columns is string %}
    {{ dbtvault.prefix([col], aliases[0]) }} IS NULL
    {% if not loop.last %} AND {% endif %}
{% else %}
    {{ dbtvault.prefix([columns], aliases[0]) }} IS NULL
{% endfor %}

{% elif type_for == 'where not null'%}

{% for col in columns if not columns is string %}
    {{ dbtvault.prefix([col], aliases[0]) }} IS NOT NULL
    {% if not loop.last %} AND {% endif %}
{% else %}
    {{ dbtvault.prefix([columns], aliases[0]) }} IS NOT NULL
{% endfor %}
{% endif %}
{% endmacro %}