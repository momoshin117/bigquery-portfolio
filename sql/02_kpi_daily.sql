-- 日次KPI（Shipped / Completeのみ対象）

CREATE OR REPLACE TABLE `bigquery-portfolio-488907.portfolio.kpi_daily` AS
SELECT
  DATE(o.created_at) AS date,
  SUM(i.sale_price) AS total_price,
  COUNT(DISTINCT o.order_id) AS order_count,
  COUNT(DISTINCT o.user_id) AS user_count,
  SAFE_DIVIDE(SUM(i.sale_price), COUNT(DISTINCT o.order_id)) AS aov
FROM `bigquery-public-data.thelook_ecommerce.orders` o
JOIN `bigquery-public-data.thelook_ecommerce.order_items` i
  ON o.order_id = i.order_id
WHERE o.status IN ('Shipped', 'Complete')
GROUP BY DATE(o.created_at);