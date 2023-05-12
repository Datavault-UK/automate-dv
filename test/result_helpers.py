import datetime
import re
from typing import List

from behave.model import Scenario, Step, Feature
from boltons import tbutils

from context_helpers import context_table_to_df


def format_scenario_name(scenario_name: str):
    first_pass = scenario_name.replace('[', '').replace(']', '').replace('-', ' ').replace('/', ' ').replace('\\', ' ')

    minimised_space = re.sub(' +', ' ', first_pass).replace(' ', '_').replace('.', '_')

    return minimised_space.lower()


def format_feature_name(feature_name: str):
    return feature_name.split('.')[0].split('/')[-1]


def serialise_feature_initial(feature: Feature, invocation_id: str):
    file_generated_at = str(datetime.datetime.now(datetime.timezone.utc).isoformat())

    feature_dict = {
        'feature_name': '',
        'invocation_id': invocation_id,
        'feature_code': f"{feature.name.split(']')[0]}]",
        'feature_path': getattr(feature, 'filename', ''),
        'generated_at': file_generated_at,
        'description': getattr(feature, 'description', ''),
        'status': '',
        'duration': getattr(feature, 'duration', ''),
        'keyword': getattr(feature, 'keyword', ''),
        'exc_traceback': '',
        'scenarios': [],
        'tags': getattr(feature, 'tags', '')
    }

    if feature_path := feature_dict.get('feature_path'):
        feature_dict['feature_name'] = format_feature_name(feature_path)

    return feature_dict


def serialise_feature_post_run(feature: Feature, existing_results: dict):
    feature_dict = {
        'feature_name': existing_results['feature_name'],
        'feature_code': existing_results['feature_code'],
        'invocation_id': existing_results['invocation_id'],
        'feature_path': getattr(feature, 'filename', ''),
        'generated_at': existing_results['generated_at'],
        'description': getattr(feature, 'description', ''),
        'status': getattr(feature.status, 'name', ''),
        'duration': getattr(feature, 'duration', ''),
        'keyword': getattr(feature, 'keyword', ''),
        'exc_traceback': getattr(feature, 'exc_traceback', ''),
        'scenarios': existing_results['scenarios'],
        'tags': getattr(feature, 'tags', '')
    }

    if feature_tb := feature_dict['exc_traceback']:
        feature_dict['exc_traceback'] = tbutils.TracebackInfo.from_traceback(tb=feature_tb).to_dict()

    return feature_dict


def serialise_scenario(scenario: Scenario, invocation_id: str):
    steps = process_steps(scenario.steps, invocation_id)

    scenario_dict = {
        'scenario_name': '',
        'feature_name': '',
        'invocation_id': invocation_id,
        'feature': getattr(scenario.feature, 'name', ''),
        'feature_code': '',
        'feature_path': getattr(scenario, 'filename', ''),
        'status': getattr(scenario.status, 'name', ''),
        'steps_hash': steps,
        'duration': getattr(scenario, 'duration', ''),
        'exc_traceback': getattr(scenario, 'exc_traceback', ''),
        'background': getattr(scenario, 'background', ''),
        'tags': getattr(scenario, 'effective_tags', '')
    }

    if feature_name := scenario_dict.get('feature'):
        scenario_dict['feature_code'] = f"{feature_name.split(']')[0]}]"

    if path := scenario_dict.get('feature_path'):
        scenario_dict['feature_name'] = format_feature_name(path)

    if name := getattr(scenario, 'name', ''):
        scenario_dict['scenario_name'] = format_scenario_name(name)

    if scenario_tb := scenario_dict['exc_traceback']:
        scenario_dict['exc_traceback'] = tbutils.TracebackInfo.from_traceback(tb=scenario_tb).to_dict()

    return scenario_dict


def process_steps(steps: List[Step], invocation_id: str):
    step_dict = dict()

    for step_num, step in enumerate(steps):
        step_dict[step_num] = {
            'keyword': getattr(step, 'keyword', ''),
            'invocation_id': invocation_id,
            'duration': getattr(step, 'duration', ''),
            'exc_traceback': getattr(step, 'exc_traceback', ''),
            'step_type': getattr(step, 'step_type', ''),
            'status': getattr(step.status, 'name', ''),
            'name': getattr(step, 'name', ''),
            'full_name': f'{step.keyword} {step.name}',
            'text': '',
            'poc_data': dict(),
            'filename': getattr(step.location, 'filename', ''),
            'line_number': getattr(step, 'line', '')
        }

        if step.table:
            step_dict[step_num]['poc_data'] = context_table_to_df(step.table).to_dict(orient='index')

        if step_tb := step_dict[step_num]['exc_traceback']:
            step_dict[step_num]['exc_traceback'] = tbutils.TracebackInfo.from_traceback(tb=step_tb).to_dict()

    return step_dict