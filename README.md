# EC BigQuery Portfolio

## 目的
ECデータを用いて、確定売上ベースの日次KPIを作成。

## 指標定義
- 対象ステータス：Shipped / Complete
- 注文数：DISTINCT order_id
- 購入者数：DISTINCT user_id
- 売上：SUM(sale_price)
- AOV：SAFE_DIVIDE(売上, 注文数)

## データ設計
- 日付基準：orders.created_at
- 売上根拠：order_items
- 参照整合性確認済み