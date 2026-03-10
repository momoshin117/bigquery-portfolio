-- =====================================
-- データの品質チェック
-- =====================================

-- 1-1.参照整合性(必須)
-- 目的:データが破綻していないかのチェック
--      order_items (子) に存在するが orders(親) に存在しない
-- 想定結果:0(件)

SELECT COUNT(*) AS without_orders
FROM `bigquery-public-data.thelook_ecommerce.order_items` i
LEFT JOIN `bigquery-public-data.thelook_ecommerce.orders` o
ON i.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 1-2.参照整合性
-- 目的:異常値がないかのチェック(空注文などシステムによって発生する可能性あり)
--      orders (親)に存在するが order_items (子)がない
-- 想定結果:without_order_items_rate 列が 1(%)未満

SELECT COUNT(DISTINCT o.order_id) AS all_order_count,
    COUNTIF(DISTINCT i.order_id IS NULL) AS without_order_items,
    SAFE_DIVIDE(
        COUNTIF(i.order_id IS NULL),
        COUNT(DISTINCT o.order_id)
    )*100 AS without_order_items_rate
FROM `bigquery-public-data.thelook_ecommerce.orders` o
LEFT JOIN `bigquery-public-data.thelook_ecommerce.order_items` i
ON o.order_id = i.order_id;


-- 2.一意性(必須)
-- 目的:親テーブル orders の order_id の一意性
--      
-- 想定結果:0(件)

SELECT order_id, COUNT(*) AS cnt
FROM `bigquery-public-data.thelook_ecommerce.orders`
GROUP BY order_id
HAVING COUNT(*) > 1;