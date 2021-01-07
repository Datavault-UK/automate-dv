import glob
import logging
import os
import re
import shutil
from hashlib import md5, sha256
from pathlib import PurePath, Path
from subprocess import PIPE, Popen, STDOUT

import pandas as pd
from ruamel.yaml import YAML
from behave.model import Table
from numpy import NaN
from pandas import Series

PROJECT_ROOT = PurePath(__file__).parents[2]
PROFILE_DIR = Path(f"{PROJECT_ROOT}/profiles")
TESTS_ROOT = Path(f"{PROJECT_ROOT}/test_project")
TESTS_DBT_ROOT = Path(f"{TESTS_ROOT}/dbtvault_test")
MODELS_ROOT = TESTS_DBT_ROOT / 'models'
SCHEMA_YML_FILE = MODELS_ROOT / 'schema.yml'
TEST_SCHEMA_YML_FILE = MODELS_ROOT / 'schema_test.yml'
DBT_PROJECT_YML_FILE = TESTS_DBT_ROOT / 'dbt_project.yml'
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
        self.logger = logging.getLogger('dbt')

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
        else:

            self.logger.warning('Model directory not set.')

        if os.getenv('TARGET', '').lower() == 'snowflake':
            target = 'snowflake'
        elif not os.getenv('TARGET', None):
            print('TARGET not set. Target set to snowflake.')
            target = 'snowflake'
        else:
            target = None

        if target == 'snowflake':
            if os.getenv('CIRCLE_NODE_INDEX') and os.getenv('CIRCLE_JOB'):
                schema_name = f"{os.getenv('SNOWFLAKE_DB_SCHEMA')}_{os.getenv('SNOWFLAKE_DB_USER')}" \
                              f"_{os.getenv('CIRCLE_JOB')}_{os.getenv('CIRCLE_NODE_INDEX')}"
            else:
                schema_name = f"{os.getenv('SNOWFLAKE_DB_SCHEMA')}_{os.getenv('SNOWFLAKE_DB_USER')}"

            self.EXPECTED_PARAMETERS = {
                'SCHEMA_NAME': schema_name,
                'DATABASE_NAME': os.getenv('SNOWFLAKE_DB_DATABASE')
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

    def run_dbt_model(self, *, mode='compile', model_name: str, args=None, full_refresh=False, include_model_deps=False,
                      include_tag=False) -> str:
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
            command = ['dbt', mode, '--full-refresh', '-m', model_name]
        else:
            command = ['dbt', mode, '-m', model_name]

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
    def clean_csv():
        """
        Deletes csv files in csv folder.
        """

        delete_files = [file for file in glob.glob(str(CSV_DIR / '*.csv'), recursive=True)]

        for file in delete_files:
            os.remove(file)

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

    def context_table_to_df(self, table: Table) -> pd.DataFrame:
        """
        Converts a context table in a feature file into a pandas DataFrame
            :param table: The context.table from a scenario
            :return: DataFrame representation of the provide context table
        """

        table_df = pd.DataFrame(columns=table.headings, data=table.rows)

        table_df = table_df.apply(self.calc_hash)
        table_df = table_df.apply(self.parse_hashdiffs)

        table_df = table_df.replace("<null>", NaN)

        return table_df

    def context_table_to_csv(self, table: Table, model_name: str) -> str:
        """
        Converts a context table in a feature file into a dictionary
            :param table: The context.table from a scenario
            :param model_name: Name of the model to create
            :return: Name of csv file (minus extension)
        """

        table_df = self.context_table_to_df(table)

        csv_fqn = CSV_DIR / f'{model_name.lower()}_seed.csv'

        table_df.to_csv(csv_fqn, index=False)

        self.logger.log(msg=f'Created {csv_fqn.name}', level=logging.DEBUG)

        return csv_fqn.stem

    def context_table_to_dict(self, table: Table, orient='index'):
        """
        Converts a context table in a feature file into a pandas DataFrame
            :param table: The context.table from a scenario
            :param orient: orient for df to_dict
            :return: A pandas DataFrame modelled from a context table
        """

        table_df = self.context_table_to_df(table)

        table_dict = table_df.to_dict(orient=orient)

        return table_dict

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


class DBTVAULTGenerator:
    """Functions to generate dbtvault Models"""

    @staticmethod
    def template_to_file(template, model_name):
        """
        Write a template to a file
            :param template: Template string to write
            :param model_name: Name of file to write
        """
        with open(FEATURE_MODELS_ROOT / f"{model_name}.sql", "w") as f:
            f.write(template.strip())

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
            "t_link": self.t_link
        }
        if vault_structure == "stage":
            generator_functions[vault_structure](model_name=model_name, config=config)
        else:
            generator_functions[vault_structure](model_name=model_name, config=config, **kwargs)

    def stage(self, model_name, source_model: dict, hashed_columns=None, derived_columns=None,
              include_source_columns=True, config=None):
        """
        Generate a stage model template
            :param model_name: Name of the model file
            :param source_model: Model to select from
            :param hashed_columns: Dictionary of hashed columns, can be None
            :param derived_columns: Dictionary of derived column, can be None
            :param include_source_columns: Boolean: Whether to extract source columns from source table
            :param config: Optional model config
        """

        if not config:
            config = {'materialized': 'view'}

        if hashed_columns:
            hashed_columns = str(hashed_columns)
        else:
            hashed_columns = "none"

        if derived_columns:
            derived_columns = str(derived_columns)
        else:
            derived_columns = "none"

        config_string = self.format_config_str(config)

        template = f"""
        {{{{ config({config_string}) }}}}
        {{{{ dbtvault.stage(include_source_columns={str(include_source_columns).lower()},
                            source_model='{source_model}',
                            hashed_columns={hashed_columns},
                            derived_columns={derived_columns}) }}}}
        """

        self.template_to_file(template, model_name)

    def hub(self, model_name, src_pk, src_nk, src_ldts, src_source, source_model, config=None):
        """
        Generate a hub model template
            :param model_name: Name of the model file
            :param src_pk: Source pk
            :param src_nk: Source nk
            :param src_ldts: Source load date timestamp
            :param src_source: Source record source column
            :param source_model: Model name to select from
            :param config: Optional model config
        """

        if isinstance(source_model, list):
            source_model = f"{source_model}"
        else:
            source_model = f"'{source_model}'"

        if not config:
            config = {"materialized": "incremental"}

        config_string = self.format_config_str(config)

        template = f"""
        {{{{ config({config_string}) }}}}
        {{{{ dbtvault.hub('{src_pk}', '{src_nk}', '{src_ldts}',
                          '{src_source}', {source_model})   }}}}
        """

        self.template_to_file(template, model_name)

    def link(self, model_name, src_pk, src_fk, src_ldts, src_source, source_model, config=None):
        """
        Generate a link model template
            :param model_name: Name of the model file
            :param src_pk: Source pk
            :param src_fk: Source fk
            :param src_ldts: Source load date timestamp
            :param src_source: Source record source column
            :param source_model: Model name to select from
            :param config: Optional model config
        """

        if isinstance(source_model, list):
            source_model = f"{source_model}"
        else:
            source_model = f"'{source_model}'"

        if not config:
            config = {"materialized": "incremental"}

        config_string = self.format_config_str(config)

        template = f"""
        {{{{ config({config_string}) }}}}
        {{{{ dbtvault.link('{src_pk}', {src_fk}, '{src_ldts}',
                           '{src_source}', {source_model})   }}}}
        """

        self.template_to_file(template, model_name)

    def sat(self, model_name, src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model,
            config=None):
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
        """

        if isinstance(src_hashdiff, dict):
            src_hashdiff = f"{src_hashdiff}"
        else:
            src_hashdiff = f"'{src_hashdiff}'"

        if not config:
            config = {"materialized": "incremental"}

        config_string = self.format_config_str(config)

        template = f"""
        {{{{ config({config_string}) }}}}
        {{{{ dbtvault.sat('{src_pk}', {src_hashdiff}, {src_payload},
                          '{src_eff}', '{src_ldts}', '{src_source}', 
                          '{source_model}')   }}}}
        """

        self.template_to_file(template, model_name)

    def eff_sat(self, model_name, src_pk, src_dfk, src_sfk,
                src_start_date, src_end_date, src_eff, src_ldts, src_source,
                source_model, config=None):
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
        """

        if isinstance(src_dfk, str):
            src_dfk = f"'{src_dfk}'"

        if isinstance(src_sfk, str):
            src_sfk = f"'{src_sfk}'"

        if not config:
            config = {"materialized": "incremental"}

        config_string = self.format_config_str(config)

        template = f"""
        {{{{ config({config_string}) }}}}
        {{{{ dbtvault.eff_sat('{src_pk}', {src_dfk}, {src_sfk},
                              '{src_start_date}', '{src_end_date}',
                              '{src_eff}', '{src_ldts}', '{src_source}',
                              '{source_model}') }}}}
        """

        self.template_to_file(template, model_name)

    def t_link(self, model_name, src_pk, src_fk, src_payload, src_eff, src_ldts, src_source, source_model, config=None):
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
        """

        if not config:
            config = {'materialized': 'incremental'}

        if isinstance(src_fk, str):
            src_fk = f"'{src_fk}'"

        config_string = self.format_config_str(config)

        template = f"""
        {{{{ config({config_string}) }}}}
        {{{{ dbtvault.t_link('{src_pk}', {src_fk}, {src_payload}, '{src_eff}',
                             '{src_ldts}', '{src_source}', '{source_model}')   }}}}
        """

        self.template_to_file(template, model_name)

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
            seed_config['column_types'] = {k: v for k, v in seed_config['column_types'].items() if k in include_columns}

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
                                      ignore_columns):

        extracted_compare_columns = [k for k, v in columns_to_compare.items()]

        columns_to_compare = list(
            [c for c in DBTVAULTGenerator.flatten(extracted_compare_columns) if c not in ignore_columns])

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
                if config:
                    config["is_auto_end_dating"] = True
                else:
                    config = {"materialized": "incremental",
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
