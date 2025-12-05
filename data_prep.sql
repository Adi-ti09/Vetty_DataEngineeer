-- data_prep.sql

CREATE TABLE transactions (
    buyer_id INT,
    purchase_time TIMESTAMP WITH TIME ZONE,
    refund TIMESTAMP WITH TIME ZONE,
    store_id CHAR(1),
    item_id VARCHAR(5),
    gross_transaction_value VARCHAR(10) -- Stored as VARCHAR due to '$'
);

INSERT INTO transactions (buyer_id, purchase_time, refund, store_id, item_id, gross_transaction_value) VALUES
(3, '2019-09-19 21:19:06.544 UTC', NULL, 'a', 'a1', '$58'),
(12, '2019-12-10 20:10:14.324 UTC', NULL, 'b', 'b2', '$475'),
(3, '2020-09-01 23:59:46.561 UTC', NULL, 'f', 'f6', '$33'),
(19, '2019-12-15 23:19:06.544 UTC', '2020-09-02 21:22:06.331 UTC', 'f', 'f1', '$250'),
(2, '2020-04-30 21:19:06.544 UTC', NULL, 'd', 'd3', '$91'),
(1, '2020-10-22 22:20:06.531 UTC', NULL, 'e', 'e7', '$24'),
(8, '2020-04-16 21:10:22.214 UTC', NULL, 'f', 'f6', '$61'),
(5, '2019-09-23 12:09:35.542 UTC', '2019-09-27 02:55:02.114 UTC', 'g', '12', '$61'); -- Note: The provided data has a missing item_id for this row, assuming '12' based on column alignment

CREATE TABLE items (
    store_id CHAR(1),
    item_id VARCHAR(5),
    item_category VARCHAR(20),
    item_name VARCHAR(50)
);

INSERT INTO items (store_id, item_id, item_category, item_name) VALUES
('a', 'a1', 'pants', 'denim pants'),
('a', 'a2', 'tops', 'blouse'),
('f', 'f1', 'table', 'coffee table'),
('f', 'f6', 'chair', 'armchair'),
('d', 'd2', 'jewelry', 'bracelet'),
('b', 'b4', 'earphone', 'airpods'),
('f', '15', 'chair', 'lounge chair'),
('d', 'd3', 'earphone', 'airpods');