-- ============================================================
-- 🚚 SUPPLY CHAIN OPERATIONS & RISK ANALYSIS
-- Tool     : MySQL Workbench
-- Dataset  : Supply Chain Operations & Risk Analysis Dataset
-- Source   : Kaggle — zoya77
-- Rows     : 1,000 | Columns Used : 12 of 24
-- Author   : Shaipshi
-- ============================================================

-- Columns Used:
-- Order_ID, Supplier_ID, Product_Category, Shipping_Mode,
-- Order_Date, Delay_Days, Disruption_Type, Disruption_Severity,
-- Historical_Disruption_Count, Supplier_Reliability_Score,
-- Order_Value_USD, Supply_Risk_Flag

CREATE DATABASE IF NOT EXISTS supply_risk_db;
USE supply_risk_db;

-- Rename table to match the SQL file
RENAME TABLE supply_chain_resilience_dataset TO supply_chain_risk;

-- ============================================================
-- SECTION 1: DELIVERY & DELAY ANALYSIS
-- ============================================================

-- Q1. Average delay days and delay rate by shipping mode
-- Which shipping mode is causing the most delays?
SELECT
    Shipping_Mode,
    COUNT(*)                                                          AS total_orders,
    ROUND(AVG(Delay_Days), 2)                                        AS avg_delay_days,
    SUM(CASE WHEN Delay_Days > 0 THEN 1 ELSE 0 END)                  AS delayed_orders,
    ROUND(SUM(CASE WHEN Delay_Days > 0 THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2)                                      AS delay_rate_pct
FROM supply_chain_risk
GROUP BY Shipping_Mode
ORDER BY avg_delay_days DESC;

-- Q2. Top 10 worst delayed orders
-- Which specific orders had the longest delays and how much is at stake?
SELECT
    Order_ID,
    Supplier_ID,
    Product_Category,
    Shipping_Mode,
    Order_Date,
    Delay_Days,
    Order_Value_USD,
    Disruption_Type,
    Disruption_Severity
FROM supply_chain_risk
WHERE Delay_Days > 0
ORDER BY Delay_Days DESC
LIMIT 10;


-- Q3. Monthly delay trend (Order_Date stored as TEXT)
SELECT
    LEFT(Order_Date, 7)                                               AS month_year,
    COUNT(*)                                                          AS total_orders,
    ROUND(AVG(Delay_Days), 2)                                        AS avg_delay_days,
    ROUND(SUM(CASE WHEN Delay_Days > 0 THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2)                                      AS delay_rate_pct
FROM supply_chain_risk
GROUP BY month_year
ORDER BY month_year;

-- ============================================================
-- SECTION 2: SUPPLY RISK ANALYSIS
-- ============================================================

-- Q4. Supply risk rate and revenue at risk by product category
-- Which categories are most exposed to supply disruption?
SELECT
    Product_Category,
    COUNT(*)                                                          AS total_orders,
    SUM(Supply_Risk_Flag)                                             AS at_risk_orders,
    ROUND(SUM(Supply_Risk_Flag) * 100.0 / COUNT(*), 2)               AS risk_rate_pct,
    ROUND(SUM(Order_Value_USD), 2)                                    AS total_order_value,
    ROUND(SUM(CASE WHEN Supply_Risk_Flag = 1
                   THEN Order_Value_USD ELSE 0 END), 2)               AS revenue_at_risk_usd
FROM supply_chain_risk
GROUP BY Product_Category
ORDER BY risk_rate_pct DESC;

-- Q5. Total portfolio revenue at risk
-- What percentage of total order value is currently at risk?
SELECT
    ROUND(SUM(Order_Value_USD), 2)                                    AS total_portfolio_value,
    ROUND(SUM(CASE WHEN Supply_Risk_Flag = 1
                   THEN Order_Value_USD ELSE 0 END), 2)               AS total_revenue_at_risk,
    ROUND(SUM(CASE WHEN Supply_Risk_Flag = 1
                   THEN Order_Value_USD ELSE 0 END)
          / SUM(Order_Value_USD) * 100, 2)                            AS pct_revenue_at_risk
FROM supply_chain_risk;


-- Q6. High value orders currently at risk
-- Which high-value orders need immediate attention?
SELECT
    Order_ID,
    Supplier_ID,
    Product_Category,
    Shipping_Mode,
    Order_Value_USD,
    Delay_Days,
    Disruption_Type,
    Disruption_Severity,
    Supplier_Reliability_Score
FROM supply_chain_risk
WHERE Supply_Risk_Flag = 1
  AND Order_Value_USD > (SELECT AVG(Order_Value_USD) FROM supply_chain_risk)
ORDER BY Order_Value_USD DESC
LIMIT 10;

-- ============================================================
-- SECTION 3: SUPPLIER PERFORMANCE ANALYSIS
-- ============================================================

-- Q7. Supplier performance scorecard
-- How does each supplier perform across reliability, delays, and risk?
SELECT
    Supplier_ID,
    COUNT(*)                                                          AS total_orders,
    ROUND(AVG(Supplier_Reliability_Score), 2)                        AS avg_reliability_score,
    ROUND(AVG(Delay_Days), 2)                                        AS avg_delay_days,
    SUM(Historical_Disruption_Count)                                  AS total_disruptions,
    SUM(Supply_Risk_Flag)                                             AS at_risk_orders,
    ROUND(SUM(Supply_Risk_Flag) * 100.0 / COUNT(*), 2)               AS risk_rate_pct
FROM supply_chain_risk
GROUP BY Supplier_ID
ORDER BY avg_reliability_score ASC
LIMIT 15;

-- Q8. Bottom 5 suppliers — critical risk suppliers
-- Which suppliers are the weakest links in the supply chain?
SELECT
    Supplier_ID,
    ROUND(AVG(Supplier_Reliability_Score), 2)                        AS avg_reliability_score,
    COUNT(*)                                                          AS total_orders,
    ROUND(AVG(Delay_Days), 2)                                        AS avg_delay_days,
    SUM(Historical_Disruption_Count)                                  AS total_historical_disruptions,
    ROUND(SUM(Supply_Risk_Flag) * 100.0 / COUNT(*), 2)               AS risk_rate_pct
FROM supply_chain_risk
GROUP BY Supplier_ID
ORDER BY avg_reliability_score ASC
LIMIT 5;

-- Q9. Supplier performance by product category
-- Are certain categories served by less reliable suppliers?
SELECT
    Product_Category,
    COUNT(DISTINCT Supplier_ID)                                       AS unique_suppliers,
    ROUND(AVG(Supplier_Reliability_Score), 2)                        AS avg_reliability_score,
    ROUND(AVG(Delay_Days), 2)                                        AS avg_delay_days,
    ROUND(SUM(Supply_Risk_Flag) * 100.0 / COUNT(*), 2)               AS risk_rate_pct
FROM supply_chain_risk
GROUP BY Product_Category
ORDER BY avg_reliability_score ASC;


-- Q10. Rank suppliers by reliability score (Window Function)
-- Where does each supplier stand relative to all others?
SELECT
    Supplier_ID,
    ROUND(AVG(Supplier_Reliability_Score), 2)                        AS avg_reliability_score,
    COUNT(*)                                                          AS total_orders,
    ROUND(AVG(Delay_Days), 2)                                        AS avg_delay_days,
    RANK() OVER (
        ORDER BY AVG(Supplier_Reliability_Score) DESC
    )                                                                 AS reliability_rank
FROM supply_chain_risk
GROUP BY Supplier_ID
ORDER BY reliability_rank;

-- Q11. CTE: Supplier risk categorization
-- Classify every supplier into Critical / High / Medium / Low risk
WITH supplier_metrics AS (
    SELECT
        Supplier_ID,
        COUNT(*)                                                      AS total_orders,
        ROUND(AVG(Supplier_Reliability_Score), 2)                    AS avg_reliability_score,
        ROUND(AVG(Delay_Days), 2)                                    AS avg_delay_days,
        ROUND(SUM(Supply_Risk_Flag) * 100.0 / COUNT(*), 2)           AS risk_rate_pct,
        SUM(Historical_Disruption_Count)                              AS total_disruptions
    FROM supply_chain_risk
    GROUP BY Supplier_ID
),
supplier_risk_category AS (
    SELECT *,
        CASE
            WHEN avg_reliability_score < 0.4
             AND risk_rate_pct > 50      THEN 'Critical Risk'
            WHEN avg_reliability_score < 0.6
             AND risk_rate_pct > 30      THEN 'High Risk'
            WHEN avg_reliability_score < 0.8 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS risk_category
    FROM supplier_metrics
)
SELECT
    risk_category,
    COUNT(*)                                                          AS supplier_count,
    ROUND(AVG(avg_reliability_score), 2)                             AS avg_reliability,
    ROUND(AVG(avg_delay_days), 2)                                    AS avg_delay_days,
    ROUND(AVG(risk_rate_pct), 2)                                     AS avg_risk_rate_pct
FROM supplier_risk_category
GROUP BY risk_category
ORDER BY avg_reliability ASC;


-- ============================================================
-- END OF ANALYSIS
-- Project  : Supply Chain Operations & Risk Analysis
-- Author   : Shaipshi 
-- Dataset  : Kaggle — zoya77 | Rows: 1,000 | Columns: 24
-- ============================================================