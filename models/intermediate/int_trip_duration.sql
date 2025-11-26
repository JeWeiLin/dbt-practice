SELECT
  *,
  (unix_timestamp(dropoff_ts) - unix_timestamp(pickup_ts))/ 60 AS trip_duration_min
FROM {{ ref('stg_trips') }}
WHERE dropoff_ts IS NOT NULL
-- 排除沒有下車時間的紀錄 