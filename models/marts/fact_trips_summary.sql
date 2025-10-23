-- 建立 Uber 行程彙總的 Fact Table。
-- 將清理後的行程資料 (stg_trips) 與 (dim_ratecode, dim_payment_type) 整合，
-- 並計算每日、供應商、費率、付款方式的指標。

SELECT
  DATE(pickup_ts) AS trip_date,
  t.vendor_id,   --供應商代碼 
  r.rate_code_description, --費率與付款方式說明文字
  p.payment_description,

  COUNT(*) AS total_trips,                 -- 行程總數
  AVG(trip_distance) AS avg_distance_mi,   -- 平均行程距離（英里）
  AVG(total_amount) AS avg_total_amount,   -- 平均總金額（含小費、稅、過路費等）
  SUM(total_amount) AS total_revenue,      -- 總營收金額
  SUM(tip_amount) AS total_tips,           -- 總小費金額
  AVG(tip_amount / NULLIF(fare_amount, 0)) AS avg_tip_ratio   -- 平均小費比例（小費 ÷ 基本車資）

FROM {{ ref('stg_trips') }} AS t
LEFT JOIN {{ ref('dim_ratecode') }} AS r
  ON t.rate_code_id = r.rate_code_id
LEFT JOIN {{ ref('dim_payment_type') }} AS p
  ON t.payment_type = p.payment_type
GROUP BY
  trip_date,         
  t.vendor_id,        
  r.rate_code_description,  
  p.payment_description     