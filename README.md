# EC BigQuery Portfolio

## 目的
BigQuery の公開データセット `thelook_ecommerce` を使用し、
ECサイトの注文データをもとに、売上や購入行動を可視化・分析できるようにすること

## 内容
1. データ品質チェック
2. 日別集計
3. ユーザー別集計
4. RFM分析

## データセット

BigQuery Public Dataset を使用
bigquery-public-data.thelook_ecommerce

主に使用したテーブル
- orders | 注文単位のテーブル 
- order_items | 商品単位のテーブル

## データモデル
+------------------+
|      orders      |
+------------------+
| order_id         |
| user_id          |
| created_at       |
| status           |
+------------------+
          |
          | 1 : N
          |
+------------------+
|   order_items    |
+------------------+
| order_id         |
| product_id       |
| sale_price       |
+------------------+

## 1.データの品質チェック

主なチェック

- 参照整合性
- 一意性

上記2つでデータが破綻していないかを分析の前に確認。

## 2.日別集計

日ごとの売上や注文状況をまとめたテーブルです。  
売上の推移や、どの日に注文数・購入者数が多かったかを確認できます。

| column                 | description
| ---------------------- | ----------- 
| order_date             | 注文日         
| sales                  | 売上          
| order_count            | 注文回数         
| purchasing_users       | 購入ユーザー数    
| average_purchase_price | 平均単価      


## 3.ユーザー別集計

ユーザーごとの購入実績をまとめたテーブルです。  
「どのユーザーがたくさん買っているか」「最後にいつ購入したか」などを確認できます。

| column                   | description 
| ------------------------ | ----------- 
| user_id                  | ユーザーID      
| order_count              | 注文回数         
| total_sales              | 累計売上        
| first_purchase_date      | 初回購入日       
| last_purchase_date       | 最終購入日       
| average_purchase_price   | 平均単価      
| days_since_last_purchase | 最終購入からの経過日数
| base_date                | 基準日       


## 4.Recency Frequency Monetary 分析

ユーザーの購買行動をもとに、優良顧客や離れそうな顧客を見つけるためのテーブルです。  
直近の購入日、購入回数、購入金額を使って、顧客を分類しやすくしています。

| column    | description  
| --------- | ------------ 
| recency   | 最終購入からの経過日数        
| frequency | 注文回数     
| monetary  | 累計購入金額        
| r_score   | Recencyスコア   
| f_score   | Frequencyスコア 
| m_score   | Monetaryスコア  
| rfm_code  | RFMコード       
