{% if execute %} 
    {{ dbtvault.hash(columns=var('columns'), alias=var('alias'), is_hashdiff=var('is_hashdiff')) }}
{% endif %}