import glob
import io
import logging
import os
import re
import shutil
import sys
from hashlib import md5, sha256
from pathlib import PurePath, Path
from subprocess import PIPE, Popen, STDOUT
from typing import List

import pandas as pd
import yaml
from behave.model import Table
from numpy import NaN
from pandas import Series
from ruamel.yaml import YAML

PROJECT_ROOT = PurePath(__file__).parents[2]
PROFILE_DIR = Path(f"{PROJECT_ROOT}/profiles")
TESTS_ROOT = Path(f"{PROJECT_ROOT}/test_project")
TESTS_DBT_ROOT = Path(f"{TESTS_ROOT}/dbtvault_test")
MODELS_ROOT = TESTS_DBT_ROOT / 'models'
SCHEMA_YML_FILE = MODELS_ROOT / 'schema.yml'
TEST_SCHEMA_YML_FILE = MODELS_ROOT / 'schema_test.yml'
DBT_PROJECT_YML_FILE = TESTS_DBT_ROOT / 'dbt_project.yml'
INVOKE_YML_FILE = PROJECT_ROOT / 'invoke.yml'
BACKUP_TEST_SCHEMA_YML_FILE = TESTS_ROOT / 'backup_files/schema_test.bak.yml'
BACKUP_DBT_PROJECT_YML_FILE = TESTS_ROOT / 'backup_files/dbt_project.bak.yml'
FEATURE_MODELS_ROOT = MODELS_ROOT / 'feature'
COMPILED_TESTS_DBT_ROOT = Path(f"{TESTS_DBT_ROOT}/target/compiled/dbtvault_test/models/unit")
EXPECTED_OUTPUT_FILE_ROOT = Path(f"{TESTS_ROOT}/unit/expected_model_output")
FEATURES_ROOT = TESTS_ROOT / 'features'
CSV_DIR = TESTS_DBT_ROOT / 'data/temp'

if not os.getenv('DBT_PROFILES_DIR'):
    os.environ['DBT_PROFILES_DIR'] = str(PROFILE_DIR)


