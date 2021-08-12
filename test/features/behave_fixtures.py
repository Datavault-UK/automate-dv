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

            for c, t in config[k]["+column_types"].items():

                if t == "BINARY(16)":
                    config[k]["+column_types"][c] = "BINARY(32)"

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
