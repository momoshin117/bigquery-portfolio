--LTV

CREATE OR REPLACE TABLE `bigquery-portfolio-488907.portfolio.user_ltv` AS
SELECT o.user_id,
 COUNT(DISTINCT o.order_id) AS total_orders,
 SUM(i.sale_price) AS lifetime_value

FROM `bigquery-public-data.thelook_ecommerce.orders` o

INNER JOIN `bigquery-public-data.thelook_ecommerce.order_items` i
ON o.order_id = i.order_id

WHERE o.status IN ('Shipped','Complete')

GROUP BY o.user_id

ORDER BY lifetime_value DESC;