--將搭乘Uber行程的 rate_code_id 數值代碼轉換為對應的說明。
SELECT
  rate_code_id,
  CASE rate_code_id
    WHEN 1 THEN 'Standard rate'
    WHEN 2 THEN 'JFK'
    WHEN 3 THEN 'Newark'
    WHEN 4 THEN 'Nassau or Westchester'
    WHEN 5 THEN 'Negotiated fare'
    WHEN 6 THEN 'Group ride'
    ELSE 'Unknown'
  END AS rate_code_description
FROM (
  SELECT DISTINCT rate_code_id
  FROM {{ ref('stg_trips') }}
  WHERE rate_code_id IS NOT NULL
)
