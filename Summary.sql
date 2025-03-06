-- Summary Statistics on Transactions

-- 1. What is the average transaction amount?
SELECT AVG(total_transaction_amount) AS avg_transaction_amount FROM transactions;

-- 2. What is the highest and lowest transaction amounts?
SELECT 
    MIN(total_transaction_amount) AS min_transaction_amount,
    MAX(total_transaction_amount) AS max_transaction_amount
FROM transactions;

-- 3. What is the median transaction amount?
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_transaction_amount) AS median_transaction_amount
FROM transactions;

-- 4. What is the standard deviation of transaction amounts?
SELECT STDDEV(total_transaction_amount) AS stddev_transaction_amount FROM transactions;

-- 5. What is the total number of fraud transactions per transaction type?
SELECT transaction_type, COUNT(*) AS fraud_count
FROM transactions
WHERE fraud_flag = 'TRUE'
GROUP BY transaction_type
ORDER BY fraud_count DESC;

-- 6. What is the SLA breach rate for transactions?
SELECT transaction_status, 
       SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS fraud_rate
FROM transactions
GROUP BY transaction_status;

-- 7. How many transactions were made per device type?
SELECT device_used, COUNT(*) AS transaction_count
FROM transactions
GROUP BY device_used
ORDER BY transaction_count DESC;

-- 8. What is the total transaction amount per transaction type?
SELECT transaction_type, SUM(total_transaction_amount) AS total_amount
FROM transactions
GROUP BY transaction_type
ORDER BY total_amount DESC;

-- 9. How does fraud distribution change by network bandwidth?
SELECT bandwidth_group, COUNT(*) AS fraud_count
FROM transactions
WHERE fraud_flag = 'TRUE'
GROUP BY bandwidth_group
ORDER BY fraud_count DESC;

-- 10. Which network slice has the most fraudulent transactions?
SELECT network_slice_id, COUNT(*) AS fraud_count
FROM transactions
WHERE fraud_flag = 'TRUE'
GROUP BY network_slice_id
ORDER BY fraud_count DESC;
