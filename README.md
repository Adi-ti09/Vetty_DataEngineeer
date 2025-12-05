# Data Engineer SQL Assessment Solution

## 🎯 Project Goal

This repository contains the solution for the technical SQL assessment, covering 8 analytical and data manipulation questions based on the provided `transactions` and `items` dataset snapshots.

The primary objective was to demonstrate proficiency in:
1.  Handling and cleaning raw data fields (e.g., string-based currency).
2.  Performing time-series and interval analysis.
3.  Utilizing advanced SQL techniques, specifically Window Functions (`ROW_NUMBER`), for ranking and behavioral analysis.

## 📂 Repository Structure

| File | Purpose |
| :--- | :--- |
| `queries.sql` | Contains the complete, commented SQL queries for questions 1 through 8. |
| `data_prep.sql` | Contains the `CREATE TABLE` and `INSERT` statements required to set up the two tables (`transactions` and `items`) and load the sample data locally. |
| `README.md` | Provides context, project structure, and documents all necessary assumptions. |
| `.gitignore` | Standard file to ignore environment files and sensitive data/outputs. |

## ⚙️ Execution / Environment

The queries were developed using **Standard SQL** syntax, assuming a modern relational database like **PostgreSQL** (due to the use of `DATE_TRUNC`, `INTERVAL`, and `EXTRACT(EPOCH...)`).

**To Execute the Solution:**
1.  Run the statements in `data_prep.sql` to create the two tables and populate them with the sample data.
2.  Execute the queries in `queries.sql`.

## 📌 Key Assumptions

As per the instructions, here are the assumptions made to solve the problems:

1.  **SQL Dialect:** The queries assume a dialect that supports `ROW_NUMBER()` for ranking, standard date/time functions (`DATE_TRUNC`), and interval arithmetic (`INTERVAL`, `EXTRACT(EPOCH)`).
2.  **Currency Data Type:** The `gross_transaction_value` column was treated as a **VARCHAR** due to the presence of the `$` symbol. Cleaning was performed in relevant queries (e.g., Q4) by using `REPLACE(gross_transaction_value, '$', '')` and casting the result to `NUMERIC`.
3.  **Refund Status:** The `refund` column is a **TIMESTAMP**. A `NULL` value in this column is interpreted as "no refund occurred," which was used to filter non-refunded purchases in Q1 and Q7.
4.  **Transaction Uniqueness:** `purchase_time` was used as the determinant for transaction order when ranking purchases by store or buyer (e.g., Q4, Q5, Q7, Q8).