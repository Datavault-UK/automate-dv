{% if execute %} 
    {{ dbtvault.hash(columns=var('columns'), alias=var('alias'), hashdiff=var('hashdiff')) }}
{% endif %}