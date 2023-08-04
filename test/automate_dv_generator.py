import io
import os
import shutil
import textwrap
from functools import partial

import ruamel.yaml

from env import env_utils
from test import *


def raw_vault_structure(model_name, vault_structure, config=None, **kwargs):
    """
    Generate a vault structure
        :param model_name: Name of model to generate
        :param vault_structure: Type of structure to generate (stage, hub, link, sat)
        :param config: Optional config
        :param kwargs: Arguments for model the generator
    """

    vault_structure = vault_structure.lower()

    generator_functions = {
        "stage": stage,
        "hub": hub,
        "link": link,
        "sat": sat,
        "eff_sat": eff_sat,
        "t_link": t_link,
        "xts": xts,
        "ma_sat": ma_sat,
        "bridge": bridge,
        "pit": pit,
        "ref_table": ref_table
    }

    processed_metadata = process_structure_metadata(vault_structure=vault_structure, model_name=model_name,
                                                    config=config, **kwargs)

    if generator_functions.get(vault_structure):
        generator_functions[vault_structure](**processed_metadata)
    else:
        raise ValueError(f"Invalid vault structure name '{vault_structure}'")


def stage(model_name, source_model: dict, derived_columns=None, null_columns=None, hashed_columns=None,
          ranked_columns=None, include_source_columns=True, config=None, depends_on=""):
    """
    Generate a stage model template
        :param model_name: Name of the model file
        :param source_model: Model to select from
        :param hashed_columns: Dictionary of hashed columns, can be None
        :param derived_columns: Dictionary of derived column, can be None
        :param hashed_columns: Dictionary of hashed columns, can be None
        :param ranked_columns: Dictionary of ranked columns, can be None
        :param null_columns: Dictionary of null columns, can be None
        :param include_source_columns: Boolean: Whether to extract source columns from source table
        :param depends_on: depends on string if provided
        :param config: Optional model config
        :param depends_on: Optional forced dependency
    """

    template = f"""
    {depends_on}
    {{{{ config({config}) }}}}
    {{{{ automate_dv.stage(include_source_columns={str(include_source_columns).lower()},
                           source_model={source_model},
                           derived_columns={derived_columns},
                           null_columns={null_columns},
                           hashed_columns={hashed_columns},
                           ranked_columns={ranked_columns}) }}}}
    """

    template_to_file(template, model_name)


def hub(model_name, src_pk, src_nk,
        src_ldts, src_source, source_model, config,
        src_extra_columns=None, depends_on=""):
    """
    Generate a hub model template
        :param model_name: Name of the model file
        :param src_pk: Source pk
        :param src_nk: Source nk
        :param src_ldts: Source load date timestamp
        :param src_source: Source record source column
        :param source_model: Model name to select from
        :param config: Optional model config string
        :param src_extra_columns: Additional columns to add to the hub
        :param depends_on: Optional forced dependency
    """

    template = f"""
    {depends_on}    
    {{{{ config({config}) }}}}
    {{{{ automate_dv.hub(src_pk={src_pk}, src_nk={src_nk}, 
                         src_ldts={src_ldts}, src_source={src_source}, 
                         src_extra_columns={src_extra_columns if src_extra_columns else 'none'}, 
                         source_model={source_model})   }}}}
    """

    template_to_file(template, model_name)


def link(model_name, src_pk, src_fk,
         src_ldts, src_source, source_model, config,
         src_extra_columns=None, depends_on=""):
    """
    Generate a link model template
        :param model_name: Name of the model file
        :param src_pk: Source pk
        :param src_fk: Source fk
        :param src_ldts: Source load date timestamp
        :param src_source: Source record source column
        :param source_model: Model name to select from
        :param config: Optional model config
        :param src_extra_columns: Additional columns to add to the link
        :param depends_on: Optional forced dependency
    """

    template = f"""
    {depends_on}
    {{{{ config({config}) }}}}
    {{{{ automate_dv.link(src_pk={src_pk}, src_fk={src_fk}, 
                          src_extra_columns={src_extra_columns if src_extra_columns else 'none'}, 
                          src_ldts={src_ldts}, src_source={src_source}, 
                          source_model={source_model})   }}}}
    """

    template_to_file(template, model_name)


