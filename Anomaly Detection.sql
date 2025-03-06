-- Anomaly Detection & Risk Analysis on Transactions

-- 1. Identifying Unusually High Transaction Amounts
SELECT * FROM transactions
WHERE total_transaction_amount > (SELECT AVG(total_transaction_amount) * 3 FROM transactions);

-- 2. Finding Suspiciously Frequent Transactions from the Same Sender
SELECT sender_account_id, COUNT(*) AS transaction_count
FROM transactions
GROUP BY sender_account_id
HAVING COUNT(*) > (SELECT AVG(transaction_count) * 2 FROM 
                   (SELECT sender_account_id, COUNT(*) AS transaction_count 
                    FROM transactions 
                    GROUP BY sender_account_id) AS subquery)
ORDER BY transaction_count DESC;

-- 3. Detecting Unusually Large Number of Transactions Within a Short Time Window
SELECT sender_account_id, COUNT(*) AS transaction_count, MIN(time) AS first_transaction, MAX(time) AS last_transaction
FROM transactions
WHERE time BETWEEN (CURRENT_DATE - INTERVAL '1 DAY') AND CURRENT_DATE
GROUP BY sender_account_id
HAVING COUNT(*) > 10
ORDER BY transaction_count DESC;

-- 4. Identifying High-Frequency Failed Transactions
SELECT sender_account_id, COUNT(*) AS failed_attempts
FROM transactions
WHERE transaction_status = 'Failed'
GROUP BY sender_account_id
HAVING COUNT(*) > 5
ORDER BY failed_attempts DESC;

-- 5. Finding Accounts with Consecutive Failed Transactions Followed by a Success
SELECT sender_account_id, transaction_status, COUNT(*) AS count
FROM (SELECT sender_account_id, transaction_status,
             LAG(transaction_status) OVER (PARTITION BY sender_account_id ORDER BY time) AS prev_status
      FROM transactions) AS subquery
WHERE prev_status = 'Failed' AND transaction_status = 'Success'
GROUP BY sender_account_id, transaction_status
ORDER BY count DESC;

-- 6. Analyzing Transactions Where Sender & Receiver Are the Same (Possible Fraud)
SELECT * FROM transactions
WHERE sender_account_id = receiver_account_id;

-- 7. Identifying Fraudulent Transactions with Unusual Device Usage
SELECT device_used, COUNT(*) AS fraud_count
FROM transactions
WHERE fraud_flag = 'TRUE'
GROUP BY device_used
ORDER BY fraud_count DESC;

-- 8. Finding Transactions in a Region Where the Sender Has Never Transacted Before
SELECT t1.sender_account_id, t1.region AS new_region
FROM transactions t1
WHERE NOT EXISTS (
    SELECT 1 FROM transactions t2 
    WHERE t1.sender_account_id = t2.sender_account_id
    AND t1.region = t2.region
    AND t2.time < t1.time
)
ORDER BY t1.time DESC;

-- 9. Identifying Unusual Transactions During Non-Business Hours
SELECT * FROM transactions
WHERE EXTRACT(HOUR FROM time) NOT BETWEEN 9 AND 18
ORDER BY time DESC;

-- 10. Flagging Large Withdrawals Without Matching Deposits
SELECT sender_account_id, 
       SUM(CASE WHEN transaction_type = 'Deposit' THEN total_transaction_amount ELSE 0 END) AS total_deposits,
       SUM(CASE WHEN transaction_type = 'Withdrawal' THEN total_transaction_amount ELSE 0 END) AS total_withdrawals
FROM transactions
GROUP BY sender_account_id
HAVING total_withdrawals > (total_deposits * 1.5)  -- Withdrawals exceed deposits by 50%
ORDER BY total_withdrawals DESC;

-- 11. Detecting High-Risk Accounts Based on Multiple Fraud Transactions
SELECT sender_account_id, COUNT(*) AS fraud_count
FROM transactions
WHERE fraud_flag = 'TRUE'
GROUP BY sender_account_id
HAVING COUNT(*) > 5
ORDER BY fraud_count DESC;

-- 12. Identifying High-Risk Network Slices for Fraud
SELECT network_slice_id, COUNT(*) AS fraud_cases
FROM transactions
WHERE fraud_flag = 'TRUE'
GROUP BY network_slice_id
ORDER BY fraud_cases DESC;

-- 13. Detecting Frequent Large Transactions Between the Same Sender and Receiver
SELECT sender_account_id, receiver_account_id, COUNT(*) AS transaction_count, 
       AVG(total_transaction_amount) AS avg_amount
FROM transactions
GROUP BY sender_account_id, receiver_account_id
HAVING COUNT(*) > 5 AND AVG(total_transaction_amount) > 1000
ORDER BY transaction_count DESC;

-- 14. Finding Unusual Changes in Transaction Behavior
WITH avg_trans AS (
    SELECT sender_account_id, AVG(total_transaction_amount) AS avg_transaction_amount
    FROM transactions
    GROUP BY sender_account_id
)
SELECT t.sender_account_id, t.total_transaction_amount, a.avg_transaction_amount
FROM transactions t
JOIN avg_trans a ON t.sender_account_id = a.sender_account_id
WHERE t.total_transaction_amount > (a.avg_transaction_amount * 3)
ORDER BY t.total_transaction_amount DESC;

-- 15. Identifying New Accounts That Have High-Value Transactions Immediately After Creation
SELECT sender_account_id, MIN(time) AS first_transaction_time, SUM(total_transaction_amount) AS total_amount
FROM transactions
GROUP BY sender_account_id
HAVING total_amount > 10000
ORDER BY first_transaction_time DESC;
