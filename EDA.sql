-- Exploratory Data Analysis (EDA) on Transactions

-- 1. How many total transactions are in the dataset?
SELECT COUNT(*) AS total_transactions FROM transactions;

-- 2. What is the total transaction amount processed?
SELECT SUM(total_transaction_amount) AS total_transaction_volume FROM transactions;

-- 3. What is the distribution of transactions by type (Transfer, Deposit, Withdrawal)?
SELECT transaction_type, COUNT(*) AS transaction_count
FROM transactions
GROUP BY transaction_type
ORDER BY transaction_count DESC;

-- 4. What is the percentage of successful vs. failed transactions?
SELECT transaction_status, COUNT(*) AS count,
       (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM transactions)) AS percentage
FROM transactions
GROUP BY transaction_status;

-- 5. What is the number of fraud vs. non-fraud transactions?
SELECT fraud_flag, COUNT(*) AS fraud_count
FROM transactions
GROUP BY fraud_flag;

-- 6. Which transaction type has the highest fraud occurrence?
SELECT transaction_type, COUNT(*) AS fraud_count
FROM transactions
WHERE fraud_flag = 'TRUE'
GROUP BY transaction_type
ORDER BY fraud_count DESC;

-- 7. How does transaction volume change over time?
SELECT EXTRACT(HOUR FROM time) AS transaction_hour, COUNT(*) AS transaction_count
FROM transactions
GROUP BY transaction_hour
ORDER BY transaction_hour;

-- 8. What is the total transaction value for fraud vs. non-fraud transactions?
SELECT fraud_flag, SUM(total_transaction_amount) AS total_fraud_value
FROM transactions
GROUP BY fraud_flag;

-- 9. What are the top regions with the highest number of transactions?
SELECT region, COUNT(*) AS transaction_count
FROM transactions
GROUP BY region
ORDER BY transaction_count DESC
LIMIT 5;

-- 10. What is the success rate of each transaction type?
SELECT transaction_type, 
       SUM(CASE WHEN transaction_status = 'Success' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS success_rate
FROM transactions
GROUP BY transaction_type;