def t_link(model_name, src_pk, src_fk, src_eff, src_ldts, src_source, source_model, config,
           src_payload=None, src_extra_columns=None, depends_on=""):
    """
    Generate a t-link model template
        :param model_name: Name of the model file
        :param src_pk: Source pk
        :param src_fk: Source fk
        :param src_payload: Source payload
        :param src_extra_columns: Additional columns to add to the t link
        :param src_eff: Source effective from
        :param src_ldts: Source load date timestamp
        :param src_source: Source record source column
        :param source_model: Model name to select from
        :param config: Optional model config
        :param depends_on: Optional forced dependency
    """

    template = f"""
    {depends_on}
    {{{{ config({config}) }}}}
    {{{{ automate_dv.t_link(src_pk={src_pk}, src_fk={src_fk}, 
                            src_payload={src_payload if src_payload else 'none'},
                            src_extra_columns={src_extra_columns if src_extra_columns else 'none'}, 
                            src_eff={src_eff}, src_ldts={src_ldts}, src_source={src_source}, 
                            source_model={source_model}) }}}}
    """

    template_to_file(template, model_name)


def sat(model_name, src_pk, src_hashdiff, src_payload,
        src_eff, src_ldts, src_source, source_model,
        config, src_extra_columns=None, depends_on=""):
    """
    Generate a satellite model template
        :param model_name: Name of the model file
        :param src_pk: Source pk
        :param src_hashdiff: Source hashdiff
        :param src_payload: Source payload
        :param src_extra_columns: Additional columns to add to the satellite
        :param src_eff: Source effective from
        :param src_ldts: Source load date timestamp
        :param src_source: Source record source column
        :param source_model: Model name to select from
        :param config: Optional model config
        :param depends_on: Optional forced dependency
    """

    template = f"""
    {depends_on}
    {{{{ config({config}) }}}}
    {{{{ automate_dv.sat(src_pk={src_pk}, src_hashdiff={src_hashdiff}, src_payload={src_payload},
                         src_extra_columns={src_extra_columns if src_extra_columns else 'none'}, 
                         src_eff={src_eff}, src_ldts={src_ldts}, src_source={src_source}, 
                         source_model={source_model}) }}}}
    """

    template_to_file(template, model_name)


def eff_sat(model_name, src_pk, src_dfk, src_sfk,
            src_start_date, src_end_date, src_eff, src_ldts, src_source,
            source_model, config, src_extra_columns=None, depends_on=""):
    """
    Generate an effectivity satellite model template
        :param model_name: Name of the model file
        :param src_pk: Source pk
        :param src_dfk: Source driving foreign key
        :param src_sfk: Source surrogate foreign key
        :param src_eff: Source effective from
        :param src_start_date: Source start date
        :param src_end_date: Source end date
        :param src_extra_columns: Additional columns to add to the eff sat
        :param src_ldts: Source load date timestamp
        :param src_source: Source record source column
        :param source_model: Model name to select from
        :param config: Optional model config
        :param depends_on: Optional forced dependency
    """

    template = f"""
    {depends_on}
    {{{{ config({config}) }}}}
    {{{{ automate_dv.eff_sat(src_pk={src_pk}, src_dfk={src_dfk}, src_sfk={src_sfk},
                             src_start_date={src_start_date}, src_end_date={src_end_date},
                             src_extra_columns={src_extra_columns if src_extra_columns else 'none'}, 
                             src_eff={src_eff}, src_ldts={src_ldts}, src_source={src_source},
                             source_model={source_model}) }}}}
    """

    template_to_file(template, model_name)


