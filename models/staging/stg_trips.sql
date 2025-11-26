SELECT
  CAST(VendorID AS BIGINT) AS vendor_id,
  tpep_pickup_datetime AS pickup_ts,
  tpep_dropoff_datetime AS dropoff_ts,
  passenger_count,
  trip_distance,
  pickup_longitude, pickup_latitude,
  dropoff_longitude, dropoff_latitude,
  RatecodeID AS rate_code_id,
  payment_type,
  fare_amount, extra, mta_tax, tip_amount, tolls_amount, total_amount  -- 費率與支付方式代碼
FROM {{ source('databricks_bronze_layer', 'ubers_raw')}}
WHERE total_amount > 0
