WITH monthly_revenue AS (
  SELECT
    EXTRACT(YEAR FROM transaction_date) AS year,
    EXTRACT(MONTH FROM transaction_date) AS month,
    merchant_name,
    SUM(amount) AS totalrevenue
  FROM
    `project.dataset.transactions`
  WHERE
    transaction_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH)  -- last 3 months data
  GROUP BY
    year, month, merchant_name
),
merchants AS (
  SELECT
    year,
    month,
    merchant_name,
    totalrevenue,
    RANK() OVER (PARTITION BY year, month ORDER BY totalrevenue DESC) AS revenue_rank
  FROM
    monthly_revenue
)

SELECT
  year,
  month,
  merchant_name,
  totalrevenue
FROM
  merchants
WHERE
  revenue_rank <= 3  -- top 3 merchants
ORDER BY
  year DESC, month DESC, totalrevenue DESC