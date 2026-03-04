# SQLファイルの説明

このプロジェクトでは3つのSQLファイルを作成し、ECデータの分析を行っています。

---

# 01_kpi_daily.sql

## 目的

日次のビジネス指標（KPI）を集計する。

## 集計粒度

```
1行 = 1日
```

## 使用テーブル

* orders
* order_items

```
orders (1) ----- (N) order_items
```

---

## 集計指標

### 日次売上

```
SUM(order_items.sale_price)
```

購入された商品の金額を合計して売上を計算。

---

### 注文数

```
COUNT(DISTINCT orders.order_id)
```

1注文に複数の商品が含まれるため
DISTINCTを使って注文IDの重複を除外。

---

### 購入ユーザー数

```
COUNT(DISTINCT orders.user_id)
```

その日に購入したユーザー数。

---

### 平均注文単価（AOV）

```
SAFE_DIVIDE(売上, 注文数)
```

SAFE_DIVIDE を使うことで
ゼロ除算エラーを防ぐ。

---

## フィルタ条件

```
status IN ('Shipped','Complete')
```

確定した注文のみを対象にする。

---

# 02_data_quality_checks.sql

## 目的

分析前にデータの整合性を確認する。

---

## チェック① orphan order_items

```
order_items に存在するが
orders に存在しない注文
```

方法

```
order_items
LEFT JOIN orders
WHERE orders.order_id IS NULL
```

意味
参照整合性が壊れていないか確認。

---

## チェック② itemsを持たない注文

```
orders に存在するが
order_items が存在しない注文
```

方法

```
orders
LEFT JOIN order_items
WHERE order_items.order_id IS NULL
```

意味
空注文が存在しないか確認。

---

## チェック③ order_idの重複

```
GROUP BY order_id
HAVING COUNT(*) > 1
```

意味
ordersテーブルの主キーが一意か確認。

---

# 03_user_ltv.sql

## 目的

ユーザー単位の顧客価値（LTV）を計算する。

---

## 粒度

```
1行 = 1ユーザー
```

---

## 対象データ

```
status IN ('Shipped','Complete')
```

キャンセルや返品を除外。

---

# SQL構造

このクエリは **CTE（WITH句）** を使って構成されている。

```
WITH base_date
WITH user_orders
SELECT final
```

---

# base_date

分析基準日を作成する。

```
as_of_date = MAX(created_at)
```

対象

```
status IN ('Shipped','Complete')
```

この日付を基準に
最終購入からの経過日数を計算する。

---

# user_orders

ユーザーごとの購買情報を集計。

集計項目

### 累計売上

```
SUM(order_items.sale_price)
```

---

### 注文数

```
COUNT(DISTINCT orders.order_id)
```

JOINによる重複を防ぐためDISTINCTを使用。

---

### 初回購入日

```
MIN(created_at)
```

---

### 最終購入日

```
MAX(created_at)
```

---

# 最終SELECT

user_orders と base_date を結合して
派生指標を作成する。

---

## user_aov

ユーザー平均注文単価

```
SAFE_DIVIDE(lifetime_value,total_orders)
```

---

## days_since_last_purchase

最終購入からの経過日数

```
DATE_DIFF(as_of_date,last_purchase_date,DAY)
```

---

# このSQLで示しているスキル

* JOINによるデータ結合
* 集計処理
* DISTINCTによる重複排除
* SAFE_DIVIDEによるエラー防止
* DATE_DIFFによる日付計算
* CTEによるSQLの構造化
* データ品質チェック
