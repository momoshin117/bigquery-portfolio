-- =====================================
-- 日別集計
-- =====================================

-- 目的:日別集計
-- テーブル:日付、売上、注文数、購入者数、平均単価

CREATE OR REPLACE TABLE `bigquery-portfolio-488907.portfolio.kpi_daily` AS
SELECT
  DATE(o.created_at) AS order_date,
  SUM(i.sale_price) AS sales,
  -- INNER JOIN のため、1注文に複数商品を注文すると、order_id, user_id ともに
  -- 同じ id が複数行にわたるため、重複を考慮したカウントが必要
  COUNT(DISTINCT o.order_id) AS order_count,
  COUNT(DISTINCT o.user_id) AS purchasing_users,
  SAFE_DIVIDE(SUM(i.sale_price), COUNT(DISTINCT o.order_id)) AS average_purchase_price
-- 売上は order_items にしかないため、INNER JOIN
-- orders にしかないものは無視
FROM `bigquery-public-data.thelook_ecommerce.orders` o
JOIN `bigquery-public-data.thelook_ecommerce.order_items` i
  ON o.order_id = i.order_id

-- （Shipped / Completeのみ対象）
WHERE o.status IN ('Shipped', 'Complete')
GROUP BY DATE(o.created_at);