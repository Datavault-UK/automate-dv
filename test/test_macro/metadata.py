def single_source_hub() -> dict:
    return dict(source_model="raw_source",
                src_pk="CUSTOMER_PK",
                src_nk="CUSTOMER_ID",
                src_ldts="LOADDATE",
                src_source="RECORD_SOURCE")


def multi_source_hub() -> dict:
    return dict(source_model="raw_source",
                src_pk="CUSTOMER_PK",
                src_nk="CUSTOMER_ID",
                src_ldts="LOADDATE",
                src_source="RECORD_SOURCE")
