# 🚚 Supply Chain Operations & Risk Analysis — SQL-Based Data Exploration

![MySQL](https://img.shields.io/badge/Database-MySQL-blue?logo=mysql&logoColor=white) 
![SQL](https://img.shields.io/badge/Query--Language-SQL-orange) 
![Analytics](https://img.shields.io/badge/Analysis-Window--Functions-green) 
![Domain](https://img.shields.io/badge/Domain-Logistics%20%26%20Supply%20Chain-red)

---

## 📈 Project Overview & Business Problem
Supply chain disruptions cost global businesses over **$4 trillion annually**. In modern logistics, running data-driven risk assessments is a company's first line of defense against major financial losses.

This project performs an end-to-end exploratory data analysis (EDA) using **MySQL Workbench** to isolate structural vulnerabilities across logistics operations. By evaluating 1,000 distinct orders, the analysis addresses 11 critical business questions spanning delivery bottlenecks, supplier failure profiles, and total revenue exposure. 

* **Target End-Users:** Procurement Managers, Logistics Directors, and Supply Chain Strategy Teams

---

## 📊 Dataset Structure

* **Data Source:** [Kaggle — Supply Chain Operations & Risk Analysis Dataset](https://www.kaggle.com/datasets/zoya77/supply-chain-operations-risk-analysis-dataset)
* **Data Volume:** 1,000 unique orders
* **Full Attributes:** 24 columns
* **Features Analyzed:** 12 core clinical operational metrics:
  * `Order_ID` / `Supplier_ID`: Unique tracking codes.
  * `Product_Category` / `Shipping_Mode`: Routing and item groupings.
  * `Delay_Days` / `Disruption_Type` / `Disruption_Severity`: Performance degradation metrics.
  * `Historical_Disruption_Count` / `Supplier_Reliability_Score`: Long-term supplier health score profiles.
  * `Order_Value_USD` / `Supply_Risk_Flag`: Financial scale and risk category flags.

---

## 🔧 Tech Stack & SQL Techniques Used
* **Platform:** MySQL Workbench
* **Core Language:** SQL (Structured Query Language)
* **Advanced Aggregations:** `GROUP BY`, `HAVING`, multi-layered `SUM`, `AVG`, and `ROUND` math.
* **Conditional Logic:** Evaluated clean categorical buckets using `CASE WHEN`.
* **Subqueries:** Set up nested calculation layers to capture relative performance thresholds.
* **Window Functions:** Implemented `RANK() OVER()` and `SUM() OVER()` to track patterns over rows without compressing records.
* **Common Table Expressions (CTEs):** Utilized `WITH` clauses to keep temporary data segmentation matrices organized and human-readable.

---

## 📋 Query Index & Technical Roadmap

| Query ID | Core Business Question | Core SQL Technique Used |
|:---|:---|:---|
| **Q1** | Which shipping mode causes the most delivery delays? | `GROUP BY`, `CASE WHEN`, `AVG` |
| **Q2** | Which specific orders suffered the longest delays? | `WHERE`, `ORDER BY`, `LIMIT` |
| **Q3** | Which product categories are most exposed to supply risk flags? | `GROUP BY`, `SUM`, `ROUND` |
| **Q4** | What exact percentage of our total portfolio value is actively at risk? | Subquery, Aggregate Division |
| **Q5** | Which specific high-value orders need immediate warehouse attention? | Subquery filtering via `WHERE` |
| **Q6** | Compile a comprehensive, multi-metric supplier performance scorecard. | `GROUP BY`, `HAVING`, Multi-Aggregation |
| **Q7** | Identify the 5 most critical underperforming suppliers in the ecosystem. | `GROUP BY`, `ORDER BY`, `LIMIT` |
| **Q8** | Which specific product categories suffer from unreliable vendors? | `GROUP BY`, `AVG` threshold analysis |
| **Q9** | Which disruption types cause the largest downstream timeline delays? | Window Function — `SUM() OVER()` |
| **Q10** | Rank all network suppliers based on their baseline reliability metrics. | Window Function — `RANK() OVER()` |
| **Q11** | Segment every network supplier into low/medium/high risk tiers. | `WITH` (CTE) combined with `CASE WHEN` |

---

## 💡 Key Analytical Findings

* **`[Shipping Mode]`** showed the highest average delay metrics, exposing an efficiency issue in regional fulfillment contracts.
* **`[Product Category]`** registered the highest total supply risk rate, making it the most vulnerable sector in the network portfolio.
* **`[X]%`** of the total portfolio value is actively sitting in high-risk categories.
* The **Top 5 lowest-reliability suppliers** were linked to a massive, disproportionate share of all flagged-at-risk orders.
* **`[Disruption Type]`** proved to be the most common issue while also generating the highest average delay times across shipments.
* Supplier reliability scores ranged significantly from **`[Min Score]`** to **`[Max Score]`**, showing a substantial quality gap between top vendors and underperforming ones.

---

## 💼 Actionable Business Recommendations

1. **Audit Carrier Service Level Agreements (SLAs):** Address issues with the worst-performing shipping modes immediately. Introduce financial penalties for delays that cross threshold benchmarks, or route high-value cargo through safer channels.
2. **Flag and Monitor High-Value Shipments:** Build a localized operational report tracking orders that are both high value and flagged as high risk. This allows inventory teams to step in before severe logistics delays impact clients.
3. **Initiate Interventions for the Bottom 5 Suppliers:** Review performance data for the 5 lowest-ranked vendors immediately. Establish structured improvement milestones, or begin moving business toward alternative backup suppliers.
4. **Diversify Sourcing for Single-Point Failures:** For categories with low average vendor reliability scores, split orders among multiple partners. Sourcing from secondary suppliers reduces dependency and lowers the impact of unexpected shipping blocks.

---
