-- Advanced Transaction Analysis

-- 1. What are the busiest transaction hours of the day?
SELECT EXTRACT(HOUR FROM time) AS transaction_hour, COUNT(*) AS transaction_count
FROM transactions
GROUP BY transaction_hour
ORDER BY transaction_count DESC;

-- 2. What percentage of transactions per network slice are fraudulent?
SELECT network_slice_id,
       COUNT(*) AS total_transactions,
       SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS fraud_percentage
FROM transactions
GROUP BY network_slice_id
ORDER BY fraud_percentage DESC;

-- 3. Which regions have the highest fraud rate?
SELECT region, 
       SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS fraud_rate
FROM transactions
GROUP BY region
ORDER BY fraud_rate DESC;

-- 4. What is the correlation between transaction amount and fraud occurrence?
SELECT 
    CASE 
        WHEN total_transaction_amount <= 500 THEN 'Low'
        WHEN total_transaction_amount <= 1000 THEN 'Medium'
        ELSE 'High'
    END AS amount_category,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) AS fraud_transactions
FROM transactions
GROUP BY amount_category
ORDER BY fraud_transactions DESC;

-- 5. How does fraud distribution vary across devices?
SELECT device_used, COUNT(*) AS fraud_count
FROM transactions
WHERE fraud_flag = 'TRUE'
GROUP BY device_used
ORDER BY fraud_count DESC;