def ma_sat(model_name, src_pk, src_cdk, src_hashdiff, src_payload,
           src_ldts, src_source, source_model, config, src_eff=None, src_extra_columns=None):
    """
    Generate a multi active satellite model template
        :param model_name: Name of the model file
        :param src_pk: Source pk
        :param src_cdk: Source cdk
        :param src_hashdiff: Source hashdiff
        :param src_payload: Source payload
        :param src_eff: Source effective from
        :param src_extra_columns: Additional columns to add to the ma sat
        :param src_ldts: Source load date timestamp
        :param src_source: Source record source column
        :param source_model: Model name to select from
        :param config: Optional model config
    """

    template = f"""
    {{{{ config({config}) }}}}
    {{{{ automate_dv.ma_sat(src_pk={src_pk}, src_cdk={src_cdk}, src_hashdiff={src_hashdiff}, 
                            src_payload={src_payload}, 
                            src_eff={src_eff if src_eff else 'none'}, 
                            src_extra_columns={src_extra_columns if src_extra_columns else 'none'}, 
                            src_ldts={src_ldts}, src_source={src_source}, 
                            source_model={source_model}) }}}}
    """

    template_to_file(template, model_name)


def xts(model_name, src_pk, src_satellite, src_ldts, src_source, source_model,
        src_extra_columns=None, config=None, depends_on=""):
    """
    Generate a XTS template
        :param model_name: Name of the model file
        :param src_pk: Source pk
        :param src_satellite: Satellite to track
        :param src_extra_columns: Additional columns to add to the xts
        :param src_ldts: Source load date timestamp
        :param src_source: Source record source column
        :param source_model: Model name to select from
        :param config: Optional model config
        :param depends_on: Optional forced dependency
    """

    template = f"""
    {depends_on}
    {{{{ config({config}) }}}}
    {{{{ automate_dv.xts(src_pk={src_pk}, src_satellite={src_satellite}, 
                         src_extra_columns={src_extra_columns if src_extra_columns else 'none'}, 
                         src_ldts={src_ldts}, src_source={src_source},
                         source_model={source_model}) }}}}
    """

    template_to_file(template, model_name)


def pit(model_name, source_model, src_pk, as_of_dates_table, satellites,
        stage_tables_ldts, src_ldts, src_extra_columns=None, depends_on="", config=None):
    """
    Generate a PIT template
        :param model_name: Name of the model file
        :param src_pk: Source pk
        :param src_extra_columns: Additional columns to add to the bridge
        :param as_of_dates_table: Name for the AS_OF table
        :param satellites: Dictionary of satellite reference mappings
        :param src_ldts: Source Load Date timestamp
        :param stage_tables_ldts: List of stage table load date(time) stamps
        :param source_model: Model name to select from
        :param config: Optional model config
        :param depends_on: Optional forced dependency
    """

    template = f"""
    {depends_on}
    {{{{ config({config}) }}}}
    {{{{ automate_dv.pit(src_pk={src_pk}, 
                         src_extra_columns={src_extra_columns if src_extra_columns else 'none'},
                         as_of_dates_table={as_of_dates_table}, 
                         satellites={satellites}, 
                         stage_tables_ldts={stage_tables_ldts},
                         src_ldts={src_ldts},
                         source_model={source_model}) }}}}
    """

    template_to_file(template, model_name)


