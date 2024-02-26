-- MAKE SURE YOU REPLACE dtc-de-course-412918 WITH THE NAME OF YOUR DATASET! 
-- When you run the query, only run 5 of the ALTER TABLE statements at one time (by highlighting only 5). 
-- Otherwise BigQuery will say too many alterations to the table are being made.

-- Green
drop table if exists ny_taxi_rides.green_tripdata;

create table ny_taxi_rides.green_tripdata as
SELECT * FROM `bigquery-public-data.new_york_taxi_trips`.tlc_green_trips_2019;

insert into ny_taxi_rides.green_tripdata 
SELECT * FROM `bigquery-public-data.new_york_taxi_trips`.tlc_green_trips_2020;


--Yellow
drop table if exists ny_taxi_rides.yellow_tripdata;

create table ny_taxi_rides.yellow_tripdata as
SELECT * FROM `bigquery-public-data.new_york_taxi_trips`.tlc_yellow_trips_2019;

insert into ny_taxi_rides.yellow_tripdata 
SELECT * FROM `bigquery-public-data.new_york_taxi_trips`.tlc_yellow_trips_2020;


-- FHV
drop table if exists ny_taxi_rides.ext_fhv_trips_2019;

create external table  ny_taxi_rides.ext_fhv_trips_2019
(
  Dispatching_base_num string,
  Pickup_datetime datetime,
  DropOff_datetime datetime,
  PULocationID int64,
  DOLocationID int64,
  SR_Flag int64,
  Affiliated_base_number string
)
OPTIONS (
    format = 'CSV',
    uris = ['gs://ntyc-taxi-csv/nyc-tlc/fhv_tripdata/fhv_tripdata_2019-*.csv.gz'],
    skip_leading_rows = 1,
    compression = 'gzip'
    );
 
 drop table if exists ny_taxi_rides.fhv_tripdata;

 create table ny_taxi_rides.fhv_tripdata as
 select * from ny_taxi_rides.ext_fhv_trips_2019;

  -- Fixes yellow table schema
ALTER TABLE `dtc-de-course-412918.ny_taxi_rides.yellow_tripdata`
  RENAME COLUMN vendor_id TO VendorID;
ALTER TABLE `dtc-de-course-412918.ny_taxi_rides.yellow_tripdata`
  RENAME COLUMN pickup_datetime TO tpep_pickup_datetime;
ALTER TABLE `dtc-de-course-412918.ny_taxi_rides.yellow_tripdata`
  RENAME COLUMN dropoff_datetime TO tpep_dropoff_datetime;
ALTER TABLE `dtc-de-course-412918.ny_taxi_rides.yellow_tripdata`
  RENAME COLUMN rate_code TO RatecodeID;
ALTER TABLE `dtc-de-course-412918.ny_taxi_rides.yellow_tripdata`
  RENAME COLUMN imp_surcharge TO improvement_surcharge;
ALTER TABLE `dtc-de-course-412918.ny_taxi_rides.yellow_tripdata`
  RENAME COLUMN pickup_location_id TO PULocationID;
ALTER TABLE `dtc-de-course-412918.ny_taxi_rides.yellow_tripdata`
  RENAME COLUMN dropoff_location_id TO DOLocationID;

  -- Fixes green table schema
ALTER TABLE `dtc-de-course-412918.ny_taxi_rides.green_tripdata`
  RENAME COLUMN vendor_id TO VendorID;
ALTER TABLE `dtc-de-course-412918.ny_taxi_rides.green_tripdata`
  RENAME COLUMN pickup_datetime TO lpep_pickup_datetime;
ALTER TABLE `dtc-de-course-412918.ny_taxi_rides.green_tripdata`
  RENAME COLUMN dropoff_datetime TO lpep_dropoff_datetime;
ALTER TABLE `dtc-de-course-412918.ny_taxi_rides.green_tripdata`
  RENAME COLUMN rate_code TO RatecodeID;
ALTER TABLE `dtc-de-course-412918.ny_taxi_rides.green_tripdata`
  RENAME COLUMN imp_surcharge TO improvement_surcharge;
ALTER TABLE `dtc-de-course-412918.ny_taxi_rides.green_tripdata`
  RENAME COLUMN pickup_location_id TO PULocationID;
ALTER TABLE `dtc-de-course-412918.ny_taxi_rides.green_tripdata`
  RENAME COLUMN dropoff_location_id TO DOLocationID;

  -- Fixes FHV table schema
ALTER TABLE `dtc-de-course-412918.ny_taxi_rides.fhv_tripdata`
  RENAME COLUMN pickup_datetime TO lpep_pickup_datetime;
ALTER TABLE `dtc-de-course-412918.ny_taxi_rides.fhv_tripdata`
  RENAME COLUMN dropoff_datetime TO lpep_dropoff_datetime;