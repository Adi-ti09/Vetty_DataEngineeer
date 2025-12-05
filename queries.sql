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
-- ==============================================================================
-- Q5. What is the most popular item name that buyers order on their first purchase?
-- ==============================================================================
WITH BuyerFirstPurchase AS (
    SELECT
        t.buyer_id,
        t.item_id,
        -- Rank transactions for each buyer, ordering by purchase time (earliest is rank 1)
        ROW_NUMBER() OVER (
            PARTITION BY t.buyer_id
            ORDER BY t.purchase_time ASC
        ) AS rn
    FROM
        transactions AS t
)
SELECT
    i.item_name,
    COUNT(i.item_name) AS first_purchase_count
FROM
    BuyerFirstPurchase AS bfp
JOIN
    items AS i ON bfp.item_id = i.item_id
WHERE
    bfp.rn = 1  -- Filter for only the first purchase
GROUP BY
    i.item_name
ORDER BY
    first_purchase_count DESC
LIMIT 1;


-- ==============================================================================
-- Q7. Create a rank by buyer_id column and filter for only the second purchase.
-- (Ignore refunds here)
-- ==============================================================================
WITH RankedPurchases AS (
    SELECT
        buyer_id,
        purchase_time,
        item_id,
        -- Rank purchases for each buyer, ordering by purchase time ascending
        ROW_NUMBER() OVER (
            PARTITION BY buyer_id
            ORDER BY purchase_time ASC
        ) AS purchase_rank
    FROM
        transactions
    WHERE
        -- Filter condition to ignore refunded purchases
        refund IS NULL
)
SELECT
    buyer_id,
    purchase_time,
    item_id,
    purchase_rank
FROM
    RankedPurchases
WHERE
    purchase_rank = 2; -- Filter for only the second rank


-- ==============================================================================
-- Q8. How will you find the second transaction time per buyer (don't use min/max)
-- ==============================================================================
-- NOTE: This solution is identical in logic to Q7, as ranking (ROW_NUMBER) is the standard 
-- way to find the Nth transaction without using MIN/MAX.
WITH RankedTransactions AS (
    SELECT
        buyer_id,
        purchase_time,
        -- Rank all transactions for each buyer
        ROW_NUMBER() OVER (
            PARTITION BY buyer_id
            ORDER BY purchase_time ASC
        ) AS purchase_rank
    FROM
        transactions
)
SELECT
    buyer_id,
    purchase_time AS second_transaction_time
FROM
    RankedTransactions
WHERE
    purchase_rank = 2; -- Filter for the second transaction time