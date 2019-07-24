from vaultBase.cliParse import CLIParse
from vaultBase.logger import Logger
from vaultBase.configReader import ConfigReader
from dbt_template_generator import TemplateGenerator
import os
import logging


def run():
    program_name = "templateGenerator"
    cli_args = CLIParse("Creates sql statements for dbt to run", program_name)
    logger = Logger(program_name, cli_args)
    config = ConfigReader(logger, cli_args)
    template_gen = TemplateGenerator(logger, config)
    template_gen.create_template_macros()
    template_gen.clean_files()
    template_gen.create_sql_files()
    sim_dates = template_gen.sim_dates

    template_gen.create_dbt_project_file(sim_dates['history_date'], sim_dates['history_date'])

    logger.log("Loading the history into the data vault.", logging.INFO)

    os.system("dbt run --full-refresh --models tag:static")

    for date in sim_dates:
        if "history" not in date:
            logger.log("Running the day load for {}.".format(date), logging.INFO)
            path = """dbt run --models tag:incremental --vars "{{'date':{}}}" """.format(sim_dates[date])
            os.system(path)
            logger.log("Day load for {} has finished.".format(date), logging.INFO)


if __name__ == '__main__':
    run()
