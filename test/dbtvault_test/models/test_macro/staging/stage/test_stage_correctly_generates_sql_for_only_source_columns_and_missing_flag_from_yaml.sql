{%- set yaml_metadata -%}
source_model: raw_source
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{% set include_source_columns = metadata_dict.get('include_source_columns', none) %}

{% set source_model = metadata_dict.get('source_model', none) %}

{% set derived_columns = metadata_dict.get('derived_columns', none) %}

{% set hashed_columns = metadata_dict.get('hashed_columns', none) %}

{% set ranked_columns = metadata_dict.get('ranked_columns', none) %}

{{ dbtvault.stage(include_source_columns=include_source_columns,
                  source_model=source_model,
                  derived_columns=derived_columns,
                  hashed_columns=hashed_columns,
                  ranked_columns=ranked_columns) }}