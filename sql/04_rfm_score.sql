-- =====================================
-- Recency Frequency Monetary 分析
-- =====================================

-- 1.`03_user_analysis` テーブルから RFM のそれぞれの要素を取得する
WITH rfm_base AS (
	SELECT
		user_id,
		days_since_last_purchase AS recency,
		order_count AS frequency,
		total_sales AS monetary
	From `03_user_analysis`
),

-- 2.取得した RFM の要素を 5つのグループにグループ分けする
-- recency のみは数値が低い方が評価が高いため、降順にする
rfm_score AS (
	SELECT
		user_id,
		recency,
		frequency,
		monetary,
		NTILE(5) OVER(ORDER BY recency DESC) AS r_score,
		NTILE(5) OVER(ORDER BY frequency) AS f_score,
		NTILE(5) OVER(ORDER BY monetary) AS m_score
	From rfm_base
)

-- 3.RFM それぞれの要素を一覧にする。
SELECT
	user_id,
	recency,
	frequency,
	monetary,
	r_score,
	f_score,
	m_score,

	-- 将来的にセグメントに分類することを見据えて、
	-- 文字列でコードを作っておく
	CONCAT(
		CAST(r_score AS STRING),
		CAST(f_score AS STRING),
		CAST(m_score AS STRING)
	) AS rfm_code
From rfm_score;
