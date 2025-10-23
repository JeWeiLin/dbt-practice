--將付費的代碼轉換為說明文字
SELECT
  payment_type,
  CASE payment_type
    WHEN 1 THEN 'Credit Card'
    WHEN 2 THEN 'Cash'
    WHEN 3 THEN 'No Charge'
    WHEN 4 THEN 'Dispute'
    WHEN 5 THEN 'Unknown'
    WHEN 6 THEN 'Voided Trip'
    ELSE 'Other'
  END AS payment_description
FROM (
  SELECT DISTINCT payment_type
  FROM {{ ref('stg_trips') }}
  WHERE payment_type IS NOT NULL
)