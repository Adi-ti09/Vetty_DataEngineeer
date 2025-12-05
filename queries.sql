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

