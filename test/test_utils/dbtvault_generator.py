import io
import os
import shutil

import ruamel.yaml

from test import *


class DBTVAULTGenerator:
    """Functions to generate dbtvault Models"""

    def raw_vault_structure(self, model_name, vault_structure, config=None, **kwargs):
        """
        Generate a vault structure
            :param model_name: Name of model to generate
            :param vault_structure: Type of structure to generate (stage, hub, link, sat)
            :param config: Optional config
            :param kwargs: Arguments for model the generator
        """

        vault_structure = vault_structure.lower()

        generator_functions = {
            "stage": self.stage,
            "hub": self.hub,
            "link": self.link,
            "sat": self.sat,
            "eff_sat": self.eff_sat,
            "t_link": self.t_link,
            "xts": self.xts,
            "ma_sat": self.ma_sat,
            "bridge": self.bridge,
            "pit": self.pit
        }

        processed_metadata = self.process_structure_metadata(vault_structure=vault_structure, model_name=model_name,
                                                             config=config, **kwargs)

        generator_functions[vault_structure](**processed_metadata)

    def stage(self, model_name, source_model: dict, derived_columns=None, hashed_columns=None,
              ranked_columns=None, include_source_columns=True, config=None, depends_on=""):
        """
        Generate a stage model template
            :param model_name: Name of the model file
            :param source_model: Model to select from
            :param hashed_columns: Dictionary of hashed columns, can be None
            :param derived_columns: Dictionary of derived column, can be None
            :param hashed_columns: Dictionary of hashed columns, can be None
            :param ranked_columns: Dictionary of ranked columns, can be None
            :param include_source_columns: Boolean: Whether to extract source columns from source table
            :param depends_on: depends on string if provided
            :param config: Optional model config
            :param depends_on: Optional forced dependency
        """

        template = f"""
        {depends_on}
        {{{{ config({config}) }}}}
        {{{{ dbtvault.stage(include_source_columns={str(include_source_columns).lower()},
                            source_model={source_model},
                            derived_columns={derived_columns},
                            hashed_columns={hashed_columns},
                            ranked_columns={ranked_columns}) }}}}
        """

        self.template_to_file(template, model_name)

    def hub(self, model_name, src_pk, src_nk, src_ldts, src_source, source_model, config, depends_on=""):
        """
        Generate a hub model template
            :param model_name: Name of the model file
            :param src_pk: Source pk
            :param src_nk: Source nk
            :param src_ldts: Source load date timestamp
            :param src_source: Source record source column
            :param source_model: Model name to select from
            :param config: Optional model config string
            :param depends_on: Optional forced dependency
        """

        template = f"""
        {depends_on}    
        {{{{ config({config}) }}}}
        {{{{ dbtvault.hub({src_pk}, {src_nk}, {src_ldts},
                          {src_source}, {source_model})   }}}}
        """

        self.template_to_file(template, model_name)

    def link(self, model_name, src_pk, src_fk, src_ldts, src_source, source_model, config, depends_on=""):
        """
        Generate a link model template
            :param model_name: Name of the model file
            :param src_pk: Source pk
            :param src_fk: Source fk
            :param src_ldts: Source load date timestamp
            :param src_source: Source record source column
            :param source_model: Model name to select from
            :param config: Optional model config
            :param depends_on: Optional forced dependency
        """

        template = f"""
        {depends_on}
        {{{{ config({config}) }}}}
        {{{{ dbtvault.link({src_pk}, {src_fk}, {src_ldts},
                           {src_source}, {source_model})   }}}}
        """

        self.template_to_file(template, model_name)

    def t_link(self, model_name, src_pk, src_fk, src_eff, src_ldts, src_source, source_model, config,
               src_payload=None, depends_on=""):
        """
        Generate a t-link model template
            :param model_name: Name of the model file
            :param src_pk: Source pk
            :param src_fk: Source fk
            :param src_payload: Source payload
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
        {{{{ dbtvault.t_link({src_pk}, {src_fk}, {src_payload if src_payload else 'none'}, 
                             {src_eff}, {src_ldts}, {src_source}, {source_model}) }}}}
        """

        self.template_to_file(template, model_name)

    def sat(self, model_name, src_pk, src_hashdiff, src_payload,
            src_eff, src_ldts, src_source, source_model,
            config, depends_on=""):
        """
        Generate a satellite model template
            :param model_name: Name of the model file
            :param src_pk: Source pk
            :param src_hashdiff: Source hashdiff
            :param src_payload: Source payload
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
        {{{{ dbtvault.sat({src_pk}, {src_hashdiff}, {src_payload},
                          {src_eff}, {src_ldts}, {src_source}, 
                          {source_model})   }}}}
        """

        self.template_to_file(template, model_name)

    def eff_sat(self, model_name, src_pk, src_dfk, src_sfk,
                src_start_date, src_end_date, src_eff, src_ldts, src_source,
                source_model, config, depends_on=""):
        """
        Generate an effectivity satellite model template
            :param model_name: Name of the model file
            :param src_pk: Source pk
            :param src_dfk: Source driving foreign key
            :param src_sfk: Source surrogate foreign key
            :param src_eff: Source effective from
            :param src_start_date: Source start date
            :param src_end_date: Source end date
            :param src_ldts: Source load date timestamp
            :param src_source: Source record source column
            :param source_model: Model name to select from
            :param config: Optional model config
            :param depends_on: Optional forced dependency
        """

        template = f"""
        {depends_on}
        {{{{ config({config}) }}}}
        {{{{ dbtvault.eff_sat({src_pk}, {src_dfk}, {src_sfk},
                              {src_start_date}, {src_end_date},
                              {src_eff}, {src_ldts}, {src_source},
                              {source_model}) }}}}
        """

        self.template_to_file(template, model_name)

    def ma_sat(self, model_name, src_pk, src_cdk, src_hashdiff, src_payload,
               src_eff, src_ldts, src_source, source_model, config):
        """
        Generate a multi active satellite model template
            :param model_name: Name of the model file
            :param src_pk: Source pk
            :param src_cdk: Source cdk
            :param src_hashdiff: Source hashdiff
            :param src_payload: Source payload
            :param src_eff: Source effective from
            :param src_ldts: Source load date timestamp
            :param src_source: Source record source column
            :param source_model: Model name to select from
            :param config: Optional model config
        """

        template = f"""
        {{{{ config({config}) }}}}
        {{{{ dbtvault.ma_sat({src_pk}, {src_cdk}, {src_hashdiff}, {src_payload},
                          {src_eff}, {src_ldts}, {src_source}, 
                          {source_model})   }}}}
        """

        self.template_to_file(template, model_name)

    def xts(self, model_name, src_pk, src_satellite, src_ldts, src_source, source_model, config=None, depends_on=""):
        """
        Generate a XTS template
            :param model_name: Name of the model file
            :param src_pk: Source pk
            :param src_satellite: Satellite to track
            :param src_ldts: Source load date timestamp
            :param src_source: Source record source column
            :param source_model: Model name to select from
            :param config: Optional model config
            :param depends_on: Optional forced dependency
        """

        template = f"""
        {depends_on}
        {{{{ config({config}) }}}}
        {{{{ dbtvault.xts({src_pk}, {src_satellite}, {src_ldts}, {src_source},
                          {source_model})   }}}}
        """

        self.template_to_file(template, model_name)

    def pit(self, model_name, source_model, src_pk, as_of_dates_table, satellites,
            stage_tables, src_ldts, depends_on="", config=None):
        """
        Generate a PIT template
            :param model_name: Name of the model file
            :param src_pk: Source pk
            :param as_of_dates_table: Name for the AS_OF table
            :param satellites: Dictionary of satellite reference mappings
            :param src_ldts: Source Load Date timestamp
            :param stage_tables: List of stage tables
            :param source_model: Model name to select from
            :param config: Optional model config
            :param depends_on: Optional forced dependency
        """

        template = f"""
        {depends_on}
        {{{{ config({config}) }}}}
        {{{{ dbtvault.pit({src_pk}, {as_of_dates_table}, {satellites},{stage_tables},{src_ldts}, {source_model}) }}}}
        """

        self.template_to_file(template, model_name)

    def bridge(self, model_name, src_pk, as_of_dates_table, bridge_walk, stage_tables_ldts, source_model, src_ldts,
               config, depends_on=""):
        """
        Generate a bridge model template
            :param model_name: Name of the model file
            :param src_pk: Source pk
            :param as_of_dates_table: Name for the AS_OF table
            :param bridge_walk: Dictionary of links and effectivity satellite reference mappings
            :param stage_tables_ldts: List of stage table load date(time) stamps
            :param source_model: Model name to select from
            :param src_ldts: Source load date timestamp
            :param config: Optional model config
            :param depends_on: Optional forced dependency
        """
        template = f"""
        {depends_on}
        {{{{ config({config}) }}}}
        {{{{ dbtvault.bridge({src_pk}, {as_of_dates_table}, {bridge_walk}, {stage_tables_ldts}, {src_ldts}, {source_model}) }}}}
        """

        self.template_to_file(template, model_name)

    def extract_column_names(self, context, model_name: str, model_params: dict, ignored_params=None):
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
            "pit": self.process_pit_columns,
            "bridge": self.process_bridge_columns,
            "xts": self.process_xts_columns
        }

        processed_headings = []

        column_strings = [column_name for column_name in column_metadata if not isinstance(column_name, dict)]
        column_dicts = [column_def for column_def in column_metadata if isinstance(column_def, dict)]

        vault_structure_type = getattr(context, "vault_structure_type", None)

        if column_dicts:
            if vault_structure_type in processing_functions.keys() and vault_structure_type in model_name.lower():
                extracted_headings = list(filter(None, map(processing_functions[context.vault_structure_type],
                                                           column_dicts)))
            else:
                extracted_headings = list(filter(None, map(self.process_other_columns,
                                                           column_dicts)))

            processed_headings.extend(extracted_headings)
        processed_headings.extend(column_strings)

        return list(self.flatten(processed_headings))

    def process_structure_metadata(self, vault_structure, model_name, config, **kwargs):
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
            "bridge": "bridge_incremental"
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

        config = self.format_config_str(config)

        processed_string_values = {key: f"'{val}'" for key, val in kwargs.items() if isinstance(val, str)
                                   and val != "none"}
        processed_list_dict_values = {key: f"{val}" for key, val in kwargs.items() if isinstance(val, list)
                                      or isinstance(val, dict)}

        return {**kwargs, **processed_string_values,
                **processed_list_dict_values, "config": config,
                "model_name": model_name}

    @staticmethod
    def process_xts_columns(column_def: dict):
        column_def = {k: v for k, v in column_def.items() if isinstance(v, dict)}

        if not column_def:
            return dict()
        else:
            return [f"{list(col.keys())[0]}" for col in list(column_def.values())[0].values()]

    @staticmethod
    def process_pit_columns(column_def: dict):

        column_def = {k: v for k, v in column_def.items() if isinstance(v, dict)}

        if not column_def:
            return dict()
        else:
            satellite_columns_hk = [f"{col}_{list(column_def[col]['pk'].keys())[0]}" for col in column_def.keys()]
            satellite_columns_ldts = [f"{col}_{list(column_def[col]['ldts'].keys())[0]}" for col in column_def.keys()]
            return [satellite_columns_hk + satellite_columns_ldts]

    @staticmethod
    def process_bridge_columns(column_def: dict):

        column_def = {k: v for k, v in column_def.items() if isinstance(v, dict)}

        if not column_def:
            return dict()
        else:
            return [column_def[col]['bridge_link_pk'] for col in column_def.keys()]

    @staticmethod
    def process_other_columns(column_def: dict):

        column_def = {k: v for k, v in column_def.items() if isinstance(v, dict)}

        if not column_def:
            return dict()
        else:
            if column_def.get("source_column", None) and column_def.get("alias", None):
                return column_def['source_column']
            else:
                return list(column_def.keys())

    @staticmethod
    def template_to_file(template, model_name):
        """
        Write a template to a file
            :param template: Template string to write
            :param model_name: Name of file to write
        """
        with open(FEATURE_MODELS_ROOT / f"{model_name}.sql", "w") as f:
            f.write(template.strip())

    @staticmethod
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

    @staticmethod
    def add_seed_config(seed_name: str, seed_config: dict, include_columns=None):
        """
        Append a given dictionary to the end of the dbt_project.yml file
            :param seed_name: Name of seed file to configure
            :param seed_config: Configuration dict for seed file
            :param include_columns: A list of columns to add to the seed config, All if not provided
        """

        yml = ruamel.yaml.YAML()

        if include_columns:
            seed_config['+column_types'] = {k: v for k, v in seed_config['+column_types'].items() if
                                            k in include_columns}

        with open(DBT_PROJECT_YML_FILE, 'r+') as f:
            project_file = yml.load(f)

            project_file["seeds"]["dbtvault_test"]["temp"] = {seed_name: seed_config}

            f.seek(0)
            f.truncate()

            yml.width = 150

            yml.indent(sequence=4, offset=2)

            yml.dump(project_file, f)

    @staticmethod
    def create_test_model_schema_dict(*, target_model_name, expected_output_csv, unique_id, columns_to_compare,
                                      ignore_columns=None):

        if ignore_columns is None:
            ignore_columns = []

        columns_to_compare = list(
            [c for c in columns_to_compare if c not in ignore_columns])

        test_yaml = {
            "models": [{
                "name": target_model_name, "tests": [{
                    "assert_data_equal_to_expected": {
                        "expected_seed": expected_output_csv,
                        "unique_id": unique_id,
                        "compare_columns": columns_to_compare}}]}]}

        return test_yaml

    @staticmethod
    def flatten(lis):
        """ Flatten nested lists into one list """
        for item in lis:
            if isinstance(item, list):
                for x in DBTVAULTGenerator.flatten(item):
                    yield x
            else:
                yield item

    @staticmethod
    def format_config_str(config: dict):
        """
        Correctly format a config string for a dbt model
        """

        config_string = ", ".join(
            [f"{k}='{v}'" if isinstance(v, str) else f"{k}={v}" for k, v in config.items()])

        return config_string

    @staticmethod
    def evaluate_hashdiff(structure_dict):
        """
        Convert hashdiff to hashdiff alias
        """

        # Extract hashdiff column alias
        if "src_hashdiff" in structure_dict.keys():
            if isinstance(structure_dict["src_hashdiff"], dict):
                structure_dict["src_hashdiff"] = structure_dict["src_hashdiff"]["alias"]

        return structure_dict

    @staticmethod
    def append_end_date_config(context, config: dict) -> dict:
        """
        Append end dating config if attribute is present.
        """

        if hasattr(context, "auto_end_date"):
            if context.auto_end_date:
                config = {**config,
                          "is_auto_end_dating": True}

        return config

    @staticmethod
    def clean_test_schema_file():
        """
        Delete the schema_test.yml file if it exists
        """

        if os.path.exists(TEST_SCHEMA_YML_FILE):
            os.remove(TEST_SCHEMA_YML_FILE)

    @staticmethod
    def backup_project_yml():
        """
        Restore dbt_project.yml from backup
        """

        shutil.copyfile(DBT_PROJECT_YML_FILE, BACKUP_DBT_PROJECT_YML_FILE)

    @staticmethod
    def restore_project_yml():
        """
        Restore dbt_project.yml from backup
        """

        shutil.copyfile(BACKUP_DBT_PROJECT_YML_FILE, DBT_PROJECT_YML_FILE)

    @staticmethod
    def dict_to_yaml_string(yaml_dict: dict):
        """
        Convert a dictionary to YAML and return a string with the YAML
        """

        yml = ruamel.yaml.YAML()
        yml.indent(sequence=4, offset=2)
        buf = io.BytesIO()
        yml.dump(yaml_dict, buf)
        yaml_str = buf.getvalue().decode('utf-8')

        return yaml_str
