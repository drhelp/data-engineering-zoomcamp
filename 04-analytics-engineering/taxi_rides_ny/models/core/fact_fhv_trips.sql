with fhv_trips as (
    select *
    from {{ ref("stg_fhv_tripdata")}}
),
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
),
trips_final as (
    select
        Dispatching_base_num
        lpep_pickup_datetime,
        lpep_dropoff_datetime,
        pickup_locationid,
        dropoff_locationid,
        SR_Flag,
        Affiliated_base_number,
        pickup_zone.borough as pickup_borough, 
        pickup_zone.zone as pickup_zone, 
        dropoff_zone.borough as dropoff_borough, 
        dropoff_zone.zone as dropoff_zone
    from fhv_trips
    inner join dim_zones as pickup_zone
    on fhv_trips.pickup_locationid = pickup_zone.locationid
    inner join dim_zones as dropoff_zone
    on fhv_trips.dropoff_locationid = dropoff_zone.locationid
)
select *
from trips_final