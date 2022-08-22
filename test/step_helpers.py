def is_full_refresh(context):
    return getattr(context, 'full_refresh', False)


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


def filter_metadata(context, metadata: dict) -> dict:
    """
    Remove metadata indicated by fixtures
        :param context: Behave context
        :param metadata: Metadata dictionary containing macro parameters
    """

    if getattr(context, 'disable_payload', False):
        metadata = {k: v for k, v in metadata.items() if k != "src_payload"}

    return metadata
