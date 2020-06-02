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
{%- macro as_constant(column_str=none) -%}

    {{- adapter_macro('dbtvault.as_constant', column_str=column_str) -}}

{%- endmacro %}

{%- macro default__as_constant(column_str) -%}

    {% if column_str is not none %}

        {%- if column_str | first == "!" -%}
        
            {{- return("'" ~ column_str[1:] ~ "'") -}}
        
        {%- else -%}
        
            {{- return(column_str) -}}
        
        {%- endif -%}
    {%- endif -%}

{%- endmacro -%}