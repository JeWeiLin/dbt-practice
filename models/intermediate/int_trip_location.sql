--經緯度條件將搭乘uber行程分為「NYC」與「Out_of_city」。
SELECT
  *,
  CASE
    WHEN pickup_longitude BETWEEN -74.05 AND -73.75
     AND pickup_latitude BETWEEN 40.6 AND 40.9 THEN 'NYC'
    ELSE 'Out_of_city'
  END AS pickup_zone
FROM {{ ref('int_trip_duration') }}