class DBTTestUtils:
    """
    Utilities for running dbt under test
    """

    def __init__(self, model_directory=None):

        # Setup logging
        self.logger = logging.getLogger('dbtvault')

        logging.basicConfig(level=logging.INFO)

        if not self.logger.handlers:
            ch = logging.StreamHandler()
            ch.setLevel(logging.DEBUG)
            formatter = logging.Formatter('(%(name)s) %(levelname)s: %(message)s')
            ch.setFormatter(formatter)

            self.logger.addHandler(ch)
            self.logger.setLevel(logging.DEBUG)
            self.logger.propagate = False

        if model_directory:
            self.compiled_model_path = COMPILED_TESTS_DBT_ROOT / model_directory
            self.expected_sql_file_path = EXPECTED_OUTPUT_FILE_ROOT / model_directory

        available_targets = ['snowflake', 'bigquery', 'sqlserver']

        target = self.get_target()

        os.environ['TARGET'] = target

        if target in available_targets:
            self.EXPECTED_PARAMETERS = self.set_dynamic_properties_for_comparison(target)

    def get_target(self):

        if os.path.isfile(INVOKE_YML_FILE):

            with open(INVOKE_YML_FILE) as config:
                config_dict = yaml.safe_load(config)
                return config_dict['target']
        else:
            self.logger.error(f"'{INVOKE_YML_FILE}' not found. Please run 'inv setup'")
            sys.exit(0)

    @staticmethod
    def set_dynamic_properties_for_comparison(target):
        """
        Database and schema for generated SQL during macro tests changes based on user.
        This function works out what those names need to be for downstream comparisons to use instead.
        """

        if target == 'snowflake':
            if os.getenv('CIRCLE_NODE_INDEX') and os.getenv('CIRCLE_JOB') and os.getenv('CIRCLE_BRANCH'):
                schema_name = f"{os.getenv('SNOWFLAKE_DB_SCHEMA')}_{os.getenv('SNOWFLAKE_DB_USER')}" \
                              f"_{os.getenv('CIRCLE_BRANCH')}_{os.getenv('CIRCLE_JOB')}_{os.getenv('CIRCLE_NODE_INDEX')}"
            else:
                schema_name = f"{os.getenv('SNOWFLAKE_DB_SCHEMA')}_{os.getenv('SNOWFLAKE_DB_USER')}"

            schema_name = schema_name.replace("-", "_").replace(".", "_").replace("/", "_")

            return {
                'SCHEMA_NAME': schema_name,
                'DATABASE_NAME': os.getenv('SNOWFLAKE_DB_DATABASE'),
            }
        elif target == 'bigquery':
            schema_name = f"{os.getenv('GCP_DATASET')}_{os.getenv('GCP_USER')}".upper()

            return {
                "DATASET_NAME": schema_name
            }
        elif target == 'sqlserver':
            if os.getenv('CIRCLE_NODE_INDEX') and os.getenv('CIRCLE_JOB') and os.getenv('CIRCLE_BRANCH'):
                schema_name = f"{os.getenv('SQLSERVER_DB_SCHEMA')}_{os.getenv('SQLSERVER_DB_USER')}" \
                              f"_{os.getenv('CIRCLE_BRANCH')}_{os.getenv('CIRCLE_JOB')}_{os.getenv('CIRCLE_NODE_INDEX')}"
            else:
                schema_name = f"{os.getenv('SQLSERVER_DB_SCHEMA')}_{os.getenv('SQLSERVER_DB_USER')}"

            schema_name = schema_name.replace("-", "_").replace(".", "_").replace("/", "_")

            return {
                'SCHEMA_NAME': schema_name,
                'DATABASE_NAME': os.getenv('SQLSERVER_DB_DATABASE'),
            }
        else:
            raise ValueError('TARGET not set')

    def run_dbt_command(self, command) -> str:
        """
        Run a command in dbt and capture dbt logs.
            :param command: Command to run.
            :return: dbt logs
        """

        if 'dbt' not in command and isinstance(command, list):
            dbt_cmd = ['dbt']
            dbt_cmd.extend(command)
            command = dbt_cmd
        elif 'dbt' not in command and isinstance(command, str):
            command = ['dbt', command]

        p = Popen(command, stdout=PIPE, stderr=STDOUT)

        stdout, _ = p.communicate()

        p.wait()

        logs = stdout.decode('utf-8')

        self.logger.log(msg=f"Running with dbt command: {' '.join(command)}", level=logging.DEBUG)

        self.logger.log(msg=logs, level=logging.DEBUG)

        return logs

    def run_dbt_seed(self, seed_file_name=None) -> str:
        """
        Run seed files in dbt
            :return: dbt logs
        """

        command = ['dbt', 'seed']

        if seed_file_name:
            command.extend(['--select', seed_file_name, '--full-refresh'])

        return self.run_dbt_command(command)

    def run_dbt_seed_model(self, seed_model_name=None) -> str:
        """
        Run seed model files in dbt
            :return: dbt logs
        """

        command = ['dbt', 'run']

        if seed_model_name:
            command.extend(['-m', seed_model_name, '--full-refresh'])

        return self.run_dbt_command(command)

    def run_dbt_model(self, *, mode='compile', model_name: str, args=None, full_refresh=False,
                      include_model_deps=False, include_tag=False) -> str:
        """
        Run or Compile a specific dbt model, with optionally provided variables.

            :param mode: dbt command to run, 'run' or 'compile'. Defaults to compile
            :param model_name: Model name for dbt to run
            :param args: variable dictionary to provide to dbt
            :param full_refresh: Run a full refresh
            :param include_model_deps: Include model dependencies (+)
            :param include_tag: Include tag string (tag:)
            :return Log output of dbt run operation
        """

        if include_tag:
            model_name = f'tag:{model_name}'

        if include_model_deps:
            model_name = f'+{model_name}'

        if full_refresh:
            command = ['dbt', mode, '-m', model_name, '--full-refresh']
        else:
            command = ['dbt', mode, '-m', model_name]

        if args:
            if not any(x in str(args) for x in ['(', ')']):
                yaml_str = str(args).replace('\'', '"')
            else:
                yaml_str = str(args)
            command.extend(['--vars', yaml_str])

        return self.run_dbt_command(command)

    def run_dbt_models(self, *, mode='compile', model_names: list, args=None, full_refresh=False) -> str:
        """
        Run or Compile a specific dbt model, with optionally provided variables.

            :param mode: dbt command to run, 'run' or 'compile'. Defaults to compile
            :param model_names: List of model names to run
            :param args: variable dictionary to provide to dbt
            :param full_refresh: Run a full refresh
            :return Log output of dbt run operation
        """

        model_name_string = " ".join(model_names)

        if full_refresh:
            command = ['dbt', mode, '-m', model_name_string, '--full-refresh']
        else:
            command = ['dbt', mode, '-m', model_name_string]

        if args:
            if not any(x in str(args) for x in ['(', ')']):
                yaml_str = str(args).replace('\'', '"')
            else:
                yaml_str = str(args)
            command.extend(['--vars', yaml_str])

        return self.run_dbt_command(command)

    def run_dbt_operation(self, macro_name: str, args=None) -> str:
        """
        Run a specified macro in dbt, with the given arguments.
            :param macro_name: Name of macro/operation
            :param args: Arguments to provide
            :return: dbt logs
        """
        command = ['run-operation', f'{macro_name}']

        if args:
            args = str(args).replace('\'', '')
            command.extend(['--args', f'{args}'])

        return self.run_dbt_command(command)

    def retrieve_compiled_model(self, model: str, exclude_comments=True):
        """
        Retrieve the compiled SQL for a specific dbt model

            :param model: Model name to check
            :param exclude_comments: Exclude comments from output
            :return: Contents of compiled SQL file
        """

        with open(self.compiled_model_path / f'{model}.sql') as f:
            file = f.readlines()

            if exclude_comments:
                file = [line for line in file if '--' not in line]

            return "".join(file).strip()

    def retrieve_expected_sql(self, file_name: str):
        """
        Retrieve the expected SQL for a specific dbt model

            :param file_name: File name to check
            :return: Contents of compiled SQL file
        """

        with open(self.expected_sql_file_path / f'{file_name}.sql') as f:
            file = f.readlines()

            processed_file = self.inject_parameters("".join(file), self.EXPECTED_PARAMETERS)

            return processed_file

    @staticmethod
    def inject_parameters(file: str, parameters: dict):
        """
        Replace placeholders in a file with the provided dictionary
            :param file: String containing expected file contents
            :param parameters: Dictionary of parameters {placeholder: value}
            :return: Parsed/injected file
        """

        if not parameters:
            return file
        else:
            for key, val in parameters.items():
                file = file.replace(f'[{key}]', val)

            return file

    @staticmethod
    def clean_target():
        """
        Deletes content in target folder (compiled SQL)
        Faster than running dbt clean.
        """

        target = TESTS_DBT_ROOT / 'target'

        shutil.rmtree(target, ignore_errors=True)

    @staticmethod
    def clean_csv(model_name=None):
        """
        Deletes csv files in csv folder.
        """

        if model_name:
            delete_files = [CSV_DIR / f"{model_name.lower()}.csv"]
        else:
            delete_files = [file for file in glob.glob(str(CSV_DIR / '*.csv'), recursive=True)]

        for file in delete_files:
            try:
                os.remove(file)
            except OSError:
                pass

    @staticmethod
    def clean_models():
        """
        Deletes models in features folder.
        """

        delete_files = [file for file in glob.glob(str(FEATURE_MODELS_ROOT / '*.sql'), recursive=True)]

        for file in delete_files:
            os.remove(file)

    @staticmethod
    def create_dummy_model():
        """
        Create dummy model to avoid unused config warning
        """

        with open(FEATURE_MODELS_ROOT / 'dummy.sql', 'w') as f:
            f.write('SELECT 1')

    @staticmethod
    def check_full_refresh(context):
        """
        Check context for full refresh
        """
        return getattr(context, 'full_refresh', False)

    def replace_test_schema(self):
        """
        Drop and create the TEST schema
        """

        self.run_dbt_operation(macro_name='recreate_current_schemas')

    def create_test_schemas(self):
        """
        Create TEST schemas
        """

        self.run_dbt_operation(macro_name='create_test_schemas')

    def drop_test_schemas(self):
        """
        Drop TEST schemas
        """

        self.run_dbt_operation(macro_name='drop_test_schemas')

    def context_table_to_df(self, table: Table, use_nan=True) -> pd.DataFrame:
        """
        Converts a context table in a feature file into a pandas DataFrame
            :param table: The context.table from a scenario
            :param use_nan: Replace <null> placeholder with NaN
            :return: DataFrame representation of the provide context table
        """

        table_df = pd.DataFrame(columns=table.headings, data=table.rows)

        table_df = table_df.apply(self.calc_hash)
        table_df = table_df.apply(self.parse_hashdiffs)

        if use_nan:
            table_df = table_df.replace("<null>", NaN)

        return table_df

    def context_table_to_csv(self, table: Table, model_name: str) -> str:
        """
        Converts a context table in a feature file into CSV format
            :param table: The context.table from a scenario
            :param model_name: Name of the model to create
            :return: Name of csv file (minus extension)
        """

        table_df = self.context_table_to_df(table)

        table_df.dropna(how="all", inplace=True)

        csv_fqn = CSV_DIR / f'{model_name.lower()}_seed.csv'

        table_df.to_csv(csv_fqn, index=False)

        self.logger.log(msg=f'Created {csv_fqn.name}', level=logging.DEBUG)

        return csv_fqn.stem

    def context_table_to_dict(self, table: Table, orient='index', use_nan=True):
        """
        Converts a context table in a feature file into a dictionary
            :param table: The context.table from a scenario
            :param orient: orient for df to_dict
            :param use_nan: Replace <null> placeholder with NaN
            :return: A dictionary modelled from a context table
        """

        table_df = self.context_table_to_df(table, use_nan=use_nan)

        table_dict = table_df.to_dict(orient=orient)

        table_dict = self.parse_lists_in_dicts(table_dict)

        return table_dict

    def context_table_to_model(self, seed_config : dict, table: Table, model_name: str, target_model_name: str):
        """
        Creates a model from a feature file data table
            :param seed_config: Configuration dict for seed file
            :param table: The context.table from a scenario or a programmatically defined table
            :param model_name: Name of the model to base the feature data table on
            :param target_model_name: Name of the model to create
            :return: Seed file name
        """

        feature_data = self.context_table_to_dict(table=table, orient="index", use_nan=False)
        column_types = seed_config[model_name]["+column_types"]

        sql_command = ""
        first_row = True

        for row_number in feature_data.keys():
            if first_row:
                first_row = False
            else:
                sql_command = sql_command + "\nUNION ALL \n"
            first_column = True

            sql_command = sql_command + "SELECT "

            for column_name in feature_data[row_number].keys():
                if first_column:
                    first_column = False
                else:
                    sql_command = sql_command + ", "

                column_data = feature_data[row_number][column_name]
                column_type = column_types[column_name]

                if column_data.lower() == "<null>" or column_data == "":
                    column_data_for_sql = "NULL"
                else:
                    column_data_for_sql = f"'{column_data}'"

                if  self.get_target() == "sqlserver" and column_type[0:6].upper() == "BINARY":
                    expression = f"CONVERT({column_type}, {column_data_for_sql}, 2)"
                else:
                    expression = f"CAST({column_data_for_sql} AS {column_type})"

                sql_command = f"{sql_command}{expression} AS {column_name} "

        with open(FEATURE_MODELS_ROOT / f"{target_model_name.lower()}_seed.sql", "w") as f:
            f.write(sql_command)

        return f"{target_model_name.lower()}_seed"

    def columns_from_context_table(self, table: Table) -> list:
        """
            Get a List of columns (headers) from a context table
            :param table: The context.table from a scenario
            :return: List of column names in the context table
        """

        table_df = self.context_table_to_df(table)

        table_dict = table_df.to_dict()

        return list(table_dict.keys())

    def find_columns_to_ignore(self, table: Table):
        """
        Gets a list of columns which contain all *, which is shorthand to denote ignoring a column for comparison
            :param table: The context.table from a scenario
            :return: List of columns
        """

        df = self.context_table_to_df(table)

        return list(df.columns[df.isin(['*']).all()])

    @staticmethod
    def process_stage_names(context, processed_stage_name):
        """
        Output a list of stage names if multiple stages are being used, or a single stage name if only one.
        """

        if hasattr(context, "processed_stage_name") and not getattr(context, 'disable_union', False):

            stage_names = context.processed_stage_name

            if isinstance(stage_names, list):
                stage_names.append(processed_stage_name)
            else:
                stage_names = [stage_names] + [processed_stage_name]

            stage_names = list(set(stage_names))

            if isinstance(stage_names, list) and len(stage_names) == 1:
                stage_names = stage_names[0]

            return stage_names

        else:
            return processed_stage_name

    @staticmethod
    def filter_metadata(context, metadata: dict) -> dict:
        """
        Remove metadata indicated by fixtures
            :param context: Behave context
            :param metadata: Metadata dictionary containing macro parameters
        """

        if getattr(context, 'disable_payload', False):
            metadata = {k: v for k, v in metadata.items() if k != "src_payload"}
            metadata.update({"src_payload": []})

        return metadata

    @staticmethod
    def calc_hash(columns_as_series: Series) -> Series:
        """
        Calculates the MD5 hash for a given value
            :param columns_as_series: A pandas Series of strings for the hash to be calculated on.
            In the form of "md5('1000')" or "sha('1000')"
            :return: Hash (MD5 or SHA) of values as Series (used as column)
        """

        patterns = {
            'md5': {
                'pattern': r"^(?:md5\(')(.*)(?:'\))", 'function': md5},
            'sha': {
                'pattern': r"^(?:sha\(')(.*)(?:'\))", 'function': sha256}}

        hashed_list = []

        for item in columns_as_series:

            active_hash_func = [pattern for pattern in patterns if pattern in item]
            if active_hash_func:
                active_hash_func = active_hash_func[0]
                raw_item = re.findall(patterns[active_hash_func]['pattern'], item)[0]
                hash_func = patterns[active_hash_func]['function']
                hashed_item = str(hash_func(raw_item.encode('utf-8')).hexdigest()).upper()
                hashed_list.append(hashed_item)
            else:
                hashed_list.append(item)

        return Series(hashed_list)

    @staticmethod
    def parse_hashdiffs(columns_as_series: Series) -> Series:
        """
        Evaluate strings surrounded with hashdiff() and exclude_hashdiff() to
        augment the YAML metadata and configure hashdiff columns for staging.

            :param columns_as_series: Columns from a context.table in Series form.
            :return: Modified series
        """

        standard_pattern = r"^(?:hashdiff\(')(.*)(?:'\))"
        exclude_pattern = r"^(?:exclude_hashdiff\(')(.*)(?:'\))"

        columns = []

        for item in columns_as_series:

            if re.search(standard_pattern, item):
                raw_item = re.findall(standard_pattern, item)[0]
                split_item = str(raw_item).split(",")
                hashdiff_dict = {"is_hashdiff": True,
                                 "columns": split_item}

                columns.append(hashdiff_dict)
            elif re.search(exclude_pattern, item):
                raw_item = re.findall(exclude_pattern, item)[0]
                split_item = str(raw_item).split(",")
                hashdiff_dict = {"is_hashdiff": True,
                                 "exclude_columns": True,
                                 "columns": split_item}

                columns.append(hashdiff_dict)
            else:
                columns.append(item)

        return Series(columns)

    @staticmethod
    def parse_lists_in_dicts(dicts_with_lists: List[dict]):
        """
        Convert string representations of lists in dict values, in a list of dicts
            :param dicts_with_lists: A list of dictionaries
        """

        if isinstance(dicts_with_lists, list):

            processed_dicts = []

            check_dicts = [k for k in dicts_with_lists if isinstance(k, dict)]

            if not check_dicts:
                return dicts_with_lists
            else:

                for i, col in enumerate(dicts_with_lists):
                    processed_dicts.append(dict())

                    if isinstance(col, dict):
                        for k, v in col.items():

                            if {"[", "]"}.issubset(set(str(v))) and isinstance(v, str):
                                v = v.replace("[", "")
                                v = v.replace("]", "")
                                v = [k.strip() for k in v.split(",")]

                            processed_dicts[i][k] = v
                    else:
                        processed_dicts[i] = {col: dicts_with_lists[i]}

                return processed_dicts
        else:
            return dicts_with_lists


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

    def process_structure_headings(self, context, model_name: str, headings: list):
        """
        Extract keys from headings if they are dictionaries
            :param context: Fixture context
            :param model_name: Name of model which headers are being processed for
            :param headings: Headings to process
        """

        processed_headings = []

        for item in headings:

            if isinstance(item, dict):

                if getattr(context, "vault_structure_type", None) == "pit" and "pit" in model_name.lower():
                    dict_check = [next(iter(item))][0]
                    if isinstance(item[dict_check], dict):
                        satellite_columns_hk = [f"{col}_{list(item[col]['pk'].keys())[0]}" for col in item.keys()]
                        satellite_columns_ldts = [f"{col}_{list(item[col]['ldts'].keys())[0]}" for col in item.keys()]
                        processed_headings.extend(satellite_columns_hk + satellite_columns_ldts)

                elif getattr(context, "vault_structure_type", None) == "bridge" and "bridge" in model_name.lower():

                    dict_check = [next(iter(item))][0]
                    if isinstance(item[dict_check], dict):
                        link_columns_hk = [item[col]['bridge_link_pk'] for col in item.keys()]
                        processed_headings.extend(link_columns_hk)

                elif getattr(context, "vault_structure_type", None) == "xts" and "xts" in model_name.lower():
                    satellite_columns = [f"{list(col.keys())[0]}" for col in list(item.values())[0].values()]

                    processed_headings.extend(satellite_columns)

                elif item.get("source_column", None) and item.get("alias", None):

                    processed_headings.append(item['source_column'])

                else:
                    processed_headings.append(list(item.keys()))
            else:
                processed_headings.append(item)

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

            yaml = YAML()
            yaml.indent(sequence=4, offset=2)

            yaml.dump(yaml_dict, f)

    @staticmethod
    def add_seed_config(seed_name: str, seed_config: dict, include_columns=None):
        """
        Append a given dictionary to the end of the dbt_project.yml file
            :param seed_name: Name of seed file to configure
            :param seed_config: Configuration dict for seed file
            :param include_columns: A list of columns to add to the seed config, All if not provided
        """

        yaml = YAML()

        if include_columns:
            seed_config['+column_types'] = {k: v for k, v in seed_config['+column_types'].items() if
                                            k in include_columns}

        with open(DBT_PROJECT_YML_FILE, 'r+') as f:
            project_file = yaml.load(f)

            project_file["seeds"]["dbtvault_test"]["temp"] = {seed_name: seed_config}

            f.seek(0)
            f.truncate()

            yaml.width = 150

            yaml.indent(sequence=4, offset=2)

            yaml.dump(project_file, f)

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

        yaml = YAML()
        yaml.indent(sequence=4, offset=2)
        buf = io.BytesIO()
        yaml.dump(yaml_dict, buf)
        yaml_str = buf.getvalue().decode('utf-8')

        return yaml_str
