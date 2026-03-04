-- 基準日
WITH base_date AS(
    SELECT  MAX(o.created_at) AS as_of_date
    FROM `bigquery-public-data.thelook_ecommerce.orders` o
    WHERE o.status IN ('Shipped', 'Complete')
    ),

    user_orders AS(
    SELECT  o.user_id,  
        SUM(i.sale_price) AS lifetime_value,
        COUNT(DISTINCT(o.order_id)) AS total_orders,
        MIN(o.created_at) AS first_purchase_date,
        MAX(o.created_at) AS last_purchase_date
    FROM `bigquery-public-data.thelook_ecommerce.orders` o
    JOIN `bigquery-public-data.thelook_ecommerce.order_items` i
    ON o.order_id = i.order_id
    WHERE o.status IN ('Shipped', 'Complete')
    GROUP BY o.user_id
)

SELECT  user_id,
    lifetime_value,
    total_orders,
    first_purchase_date,
    last_purchase_date,
    SAFE_DIVIDE(lifetime_value,total_orders) AS user_aov,
    DATE_DIFF(DATE(as_of_date),DATE(last_purchase_date),DAY) AS days_since
FROM    user_orders
CROSS JOIN    base_date
ORDER BY lifetime_value DESC;