def bridge(model_name, src_pk, as_of_dates_table, bridge_walk, stage_tables_ldts, source_model, src_ldts,
           config, src_extra_columns=None, depends_on=""):
    """
    Generate a bridge model template
        :param model_name: Name of the model file
        :param src_pk: Source pk
        :param as_of_dates_table: Name for the AS_OF table
        :param bridge_walk: Dictionary of links and effectivity satellite reference mappings
        :param stage_tables_ldts: List of stage table load date(time) stamps
        :param source_model: Model name to select from
        :param src_extra_columns: Additional columns to add to the bridge
        :param src_ldts: Source load date timestamp
        :param config: Optional model config
        :param depends_on: Optional forced dependency
    """
    template = f"""
    {depends_on}
    {{{{ config({config}) }}}}
    {{{{ automate_dv.bridge(src_pk={src_pk}, 
                            src_extra_columns={src_extra_columns if src_extra_columns else 'none'}, 
                            src_ldts={src_ldts}, 
                            as_of_dates_table={as_of_dates_table}, 
                            bridge_walk={bridge_walk}, 
                            stage_tables_ldts={stage_tables_ldts},
                            source_model={source_model}) }}}}
    """

    template_to_file(template, model_name)


def ref_table(model_name, src_pk, src_ldts, src_source, source_model,
              config, src_extra_columns=None, depends_on=""):
    """
    Generate a reference table model template
        :param model_name: Name of the model file
        :param src_pk: Source pk
        :param src_ldts: Source load date timestamp
        :param src_source: Source record source column
        :param source_model: Model name to select from
        :param config: Optional model config string
        :param src_extra_columns: Additional columns to add to the reference table
        :param depends_on: Optional forced dependency
    """

    template = f"""
    {depends_on}    
    {{{{ config({config}) }}}}
    {{{{ automate_dv.ref_table(src_pk={src_pk}, src_ldts={src_ldts}, src_source={src_source}, 
                               src_extra_columns={src_extra_columns if src_extra_columns else 'none'}, 
                               source_model={source_model})   }}}}
    """

    template_to_file(template, model_name)


def macro_model(model_name, macro_name, metadata=None):
    """
    Generate a model containing a call to a macro
        :param model_name: Name of model to generate
        :param macro_name: Type of macro to generate a model for
        :param metadata: Optional metadata dictionary
    """

    macro_name = macro_name.lower()

    generator_functions = {
        "hash": hash_macro,
        "prefix": prefix_macro,
        "derive_columns": derive_columns_macro,
        "hash_columns": hash_columns_macro,
        "rank_columns": rank_columns_macro,
        "stage": stage_macro,
        "concat_ws": concat_ws_macro,
        "expand_column_list": expand_column_list_macro,
        "as_constant": as_constant_macro,
        "alias": alias_macro,
        "alias_all": alias_all_macro,
        "escape_column_names": escape_column_names_macro,
        "null_columns": null_columns_macro,
        "create_ghost_record": create_ghost_record_macro,
        "null_expression": null_expression_macro,
        "select_hash_alg": select_hash_alg_macro,
        "standard_column_wrapper": standard_column_wrapper_macro,
        "process_columns_to_escape": process_columns_to_escape_macro,
    }

    if generator_functions.get(macro_name):
        generator_functions[macro_name](model_name, metadata=metadata)
    else:
        raise ValueError(f"Invalid macro name '{macro_name}'")


def hash_macro(model_name, **_):
    template = f"""
    {{% if execute %}}
    {{{{ automate_dv.hash(columns=var('columns'), 
                          alias=var('alias'), 
                          is_hashdiff=var('is_hashdiff', false), 
                          columns_to_escape=var('columns_to_escape', false)) }}}}
    {{% endif %}}
    """

    template_to_file(template, model_name)


def concat_ws_macro(model_name, **_):
    template = f"""
    {{%- if execute -%}}
    {{{{ automate_dv.concat_ws(string_list=var('string_list')) }}}}
    {{%- endif -%}}
    """

    template_to_file(template, model_name)


def derive_columns_macro(model_name, **_):
    template = f"""
    -- depends_on: {{{{ ref('raw_source') }}}}
    {{%- if execute -%}}
        {{%- if var('source_model', '') != '' -%}}
            {{%- set source_relation = ref(var('source_model')) -%}}
        {{% endif %}}
    {{% endif %}}
    
    {{{{ automate_dv.derive_columns(source_relation=source_relation, columns=var('columns', [])) }}}}
    """

    template_to_file(template, model_name)


