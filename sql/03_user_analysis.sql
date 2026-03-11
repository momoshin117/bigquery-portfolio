-- =====================================
-- ユーザー別集計
-- =====================================

-- 目的:ユーザー別の集計結果を作成
-- テーブル:ユーザーID、累計購入金額、購入回数、初回購入日、最終購入日、
--      最終購入日からの経過日数

-- 1.基準日の計算
--   基準日 = orders テーブルに存在する最新の日付と定義
--   発送済み or 完了 の注文のみを対象

WITH base_date_table AS(
    SELECT  MAX(o.created_at) AS base_date
    FROM `bigquery-public-data.thelook_ecommerce.orders` o
    WHERE o.status IN ('Shipped', 'Complete')
    ),

    --2.ユーザーごとの集計
    user_orders AS(
    SELECT  o.user_id,  
        SUM(i.sale_price) AS total_sales,

        -- 1注文に複数商品頼むと、同一の order_id が複数行に存在するため、
        -- 重複を除いて注文回数を集計
        COUNT(DISTINCT(o.order_id)) AS order_count,
        MIN(o.created_at) AS first_purchase_date,
        MAX(o.created_at) AS last_purchase_date

    -- 商品明細のある注文のみを集計するため、INNER JOIN    
    FROM `bigquery-public-data.thelook_ecommerce.orders` o
    JOIN `bigquery-public-data.thelook_ecommerce.order_items` i
    ON o.order_id = i.order_id
    WHERE o.status IN ('Shipped', 'Complete')
    GROUP BY o.user_id
)

-- 3.ユーザーごとの分析結果を出力
--  累計購入金額が多い順
SELECT  user_id,
    total_sales,
    order_count,
    first_purchase_date,
    last_purchase_date,
    SAFE_DIVIDE(total_sales,order_count) AS average_purchase_price,
    DATE_DIFF(DATE(base_date),DATE(last_purchase_date),DAY) AS days_since_last_purchase

-- 全ての行に基準日を出力させるために CROSS JOIN
FROM    user_orders
CROSS JOIN    base_date_table
ORDER BY total_sales DESC;
