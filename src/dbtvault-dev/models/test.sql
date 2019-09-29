{{- config(materialized='incremental', schema='test_vlt', enabled=true, tags='feature') -}}


{{ dbtvault.prefix(['CUSTOMERKEY', 'DOB', 'NAME', 'PHONE'], 'a') }}
{{ dbtvault.prefix(['CUSTOMERKEY'], 'a') }}