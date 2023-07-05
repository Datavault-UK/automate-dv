def single_source_hub() -> dict:
    return dict(source_model="raw_source",
                src_pk="CUSTOMER_PK",
                src_nk="CUSTOMER_ID",
                src_ldts="LOAD_DATE",
                src_source="RECORD_SOURCE")


def single_source_multi_nk_hub() -> dict:
    return dict(source_model="raw_source",
                src_pk="CUSTOMER_PK",
                src_nk=["CUSTOMER_ID",
                        "CUSTOMER_NAME"],
                src_ldts="LOAD_DATE",
                src_source="RECORD_SOURCE")


def multi_source_hub() -> dict:
    return dict(source_model=["raw_source",
                              "raw_source_2"],
                src_pk="CUSTOMER_PK",
                src_nk="CUSTOMER_ID",
                src_ldts="LOAD_DATE",
                src_source="RECORD_SOURCE")


def multi_source_multi_nk_hub() -> dict:
    return dict(source_model=["raw_source",
                              "raw_source_2"],
                src_pk="CUSTOMER_PK",
                src_nk=["CUSTOMER_ID",
                        "CUSTOMER_NAME"],
                src_ldts="LOAD_DATE",
                src_source="RECORD_SOURCE")


def single_source_link() -> dict:
    return dict(source_model="raw_source",
                src_pk="CUSTOMER_PK",
                src_fk=["ORDER_FK",
                        "BOOKING_FK"],
                src_ldts="LOAD_DATE",
                src_source="RECORD_SOURCE")


def multi_source_link() -> dict:
    return dict(source_model=["raw_source",
                              "raw_source_2"],
                src_pk="CUSTOMER_PK",
                src_fk=["ORDER_FK",
                        "BOOKING_FK"],
                src_ldts="LOAD_DATE",
                src_source="RECORD_SOURCE")


def single_source_sat() -> dict:
    return dict(source_model="raw_source",
                src_pk="CUSTOMER_PK",
                src_eff="EFFECTIVE_FROM",
                src_payload=["TEST_COLUMN_4", "TEST_COLUMN_5", "TEST_COLUMN_6"],
                src_hashdiff="HASHDIFF",
                src_ldts="LOAD_DATE",
                src_source="RECORD_SOURCE")


def single_source_ref_table() -> dict:
    return dict(source_model="raw_source_ref_table",
                src_pk="DATE_PK",
                src_extra_columns=["YEAR", "MONTH", "DAY", "DAY_OF_WEEK"],
                src_ldts="LOAD_DATE",
                src_source="RECORD_SOURCE")
