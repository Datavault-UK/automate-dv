{{ dbtvault.stage(include_source_columns=var('include_source_columns', none),
                  source_model=var('source_model', none),
                  hashed_columns=var('hashed_columns', none),
                  derived_columns=var('derived_columns', none)) }}