def null_columns_macro(model_name, **_):
    template = f"""
    {{%- if execute -%}}
    {{{{ automate_dv.null_columns(columns=var('columns', [])) }}}}
    {{% endif %}}
    """

    template_to_file(template, model_name)


def hash_columns_macro(model_name, metadata):
    template = f"{{%- set yaml_metadata -%}}\n" \
               f"{dict_to_yaml_string(metadata)}" \
               f"{{%- endset -%}}\n\n" \
               f"{{% set metadata_dict = fromyaml(yaml_metadata) %}}\n\n" \
               f"{{{{ automate_dv.hash_columns(columns=metadata_dict['columns']) }}}}"

    template_to_file(textwrap.dedent(template), model_name)


def rank_columns_macro(model_name, metadata):
    template = f"{{%- set yaml_metadata -%}}\n" \
               f"{dict_to_yaml_string(metadata)}" \
               f"{{%- endset -%}}\n\n" \
               f"{{% set metadata_dict = fromyaml(yaml_metadata) %}}\n\n" \
               f"{{{{ automate_dv.rank_columns(columns=metadata_dict['columns']) }}}}"

    template_to_file(textwrap.dedent(template), model_name)


def stage_macro(model_name, metadata):
    template = f"{{%- set yaml_metadata -%}}\n" \
               f"{dict_to_yaml_string(metadata)}" \
               f"{{%- endset -%}}\n\n" \
               f"{{% set metadata_dict = fromyaml(yaml_metadata) %}}\n\n" \
               f"{{{{ automate_dv.stage(include_source_columns=metadata_dict.get('include_source_columns', none),\n" \
               f"                       source_model=metadata_dict.get('source_model', none),\n" \
               f"                       derived_columns=metadata_dict.get('derived_columns', none),\n" \
               f"                       null_columns=metadata_dict.get('null_columns', none),\n" \
               f"                       hashed_columns=metadata_dict.get('hashed_columns', none),\n" \
               f"                       ranked_columns=metadata_dict.get('ranked_columns', none)) }}}}"

    template_to_file(template, model_name)


def expand_column_list_macro(model_name, **_):
    template = "{{- automate_dv.expand_column_list(columns=var('columns', none)) -}}"

    template_to_file(template, model_name)


def escape_column_names_macro(model_name, **_):
    template = "{{- automate_dv.escape_column_names(columns=var('columns', none)) -}}"

    template_to_file(template, model_name)


def as_constant_macro(model_name, **_):
    template = "{{- automate_dv.as_constant(column_str=var('column_str', none)) -}}"

    template_to_file(template, model_name)


def alias_macro(model_name, **_):
    template = "{{ automate_dv.alias(alias_config=var('alias_config', none), prefix=var('prefix', none)) }}"

    template_to_file(template, model_name)


def alias_all_macro(model_name, **_):
    template = "{{ automate_dv.alias_all(columns=var('columns', none), prefix=var('prefix', none)) }}"

    template_to_file(template, model_name)


def prefix_macro(model_name, **_):
    template = f"""
    {{% if execute %}}
    {{{{ automate_dv.prefix(columns=var('columns', none), prefix_str=var('prefix', none), 
    alias_target=var('alias_target', none)) }}}}
    {{% endif %}}
    """

    template_to_file(template, model_name)


def create_ghost_record_macro(model_name, **_):
    template = f"""
               -- depends_on: {{{{ ref('raw_source_sat') }}}}
               {{% if execute %}}
               {{%- if var('source_model', '') != '' -%}}
                   {{%- set source_relation = ref(var('source_model')) -%}}
               {{% endif %}}
               {{{{ automate_dv.create_ghost_record(src_pk=var('src_pk', none),
               src_hashdiff=var('src_hashdiff', none),
               src_payload=var('src_payload', none),
               src_extra_columns=var('src_extra_columns', none),
               src_eff=var('src_eff',none) ,
               src_ldts=var('src_ldts', none),
               src_source=var('src_source', none),
               source_model=var('source_model', none))}}}}
               {{% endif %}}
               """

    template_to_file(template, model_name)


