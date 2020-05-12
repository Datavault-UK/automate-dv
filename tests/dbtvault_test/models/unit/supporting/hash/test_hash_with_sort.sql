{% if execute %} 
    {{ dbtvault.hash(columns=var('columns'), alias=var('alias'), sort=var('sort')) }}
{% endif %}