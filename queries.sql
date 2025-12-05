-- ==============================================================================
-- Q1. What is the count of purchases per month (excluding refunded purchases)?
-- ==============================================================================
SELECT
    -- Extract the year-month for grouping
    DATE_TRUNC('month', purchase_time) AS purchase_month,
    COUNT(buyer_id) AS total_purchases
FROM
    transactions
WHERE
    -- Filter condition to exclude refunded purchases (refund column is NULL)
    refund IS NULL
GROUP BY
    purchase_month
ORDER BY
    purchase_month;


-- ==============================================================================
-- Q2. How many stores receive at least 5 orders/transactions in October 2020?
-- ==============================================================================
SELECT
    -- Count the number of stores that meet the criteria
    COUNT(t.store_id) AS stores_with_5_plus_orders
FROM
    (
        SELECT
            store_id
        FROM
            transactions
        WHERE
            -- Filter for October 2020 purchases
            purchase_time >= '2020-10-01'
            AND purchase_time < '2020-11-01'
        GROUP BY
            store_id
        -- Filter the groups (stores) to only include those with 5 or more transactions
        HAVING
            COUNT(store_id) >= 5
    ) AS t;

-- ==============================================================================
-- Q3. For each store, what is the shortest interval (in min) from purchase to refund time?
-- ==============================================================================
SELECT
    store_id,
    -- Calculate the time difference (refund - purchase_time), extract the difference 
    -- in seconds (epoch), and divide by 60 to get minutes.
    MIN(EXTRACT(EPOCH FROM (refund - purchase_time)) / 60) AS shortest_refund_interval_minutes
FROM
    transactions
WHERE
    -- Only consider transactions that were actually refunded
    refund IS NOT NULL
GROUP BY
    store_id
ORDER BY
    store_id;


-- ==============================================================================
-- Q4. What is the gross_transaction_value of every store's first order?
-- ==============================================================================
WITH RankedTransactions AS (
    SELECT
        store_id,
        gross_transaction_value,
        purchase_time,
        -- Rank transactions for each store, ordering by purchase time (earliest is rank 1)
        ROW_NUMBER() OVER (
            PARTITION BY store_id
            ORDER BY purchase_time ASC
        ) AS rn
    FROM
        transactions
)
SELECT
    store_id,
    -- Clean the value by removing '$' and casting it to a numeric type
    CAST(REPLACE(gross_transaction_value, '$', '') AS NUMERIC) AS first_order_value,
    purchase_time
FROM
    RankedTransactions
WHERE
    rn = 1 -- Filter for only the first order (rank 1)
ORDER BY
    store_id;