def null_expression_macro(model_name, **_):
    template = f"""
               {{{{ automate_dv.null_expression(column_str=var('column_str', none))}}}}
               """

    template_to_file(template, model_name)


def select_hash_alg_macro(model_name, **_):
    template = f"""
               {{{{ automate_dv.select_hash_alg(hash=var('hash', none))}}}}
               """

    template_to_file(template, model_name)


def standard_column_wrapper_macro(model_name, **_):
    template = f"""
               {{{{ automate_dv.standard_column_wrapper()}}}}
               """

    template_to_file(template, model_name)


def process_columns_to_escape_macro(model_name, **_):
    template = f"""
               {{% if execute %}}
               {{{{ automate_dv.process_columns_to_escape(derived_columns_list=var('derived_columns_list', none))}}}}
               {{% endif %}}
               """

    template_to_file(template, model_name)


def extract_column_names(context, model_name: str, model_params: dict, ignored_params=None):
    """
    Extract keys from headings if they are dictionaries
        :param context: Fixture context
        :param model_name: Name of model which headers are being processed for
        :param model_params: Dictionary of parameters provided to the model (sc_pk, src_hashdiff, etc.)
        :param ignored_params: A list of parameters to ignore in the dictionary
    """

    if not ignored_params:
        ignored_params = ["source_model"]

    column_metadata = [v for k, v in model_params.items() if k not in ignored_params]

    processing_functions = {
        "pit": process_pit_columns,
        "bridge": process_bridge_columns,
        "xts": process_xts_columns,
        "sat": process_sat_columns,
    }

    processed_headings = []

    column_strings = [column_name for column_name in column_metadata if not isinstance(column_name, dict)]
    column_dicts = [column_def for column_def in column_metadata if isinstance(column_def, dict)]

    vault_structure_type = getattr(context, "vault_structure_type", None)

    if column_dicts:
        if vault_structure_type in processing_functions.keys() and vault_structure_type in model_name.lower():
            extracted_headings = list(
                filter(None,
                       map(partial(processing_functions[context.vault_structure_type],
                                   context=context), column_dicts)))
        else:
            extracted_headings = list(filter(None, map(process_other_columns,
                                                       column_dicts)))

        processed_headings.extend(extracted_headings)
    processed_headings.extend(column_strings)

    return list(set(flatten(processed_headings)))


def process_structure_metadata(vault_structure, model_name, config, **kwargs):
    """
    Format metadata into a format suitable for injecting into a model string.
        :param vault_structure: THe type of vault structure the metadata is for (hub, link, sat etc.)
        :param model_name: Name of the model the metadata is for
        :param config: A config dictionary to be converted to a string
        :param kwargs: Metadata keys for various vault structures (src_pk, src_hashdiff, etc.)
    """
    default_materialisations = {
        "stage": "view",
        "hub": "incremental",
        "link": "incremental",
        "sat": "incremental",
        "eff_sat": "incremental",
        "xts": "incremental",
        "t_link": "incremental",
        "ma_sat": "incremental",
        "pit": "pit_incremental",
        "bridge": "bridge_incremental",
        "ref_table": "incremental"
    }

    if config:
        if "materialized" not in config:
            config["materialized"] = default_materialisations[vault_structure]
    else:
        config = {"materialized": default_materialisations[vault_structure]}

    if vault_structure == "stage":

        if not kwargs.get("hashed_columns", None):
            kwargs["hashed_columns"] = "none"

        if not kwargs.get("derived_columns", None):
            kwargs["derived_columns"] = "none"

    config = format_config_str(config)

    processed_string_values = {key: f"'{val}'" for key, val in kwargs.items() if isinstance(val, str)
                               and val != "none"}
    processed_list_dict_values = {key: f"{val}" for key, val in kwargs.items() if isinstance(val, list)
                                  or isinstance(val, dict)}

    return {**kwargs, **processed_string_values,
            **processed_list_dict_values, "config": config,
            "model_name": model_name}


