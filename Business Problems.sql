-- Real-world Business Problems and SQL Solutions

-- 1. Identifying Peak Transaction Hours
SELECT EXTRACT(HOUR FROM time) AS transaction_hour, COUNT(*) AS transaction_count
FROM transactions
GROUP BY transaction_hour
ORDER BY transaction_count DESC;

-- 2. Fraud Detection Based on Transaction Amounts
SELECT transaction_type, AVG(total_transaction_amount) AS avg_fraud_amount
FROM transactions
WHERE fraud_flag = 'TRUE'
GROUP BY transaction_type
ORDER BY avg_fraud_amount DESC;

-- 3. Identifying High-Risk Regions for Fraudulent Transactions
SELECT region, COUNT(*) AS fraud_count
FROM transactions
WHERE fraud_flag = 'TRUE'
GROUP BY region
ORDER BY fraud_count DESC
LIMIT 5;

-- 4. Analyzing Failed Transactions by Network Slice
SELECT network_slice_id, COUNT(*) AS failed_transactions
FROM transactions
WHERE transaction_status = 'Failed'
GROUP BY network_slice_id
ORDER BY failed_transactions DESC;

-- 5. Detecting Anomalies in High-Value Transactions
SELECT * FROM transactions
WHERE total_transaction_amount > (SELECT AVG(total_transaction_amount) * 2 FROM transactions);

-- 6. Analyzing Fraud Trends Over Time
SELECT DATE_TRUNC('month', time) AS month, COUNT(*) AS fraud_cases
FROM transactions
WHERE fraud_flag = 'TRUE'
GROUP BY month
ORDER BY month DESC;
