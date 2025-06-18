WITH transactions AS (
  SELECT
    user_id,
    transaction_date,
    amount,
    merchant_name,
    COUNT(*) OVER (PARTITION BY user_id) AS transaction_count
  FROM
    `project.dataset.transactions`
  WHERE
    transaction_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH)  -- last 3 months data
)

SELECT
  user_id,
  merchant_name,
  SUM(amount) AS total_amount_spent
FROM
  transactions
WHERE
  transaction_count > 3  -- users with more than 3 times transactions
GROUP BY
  user_id,
  merchant_name
ORDER BY
  total_amount_spent DESC