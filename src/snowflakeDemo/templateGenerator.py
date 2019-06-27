from vaultBase.cliParse import CLIParse
from vaultBase.logger import Logger
from vaultBase.configReader import ConfigReader
from dbt_template_generator import TemplateGenerator


def run():
    program_name = "templateGenerator"
    cli_args = CLIParse("Creates sql statements for dbt to run", program_name)
    logger = Logger(program_name, cli_args)
    config = ConfigReader(logger, cli_args)
    template_gen = TemplateGenerator(logger, config)
    template_gen.create_sql_files()


if __name__ == '__main__':
    run()
