{% if execute %} 
    {{ dbtvault.hash(columns=var('columns'), alias=var('alias')) }}
{% endif %}