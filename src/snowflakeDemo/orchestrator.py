from vaultBase.cliParse import CLIParse
from vaultBase.logger import Logger
from vaultBase.configReader import ConfigReader
from dbt_template_generator import TemplateGenerator
from addKeys import KeyAdder
from multiprocessing import Pool
from pathos.multiprocessing import ProcessPool
import os


def run():
    program_name = "templateGenerator"
    cli_args = CLIParse("Creates sql statements for dbt to run", program_name)
    logger = Logger(program_name, cli_args)
    config = ConfigReader(logger, cli_args)
    template_gen = TemplateGenerator(logger, config)
    template_gen.create_sql_files()
    sim_dates = template_gen.sim_dates

    template_gen.create_dbt_project_file(sim_dates['history_start_date'], sim_dates['history_end_date'])

    key_add = KeyAdder(logger, config)
    tables = key_add.get_table_keys()

    # Adding keys to tables
    with ProcessPool() as P:
        P.map(key_add.pk_pipe, tables)

    # History Section
    # os.system('dbt run --models tag:history --exclude tag:sat')
    #
    # for day in range(template_gen.get_history_date_diff):
    #     if day == 0:
    #         os.system('dbt run --models tag:sat')
    #         key_add = KeyAdder(logger, config)
    #         key_add.execute_primary_key_statements()
    #         key_add.execute_foreign_key_statements()
    #
    #     else:
    #         os.system('dbt run --models tag:sat')

    # Incremental Section
    # for date in sim_dates:
    #     os.system('dbt run --vars {}'.format(date))


if __name__ == '__main__':
    run()
