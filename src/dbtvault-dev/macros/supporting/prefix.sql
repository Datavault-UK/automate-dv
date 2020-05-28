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

{%- macro prefix(columns, prefix_str, alias_target) -%}

    {{- log(this, true) -}}
    {{- log('cols 1: ' ~ columns, true) -}}

    {{- adapter_macro('dbtvault.prefix', columns=columns, prefix_str=prefix_str, alias_target=alias_target) -}}

{%- endmacro -%}

{%- macro default__prefix(columns=none, prefix_str=none, alias_target='source') -%}

    {{- log('cols 2: ' ~ columns, true) -}}

    {%- if columns and prefix_str -%}

        {{- log('here 1', true) -}}

        {%- for col in columns -%}

            {{- log('here 2', true) -}}

            {%- if col is mapping -%}

                {{- log('here 3', true) -}}

                {%- if alias_target == 'source' -%}

                    {{- log('cols 3: ' ~ columns, true) -}}

                    {{- dbtvault.prefix([col['source_column']], prefix_str) -}}

                {%- elif alias_target == 'target' -%}

                    {{- log('cols 4: ' ~ columns, true) -}}

                    {{- dbtvault.prefix([col['alias']], prefix_str) -}}

                {%- else -%}

                    {{- log('cols 5: ' ~ columns, true) -}}

                    {{- dbtvault.prefix([col['source_column']], prefix_str) -}}

                {%- endif -%}

                {%- if not loop.last -%} , {% endif %}

            {%- else -%}

                {{- log('here 6 ' ~ col, true) -}}

                {%- if col is iterable and col is not string -%}

                    {{- log('cols 6: ' ~ columns, true) -}}

                    {{- dbtvault.prefix(col, prefix_str) -}}

                {%- elif col is not none -%}

                    {{- log('here 7 ' ~ col, true) -}}

                    {{- prefix_str}}.{{col.strip() -}}
                {% else %}

                    {%- if execute -%}
                        {{- exceptions.raise_compiler_error("Unexpected or missing configuration for '" ~ this ~ "' Unable to prefix columns.") -}}
                    {%- endif -%}
                {%- endif -%}

                {{- ', ' if not loop.last -}}

            {%- endif -%}

        {%- endfor -%}

    {%- else -%}

        {%- if execute -%}
            {{- exceptions.raise_compiler_error("Invalid parameters provided to prefix macro. Expected: (columns [list/string], prefix_str [string]) got: (" ~ columns ~ ", " ~ prefix_str ~ ")") -}}
        {%- endif -%}
    {%- endif -%}

{%- endmacro -%}