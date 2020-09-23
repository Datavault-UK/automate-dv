WITH staging AS (
    {{ dbtvault.stage(include_source_columns=var('include_source_columns', none),
                      source_model=var('source_model', none),
                      hashed_columns=var('hashed_columns', none),
                      derived_columns=var('derived_columns', none)) }}
)


SELECT *, 
       TO_DATE('{{ var('load_date') }}') AS LOADDATE,
       TO_DATE('{{ var('load_date') }}') AS EFFECTIVE_FROM
FROM staging