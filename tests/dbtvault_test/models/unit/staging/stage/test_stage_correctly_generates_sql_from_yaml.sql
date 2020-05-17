{{ dbtvault.stage(include_source_columns=var('include_source_columns'), 
                  source_model=var('source_model'), 
                  hashed_columns=var('hashed_columns'), 
                  derived_columns=var('derived_columns')) }}