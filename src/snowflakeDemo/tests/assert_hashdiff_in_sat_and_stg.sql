-- If there are no matches, then the test returns 0 rows (failure).
-- If there are matches, then the test returns 3 rows (success)



select distinct a.CUSTOMER_HASHDIFF
from {{ref('sat_test')}} as a
inner join {{ref('v_stg_tpch_data')}} as stg on a.CUSTOMER_HASHDIFF<>stg.CUSTOMER_HASHDIFF
