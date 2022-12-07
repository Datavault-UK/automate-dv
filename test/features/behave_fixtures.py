import behave


@behave.fixture
def enable_sha(context):
    """
    Augment the metadata for a vault structure load to work with SHA hashing instead of MD5
    """

    context.hashing = "SHA"

    if hasattr(context, "seed_config"):

        config = dict(context.seed_config)

        for k, v in config.items():

            for c, t in config[k]["column_types"].items():

                if t == "BINARY(16)":
                    config[k]["column_types"][c] = "BINARY(32)"

    else:
        raise ValueError("sha behave.fixture used before vault structure behave.fixture.")


@behave.fixture
def enable_auto_end_date(context):
    """
    Indicate that auto end-dating on effectivity satellites should be enabled
    """
    context.auto_end_date = True


@behave.fixture
def enable_full_refresh(context):
    """
    Indicate that a full refresh for a dbt run should be executed
    """
    context.full_refresh = True


@behave.fixture
def disable_union(context):
    """
    Indicate that a list should not be created if multiple stages are specified in a scenario
    """
    context.disable_union = True


@behave.fixture
def disable_payload(context):
    """
    Indicate that a src_payload key should be removed from the provided metadata
    """
    context.disable_payload = True


@behave.fixture
def enable_ghost_records(context):
    """
    Indicate ghost records should be implemented in any tables
    """
    context.enable_ghost_records = True


@behave.fixture
def system_record_value(context):
    """
    Configures the source value for ghost record
    """
    context.system_record_value = 'OTHER_SYSTEM'


@behave.fixture
def disable_hashing_upper_case(context):
    """
    Stop hashing in upper case
    """
    context.disable_upper_in_hash = 'DISABLED'