def process_xts_columns(column_def: dict, context=None):
    column_def = {k: v for k, v in column_def.items() if isinstance(v, dict)}

    if not column_def:
        return dict()
    else:
        return [f"{list(col.keys())[0]}" for col in list(column_def.values())[0].values()]


def process_sat_columns(column_def: dict, context=None):
    if exclude_columns := column_def.get('columns', column_def.get('exclude_columns', '')):
        original_columns = list(flatten(
            [val for col, val in context.vault_structure_columns_original[context.target_model_name].items()]))

        if isinstance(exclude_columns, list):
            payload_columns = list(set(original_columns) - set(exclude_columns))
        else:
            payload_columns = []
            for col in original_columns:
                if isinstance(col, dict):
                    if col_name := col.get('alias'):
                        payload_columns.append(col_name)
                else:
                    payload_columns.append(col)

        return payload_columns


def process_pit_columns(column_def: dict, context=None):
    column_def = {k: v for k, v in column_def.items() if isinstance(v, dict)}

    if not column_def:
        return dict()
    else:
        satellite_columns_hk = [f"{col}_{list(column_def[col]['pk'].keys())[0]}" for col in column_def.keys()]
        satellite_columns_ldts = [f"{col}_{list(column_def[col]['ldts'].keys())[0]}" for col in column_def.keys()]
        return [satellite_columns_hk + satellite_columns_ldts]


def process_bridge_columns(column_def: dict, context=None):
    column_def = {k: v for k, v in column_def.items() if isinstance(v, dict)}

    if not column_def:
        return dict()
    else:
        return [column_def[col]['bridge_link_pk'] for col in column_def.keys()]


def process_other_columns(column_def: dict):
    column_def = {k: v for k, v in column_def.items() if isinstance(v, dict)}

    if not column_def:
        return dict()
    else:
        if column_def.get("source_column", None) and column_def.get("alias", None):
            return column_def['source_column']
        else:
            return list(column_def.keys())


def template_to_file(template, model_name):
    """
    Write a template to a file
        :param template: Template string to write
        :param model_name: Name of file to write
    """
    with open(TEST_MODELS_ROOT / f"{model_name}.sql", "w") as f:
        f.write(template.strip())


def add_seed_config(seed_name: str, seed_config: dict, include_columns=None,
                    additional_config=None):
    """
    Append a given dictionary to the end of the dbt_project.yml file
        :param seed_name: Name of seed file to configure
        :param seed_config: Configuration dict for seed file
        :param include_columns: A list of columns to add to the seed config, All if not provided
        :param additional_config: Additional configuration defined by external metadata (fixtures etc.)
    """
    yml = ruamel.yaml.YAML()
    yml.preserve_quotes = True
    yml.indent(sequence=4, offset=2)
    properties_path = TEMP_SEED_DIR / 'vault_properties.yml'

    if include_columns:
        seed_config['column_types'] = {k: v for k, v in seed_config['column_types'].items() if
                                       k in include_columns}

    if additional_config:
        seed_config = {**seed_config, **additional_config}

    if env_utils.platform() == 'postgres':
        quoted_columns = False
    else:
        quoted_columns = True

    seed_properties = {
        'version': 2,
        'seeds': [
            {'name': seed_name, 'config': {**seed_config, 'quote_columns': quoted_columns}}
        ]
    }

    with open(properties_path, 'w+') as f:
        yml.dump(seed_properties, f)


