-- =====================================
-- データ品質
-- =====================================

-- 参照整合性：子に存在して親に存在しないか
-- order_items に存在するが orders に存在しない

SELECT COUNT(*) AS orphan_items
FROM `bigquery-public-data.thelook_ecommerce.order_items` i
LEFT JOIN `bigquery-public-data.thelook_ecommerce.orders` o
ON i.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 親に存在して子に存在しないか
--orders に存在するが order_items がない

SELECT COUNT(*) AS orders_without_items
FROM `bigquery-public-data.thelook_ecommerce.orders` o
LEFT JOIN `bigquery-public-data.thelook_ecommerce.order_items` i
ON o.order_id = i.order_id
WHERE i.order_id IS NULL;


-- 一意性：order_id が唯一無二か

SELECT order_id, COUNT(*) AS cnt
FROM `bigquery-public-data.thelook_ecommerce.orders`
GROUP BY order_id
HAVING COUNT(*) > 1;