with 

source as (

    select * from {{ source('staging', 'fhv_tripdata') }}

),

renamed as (

    select
        dispatching_base_num,
        lpep_pickup_datetime,
        lpep_dropoff_datetime,
        pulocationid as pickup_locationid,
        dolocationid as dropoff_locationid,
        sr_flag,
        affiliated_base_number

    from source

)

select * from renamed
where 1 = 1
and extract(year from lpep_pickup_datetime) = 2019

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}