def create_test_model_schema_dict(*, target_model_name, expected_output_csv, unique_id, columns_to_compare,
                                  ignore_columns=None):
    if ignore_columns is None:
        ignore_columns = []

    columns_to_compare = list(
        [c for c in columns_to_compare if c not in ignore_columns])

    test_yaml = {
        "models": [{
            "name": target_model_name, "tests": [{
                "expect_tables_to_match": {
                    "expected_seed": expected_output_csv,
                    "unique_id": unique_id,
                    "compare_columns": columns_to_compare}}]}]}

    return test_yaml


def flatten(lis):
    """ Flatten nested lists into one list """
    for item in lis:
        if isinstance(item, list):
            for x in flatten(item):
                yield x
        else:
            yield item


def format_config_str(config: dict):
    """
    Correctly format a config string for a dbt model
    """

    config_string = ", ".join(
        [f"{k}='{v}'" if isinstance(v, str) else f"{k}={v}" for k, v in config.items()])

    return config_string


def evaluate_hashdiff(structure_dict):
    """
    Convert hashdiff to hashdiff alias
    """

    # Extract hashdiff column alias
    if "src_hashdiff" in structure_dict.keys():
        if isinstance(structure_dict["src_hashdiff"], dict):
            structure_dict["src_hashdiff"] = structure_dict["src_hashdiff"]["alias"]

    return structure_dict


def append_end_date_config(context, config: dict) -> dict:
    """
    Append end dating config if attribute is present.
    """

    if hasattr(context, "auto_end_date"):
        if context.auto_end_date:
            config = {**config,
                      "is_auto_end_dating": True}

    return config


def append_model_text_config(context, config) -> dict:
    """
    Append custom database config if attribute is present.
    """

    if hasattr(context, 'text'):
        if context.text:
            config_text_dict = parse_step_text(context.text)
            config = {**config,
                      **config_text_dict}

    return config


def append_dict_to_schema_yml(yaml_dict):
    """
    Append a given dictionary to the end of the schema_test.yml file
        :param yaml_dict: Dictionary to append to the schema_test.yml file
    """
    shutil.copyfile(BACKUP_TEST_SCHEMA_YML_FILE, TEST_SCHEMA_YML_FILE)

    with open(TEST_SCHEMA_YML_FILE, 'a+') as f:
        f.write('\n\n')

        yml = ruamel.yaml.YAML()
        yml.indent(sequence=4, offset=2)

        yml.dump(yaml_dict, f)


def clean_test_schema_file():
    """
    Delete the schema_test.yml file if it exists
    """

    if TEST_SCHEMA_YML_FILE.exists():
        os.remove(TEST_SCHEMA_YML_FILE)


def backup_project_yml():
    """
    Restore dbt_project.yml from backup
    """

    shutil.copyfile(DBT_PROJECT_YML_FILE, BACKUP_DBT_PROJECT_YML_FILE)


def restore_project_yml():
    """
    Restore dbt_project.yml from backup
    """

    if BACKUP_DBT_PROJECT_YML_FILE.exists():
        shutil.copyfile(BACKUP_DBT_PROJECT_YML_FILE, DBT_PROJECT_YML_FILE)
        os.remove(BACKUP_DBT_PROJECT_YML_FILE)


def dict_to_yaml_string(yaml_dict: dict, sequence=4, offset=2):
    """
    Convert a dictionary to YAML and return a string with the YAML
    """

    yml = ruamel.yaml.YAML()
    yml.indent(sequence=sequence, offset=offset)
    buf = io.BytesIO()
    yml.dump(yaml_dict, buf)
    yaml_str = buf.getvalue().decode('utf-8')

    return yaml_str


def parse_step_text(step_text: str):
    config_dict = dict()

    if pair_list := step_text.split(","):
        for pair in pair_list:
            pair_dict = {str(pair.split(':')[0]).strip(): str(pair.split(':')[1]).strip()}
            config_dict = {**config_dict, **pair_dict}

    return config_dict


def handle_step_text_dict(context):
    if hasattr(context, 'text'):

        if context.text:
            config_dict = parse_step_text(context.text)

            return config_dict
